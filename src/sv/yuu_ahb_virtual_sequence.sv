/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_VIRTUAL_SEQUENCE_SV
`define GUARD_YUU_AHB_VIRTUAL_SEQUENCE_SV

// Class: yuu_ahb_virtual_sequence
// AHB virtual sequence base.
class yuu_ahb_virtual_sequence extends uvm_sequence;
  `uvm_object_utils(yuu_ahb_virtual_sequence)
  `uvm_declare_p_sequencer(yuu_ahb_virtual_sequencer)

  // Function: new
  // Constructor of object.
  function new(string name = "yuu_ahb_virtual_sequence");
    super.new(name);
  endfunction
endclass

`endif
