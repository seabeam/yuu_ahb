/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_DRIVER_SV
`define YUU_AHB_MASTER_DRIVER_SV

// Class: yuu_ahb_master_driver
// Driver implementation of AHB master
class yuu_ahb_master_driver extends uvm_driver #(yuu_ahb_master_item);
  // Variable: vif
  // AHB master interface handle.
  virtual yuu_ahb_master_interface vif;

  // Variable: out_driver_port
  // Analysis port out from driver.
  uvm_analysis_port #(yuu_ahb_master_item) out_driver_port;

  // Variable: cfg
  // AHB master agent configuration object.
  yuu_ahb_master_config cfg;

  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool        events;

  // Variable: processes
  // Processes for handling reset.
  protected process processes[string];

  // Variable: m_cmd_sem
  // Semaphore for pipeline in command phase.
  protected semaphore m_cmd_sem;

  // Variable: m_data_sem
  // Semaphore for pipeline in data phase.
  protected semaphore m_data_sem;

  // Variable: error_key
  // Error process flag
  boolean error_key = False;

  `uvm_register_cb(yuu_ahb_master_driver, yuu_ahb_master_driver_callback)

  `uvm_component_utils_begin(yuu_ahb_master_driver)
  `uvm_component_utils_end

  extern                   function      new(string name, uvm_component parent);
  extern           virtual function void build_phase(uvm_phase phase);
  extern           virtual function void connect_phase(uvm_phase phase);
  extern           virtual task          run_phase(uvm_phase phase);

  extern protected virtual task          init_component();
  extern protected virtual task          reset_signal();
  extern protected virtual task          get_and_drive();
  extern protected virtual task          cmd_phase(input yuu_ahb_master_item item);
  extern protected virtual task          data_phase(input yuu_ahb_master_item item);
  extern protected virtual task          wait_reset();
  extern protected virtual task          error_proc();
  extern protected virtual task          send_response(input yuu_ahb_master_item item);
endclass

// Function: new
// Constructor of object.
function yuu_ahb_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

// Function: build_phase
// UVM built-in method.
function void yuu_ahb_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);

  out_driver_port = new("out_driver_port", this);
  m_cmd_sem = new(1);
  m_data_sem = new(1);
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_master_driver::connect_phase(uvm_phase phase);
  this.vif = cfg.vif;
  this.events = cfg.events;
endfunction

// Task: run_phase
// UVM built-in method.
task yuu_ahb_master_driver::run_phase(uvm_phase phase);
  init_component();
  fork
    get_and_drive();
    error_proc();
    wait_reset();
  join
endtask


// Task: init_component
// Internal resource initialize.
task yuu_ahb_master_driver::init_component();
  m_cmd_sem.try_get();
  m_cmd_sem.put();
  m_data_sem.try_get();
  m_data_sem.put();

  reset_signal();
endtask

// Task: reset_signal
// Reset interface signal.
task yuu_ahb_master_driver::reset_signal();
  vif.drv_cb.haddr    <= 'h0;
  vif.drv_cb.htrans   <= 2'h0;
  vif.drv_cb.hburst   <= 'h0;
  vif.drv_cb.hwrite   <= 1'b1;
  vif.drv_cb.hsize    <= 'h2;
  vif.drv_cb.hwdata   <= 'h0;
  vif.drv_cb.hprot    <= 'h0;
  vif.drv_cb.hprot_emt<= 'h0;
  vif.drv_cb.hmaster  <= 4'h0;
  vif.drv_cb.hmastlock<= 1'b0;
  vif.drv_cb.hnonsec  <= 1'b1;
  vif.drv_cb.hexcl    <= 1'b0;

  vif.drv_cb.upper_byte_lane <= 'h0;
  vif.drv_cb.lower_byte_lane <= 'h0;
endtask

// Task: get_and_drive
// Fetch transaction from sequencer and drive on bus.
task yuu_ahb_master_driver::get_and_drive();
  uvm_event handshake = events.get($sformatf("%s_driver_handshake", cfg.get_name()));
  process proc_drive;

  forever begin
    wait(vif.drv_mp.hreset_n === 1'b1);
    fork
      begin
        yuu_ahb_master_item item;

        proc_drive = process::self();
        processes["proc_drive"] = proc_drive;
        seq_item_port.get_next_item(item);
        handshake.trigger();
        @(vif.drv_cb);
        out_driver_port.write(item);
        `uvm_do_callbacks(yuu_ahb_master_driver, yuu_ahb_master_driver_callback, pre_send(this, item));
        fork
          cmd_phase(item);
          data_phase(item);
        join_any
        seq_item_port.item_done();
        handshake.reset();
      end
    join
  end
endtask

// Task: cmd_phase
// Main drive task, command phase.
// Para:
//  item - item expect to drive
task yuu_ahb_master_driver::cmd_phase(input yuu_ahb_master_item item);
  uvm_event drive_cmd_begin = events.get($sformatf("%s_driver_drive_cmd_begin", cfg.get_name()));
  uvm_event drive_cmd_end = events.get($sformatf("%s_driver_drive_cmd_end", cfg.get_name()));
  uvm_event error_stopped = events.get($sformatf("%s_error_stopped", cfg.get_name()));

  m_cmd_sem.get();
  begin
    int len;

    yuu_ahb_master_item cur_item = yuu_ahb_master_item::type_id::create("cur_item");
    cur_item.copy(item);
    len = cur_item.len;

    repeat(cur_item.idle_delay) vif.wait_cycle();
    `uvm_info("cmd_phase", "Transaction start", UVM_HIGH)

    vif.drv_cb.hwrite <= cur_item.direction;
    vif.drv_cb.hsize <= cur_item.size;
    vif.drv_cb.hburst <= cur_item.burst;
    vif.drv_cb.hprot <= {cur_item.prot3, cur_item.prot2, cur_item.prot1, cur_item.prot0};
    vif.drv_cb.hprot_emt <= {cur_item.prot6_emt, cur_item.prot5_emt, cur_item.prot4_emt, cur_item.prot3_emt};
    vif.drv_cb.hmaster <= cur_item.master;
    vif.drv_cb.hmastlock <= cur_item.lock;
    vif.drv_cb.hnonsec <= cur_item.nonsec;
    vif.drv_cb.hexcl <= cur_item.excl;

    for (int i=0; i <= len; i++) begin
      if (error_stopped.is_on()) begin
        if (error_key) begin
          error_stopped.reset();
          error_key = False;
        end
        else
          error_key = True;
        break;
      end

      drive_cmd_begin.trigger();
      `uvm_info("cmd_phase", "Beat start", UVM_HIGH)

      vif.drv_cb.haddr <= cur_item.address[i];
      if (cur_item.busy_delay[i] > 0) begin
        vif.drv_cb.htrans <= BUSY;
        repeat(cur_item.busy_delay[i]) vif.wait_cycle();
      end
      vif.drv_cb.htrans <= cur_item.trans[i];
      do
        vif.wait_cycle();
      while (vif.drv_cb.hready_i !== 1'b1);

      if (cur_item.location[i] == LAST) begin
        vif.drv_cb.htrans <= IDLE;
        vif.drv_cb.hmastlock <= 1'b0;
        vif.drv_cb.hnonsec <= 1'b1;
      end

      drive_cmd_end.trigger();
      `uvm_info("cmd_phase", "Beat end", UVM_HIGH)
    end
  end
  m_cmd_sem.put();

  `uvm_info("cmd_phase", "Transaction end", UVM_HIGH)
endtask

// Task: data_phase
// Main drive task, data phase.
// Para:
//  item - item expect to drive
task yuu_ahb_master_driver::data_phase(input yuu_ahb_master_item item);
  uvm_event drive_data_begin = events.get($sformatf("%s_driver_drive_data_begin", cfg.get_name()));
  uvm_event drive_data_end = events.get($sformatf("%s_driver_drive_data_end", cfg.get_name()));
  uvm_event error_stopped = events.get($sformatf("%s_error_stopped", cfg.get_name()));

  m_data_sem.get();
  begin
    int len;
    yuu_ahb_master_item cur_item = yuu_ahb_master_item::type_id::create("cur_item");
    cur_item.set_id_info(item);
    cur_item.copy(item);
    len = cur_item.len;

    while (vif.drv_cb.hready_i !== 1'b1 || vif.mon_cb.htrans !== NONSEQ)
      vif.wait_cycle();
    `uvm_info("data_phase", "Transaction start", UVM_HIGH)
    drive_data_begin.trigger();

    for (int i=0; i <= len; i++) begin
      boolean has_got = False;
      `uvm_info("data_phase", "Beat start", UVM_HIGH)
      if (cur_item.direction == WRITE) begin
        vif.drv_cb.hwdata <= cur_item.data[i];
        vif.drv_cb.upper_byte_lane <= cur_item.upper_byte_lane[i];
        vif.drv_cb.lower_byte_lane <= cur_item.lower_byte_lane[i];
      end

      do begin
        vif.wait_cycle();
        if (vif.drv_cb.hready_i === 1'b1 && cur_item.direction == READ && !has_got) begin
          if (i == 0)
            cur_item.exokay = vif.drv_cb.hexokay;
          cur_item.data[i] = vif.drv_cb.hrdata;
          cur_item.response[i] = vif.drv_cb.hresp;
          has_got = True;
        end
      end
      while (vif.drv_cb.hready_i !== 1'b1 || vif.mon_cb.htrans === BUSY);
      if (!has_got) begin
        if (cur_item.direction == READ) begin
          cur_item.data[i] = vif.drv_cb.hrdata;
        end
        cur_item.response[i] = vif.drv_cb.hresp;
        if (i == 0)
          cur_item.exokay = vif.drv_cb.hexokay;
      end

      `uvm_info("data_phase", "Beat end", UVM_HIGH)
      if (error_stopped.is_on()) begin
        if (error_key) begin
          error_stopped.reset();
          error_key = False;
        end
        else
          error_key = True;
        break;
      end
    end
    `uvm_do_callbacks(yuu_ahb_master_driver, yuu_ahb_master_driver_callback, post_send(this, cur_item));
    drive_data_end.trigger();
    if (cfg.use_response)
      send_response(cur_item);
    //cur_item.print();
    `uvm_info("data_phase", "Transaction end", UVM_HIGH)
  end

  m_data_sem.put();
endtask

// Task: send_response
// Send response back to sequencer.
// Para:
//  item - the transaction after driving on bus
task yuu_ahb_master_driver::send_response(input yuu_ahb_master_item item);
  rsp = yuu_ahb_master_item::type_id::create("rsp");
  rsp.set_id_info(item);
  rsp.copy(item);
  seq_item_port.put_response(rsp);
  // rsp.print();
endtask

// Task: wait_reset
// Thread of reset waiting for handle on-the-fly reset.
task yuu_ahb_master_driver::wait_reset();
  uvm_event handshake = events.get($sformatf("%s_driver_handshake", cfg.get_name()));

  forever begin
    @(negedge vif.drv_mp.hreset_n);
    `uvm_warning("wait_reset", "Reset signal is asserted, transaction may be dropped")
    if (handshake.is_on())
      seq_item_port.item_done();
    foreach (processes[i])
      processes[i].kill();
    init_component();
    @(posedge vif.drv_mp.hreset_n);
  end
endtask

// Task: error_proc
// Response error detect, then set the error flag for processing.
task yuu_ahb_master_driver::error_proc();
  uvm_event error_stopped = events.get($sformatf("%s_error_stopped", cfg.get_name()));
  process proc_error;

  wait(vif.drv_mp.hreset_n === 1'b1);
  forever begin
    fork
      begin
        proc_error = process::self();
        processes["proc_error"] = proc_error;
        @(posedge vif.drv_cb.hresp[0]);
        if (cfg.error_behavior == ABORT_AFTER_ERROR) begin
          error_stopped.trigger();
          vif.drv_cb.htrans <= IDLE;
          vif.wait_cycle();
        end
      end
    join
  end
endtask

`endif