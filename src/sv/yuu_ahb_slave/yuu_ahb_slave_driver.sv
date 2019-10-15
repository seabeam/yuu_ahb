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

  protected yuu_ahb_slave_memory m_mem;
  
  `uvm_component_utils_begin(yuu_ahb_slave_driver)
  `uvm_component_utils_end

  extern                   function      new(string name, uvm_component parent);
  extern           virtual function void build_phase(uvm_phase phase);
  extern           virtual task          reset_phase(uvm_phase phase);
  extern           virtual task          main_phase(uvm_phase phase);
  extern protected virtual task          reset_signal();
  extern protected virtual function void init_mem();
  extern protected virtual task          get_and_drive();
  extern protected virtual task          drive_bus();
  extern protected virtual task          pre_drive_bus();
  extern protected virtual task          post_drive_bus();
  extern protected virtual function int  set_delay(yuu_ahb_direction_e direction);
endclass

function yuu_ahb_slave_driver::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void yuu_ahb_slave_driver::build_phase(uvm_phase phase);
  out_driver_ap = new("out_driver_ap", this);
endfunction

task yuu_ahb_slave_driver::reset_phase(uvm_phase phase);
  init_mem();
  reset_signal();
endtask

task yuu_ahb_slave_driver::main_phase(uvm_phase phase);
  wait(vif.MON.hreset_n);
  @(vif.mon_cb);
  get_and_drive();
endtask


task yuu_ahb_slave_driver::reset_signal();
  vif.cb.hresp    <= OKAY;
  vif.cb.hready_o <= 1'b1;
  vif.cb.hrdata   <= 'h0;
endtask

function void yuu_ahb_slave_driver::init_mem();
  m_mem = yuu_ahb_slave_memory::type_id::create("m_mem");
endfunction

task yuu_ahb_slave_driver::get_and_drive();
  forever begin
    pre_drive_bus();
    drive_bus();
    post_drive_bus();
  end
endtask

task yuu_ahb_slave_driver::drive_bus ();
  yuu_ahb_addr_t      addr;
  yuu_ahb_direction_e direction;
  yuu_ahb_size_e      size;
  yuu_ahb_wdata_t     wdata;
  yuu_ahb_rdata_t     rdata;

  while((vif.htrans !== NONSEQ && vif.htrans !== SEQ) || vif.hsel !== 1'b1 || vif.hready_i !== 1'b1) begin
    @(posedge vif.hclk);
  end
  addr   = vif.haddr;
  direction = yuu_ahb_direction_e'(vif.hwrite);
  size   = yuu_ahb_size_e'(vif.hsize);
  fork
    wait((vif.htrans === NONSEQ || vif.htrans === SEQ) && vif.hsel === 1'b1 && vif.hready_i === 1'b1);
    begin
      vif.hready_o <= 1'b0;
      repeat(req.wait_delay) @(vif.cb);
      vif.hready_o <= 1'b1;
    end
  join
  if (direction == WRITE) begin
    yuu_ahb_addr_t low_boundary = addr[7:0] % (`YUU_AHB_ADDR_WIDTH/8);
    yuu_ahb_addr_t high_boundary = low_boundary+(1<<int'(size));
    yuu_ahb_addr_t mem_addr = addr/(`YUU_AHB_ADDR_WIDTH/8);
    int strobe = 0;
    
    for (yuu_ahb_addr_t i=low_boundary; i<high_boundary; i++)
      strobe[i] = 1'b1;

    @(posedge vif.hclk);
    wdata = vif.hwdata; 
    m_mem.write(mem_addr, wdata, strobe);
  end
  else begin
    yuu_ahb_addr_t mem_addr = addr/(`YUU_AHB_ADDR_WIDTH/8);
    m_mem.read(mem_addr, rdata);
    if (cfg.use_random_data)
      vif.cb.hrdata <= $urandom();
    else
      vif.cb.hrdata <= rdata;
    @(posedge vif.hclk);
  end
endtask

task yuu_ahb_slave_driver::pre_drive_bus();
  return;
endtask

task yuu_ahb_slave_driver::post_drive_bus();
  return;
endtask

function int yuu_ahb_slave_driver::set_delay(yuu_ahb_direction_e direction);
  int delay;

  if (cfg.has_slave_delay) begin
    if (cfg.has_slave_random_delay) begin
      if (cfg.slave_delay_min != -1 && cfg.slave_delay_max != -1) begin
        delay  = $urandom() % cfg.slave_delay_max;
        while (delay >= cfg.slave_delay_max) begin
          delay  += cfg.slave_delay_min;
        end
      end
      else begin
        delay  = $urandom;
      end
    end
    else begin
      if (direction == WRITE) begin
        delay  = cfg.slave_write_delay;
      end
      else begin
        delay  = cfg.slave_read_delay;
      end
    end
  end
  else begin
    delay  = 0;
  end

  return delay;
endfunction

`endif
