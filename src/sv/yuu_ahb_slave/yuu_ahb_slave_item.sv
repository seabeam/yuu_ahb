/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_ITEM_SVH
`define YUU_AHB_SLAVE_ITEM_SVH

class yuu_ahb_slave_item extends yuu_ahb_item;
  yuu_ahb_slave_config  cfg;

  rand int unsigned wait_delay[];

  constraint c_wait {
    wait_delay.size() == len+1;
    foreach (wait_delay[i]) {
      soft wait_delay[i] inside {[0:16]};
      if (!cfg.wait_enable || len == 0) {
        wait_delay[i] == 0;
      }
    }
  }

  `uvm_object_utils_begin(yuu_ahb_slave_item)
    `uvm_field_array_int(busy_delay, UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern               function        new(string name = "yuu_ahb_slave_item");
endclass

function yuu_ahb_slave_item::new(string name = "yuu_ahb_slave_item");
  super.new(name);
endfunction


`endif
