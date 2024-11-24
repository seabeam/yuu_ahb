/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_RAL_CASE_SV
`define GUARD_YUU_AHB_RAL_CASE_SV

class yuu_master_ral_virtual_sequence extends yuu_ahb_virtual_sequence;
  slave_ral_model model;

  `uvm_object_utils(yuu_master_ral_virtual_sequence)

  function new(string name="yuu_master_ral_virtual_sequence");
    super.new(name);
  endfunction : new

  task body();
    yuu_ahb_slave_response_sequence       rsp_seq = new("rsp_seq");
    fork
      begin
        uvm_status_e    status;
        uvm_reg_data_t  value;

        #100ns;
        model.common.RA.write(status, 32'h1234);
        #100ns;
        model.common.RB.write(status, 32'h4321);
        model.common.RA.read(status, value);
        #100ns;
        if (value != 32'h1234)
          `uvm_fatal("body", $sformatf("Expect value is 32'h1234 but 32'h%0h get", value))
        `uvm_info("body", $sformatf("Register A value is %8h", value), UVM_LOW);
      end
      rsp_seq.start(p_sequencer.slave_sequencer[0]);
    join_any
  endtask
endclass : yuu_master_ral_virtual_sequence


class yuu_ahb_ral_case extends yuu_ahb_base_case;
  `uvm_component_utils(yuu_ahb_ral_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    cfg.mst_cfg[0].use_reg_model = True;
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    yuu_master_ral_virtual_sequence seq;

    seq = new("seq");
    seq.model = model;
    phase.raise_objection(this);
    seq.start(vsequencer);
    phase.drop_objection(this);
  endtask : run_phase
endclass : yuu_ahb_ral_case

`endif
