class yuu_master_ral_direct_sequence extends yuu_ahb_master_sequence_base;
  slave_ral_model model;

  `uvm_object_utils(yuu_master_ral_direct_sequence)

  function new(string name="yuu_master_ral_direct_sequence");
    super.new(name);
  endfunction : new

  task body();
    uvm_status_e    status;
    uvm_reg_data_t  value;

    #100ns;
    model.common.RB.write(status, 32'h1234);
    #100ns;
    model.common.RA.write(status, 32'h1234);
    //#100ns;
    model.common.RA.read(status, value);
    #100ns;
  endtask
endclass : yuu_master_ral_direct_sequence


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
    yuu_master_ral_direct_sequence  mst_seq = new("mst_seq");
    yuu_slave_rsp_seqence     rsp_seq = new("rsp_seq");

    mst_seq.model = model;
    phase.raise_objection(this);
    fork
      mst_seq.start(env.sequencer.master_sequencer[0]);
      rsp_seq.start(env.sequencer.slave_sequencer[0]);
    join_any
    phase.drop_objection(this);
  endtask : run_phase
endclass : yuu_ahb_ral_case
