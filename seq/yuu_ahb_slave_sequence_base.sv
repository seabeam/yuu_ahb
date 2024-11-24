/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_SLAVE_SEQUENCE_BASE_SV
`define GUARD_YUU_AHB_SLAVE_SEQUENCE_BASE_SV

typedef class yuu_ahb_slave_sequencer;
// Class: yuu_ahb_slave_sequence_base
// The base class for AHB slave sequence.
class yuu_ahb_slave_sequence_base extends uvm_sequence #(yuu_ahb_slave_item);
  // Variable: vif
  // AHB slave interface handle.
  virtual yuu_ahb_slave_interface vif;

  // Variable: cfg
  // AHB slave agent configuration object.
  yuu_ahb_slave_config cfg;

  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool events;

  // Variable: error_object
  // Error object for application.
  yuu_ahb_error error_object;

  `uvm_object_utils(yuu_ahb_slave_sequence_base)
  `uvm_declare_p_sequencer(yuu_ahb_slave_sequencer)

  // Function: new
  // Constructor of object.
  function new(string name = "yuu_ahb_slave_sequence_base");
    super.new(name);
  endfunction

  // Task: pre_start
  // UVM built-in method.
  task pre_start();
    cfg = p_sequencer.cfg;
    vif = cfg.vif;
    events = cfg.events;
  endtask

  // Task: body
  // UVM built-in method.
  task body();
    `uvm_warning("body", "The body task should be OVERRIDED by derived class")
  endtask
endclass

`endif
