/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_SINGLE_BASE_CASE_SV
`define GUARD_YUU_AHB_SINGLE_BASE_CASE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

import yuu_common_pkg::*;
import yuu_ahb_pkg::*;

`include "slave_ral_model.sv"
class yuu_ahb_single_base_case extends uvm_test;
  virtual yuu_ahb_master_interface  mst_vif;
  virtual yuu_ahb_slave_interface   slv_vif;

  yuu_ahb_master_agent  master;
  yuu_ahb_slave_agent   slave;
  yuu_ahb_master_config mst_cfg;
  yuu_ahb_slave_config  slv_cfg;
  yuu_ahb_virtual_sequencer vsequencer;
  slave_ral_model model;

  uvm_event_pool events;

  `uvm_component_utils(yuu_ahb_single_base_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    events = new("events");
    mst_cfg = yuu_ahb_master_config::type_id::create("mst_cfg");
    slv_cfg = yuu_ahb_slave_config::type_id::create("slv_cfg");
    mst_cfg.events = events;
    slv_cfg.events = events;
    uvm_config_db#(virtual yuu_ahb_master_interface)::get(null, get_full_name(), "yuu_ahb_master_interface", mst_vif);
    uvm_config_db#(virtual yuu_ahb_slave_interface)::get(null, get_full_name(), "yuu_ahb_slave_interface", slv_vif);

    mst_cfg.vif = mst_vif;
    mst_cfg.index = 0;
    mst_cfg.idle_enable = True;
    mst_cfg.busy_enable = True;
    mst_cfg.use_response = False;
    mst_cfg.set_map(0, 32'hF000_0000);

    slv_cfg.vif = slv_vif;
    slv_cfg.index = 0;
    slv_cfg.mem_init_pattern = PATTERN_RANDOM;
    slv_cfg.wait_enable = False;
    slv_cfg.set_map(0, 32'hF000_0000);

    uvm_config_db#(yuu_ahb_master_config)::set(this, "master", "cfg", mst_cfg);
    uvm_config_db#(yuu_ahb_slave_config)::set(this, "slave", "cfg", slv_cfg);
    master  = yuu_ahb_master_agent::type_id::create("master", this);
    slave   = yuu_ahb_slave_agent::type_id::create("slave", this);

    model = new("model");
    model.build();
    model.lock_model();
    model.reset();

    vsequencer = yuu_ahb_virtual_sequencer::type_id::create("vsequencer", this);
    vsequencer.cfg = yuu_ahb_env_config::type_id::create("cfg");
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    model.default_map.set_sequencer(master.sequencer, master.adapter);
    if (mst_cfg.use_reg_model)
      master.predictor.map = model.default_map;
    vsequencer.master_sequencer = new[1];
    vsequencer.master_sequencer[0] = master.sequencer;
    vsequencer.slave_sequencer = new[1];
    vsequencer.slave_sequencer[0] = slave.sequencer;
  endfunction
endclass

`endif
