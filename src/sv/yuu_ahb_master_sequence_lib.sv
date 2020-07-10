/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_SEQUENCE_LIB_SV
`define YUU_AHB_MASTER_SEQUENCE_LIB_SV

typedef class yuu_ahb_master_sequencer;
class yuu_ahb_master_sequence_base extends uvm_sequence #(yuu_ahb_item);
  virtual yuu_ahb_master_interface vif;

  yuu_ahb_agent_config cfg;
  uvm_event_pool       events;

  int unsigned n_item = 10;

  `uvm_object_utils(yuu_ahb_master_sequence_base)
  `uvm_declare_p_sequencer(yuu_ahb_master_sequencer)

  function new(string name="yuu_ahb_master_sequence_base");
    super.new(name);
  endfunction

  virtual task pre_start();
    cfg = p_sequencer.cfg;
    vif = cfg.mst_vif;
    events = cfg.events;
  endtask

  virtual task body();
    `uvm_warning("body", "The body task should be OVERRIDED by derived class")
  endtask
endclass


class yuu_ahb_write_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(yuu_ahb_write_sequence)

  function new(string name="yuu_ahb_write_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(n_item) begin
      `uvm_create(req);
      req.cfg = cfg;
      if (!req.randomize() with {direction == WRITE;}) begin
        `uvm_fatal("body", "Transaction randomize error.")
      end
      `uvm_send(req);
    end
  endtask
endclass


class yuu_ahb_read_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(yuu_ahb_read_sequence)

  function new(string name="yuu_ahb_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(n_item) begin
      `uvm_create(req);
      req.cfg = cfg;
      if (!req.randomize() with {direction == READ;}) begin
        `uvm_fatal("body", "Transaction randomize error.")
      end
      `uvm_send(req);
    end
  endtask
endclass

`endif