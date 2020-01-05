/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_ENV_CONFIG_SV
`define YUU_AHB_ENV_CONFIG_SV

class yuu_ahb_env_config extends uvm_object;
  virtual yuu_ahb_interface ahb_if;

  yuu_ahb_master_config  mst_cfg[$];
  yuu_ahb_slave_config   slv_cfg[$];
  uvm_event_pool events;

  boolean compare_enable = False;
  boolean protocol_check_enable = False;

  `uvm_object_utils_begin(yuu_ahb_env_config)
    `uvm_field_enum         (boolean, compare_enable,         UVM_PRINT | UVM_COPY)
    `uvm_field_enum         (boolean, protocol_check_enable,  UVM_PRINT | UVM_COPY)
    `uvm_field_queue_object (         mst_cfg,                UVM_PRINT | UVM_COPY)
    `uvm_field_queue_object (         slv_cfg,                UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern         function new(string name="yuu_ahb_env_config");
  extern virtual function void set_config(yuu_ahb_agent_config cfg);
  extern virtual function void set_configs(yuu_ahb_agent_config cfg[]);
endclass

function yuu_ahb_env_config::new(string name="yuu_ahb_env_config");
  super.new(name);
endfunction

function void yuu_ahb_env_config::set_config(yuu_ahb_agent_config cfg);
  yuu_ahb_master_config m_cfg;
  yuu_ahb_slave_config  s_cfg;

  if (cfg == null)
    `uvm_fatal("set_config", "Which yuu_ahb agent config set is null")

  cfg.events = events;
  if ($cast(m_cfg, cfg)) begin
    if(m_cfg.index >= 0)
      m_cfg.vif = ahb_if.get_master_if(m_cfg.index);
    mst_cfg.push_back(m_cfg);
  end
  else if ($cast(s_cfg, cfg))begin
    if (s_cfg.index >= 0)
      s_cfg.vif = ahb_if.get_slave_if(s_cfg.index);
    slv_cfg.push_back(s_cfg);
  end
  else
    `uvm_fatal("set_config", "Invalid yuu_ahb agent configure object type")
endfunction

function void yuu_ahb_env_config::set_configs(yuu_ahb_agent_config cfg[]);
  foreach (cfg[i])
    set_config(cfg[i]);
endfunction

`endif