/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_ENV_CONFIG_SV
`define GUARD_YUU_AHB_ENV_CONFIG_SV 

// Class: yuu_ahb_env_config
// Configuration class for AHB environment.
class yuu_ahb_env_config extends uvm_object;
  // Variable: vif
  // AHB bus interface handle.
  virtual yuu_ahb_interface ahb_if;

  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool events;

  // Variable: mst_cfg
  // AHB master configuration pool.
  yuu_ahb_master_config mst_cfg[$];

  // Variable: slv_cfg
  // AHB slave configuration pool.
  yuu_ahb_slave_config slv_cfg[$];

  // Variable: compare_enable
  // Enable scoreboard.
  boolean compare_enable = False;

  // Variable: protocol_check_enable
  // Bus protocol check enable.
  boolean protocol_check_enable = False;

  `uvm_object_utils_begin(yuu_ahb_env_config)
    `uvm_field_enum(boolean, compare_enable, UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean, protocol_check_enable, UVM_PRINT | UVM_COPY)
    `uvm_field_queue_object(mst_cfg, UVM_PRINT | UVM_COPY)
    `uvm_field_queue_object(slv_cfg, UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern function new(string name = "yuu_ahb_env_config");
  extern virtual function void set_config(yuu_ahb_agent_config cfg);
  extern virtual function void set_configs(yuu_ahb_agent_config cfg[]);
  extern virtual function boolean check_valid();
endclass

// Function: new
// Constructor of object.
function yuu_ahb_env_config::new(string name = "yuu_ahb_env_config");
  super.new(name);
endfunction

// Function: set_config
// Set user configuration to environment configuration pool.
// Para:
//  cfg - Agent configuration.
function void yuu_ahb_env_config::set_config(yuu_ahb_agent_config cfg);
  if (cfg == null) `uvm_fatal("set_config", "Which yuu_ahb agent config set is null")

  cfg.events = events;
  case (cfg.get_type_name())
    "yuu_ahb_master_config": begin
      yuu_ahb_master_config mcfg = yuu_ahb_master_config::type_id::create("config");

      $cast(mcfg, cfg);
      if (mcfg.index >= 0) mcfg.vif = ahb_if.get_master_if(mcfg.index);
      mst_cfg.push_back(mcfg);
    end
    "yuu_ahb_slave_config": begin
      yuu_ahb_slave_config scfg = yuu_ahb_slave_config::type_id::create("config");

      $cast(scfg, cfg);
      if (scfg.index >= 0) scfg.vif = ahb_if.get_slave_if(scfg.index);
      slv_cfg.push_back(scfg);
    end
    default: begin
      `uvm_fatal("set_config", $sformatf("Invalid agent config object type: %s", cfg.get_type_name()
                 ))
    end
  endcase
endfunction

// Function: set_configs
// Set user configurations to environment configuration pool.
// Para:
//  cfg - Agent configurations array.
function void yuu_ahb_env_config::set_configs(yuu_ahb_agent_config cfg[]);
  foreach (cfg[i]) set_config(cfg[i]);
endfunction

// Function: check_valid
// Check the validity of the configuration.
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
