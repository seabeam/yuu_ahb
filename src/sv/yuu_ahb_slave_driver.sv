/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_DRIVER_SV
`define YUU_AHB_SLAVE_DRIVER_SV

class yuu_ahb_slave_driver extends uvm_driver #(yuu_ahb_slave_item);
  virtual yuu_ahb_slave_interface  vif;
  uvm_analysis_port #(yuu_ahb_slave_item) out_driver_port;

  yuu_ahb_slave_config  cfg;
  uvm_event_pool        events;
  protected process processes[string];
  protected yuu_common_addr_map maps[];

  protected yuu_ahb_slave_memory  m_mem;
  protected boolean               m_excl_start;
  protected yuu_ahb_addr_t        m_excl_addr;
  protected int unsigned          m_excl_master;
  local     int unsigned          drive_count;

  `uvm_register_cb(yuu_ahb_slave_driver, yuu_ahb_slave_driver_callback)

  `uvm_component_utils_begin(yuu_ahb_slave_driver)
  `uvm_component_utils_end

  extern                   function         new(string name, uvm_component parent);
  extern           virtual function void    build_phase(uvm_phase phase);
  extern           virtual function void    connect_phase(uvm_phase phase);
  extern           virtual task             run_phase(uvm_phase phase);

  extern protected virtual task             init_component();
  extern protected virtual function void    init_mem();
  extern protected virtual function boolean is_out(yuu_ahb_addr_t addr);
  extern protected virtual task             reset_signal();
  extern protected virtual task             get_and_drive();
  extern protected virtual task             drive_bus();
  extern protected virtual task             wait_reset();
endclass

function yuu_ahb_slave_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void yuu_ahb_slave_driver::build_phase(uvm_phase phase);
  out_driver_port = new("out_driver_port", this);
  cfg.get_maps(maps);
endfunction

function void yuu_ahb_slave_driver::connect_phase(uvm_phase phase);
  this.vif = cfg.vif;
  this.events = cfg.events;
endfunction

task yuu_ahb_slave_driver::run_phase(uvm_phase phase);
  init_component();
  fork
    get_and_drive();
    wait_reset();
  join
endtask


task yuu_ahb_slave_driver::init_component();
  init_mem();
  reset_signal();
  drive_count = 0;
endtask

function void yuu_ahb_slave_driver::init_mem();
  if (!uvm_config_db #(yuu_ahb_slave_memory)::get(null, get_full_name(), "mem", m_mem)) begin
    m_mem = new;
  end
  m_mem.init_pattern  = cfg.mem_init_pattern;
  m_mem.data_width    = cfg.data_width;
  m_mem.enable_byte_align = False;
endfunction

function boolean yuu_ahb_slave_driver::is_out(yuu_ahb_addr_t addr);
  foreach (maps[i]) begin
    if (maps[i].is_contain(addr))
      return False;
  end

  `uvm_warning("is_out", $sformatf("Address 0x%0h out of bound", addr))
  return True;
endfunction

task yuu_ahb_slave_driver::reset_signal();
  vif.drv_cb.hresp <= OKAY;
  vif.drv_cb.hready_o <= 1'b1;
  vif.drv_cb.hrdata <= 'h0;
  vif.drv_cb.hexokay <= 1'b1;
endtask

task yuu_ahb_slave_driver::get_and_drive();
  process proc_drive;

  forever begin
    wait(vif.drv_mp.hreset_n === 1'b1);
    fork
      begin
        proc_drive = process::self();
        processes["proc_drive"] = proc_drive;
        drive_bus();
      end
    join
  end
endtask

task yuu_ahb_slave_driver::drive_bus();
  uvm_event handshake   = events.get($sformatf("%s_driver_handshake", cfg.get_name()));
  yuu_ahb_addr_t      addr;
  yuu_ahb_direction_e direction;
  yuu_ahb_size_e      size;
  yuu_ahb_data_t      wdata;
  yuu_ahb_data_t      rdata;

  while((vif.drv_cb.htrans !== NONSEQ && vif.drv_cb.htrans !== SEQ) || vif.drv_cb.hsel !== 1'b1 || vif.drv_cb.hready_i !== 1'b1) begin
    vif.wait_cycle();
  end

  seq_item_port.get_next_item(req);
  handshake.trigger();
  `uvm_do_callbacks(yuu_ahb_slave_driver, yuu_ahb_slave_driver_callback, pre_send(this, req));
  drive_count ++;
  req.start_address = vif.drv_cb.haddr;
  req.address = new[1];
  req.address[0] = vif.drv_cb.haddr;
  req.direction = yuu_ahb_direction_e'(vif.drv_cb.hwrite);
  req.size = yuu_ahb_size_e'(vif.drv_cb.hsize);
  // Force burst to SINGLE
  req.burst = SINGLE;
  req.prot3 = yuu_ahb_prot3_e'(vif.drv_cb.hprot[3]);
  req.prot2 = yuu_ahb_prot2_e'(vif.drv_cb.hprot[2]);
  req.prot1 = yuu_ahb_prot1_e'(vif.drv_cb.hprot[1]);
  req.prot0 = yuu_ahb_prot0_e'(vif.drv_cb.hprot[0]);
  req.prot6_emt = yuu_ahb_emt_prot6_e'(vif.drv_cb.hprot_emt[6]);
  req.prot5_emt = yuu_ahb_emt_prot5_e'(vif.drv_cb.hprot_emt[5]);
  req.prot4_emt = yuu_ahb_emt_prot4_e'(vif.drv_cb.hprot_emt[4]);
  req.prot3_emt = yuu_ahb_emt_prot3_e'(vif.drv_cb.hprot_emt[3]);
  req.master = vif.drv_cb.hmaster;
  req.lock = vif.drv_cb.hmastlock;
  req.nonsec = yuu_ahb_nonsec_e'(vif.drv_cb.hnonsec);

  req.burst_size = yuu_ahb_burst_size_e'(req.size);
  req.burst_type = AHB_INCR;
  req.address_aligned_enable = True;
  if (vif.drv_cb.excl_write_enable === 0)
    req.exokay = EXERROR;
  else
    req.exokay = EXOKAY;
  if (is_out(req.address[0]))
    req.response[0] = ERROR;
  fork
    wait((vif.drv_cb.htrans === NONSEQ || vif.drv_cb.htrans === SEQ) && vif.drv_cb.hsel === 1'b1 && vif.drv_cb.hready_i === 1'b1);
    begin
      vif.drv_cb.hready_o <= 1'b0;
      vif.drv_cb.hresp <= OKAY;
      vif.drv_cb.hexokay <= EXOKAY;
      repeat(req.wait_delay) vif.wait_cycle();
      vif.drv_cb.hexokay <= req.exokay;
      if (req.response[0] == ERROR) begin
        vif.drv_cb.hresp <= req.response[0];
        vif.wait_cycle();
      end
      vif.drv_cb.hready_o <= 1'b1;
    end
  join
  
  req.data = new[1];
  if (req.direction == WRITE) begin
    yuu_ahb_addr_t low_boundary = req.address[0][7:0] % (`YUU_AHB_MAX_ADDR_WIDTH/8);
    yuu_ahb_addr_t high_boundary = low_boundary+(1<<int'(req.size));
    yuu_ahb_addr_t mem_addr = req.address[0]/(`YUU_AHB_MAX_ADDR_WIDTH/8);
    int strobe = 0;

    for (yuu_ahb_addr_t i=low_boundary; i<high_boundary; i++)
      strobe[i] = 1'b1;

    vif.wait_cycle();
    req.data[0] = vif.drv_cb.hwdata;
    vif.drv_cb.hresp <= OKAY;
    if (req.response[0] != ERROR)
      m_mem.write(mem_addr, req.data[0], strobe);
    `uvm_do_callbacks(yuu_ahb_slave_driver, yuu_ahb_slave_driver_callback, post_send(this, req));
    out_driver_port.write(req);
    seq_item_port.item_done();
    handshake.reset();
  end
  else begin
    yuu_ahb_addr_t mem_addr = req.address[0]/(`YUU_AHB_MAX_ADDR_WIDTH/8);
    m_mem.read(mem_addr, rdata);
    if (req.response[0] != ERROR) begin
      vif.drv_cb.hrdata <= rdata;
      req.data[0] = rdata;
    end
    else begin
      vif.drv_cb.hrdata <= 'h0;
      req.data[0] = 0;
    end
    `uvm_do_callbacks(yuu_ahb_slave_driver, yuu_ahb_slave_driver_callback, post_send(this, req));
    out_driver_port.write(req);
    seq_item_port.item_done();
    vif.wait_cycle();
    vif.drv_cb.hresp <= OKAY;
  end
endtask

task yuu_ahb_slave_driver::wait_reset();
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

`endif
