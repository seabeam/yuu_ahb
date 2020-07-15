/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_VIRTUAL_SEQUENCER_SV
`define YUU_AHB_VIRTUAL_SEQUENCER_SV

class yuu_ahb_virtual_sequencer extends uvm_virtual_sequencer;
  virtual yuu_ahb_interface vif;

  yuu_ahb_env_config  cfg;
  uvm_event_pool      events;

  yuu_ahb_master_sequencer  master_sequencer[];
  yuu_ahb_slave_sequencer   slave_sequencer[];

  `uvm_component_utils(yuu_ahb_virtual_sequencer)

  extern function      new(string name, uvm_component parent);
  extern function void connect_phase(uvm_phase phase);
endclass : yuu_ahb_virtual_sequencer

function yuu_ahb_virtual_sequencer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void yuu_ahb_virtual_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);

  if (cfg == null)
    `uvm_fatal("connect_phase", "Virtual sequencer cannot get env configuration object")

  vif = cfg.ahb_if;
  events = cfg.events;
endfunction


class yuu_ahb_virtual_sequence extends uvm_sequence_base;
  `uvm_object_utils(yuu_ahb_virtual_sequence)
  `uvm_declare_p_sequencer(yuu_ahb_virtual_sequencer)

  function new(string name="yuu_ahb_virtual_sequence");
    super.new(name);
  endfunction
endclass : yuu_ahb_virtual_sequence

`endif
