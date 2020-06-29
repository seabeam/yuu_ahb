/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SINGLE_DIRECT_CASE_SV
`define YUU_AHB_SINGLE_DIRECT_CASE_SV

class yuu_ahb_single_direct_case extends yuu_ahb_single_base_case;
  `uvm_component_utils(yuu_ahb_single_direct_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    mst_cfg.use_response = True;
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    yuu_master_direct_virtual_sequence seq;
    seq = new("seq");

    phase.raise_objection(this);
    seq.start(vsequencer);
    phase.drop_objection(this);
  endtask : run_phase
endclass : yuu_ahb_single_direct_case

`endif
