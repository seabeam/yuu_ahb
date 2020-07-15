/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_CONFIG_SV
`define YUU_AHB_MASTER_CONFIG_SV

class yuu_ahb_master_config extends yuu_ahb_agent_config;
  // group: master
  virtual yuu_ahb_master_interface  vif;

  boolean idle_enable = True;
  boolean busy_enable = True;
  boolean use_busy_end              = False;
  boolean use_protection_transfers  = False;
  boolean use_extended_memory_types = False;
  boolean use_locked_transfers      = False;
  boolean use_secure_transfers      = False;
  boolean use_exclusive_transfers   = False;
  boolean use_response              = False;
  boolean use_reg_model             = False;

  yuu_ahb_error_behavior_e error_behavior = CONTINUE_AFTER_ERROR;
  
  
  `uvm_object_utils_begin(yuu_ahb_master_config)
    `uvm_field_enum(boolean,                  idle_enable,              UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  busy_enable,              UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_busy_end,             UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_protection_transfers, UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_extended_memory_types,UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_locked_transfers,     UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_secure_transfers,     UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_exclusive_transfers,  UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_response,             UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  use_reg_model,            UVM_PRINT | UVM_COPY)
    `uvm_field_enum(yuu_ahb_error_behavior_e, error_behavior,           UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern function         new(string name="yuu_ahb_master_config");
  extern function boolean check_valid();
endclass

function yuu_ahb_master_config::new (string name="yuu_ahb_master_config");
  super.new(name);
endfunction

function boolean yuu_ahb_master_config::check_valid();
  if (use_reg_model && !use_response)
      `uvm_error("check_valid", "When register model using, only use_response enable is available")
      return False;

  return True;
endfunction

`endif