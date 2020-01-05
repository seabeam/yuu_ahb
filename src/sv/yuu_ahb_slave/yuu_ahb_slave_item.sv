/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_ITEM_SV
`define YUU_AHB_SLAVE_ITEM_SV

class yuu_ahb_slave_item extends yuu_ahb_item;
  yuu_ahb_slave_config  cfg;

  rand int unsigned wait_delay;

  constraint c_len {
    len == 0;
  }

  constraint c_wait {
    soft wait_delay inside {[0:16]};
    if (!cfg.wait_enable) {
      wait_delay == 0;
    }
  }

  `uvm_object_utils_begin(yuu_ahb_slave_item)
    `uvm_field_int(wait_delay, UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern function      new(string name="yuu_ahb_slave_item");
  extern function void pre_randomize();
endclass

function yuu_ahb_slave_item::new(string name="yuu_ahb_slave_item");
  super.new(name);
endfunction

function void yuu_ahb_slave_item::pre_randomize();
  super.pre_randomize();

  if (!uvm_config_db #(yuu_ahb_slave_config)::get(null, get_full_name(), "cfg", cfg) && cfg == null)
    `uvm_fatal("pre_randomize", "Cannot get AHB slave configuration in transaction")
endfunction

`endif