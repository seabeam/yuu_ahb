/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_ENV_CONFIG_SV
`define YUU_AHB_ENV_CONFIG_SV

class yuu_ahb_env_config extends uvm_object;
  virtual yuu_ahb_interface ahb_if;

  uvm_event_pool events;
  
  yuu_ahb_agent_config  mst_cfg[$];
  yuu_ahb_agent_config  slv_cfg[$];

  boolean compare_enable = False;
  boolean protocol_check_enable = False;

  `uvm_object_utils_begin(yuu_ahb_env_config)
    `uvm_field_enum         (boolean, compare_enable,         UVM_PRINT | UVM_COPY)
    `uvm_field_enum         (boolean, protocol_check_enable,  UVM_PRINT | UVM_COPY)
    `uvm_field_queue_object (         mst_cfg,                UVM_PRINT | UVM_COPY)
    `uvm_field_queue_object (         slv_cfg,                UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern         function         new(string name="yuu_ahb_env_config");
  extern virtual function void    set_config(yuu_ahb_agent_config cfg);
  extern virtual function void    set_configs(yuu_ahb_agent_config cfg[]);
  extern virtual function boolean check_valid();
endclass

function yuu_ahb_env_config::new(string name="yuu_ahb_env_config");
  super.new(name);
endfunction

function void yuu_ahb_env_config::set_config(yuu_ahb_agent_config cfg);
  if (cfg == null)
    `uvm_fatal("set_config", "Which yuu_ahb agent config set is null")

  cfg.events = events;
  if (cfg.agent_type == MASTER) begin
    if(cfg.index >= 0)
      cfg.mst_vif = ahb_if.get_master_if(cfg.index);
    mst_cfg.push_back(cfg);
  end
  else if (cfg.agent_type == SLAVE) begin
    if (cfg.index >= 0)
      cfg.slv_vif = ahb_if.get_slave_if(cfg.index);
    slv_cfg.push_back(cfg);
  end
  else
    `uvm_fatal("set_config", $sformatf("Invalid yuu_ahb agent configure object type: %s", cfg.agent_type))
endfunction

function void yuu_ahb_env_config::set_configs(yuu_ahb_agent_config cfg[]);
  foreach (cfg[i])
    set_config(cfg[i]);
endfunction

function boolean yuu_ahb_env_config::check_valid();
  foreach (mst_cfg[i]) begin
    if (!mst_cfg[i].check_valid()) begin
      return False;
    end
  end
  foreach (slv_cfg[i]) begin
    if (!slv_cfg[i].check_valid()) begin
      return False;
    end
  end

  return True;
endfunction

`endif