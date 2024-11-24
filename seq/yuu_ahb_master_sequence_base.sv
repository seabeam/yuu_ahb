/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_MASTER_SEQUENCE_BASE_SV
`define GUARD_YUU_AHB_MASTER_SEQUENCE_BASE_SV

typedef class yuu_ahb_master_sequencer;
// Class: yuu_ahb_master_sequence_base
// The base class for AHB master sequence.
class yuu_ahb_master_sequence_base extends uvm_sequence #(yuu_ahb_master_item);
  // Variable: vif
  // AHB master interface handle.
  virtual yuu_ahb_master_interface vif;

  // Variable: cfg
  // AHB master agent configuration object.
  yuu_ahb_master_config cfg;

  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool events;

  // Variable: n_item
  // Transaction number which expect to send.
  int unsigned n_item = 10;

  `uvm_object_utils(yuu_ahb_master_sequence_base)
  `uvm_declare_p_sequencer(yuu_ahb_master_sequencer)

  // Function: new
  // Constructor of object.
  function new(string name = "yuu_ahb_master_sequence_base");
    super.new(name);
  endfunction

  // Task: pre_start
  // UVM built-in method.
  virtual task pre_start();
    cfg = p_sequencer.cfg;
    vif = cfg.vif;
    events = cfg.events;
  endtask

  // Task: body
  // UVM built-in method.
  virtual task body();
    `uvm_warning("body", "The body task should be OVERRIDED by derived class")
  endtask
endclass

`endif
