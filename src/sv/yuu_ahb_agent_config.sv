/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_AGENT_CONFIG_SV
`define YUU_AHB_AGENT_CONFIG_SV

class yuu_ahb_agent_config extends uvm_object;
  // group: common
  uvm_event_pool   events;

  int index = -1;
  int timeout = 0;
  int unsigned addr_width = `YUU_AHB_ADDR_WIDTH;
  int unsigned data_width = `YUU_AHB_DATA_WIDTH;
  yuu_ahb_agent_type_e agent_type = MASTER;
  boolean analysis_enable = False;
  boolean coverage_enable = False;
  boolean protocol_check_enable = True;
  yuu_common_addr_map maps[];
  protected boolean multi_range = False;
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  
  `uvm_object_utils_begin(yuu_ahb_agent_config)
    `uvm_field_int         (                          index,                  UVM_PRINT | UVM_COPY)
    `uvm_field_int         (                          timeout,                UVM_PRINT | UVM_COPY)
    `uvm_field_int         (                          addr_width,             UVM_PRINT | UVM_COPY)
    `uvm_field_int         (                          data_width,             UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (yuu_ahb_agent_type_e,     agent_type,             UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  analysis_enable,        UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  coverage_enable,        UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  protocol_check_enable,  UVM_PRINT | UVM_COPY)
    `uvm_field_array_object(                          maps,                   UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  multi_range,            UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (uvm_active_passive_enum,  is_active,              UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern function                     new(string name="yuu_ahb_agent_config");
  extern function boolean             check_valid();
  extern function void                set_map(yuu_ahb_addr_t low, yuu_ahb_addr_t high);
  extern function void                set_maps(yuu_ahb_addr_t lows[], yuu_ahb_addr_t highs[]);
  extern function yuu_common_addr_map get_map();
  extern function void                get_maps(ref yuu_common_addr_map maps[]);
  extern function boolean             is_multi_range();
endclass

function yuu_ahb_agent_config::new (string name="yuu_ahb_agent_config");
  super.new(name);
endfunction

function boolean yuu_ahb_agent_config::check_valid();
  return True;
endfunction

// set_map
//
// Set slave address range
// low: low address boundary
// high: high address boundary
function void yuu_ahb_agent_config::set_map(yuu_ahb_addr_t low, yuu_ahb_addr_t high);
  maps = new[1];
  maps[0] = yuu_common_addr_map::type_id::create($sformatf("%s_maps[0]", this.get_name()));

  maps[0].set_map(low, high);
endfunction

function void yuu_ahb_agent_config::set_maps(yuu_ahb_addr_t lows[], yuu_ahb_addr_t highs[]);
  if (lows.size() == 0|| highs.size() == 0)
    `uvm_error("set_maps", "The lows or highs array is empty")
  else if (lows.size() != highs.size())
    `uvm_error("set_maps", "The lows and highs array must in the same size")
  else begin
    maps = new[lows.size()];
    foreach (maps[i])
      maps[i] = yuu_common_addr_map::type_id::create($sformatf("%s_maps[%0d]", this.get_name(), i));
    foreach (lows[i])
      maps[i].set_map(lows[i], highs[i]);
    if (lows.size() > 1)
      this.multi_range = True;
  end
endfunction

function yuu_common_addr_map yuu_ahb_agent_config::get_map();
  return this.maps[0];
endfunction

function void yuu_ahb_agent_config::get_maps(ref yuu_common_addr_map maps[]);
  maps = new[this.maps.size()];
  foreach (maps[i]) begin
    maps[i] = yuu_common_addr_map::type_id::create("map");
    maps[i].copy(this.maps[i]);
  end
endfunction

function boolean yuu_ahb_agent_config::is_multi_range();
  return this.multi_range;
endfunction

`endif