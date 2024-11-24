/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_SLAVE_SEQUENCER_SV
`define GUARD_YUU_AHB_SLAVE_SEQUENCER_SV

// Class: yuu_ahb_slave_sequencer
// Sequencer implementation of AHB slave
class yuu_ahb_slave_sequencer extends uvm_sequencer #(yuu_ahb_slave_item);
  // Variable: vif
  // AHB slave interface handle.
  virtual yuu_ahb_slave_interface vif;

  // Variable: cfg
  // AHB slave agent configuration object.
  yuu_ahb_slave_config cfg;

  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool events;

  `uvm_component_utils(yuu_ahb_slave_sequencer)

  extern function new(string name, uvm_component parent);
  extern virtual function void connect_phase(uvm_phase phase);
endclass

// Function: new
// Constructor of object.
function yuu_ahb_slave_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_slave_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  this.vif = cfg.vif;
  this.events = cfg.events;
endfunction

`endif
