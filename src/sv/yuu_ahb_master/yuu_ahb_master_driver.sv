///////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_DRIVER_SV
`define YUU_AHB_MASTER_DRIVER_SV

class yuu_ahb_master_driver extends uvm_driver #(yuu_ahb_master_item);
  virtual yuu_ahb_master_interface vif;
  uvm_analysis_port #(yuu_ahb_master_item) out_driver_ap;

  yuu_ahb_master_config cfg;
  uvm_event_pool events;
  semaphore m_cmd_sem, m_data_sem;

  `uvm_register_cb(yuu_ahb_master_driver, yuu_ahb_master_driver_callback)

  `uvm_component_utils_begin(yuu_ahb_master_driver)
  `uvm_component_utils_end
  
  extern                   function      new(string name, uvm_component parent);
  extern protected virtual function void build_phase(uvm_phase phase);
  extern protected virtual task          reset_phase(uvm_phase phase);
  extern protected virtual task          main_phase(uvm_phase phase);

  extern protected virtual task          reset_signal();
  extern protected virtual task          get_and_drive();
  extern protected virtual task          cmd_phase(input yuu_ahb_master_item item);
  extern protected virtual task          data_phase(input yuu_ahb_master_item item);
  extern protected virtual task          wait_reset(uvm_phase phase);
  extern protected virtual task          send_response(input yuu_ahb_master_item item); 
endclass

function yuu_ahb_master_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void yuu_ahb_master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  out_driver_ap = new("out_driver_ap", this);
  m_cmd_sem = new(1);
  m_data_sem = new(1);
endfunction

task yuu_ahb_master_driver::reset_phase(uvm_phase phase);
  m_cmd_sem.try_get();
  m_cmd_sem.put();
  m_data_sem.try_get();
  m_data_sem.put();

  reset_signal();
endtask

task yuu_ahb_master_driver::main_phase(uvm_phase phase);
  wait(vif.DUT.hreset_n === 1'b1);
  @(vif.cb);
  fork
    get_and_drive();
    wait_reset(phase);
  join
endtask

task yuu_ahb_master_driver::reset_signal();
  vif.cb.haddr      <= 'h0;
  vif.cb.htrans     <= 2'h0;
  vif.cb.hburst     <= 'h0;
  vif.cb.hwrite     <= 1'b1;
  vif.cb.hsize      <= 'h2;
  vif.cb.hwdata     <= 'h0;
  vif.cb.hprot      <= 'h0;
  vif.cb.hprot_emt  <= 'h0;
  vif.cb.hmaster    <= 4'h0;
  vif.cb.hmastlock  <= 1'b0;
  vif.cb.hnonsec    <= 1'b1;
  
  vif.cb.upper_byte_lane <= 'h0;
  vif.cb.lower_byte_lane <= 'h0;
endtask

task yuu_ahb_master_driver::get_and_drive();
  forever begin
    yuu_ahb_master_item item;

    seq_item_port.get_next_item(item);
    out_driver_ap.write(item);
    `uvm_do_callbacks(yuu_ahb_master_driver, yuu_ahb_master_driver_callback, pre_send(this, item));
    fork
      cmd_phase(item);
      data_phase(item);
    join_any
    seq_item_port.item_done();
  end
endtask

task yuu_ahb_master_driver::cmd_phase(input yuu_ahb_master_item item);
  uvm_event drive_cmd_begin = events.get($sformatf("%s_drive_cmd_begin", cfg.get_name()));
  uvm_event drive_cmd_end   = events.get($sformatf("%s_drive_cmd_end", cfg.get_name()));
  
  m_cmd_sem.get();
  begin
    int len;
    yuu_ahb_master_item cur_item = yuu_ahb_master_item::type_id::create("cur_item");
    cur_item.copy(item);
    len = cur_item.len;
    
    repeat(cur_item.idle_delay) @vif.cb;
    `uvm_info("cmd_phase", "Transaction start", UVM_HIGH)

    vif.cb.hwrite   <= cur_item.direction;
    vif.cb.hsize    <= cur_item.size;
    vif.cb.hburst   <= cur_item.burst;
    vif.cb.hprot    <= {cur_item.prot3, cur_item.prot2, cur_item.prot1, cur_item.prot0};
    vif.cb.hprot_emt<= {cur_item.prot6_emt, cur_item.prot5_emt, cur_item.prot4_emt, cur_item.prot3_emt};
    vif.cb.hmaster  <= cur_item.master;
    vif.cb.hmastlock<= cur_item.lock;
    vif.cb.hnonsec  <= cur_item.nonsec;

    for (int i=0; i<=len; i++) begin
      drive_cmd_begin.trigger();
      `uvm_info("cmd_phase", "Beat start", UVM_HIGH)

      vif.cb.haddr <= cur_item.address[i];
      if (cur_item.busy_delay[i] > 0) begin
        vif.cb.htrans <= BUSY;
        repeat(cur_item.busy_delay[i]) @vif.cb;
      end
      vif.cb.htrans <= cur_item.trans[i];
      do 
        @vif.cb;
      while (vif.cb.hready_i !== 1'b1);

      if (cur_item.location[i] == LAST) begin
        vif.cb.htrans   <= IDLE;
        vif.cb.hmastlock<= 1'b0;
        vif.cb.hnonsec  <= 1'b1;
      end

      drive_cmd_end.trigger();
      `uvm_info("cmd_phase", "Beat end", UVM_HIGH)
    end
  end
  m_cmd_sem.put();

  `uvm_info("cmd_phase", "Transaction end", UVM_HIGH)
endtask

task yuu_ahb_master_driver::data_phase(input yuu_ahb_master_item item);
  uvm_event drive_data_begin = events.get($sformatf("%s_drive_data_begin", cfg.get_name()));
  uvm_event drive_data_end   = events.get($sformatf("%s_drive_data_end", cfg.get_name()));

  m_data_sem.get();
  begin
    int len;
    yuu_ahb_master_item cur_item = yuu_ahb_master_item::type_id::create("cur_item");
    cur_item.set_id_info(item);
    cur_item.copy(item);
    len = cur_item.len;

    while (vif.cb.hready_i !== 1'b1 || vif.mon_cb.htrans !== NONSEQ)
      @vif.cb;
    `uvm_info("data_phase", "Transaction start", UVM_HIGH)
    drive_data_begin.trigger();

    for (int i=0; i<=len; i++) begin
      `uvm_info("data_phase", "Beat start", UVM_HIGH)
      if (cur_item.direction == WRITE) begin
        vif.cb.hwdata <= cur_item.data[i];
        vif.cb.upper_byte_lane <= cur_item.upper_byte_lane[i];
        vif.cb.lower_byte_lane <= cur_item.lower_byte_lane[i];
      end

      do 
        @vif.cb;
      while (vif.cb.hready_i !== 1'b1 || vif.mon_cb.htrans === BUSY);
      if (cur_item.direction == READ) begin
        cur_item.data[i] = vif.cb.hrdata;
      end
      cur_item.response[i] = vif.cb.hresp;

      `uvm_info("data_phase", "Beat end", UVM_HIGH)
    end
    `uvm_do_callbacks(yuu_ahb_master_driver, yuu_ahb_master_driver_callback, post_send(this, cur_item));
    drive_data_end.trigger();
    if (cfg.use_response)
      send_response(cur_item);
    `uvm_info("data_phase", "Transaction end", UVM_HIGH)
  end

  m_data_sem.put();
endtask

task yuu_ahb_master_driver::send_response(input yuu_ahb_master_item item);
  rsp = yuu_ahb_master_item::type_id::create("rsp");
  rsp.set_id_info(item);
  rsp.copy(item);
  seq_item_port.put_response(rsp);
  //rsp.print();
endtask

task yuu_ahb_master_driver::wait_reset(uvm_phase phase);
  @(negedge vif.hreset_n);
  phase.jump(uvm_reset_phase::get());
endtask

`endif
