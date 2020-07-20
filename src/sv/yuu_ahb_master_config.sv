/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_CONFIG_SV
`define YUU_AHB_MASTER_CONFIG_SV

class yuu_ahb_master_config extends yuu_ahb_agent_config;
  // Variable: vif
  // AHB master interface handle.
  virtual yuu_ahb_master_interface  vif;

  // Variable: idle_enable
  // Switch of IDLE trans between transactions sent out from master.
  boolean idle_enable = True;

  // Variable: busy_enable
  // Switch of busy trans during transaction  sent out from master.
  boolean busy_enable = True;

  // Variable: use_busy_end
  // Transaction randomize with BUSY trans in last transfer or not.
  boolean use_busy_end              = False;

  // Variable: use_protection_transfers
  // Transaction randomize with protection information or not.
  boolean use_protection_transfers  = False;

  // Variable: use_extended_memory_types
  // Transaction randomize with extended memory types information or not.
  boolean use_extended_memory_types = False;

  // Variable: use_locked_transfers
  // Transaction randomize with locked transfers information or not.
  boolean use_locked_transfers      = False;

  // Variable: use_secure_transfers
  // Transaction randomize with secure transfers information or not.
  boolean use_secure_transfers      = False;

  // Variable: use_exclusive_transfers
  // Transaction randomize with exclusive transfers information or not.
  boolean use_exclusive_transfers   = False;

  // Variable: use_response
  // Switch of AHB master wait response from connected slave.
  boolean use_response              = False;

  // Variable: use_reg_model
  // Switch of instantiating register related components like adapter,
  // predictor. When this option is True, the use_response will be
  // also set to True.
  boolean use_reg_model             = False;

  // Variable: error_behavior
  // Behavior of AHB master get a error response. Either continue or
  // abort can be chosen.
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

// Function: new
// Constructor of object.
function yuu_ahb_master_config::new(string name="yuu_ahb_master_config");
  super.new(name);
endfunction

// Function: check_valid
// Check the validity of the configuration.
function boolean yuu_ahb_master_config::check_valid();
  if (use_reg_model && !use_response)
      `uvm_error("check_valid", "When register model using, only use_response enable is available")
      return False;

  return True;
endfunction

`endif