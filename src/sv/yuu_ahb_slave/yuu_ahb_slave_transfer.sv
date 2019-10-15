/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_TRANSFER_SV
`define YUU_AHB_SLAVE_TRANSFER_SV

class yuu_ahb_slave_transfer extends yuu_ahb_transfer;
  rand int unsigned wait_delay;

  constraint c_wait_delay {
    cfg.wait_enable == False -> wait_delay == 0;
    soft wait_delay inside {[0:16]};
  }

  `uvm_object_utils_begin(yuu_ahb_slave_transfer)
    `uvm_field_int (wait_delay, UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  function new(string name = "yuu_ahb_slave_transfer");
    super.new(name);
  endfunction
endclass

`endif
