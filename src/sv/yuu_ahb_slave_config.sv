/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_SLAVE_CONFIG_SV
`define GUARD_YUU_AHB_SLAVE_CONFIG_SV

// Class: yuu_ahb_slave_config
// Configuration object for AHB slave.
class yuu_ahb_slave_config extends yuu_ahb_agent_config;
  // Variable: vif
  // AHB bus interface handle.
  virtual yuu_ahb_slave_interface vif;

  // Variable: wait_enable
  // The switch of slave random wait cycles.
  boolean wait_enable = True;

  // Variable: mem_init_pattern
  // The initial pattern of built-in memory of slave driver.
  yuu_common_mem_pattern_e mem_init_pattern = PATTERN_ALL_0;
  
  
  `uvm_object_utils_begin(yuu_ahb_slave_config)
    `uvm_field_enum(boolean,                  wait_enable,      UVM_PRINT | UVM_COPY)
    `uvm_field_enum(yuu_common_mem_pattern_e, mem_init_pattern, UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern function         new(string name="yuu_ahb_slave_config");
  extern function boolean check_valid();
endclass

// Function: new
// Constructor of object.
function yuu_ahb_slave_config::new (string name="yuu_ahb_slave_config");
  super.new(name);
endfunction

// Function: check_valid
// Check the validity of the configuration.
function boolean yuu_ahb_slave_config::check_valid();
  return True;
endfunction

`endif