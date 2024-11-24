/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_MASTER_READ_SEQUENCE_SV
`define GUARD_YUU_AHB_MASTER_READ_SEQUENCE_SV

// Class: yuu_ahb_master_read_sequence
// Random master read sequence.
class yuu_ahb_master_read_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(yuu_ahb_master_read_sequence)

  // Task: body
  // UVM built-in method.
  function new(string name = "yuu_ahb_master_read_sequence");
    super.new(name);
  endfunction

  // Task: body
  // UVM built-in method.
  virtual task body();
    repeat (n_item) begin
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
