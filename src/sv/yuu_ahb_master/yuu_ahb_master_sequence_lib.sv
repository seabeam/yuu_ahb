/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_SEQUENCE_LIB_SVH
`define YUU_AHB_MASTER_SEQUENCE_LIB_SVH

class yuu_ahb_master_sequence_base extends uvm_sequence #(yuu_ahb_master_item);
  int unsigned n_item = 10;
  
  yuu_ahb_master_config cfg;
  uvm_event_pool events;

  `uvm_object_utils_begin(yuu_ahb_master_sequence_base)
  `uvm_object_utils_end

  function new(string name = "yuu_ahb_master_sequence_base");
    super.new(name);
  endfunction
  
  virtual task pre_body();
    if (!uvm_config_db#(yuu_ahb_master_config)::get(null, get_full_name(), "cfg", cfg) && cfg == null)
      `uvm_fatal("pre_body", "Cannot get yuu_ahb agent config in sequence")
  endtask

  virtual task body();
    return;
  endtask
endclass


class yuu_ahb_write_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(yuu_ahb_write_sequence)

  function new(string name = "yuu_ahb_write_sequence");
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

  function new(string name = "yuu_ahb_read_sequence");
    super.new(name);
  endfunction

  virtual task body();
    repeat(n_item) begin
      `uvm_create(req);
      req.cfg = cfg;
      if (!req.randomize() with {direction  == READ;}) begin
        `uvm_fatal("body", "Transaction randomize error.")
      end
      `uvm_send(req);
    end
  endtask
endclass

`endif
