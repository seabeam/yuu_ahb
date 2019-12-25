/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_DRIVER_SV
`define YUU_AHB_SLAVE_DRIVER_SV

class yuu_ahb_slave_driver extends uvm_driver #(yuu_ahb_slave_item);
  virtual yuu_ahb_slave_interface  vif;
  uvm_analysis_port #(yuu_ahb_slave_item) out_driver_ap;

  yuu_ahb_slave_config  cfg;
  uvm_event_pool events;
  protected process processes[string];
  protected yuu_amba_addr_map maps[];

  protected yuu_ahb_slave_memory  m_mem;
  protected boolean               m_excl_start;
  protected yuu_ahb_addr_t        m_excl_addr;
  protected int unsigned          m_excl_master;
  local     int unsigned          drive_count;

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
  out_driver_ap = new("out_driver_ap", this);
  cfg.get_maps(maps);
endfunction

function void yuu_ahb_slave_driver::connect_phase(uvm_phase phase);
  this.vif = cfg.vif;
  this.events = cfg.events;
endfunction

task yuu_ahb_slave_driver::run_phase(uvm_phase phase);
  init_component();
  wait(vif.hreset_n === 1'b1);
  vif.wait_cycle();
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
  m_mem.data_width    = cfg.bus_width;
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
  vif.cb.hresp    <= OKAY;
  vif.cb.hready_o <= 1'b1;
  vif.cb.hrdata   <= 'h0;
  vif.cb.hexokay  <= 1'b1;
endtask

task yuu_ahb_slave_driver::get_and_drive();
  process proc_drive;

  forever
    fork
      begin
        proc_drive = process::self();
        processes["proc_drive"] = proc_drive;
        drive_bus();
      end
    join
endtask

task yuu_ahb_slave_driver::drive_bus();
  yuu_ahb_addr_t      addr;
  yuu_ahb_direction_e direction;
  yuu_ahb_size_e      size;
  yuu_ahb_data_t      wdata;
  yuu_ahb_data_t      rdata;

  while((vif.cb.htrans !== NONSEQ && vif.cb.htrans !== SEQ) || vif.cb.hsel !== 1'b1 || vif.cb.hready_i !== 1'b1) begin
    vif.wait_cycle();
  end

  seq_item_port.get_next_item(req);
  drive_count ++;
  req.start_address = vif.cb.haddr;
  req.address   = new[1];
  req.address[0]= vif.cb.haddr;
  req.direction = yuu_ahb_direction_e'(vif.cb.hwrite);
  req.size      = yuu_ahb_size_e'(vif.cb.hsize);
  // Force burst to SINGLE
  req.burst     = SINGLE;
  req.prot3     = yuu_ahb_prot3_e'(vif.cb.hprot[3]);
  req.prot2     = yuu_ahb_prot2_e'(vif.cb.hprot[2]);
  req.prot1     = yuu_ahb_prot1_e'(vif.cb.hprot[1]);
  req.prot0     = yuu_ahb_prot0_e'(vif.cb.hprot[0]);
  req.prot6_emt = yuu_ahb_emt_prot6_e'(vif.cb.hprot_emt[6]);
  req.prot5_emt = yuu_ahb_emt_prot5_e'(vif.cb.hprot_emt[5]);
  req.prot4_emt = yuu_ahb_emt_prot4_e'(vif.cb.hprot_emt[4]);
  req.prot3_emt = yuu_ahb_emt_prot3_e'(vif.cb.hprot_emt[3]);
  req.master    = vif.cb.hmaster;
  req.lock      = vif.cb.hmastlock;
  req.nonsec    = yuu_ahb_nonsec_e'(vif.cb.hnonsec);

  req.burst_size = yuu_amba_size_e'(req.size);
  req.burst_type = yuu_amba_pkg::INCR;
  req.address_aligned_enable = True;
  if (vif.cb.excl_write_enable === 0)
    req.exokay = EXERROR;
  else
    req.exokay = EXOKAY;
  if (is_out(req.address[0]))
    req.response[0] = ERROR;
  fork
    wait((vif.cb.htrans === NONSEQ || vif.cb.htrans === SEQ) && vif.cb.hsel === 1'b1 && vif.cb.hready_i === 1'b1);
    begin
      vif.cb.hready_o <= 1'b0;
      vif.cb.hresp    <= OKAY;
      vif.cb.hexokay  <= EXOKAY;
      repeat(req.wait_delay) vif.wait_cycle();
      vif.cb.hexokay  <= req.exokay;
      if (req.response[0] == ERROR) begin
        vif.cb.hresp <= req.response[0];
        vif.wait_cycle();
      end
      vif.cb.hready_o <= 1'b1;
    end
  join
  
  req.data = new[1];
  if (req.direction == WRITE) begin
    yuu_ahb_addr_t low_boundary = req.address[0][7:0] % (`YUU_AHB_ADDR_WIDTH/8);
    yuu_ahb_addr_t high_boundary = low_boundary+(1<<int'(req.size));
    yuu_ahb_addr_t mem_addr = req.address[0]/(`YUU_AHB_ADDR_WIDTH/8);
    int strobe = 0;

    for (yuu_ahb_addr_t i=low_boundary; i<high_boundary; i++)
      strobe[i] = 1'b1;

    vif.wait_cycle();
    req.data[0] = vif.cb.hwdata;
    vif.cb.hresp <= OKAY;
    if (req.response[0] != ERROR)
      m_mem.write(mem_addr, req.data[0], strobe);
    seq_item_port.item_done();
  end
  else begin
    yuu_ahb_addr_t mem_addr = req.address[0]/(`YUU_AHB_ADDR_WIDTH/8);
    m_mem.read(mem_addr, rdata);
    if (req.response[0] != ERROR) begin
      vif.cb.hrdata <= rdata;
      req.data[0] = rdata;
    end
    else begin
      vif.cb.hrdata <= 'h0;
      req.data[0] = 0;
    end
    seq_item_port.item_done();
    vif.wait_cycle();
    vif.cb.hresp <= OKAY;
  end
endtask

task yuu_ahb_slave_driver::wait_reset();
  forever begin
    @(negedge vif.hreset_n);
    if (seq_item_port.has_do_available())
      seq_item_port.item_done();
    foreach (processes[i])
      processes[i].kill();
    init_component();
    @(posedge vif.hreset_n);
  end
endtask

`endif
