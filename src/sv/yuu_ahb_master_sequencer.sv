/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_SEQUENCER_SV
`define YUU_AHB_MASTER_SEQUENCER_SV

class yuu_ahb_master_sequencer extends uvm_sequencer #(yuu_ahb_master_item);
  virtual yuu_ahb_master_interface vif;

  yuu_ahb_master_config cfg;
  uvm_event_pool        events;

  `uvm_component_utils(yuu_ahb_master_sequencer)

  extern                   function      new(string name, uvm_component parent);
  extern           virtual function void connect_phase(uvm_phase phase);
endclass

function yuu_ahb_master_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void yuu_ahb_master_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  this.vif = cfg.vif;
  this.events = cfg.events;
endfunction

`endif
