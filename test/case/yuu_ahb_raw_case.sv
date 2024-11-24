/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_RAW_CASE_SV
`define GUARD_YUU_AHB_RAW_CASE_SV

class yuu_ahb_raw_case extends yuu_ahb_base_case;
  `uvm_component_utils(yuu_ahb_raw_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg.mst_cfg[0].use_response = True;
    cfg.mst_cfg[0].busy_enable = False;
    cfg.mst_cfg[0].keep_value_end_enable = False;

    uvm_config_db#(uvm_object_wrapper)::set(this, "env.slave[0].sequencer.run_phase", "default_sequence", yuu_ahb_slave_response_sequence::type_id::get());
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    yuu_ahb_master_raw_sequence seq = yuu_ahb_master_raw_sequence::type_id::create("seq");

    phase.raise_objection(this);
    seq.n_item = 100;
    seq.start(vsequencer.master_sequencer[0]);
    phase.drop_objection(this);
  endtask : run_phase
endclass : yuu_ahb_raw_case

`endif
