/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////

`ifndef YUU_AHB_BASE_CASE_SV
`define YUU_AHB_BASE_CASE_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

import yuu_common_pkg::*;
import yuu_ahb_pkg::*;

`include "slave_ral_model.sv"
class yuu_ahb_base_case extends uvm_test;
  virtual yuu_ahb_interface vif;

  yuu_ahb_env env;
  yuu_ahb_env_config cfg;
  yuu_ahb_virtual_sequencer vsequencer;
  slave_ral_model model;

  uvm_event_pool events;

  `uvm_component_utils(yuu_ahb_base_case)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    events = new("events");
    cfg = yuu_ahb_env_config::type_id::create("cfg");
    cfg.events = events;
    uvm_config_db#(virtual yuu_ahb_interface)::get(null, get_full_name(), "yuu_ahb_interface", vif);

    cfg.ahb_if = vif;
    begin
      yuu_ahb_agent_config m_cfg = yuu_ahb_agent_config::type_id::create("e0_m0");
      m_cfg.index = 0;
      m_cfg.idle_enable = True;
      m_cfg.busy_enable = True;
      m_cfg.use_response = False;
      m_cfg.agent_type = MASTER;
      cfg.set_config(m_cfg);
    end
    begin
      yuu_ahb_agent_config s_cfg = yuu_ahb_agent_config::type_id::create("e0_s0");
      s_cfg.index = 0;
      s_cfg.set_map(0, 32'hF000_0000);
      s_cfg.mem_init_pattern = PATTERN_RANDOM;
      s_cfg.wait_enable = False;
      s_cfg.agent_type = SLAVE;
      cfg.set_config(s_cfg);
    end

    uvm_config_db#(yuu_ahb_env_config)::set(this, "env", "cfg", cfg);
    env = yuu_ahb_env::type_id::create("env", this);

    model = new("model");
    model.build();
    model.lock_model();
    model.reset();
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    model.default_map.set_sequencer(env.vsequencer.master_sequencer[0], env.master[0].adapter);
    if (cfg.mst_cfg[0].use_reg_model)
      env.master[0].predictor.map = model.default_map;
    vsequencer = env.vsequencer;
  endfunction
endclass

`endif
