/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_SLAVE_ITEM_SV
`define GUARD_YUU_AHB_SLAVE_ITEM_SV

// Class: yuu_ahb_slave_item
// AHB slave transaction.
class yuu_ahb_slave_item extends yuu_ahb_item;
  // Variable: cfg
  // AHB slave agent configuration object.
  yuu_ahb_slave_config cfg;

  // Variable: wait_delay
  // HREADY low cycles inside burst transfer.
  rand int unsigned wait_delay;

  // Constraint: c_len
  // Slave transaction only has len = 0.
  constraint c_len {len == 0;}

  // Constraint: c_wait
  // wait_delay range constraint.
  constraint c_wait {
    soft wait_delay inside {[0 : `YUU_AHB_MAX_DELAY]};
    if (!cfg.wait_enable) {wait_delay == 0;}
  }

  `uvm_object_utils_begin(yuu_ahb_slave_item)
    `uvm_field_int(wait_delay, UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern function new(string name = "yuu_ahb_slave_item");
  extern function void pre_randomize();
endclass

// Function: new
// Constructor of object.
function yuu_ahb_slave_item::new(string name = "yuu_ahb_slave_item");
  super.new(name);
endfunction

// Function: pre_randomize
// SV built-in function.
function void yuu_ahb_slave_item::pre_randomize();
  if (!uvm_config_db#(yuu_ahb_slave_config)::get(null, get_full_name(), "cfg", cfg) && cfg == null)
    `uvm_fatal("pre_randomize", "Cannot get AHB configuration in transaction")
endfunction

`endif
