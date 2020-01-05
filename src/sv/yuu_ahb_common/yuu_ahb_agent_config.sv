/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_AGENT_CONFIG_SV
`define YUU_AHB_AGENT_CONFIG_SV

class yuu_ahb_agent_config extends uvm_object;
  uvm_event_pool   events;

  int          index = -1;
  int unsigned addr_width = `YUU_AHB_ADDR_WIDTH;
  int unsigned data_width = `YUU_AHB_DATA_WIDTH;
  int          timeout = 0;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Struct control
  boolean analysis_enable = False;
  boolean coverage_enable = False;
  boolean protocol_check_enable = True;

  `uvm_object_utils_begin(yuu_ahb_agent_config)
    `uvm_field_int (                          index,                  UVM_PRINT | UVM_COPY)
    `uvm_field_int (                          addr_width,             UVM_PRINT | UVM_COPY)
    `uvm_field_int (                          data_width,             UVM_PRINT | UVM_COPY)
    `uvm_field_int (                          timeout,                UVM_PRINT | UVM_COPY)
    `uvm_field_enum(uvm_active_passive_enum,  is_active,              UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  coverage_enable,        UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  analysis_enable,        UVM_PRINT | UVM_COPY)
    `uvm_field_enum(boolean,                  protocol_check_enable,  UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  function new (string name="yuu_ahb_agent_config");
    super.new(name);
  endfunction
endclass

`endif