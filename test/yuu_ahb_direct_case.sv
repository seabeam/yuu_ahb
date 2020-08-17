/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_DIRECT_CASE_SV
`define GUARD_YUU_AHB_DIRECT_CASE_SV

class yuu_master_direct_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(yuu_master_direct_sequence)

  function new(string name="yuu_master_direct_sequence");
    super.new(name);
  endfunction : new

  task body();
    uvm_event master_done = events.get("master_done");

    req = yuu_ahb_master_item::type_id::create("req");
    req.cfg = cfg;

    req.randomize() with {start_address == 32'h80000100;
                          len == 3;
                          size == SIZE32;
                          burst_type != AHB_WRAP;
                          foreach(data[i]) {
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == READ;};
    start_item(req);
    finish_item(req);
    get_response(rsp);

    // 0x80000100 ---- 0x00000001
    // 0x80000104 ---- 0x00000200
    // 0x80000108 ---- 0x00030000
    // 0x8000010C ---- 0x04000000
    req.randomize() with {start_address == 32'h80000100;
                          len == 3;
                          size == SIZE32;
                          burst_type != AHB_WRAP;
                          foreach(data[i]) {
                            data[i] == (i+'h1)<<i*8;
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == WRITE;};
    start_item(req);
    finish_item(req);
    get_response(rsp);

    req.randomize() with {start_address == 32'h80000100;
                          len == 15;
                          size == SIZE8;
                          burst_type != AHB_WRAP;
                          foreach(data[i]) {
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == READ;};
    start_item(req);
    finish_item(req);
    get_response(rsp);
    foreach (rsp.address[i]) begin
      bit[31:0] expected;
      bit[31:0] address;
      int index;
      
      address = rsp.address[i][31:2];
      index = address[1:0]+1;
      expected = index<<((index-1)*8);
      if (expected != rsp.data[i])
        `uvm_error("body", $sformatf("Compare failed, expected is 0x%0h, actual is 0x%0h", expected, rsp.data[i]))
      else
        `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp.data[i]), UVM_LOW)
    end

    // 0x80000100 ---- 0x00040301
    // 0x80000104 ---- 0x00000200
    // 0x80000108 ---- 0x00030000
    // 0x8000010C ---- 0x04000000
    req.randomize() with {start_address == 32'h80000101;
                          len == 1;
                          size == SIZE8;
                          burst_type != AHB_WRAP;
                          foreach(data[i]) {
                            data[i] == (i+'h3)<<(i+1)*8;
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == WRITE;};
    start_item(req);
    finish_item(req);
    get_response(rsp);

    req.randomize() with {start_address == 32'h80000100;
                          len == 3;
                          size == SIZE32;
                          burst_type != AHB_WRAP;
                          foreach(data[i]) {
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == READ;};
    start_item(req);
    finish_item(req);
    get_response(rsp);
    if (rsp.data[0] != 32'h00040301)
      `uvm_error("body", $sformatf("Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h00040301, rsp.data[0]))
    else
      `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp.data[0]), UVM_LOW)
    if (rsp.data[1] != 32'h00000200)
      `uvm_error("body", $sformatf("Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h00000200, rsp.data[1]))
    else
      `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp.data[1]), UVM_LOW)
    if (rsp.data[2] != 32'h00030000)
      `uvm_error("body", $sformatf("Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h00030000, rsp.data[2]))
    else
      `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp.data[2]), UVM_LOW)
    if (rsp.data[3] != 32'h04000000)
      `uvm_error("body", $sformatf("Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h04000000, rsp.data[3]))
    else
      `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp.data[3]), UVM_LOW)
  endtask
endclass : yuu_master_direct_sequence

class yuu_slave_rsp_seqence extends yuu_ahb_slave_sequence_base;
  `uvm_object_utils(yuu_slave_rsp_seqence)

  function new(string name ="yuu_slave_rsp_seqence");
    super.new(name);
  endfunction

  task body();
    uvm_event master_done = events.get("master_done");

    forever begin
      `uvm_create(req)
      req.cfg = cfg;
      req.randomize() with {
        len == 0;
        //response[0] dist {ERROR:=1, OKAY:=1};
        response[0] == OKAY;
        wait_delay inside {[0:2]};
      };
      start_item(req);
      finish_item(req);
    end
  endtask
endclass

class yuu_master_direct_virtual_sequence extends yuu_ahb_virtual_sequence;
  `uvm_object_utils(yuu_master_direct_virtual_sequence)

  function new(string name ="yuu_master_direct_virtual_sequence");
    super.new(name);
  endfunction

  task body();
    yuu_master_direct_sequence  mst_seq = new("mst_seq");
    yuu_slave_rsp_seqence       rsp_seq = new("rsp_seq");
    fork
      mst_seq.start(p_sequencer.master_sequencer[0]);
      rsp_seq.start(p_sequencer.slave_sequencer[0]);
    join_any
  endtask
endclass : yuu_master_direct_virtual_sequence


class yuu_ahb_direct_case extends yuu_ahb_base_case;
  `uvm_component_utils(yuu_ahb_direct_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg.mst_cfg[0].use_response = True;
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    yuu_master_direct_virtual_sequence seq;
    seq = new("seq");

    phase.raise_objection(this);
    seq.start(vsequencer);
    phase.drop_objection(this);
  endtask : run_phase
endclass : yuu_ahb_direct_case

`endif
