/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_AGENT_CONFIG_SV
`define YUU_AHB_AGENT_CONFIG_SV

// Class: yuu_ahb_agent_config
// Configuration object of yuu_ahb_agent, which is a base class for AHB master/slave
// agent configuration. This class includes most setting of AHB agent.
class yuu_ahb_agent_config extends uvm_object;
  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool   events;

  // Variable: index
  // Index of agent, by default is -1. It must be set to a non-nagetive integer which
  // the agent is not reserved.
  int index = -1;

  // Variable: timeout
  // Timeout setting of agent.
  real timeout = 0;

  // Variable: addr_width
  // Address width of HADDR, default value is 32.
  int unsigned addr_width = `YUU_AHB_ADDR_WIDTH;

  // Variable: data_width
  // Data width of HWDATA/HRADATA, default value is 32.
  int unsigned data_width = `YUU_AHB_DATA_WIDTH;

  // Variable: analysis_enable
  // Enable throughput analysis component of agent.
  boolean analysis_enable = False;

  // Variable: coverage_enable
  // Enable functional coverage collection component of agent.
  boolean coverage_enable = False;

  // Variable: protocol_check_enable
  // Enable AHB protocol checker for agent.
  boolean protocol_check_enable = True;

  // Variable: maps
  // The address(es) which master can access, or the address(es)
  // of slave.
  yuu_common_addr_map maps[];

  // Variable: multi_range
  // If the agent has multiple address range.
  protected boolean multi_range = False;
  
  // Variable: is_active
  // When agent set to ACTIVE the sequencer and driver will be worked.
  // Otherwise only monitor is working.
  uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  
  `uvm_object_utils_begin(yuu_ahb_agent_config)
    `uvm_field_int         (                          index,                  UVM_PRINT | UVM_COPY)
    `uvm_field_real        (                          timeout,                UVM_PRINT | UVM_COPY)
    `uvm_field_int         (                          addr_width,             UVM_PRINT | UVM_COPY)
    `uvm_field_int         (                          data_width,             UVM_PRINT | UVM_COPY)
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

// Function: new
// Constructor of object.
function yuu_ahb_agent_config::new (string name="yuu_ahb_agent_config");
  super.new(name);
endfunction

// Function: check_valid
// Check the validity of the configuration.
function boolean yuu_ahb_agent_config::check_valid();
  return True;
endfunction

// Function: set_map
//
// Set master/slave address range
// Para:
//  low   - (yuu_ahb_addr_t) low address boundary
//  high  - (yuu_ahb_addr_t) high address boundary
function void yuu_ahb_agent_config::set_map(yuu_ahb_addr_t low, yuu_ahb_addr_t high);
  maps = new[1];
  maps[0] = yuu_common_addr_map::type_id::create($sformatf("%s_maps[0]", this.get_name()));

  maps[0].set_map(low, high);
endfunction

// Function: set_maps
//
// Set master/slave address ranges
// Para:
//  low   - (yuu_ahb_addr_t[]) low address boundaries
//  high  - (yuu_ahb_addr_t[]) high address boundaries
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

// Function: get_map
//
// get all master/slave address range
function yuu_common_addr_map yuu_ahb_agent_config::get_map();
  return this.maps[0];
endfunction

// Function: get_maps
//
// get all master/slave address ranges
// Para:
//  maps - address maps information of agent
function void yuu_ahb_agent_config::get_maps(ref yuu_common_addr_map maps[]);
  maps = new[this.maps.size()];
  foreach (maps[i]) begin
    maps[i] = yuu_common_addr_map::type_id::create("map");
    maps[i].copy(this.maps[i]);
  end
endfunction

// Function: is_multi_range
//
// Return agent has multiple address ranges or not
function boolean yuu_ahb_agent_config::is_multi_range();
  return this.multi_range;
endfunction

`endif