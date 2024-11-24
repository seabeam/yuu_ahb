/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_MONITOR_DEMO_CASE_SV
`define GUARD_YUU_AHB_MONITOR_DEMO_CASE_SV

class yuu_monitor_demo_sequence extends yuu_ahb_master_sequence_base;
  int count = 0;
  `uvm_object_utils(yuu_monitor_demo_sequence)

  function new(string name = "yuu_monitor_demo_sequence");
    super.new(name);
  endfunction : new

  task body();
    uvm_event master_done = events.get("master_done");
    yuu_ahb_master_item wr_req, rd_req;

    use_response_handler(1);
    wr_req = yuu_ahb_master_item::type_id::create("wr_req");
    wr_req.cfg = cfg;

    wr_req.randomize() with {
      start_address == 32'h80000100;
      len == 3;
      size == SIZE32;
      burst == INCR;
      idle_delay == 4;
      foreach (data[i]) {
        data[i] == (i + 'h1) << i * 8;
        busy_delay[i] inside {[0 : 2]};
      }
      direction == WRITE;
    };
    start_item(wr_req);
    finish_item(wr_req);

    rd_req = yuu_ahb_master_item::type_id::create("rd_req");
    rd_req.cfg = cfg;

    rd_req.randomize() with {start_address == 32'h80000100;
                             len == 3;
                             size == SIZE32;
                             burst == INCR4;
                             idle_delay == 4;
                             foreach (data[i]) {busy_delay[i] inside {[0 : 2]};}
                             direction == READ;};
    start_item(rd_req);
    finish_item(rd_req);

    wait (count == 2);
  endtask

  function void response_handler(uvm_sequence_item response);
    count++;
  endfunction : response_handler
endclass : yuu_monitor_demo_sequence


class yuu_ahb_monitor_demo_case extends yuu_ahb_single_base_case;
  uvm_analysis_imp #(yuu_ahb_item, yuu_ahb_monitor_demo_case) in_case_export;
  bit has_write;
  bit has_read;

  `uvm_component_utils(yuu_ahb_monitor_demo_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    in_case_export = new("in_case_export", this);
    mst_cfg.use_response = True;

    uvm_config_db#(uvm_object_wrapper)::set(this, "slave.sequencer.run_phase", "default_sequence",
                                            yuu_ahb_slave_response_sequence::type_id::get());
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    slave.out_monitor_port.connect(in_case_export);
  endfunction : connect_phase

  function void write(yuu_ahb_item t);
    t.print();
    if (t.direction == WRITE) has_write = 1;
    else if (t.direction == READ) has_read = 1;
  endfunction

  task run_phase(uvm_phase phase);
    yuu_monitor_demo_sequence seq;
    seq = new("seq");

    phase.raise_objection(this);
    repeat (8) mst_vif.wait_cycle();
    seq.start(master.sequencer);
    phase.drop_objection(this);
  endtask : run_phase

  function void check_phase(uvm_phase phase);
    if (has_read && has_write) `uvm_info("check_phase", "Check passed", UVM_LOW)
    else `uvm_error("check_phase", "Check failed")
  endfunction : check_phase
endclass : yuu_ahb_monitor_demo_case

`endif
