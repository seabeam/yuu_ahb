/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_B2B_CASE_SV
`define GUARD_YUU_AHB_B2B_CASE_SV

class yuu_master_b2b_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(yuu_master_b2b_sequence)

  function new(string name = "yuu_master_b2b_sequence");
    super.new(name);
  endfunction : new

  task body();
    uvm_event master_done = events.get("master_done");
    yuu_ahb_master_item req0, req1;
    yuu_ahb_master_item rsp0, rsp1;

    req0 = yuu_ahb_master_item::type_id::create("req0");
    req1 = yuu_ahb_master_item::type_id::create("req1");
    req0.cfg = cfg;
    req1.cfg = cfg;

    // 0x80000100 ---- 0x00000001
    // 0x80000104 ---- 0x00000200
    // 0x80000108 ---- 0x00030000
    // 0x8000010C ---- 0x04000000
    fork
      begin
        req0.randomize() with {
          start_address == 32'h80000100;
          len == 3;
          size == SIZE32;
          burst_type != AHB_WRAP;
          foreach (data[i]) {
            data[i] == (i + 'h1) << i * 8;
            busy_delay[i] inside {[0 : 2]};
          }
          direction == WRITE;
        };
        start_item(req0);
        finish_item(req0);
        get_response(rsp);
      end
      begin
        req1.randomize() with {
          start_address == 32'h80000100;
          len == 15;
          size == SIZE8;
          burst_type != AHB_WRAP;
          foreach (data[i]) {busy_delay[i] inside {[0 : 2]};}
          direction == READ;
        };
        start_item(req1);
        finish_item(req1);
        get_response(rsp1);
      end
    join

    foreach (rsp1.address[i]) begin
      bit [31:0] expected;
      bit [31:0] address;
      int index;

      address = rsp1.address[i][31:2];
      index = address[1:0] + 1;
      expected = index << ((index - 1) * 8);
      if (expected != rsp1.data[i])
        `uvm_error("body", $sformatf(
                   "Compare failed, expected is 0x%0h, actual is 0x%0h", expected, rsp1.data[i]))
      else `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp1.data[i]), UVM_LOW)
    end

    // 0x80000100 ---- 0x00040301
    // 0x80000104 ---- 0x00000200
    // 0x80000108 ---- 0x00030000
    // 0x8000010C ---- 0x04000000
    fork
      begin
        req0.randomize() with {
          start_address == 32'h80000101;
          len == 1;
          size == SIZE8;
          burst_type != AHB_WRAP;
          foreach (data[i]) {
            data[i] == (i + 'h3) << (i + 1) * 8;
            busy_delay[i] inside {[0 : 2]};
          }
          direction == WRITE;
        };
        start_item(req0);
        finish_item(req0);
        get_response(rsp0);
      end
      begin
        req1.randomize() with {
          start_address == 32'h80000100;
          len == 3;
          size == SIZE32;
          burst_type != AHB_WRAP;
          foreach (data[i]) {busy_delay[i] inside {[0 : 2]};}
          direction == READ;
        };
        start_item(req1);
        finish_item(req1);
        get_response(rsp1);
      end
    join
    if (rsp1.data[0] != 32'h00040301)
      `uvm_error("body", $sformatf(
                 "Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h00040301, rsp1.data[0]))
    else `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp1.data[0]), UVM_LOW)
    if (rsp1.data[1] != 32'h00000200)
      `uvm_error("body", $sformatf(
                 "Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h00000200, rsp1.data[1]))
    else `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp1.data[1]), UVM_LOW)
    if (rsp1.data[2] != 32'h00030000)
      `uvm_error("body", $sformatf(
                 "Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h00030000, rsp1.data[2]))
    else `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp1.data[2]), UVM_LOW)
    if (rsp1.data[3] != 32'h04000000)
      `uvm_error("body", $sformatf(
                 "Compare failed, expected is 0x%0h, actual is 0x%0h", 32'h04000000, rsp1.data[3]))
    else `uvm_info("body", $sformatf("Compare pass, actual is 0x%0h", rsp1.data[3]), UVM_LOW)
  endtask
endclass : yuu_master_b2b_sequence

class yuu_ahb_b2b_case extends yuu_ahb_base_case;
  `uvm_component_utils(yuu_ahb_b2b_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg.mst_cfg[0].use_response = True;
    cfg.mst_cfg[0].busy_enable  = False;
    cfg.mst_cfg[0].idle_enable  = False;
    uvm_config_db#(uvm_object_wrapper)::set(this, "env.slave[0].sequencer.run_phase",
                                            "default_sequence",
                                            yuu_ahb_slave_response_sequence::type_id::get());
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    yuu_master_b2b_sequence seq = new("seq");

    phase.raise_objection(this);
    seq.start(vsequencer.master_sequencer[0]);
    phase.drop_objection(this);
  endtask : run_phase
endclass : yuu_ahb_b2b_case

`endif
