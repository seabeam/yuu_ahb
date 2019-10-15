/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_MONITOR_SV
`define YUU_AHB_SLAVE_MONITOR_SV

class yuu_ahb_slave_monitor extends uvm_monitor;
  virtual yuu_ahb_slave_interface  vif;
  
  uvm_analysis_port #(yuu_ahb_item) out_monitor_ap;

  yuu_ahb_slave_config cfg;
  uvm_event_pool events;

  protected semaphore m_sem;
  protected yuu_ahb_transfer   transfer_queue[$];
  protected yuu_ahb_wdata_t    wdata_queue[$];
  protected yuu_ahb_rdata_t    rdata_queue[$];
  protected yuu_ahb_response_e resp_queue[$];

  `uvm_component_utils(yuu_ahb_slave_monitor)

  function new(string name = "yuu_ahb_slave_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    out_monitor_ap = new("out_monitor_ap", this);
    m_sem = new(1);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    this.vif = cfg.vif;
    events = cfg.events;
  endfunction
  
  task reset_phase(uvm_phase phase);
    wait(vif.MON.hreset_n === 1'b1);
  endtask
  
  task main_phase(uvm_phase phase);
    fork
      forever begin
        fork
          collect();
          collect();
        join_any
      end
      forever begin
        burst_end();
      end
    join
  endtask
  
  task collect();
    m_sem.get();
    collect_command();
    m_sem.put();
    collect_data();
  endtask
  
  task collect_command();
    yuu_ahb_transfer transfer = yuu_ahb_transfer::type_id::create("transfer");
  
    while (vif.MON.hreset_n !== 1'b1 || vif.mon_cb.hready_i !== 1'b1 || vif.mon_cb.htrans == IDLE || vif.mon_cb.hsel != 1'b1 || vif.mon_cb.hready_o !== 1'b1) begin
      @ vif.mon_cb;
    end
  
    transfer.address  = yuu_ahb_addr_t'(vif.mon_cb.haddr);
    transfer.direction= yuu_ahb_direction_e'(vif.mon_cb.hwrite);
    transfer.size     = yuu_ahb_size_e'(vif.mon_cb.hsize);
    transfer.trans    = yuu_ahb_trans_e'(vif.mon_cb.htrans);
    transfer.burst    = yuu_ahb_burst_e'(vif.mon_cb.hburst);
    transfer.location = (transfer.trans == NONSEQ) ? FIRST : MIDDLE;
    transfer_queue.push_back(transfer);
    @ vif.mon_cb;
  endtask
  
  task collect_data();
    while (vif.MON.hreset_n !== 1'b1 || vif.mon_cb.hready_i !== 1'b1 || vif.mon_cb.hready_o !== 1'b1) begin
      @ vif.mon_cb;
    end
    if (transfer_queue[$].direction == WRITE) begin
      wdata_queue.push_back(yuu_ahb_wdata_t'(vif.mon_cb.hwdata));
    end
    else if (transfer_queue[$].direction == READ) begin
      rdata_queue.push_back(yuu_ahb_rdata_t'(vif.mon_cb.hrdata));
    end
    if (yuu_ahb_response_e'(vif.mon_cb.hresp) == ERROR) begin
      `uvm_error("AHBS Monitor", $sformatf("Error response catched, address: 0x%0h", transfer_queue[$].address))
    end
    resp_queue.push_back(yuu_ahb_response_e'(vif.mon_cb.hresp));
    @ vif.mon_cb;
  endtask
  
  function void process_observed(yuu_ahb_item item);
    // Set Common infomation
    item.direction  = transfer_queue[0].direction;
    item.size       = transfer_queue[0].size;
    item.burst      = transfer_queue[0].burst;
    item.start_address = transfer_queue[0].address;
    item.amba_size  = size_ahb_to_amba(item.size);
    item.burst_type = burst_ahb_to_amba(item.burst);

    process_transfer(item);
  
    out_monitor_ap.write(item);
    `uvm_info("AHBS monitor", $sformatf("Master monitor(%s) send out the observed item", cfg.get_name()), UVM_HIGH)
  endfunction
  
  function void process_transfer(ref yuu_ahb_item item);
    bit busy_flag;
    int size;

    if (transfer_queue[0].direction == WRITE) begin
      size = wdata_queue.size();
      for (int i=0; i<size; i++) begin
        transfer_queue[0].response = resp_queue.pop_front();
        item.hwdata.push_back(wdata_queue.pop_front());
        item.transfers.push_back(transfer_queue.pop_front());
      end
    end
    else if (transfer_queue[0].direction == READ) begin
      size = rdata_queue.size();
      for (int i=0; i<size; i++) begin
        transfer_queue[0].response = resp_queue.pop_front();
        item.hrdata.push_back(rdata_queue.pop_front());
        item.transfers.push_back(transfer_queue.pop_front());
      end
    end

    keep_one_busy(item);

    foreach (item.transfers[i]) begin
      item.trans.push_back(item.transfers[i].trans);
      item.transfers[i].data = item.direction == READ ? item.hrdata[i] : item.hwdata[i];
      item.transfers[i].set_parent(item);
      if (item.transfers[i].trans != BUSY)
        item.len++;
    end
    item.len -= 1;

    item.transfers[$].location = LAST;
  endfunction

  function void keep_one_busy(ref yuu_ahb_item t);
    int idx_queue[$];
  
    for (int i=1; i<t.transfers.size(); i++) begin
      if (t.transfers[i].trans == BUSY && t.transfers[i-1].trans == BUSY) begin
        idx_queue.push_back(i);
      end
    end
  
    foreach (idx_queue[i]) begin
      t.transfers.delete(idx_queue[i]-i);
      t.hwdata.delete(idx_queue[i]-i);
      t.hrdata.delete(idx_queue[i]-i);
    end
  endfunction

  task burst_end();
    yuu_ahb_item monitor_item = yuu_ahb_item::type_id::create("monitor_item");
  
    while (vif.MON.hreset_n !== 1'b1 || vif.mon_cb.hready_i !== 1'b1 || vif.mon_cb.htrans != NONSEQ || vif.mon_cb.hsel != 1'b1 || vif.mon_cb.hready_o !== 1'b1) begin
      @vif.mon_cb;
    end
    monitor_item.start_time = $realtime();
    monitor_item.master = vif.mon_cb.hmaster;
    @vif.mon_cb;
    while (vif.MON.hreset_n !== 1'b1 || vif.mon_cb.hready_i !== 1'b1 || (vif.mon_cb.htrans != NONSEQ && vif.mon_cb.htrans != IDLE) || vif.mon_cb.hready_o !== 1'b1) begin
      @vif.mon_cb;
    end
    monitor_item.end_time = $realtime();
    // Detected
    #0;
    process_observed(monitor_item);
  endtask

endclass

`endif
