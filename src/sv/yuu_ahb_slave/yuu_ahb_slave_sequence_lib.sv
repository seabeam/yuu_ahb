/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_SEQUENCE_LIB_SV
`define YUU_AHB_SLAVE_SEQUENCE_LIB_SV

typedef class yuu_ahb_slave_sequencer;
class yuu_ahb_slave_response_sequence extends uvm_sequence #(yuu_ahb_slave_item);
  yuu_ahb_slave_config  cfg;
  yuu_ahb_error         error_object;

  `uvm_object_utils(yuu_ahb_slave_response_sequence)
  `uvm_declare_p_sequencer(yuu_ahb_slave_sequencer)
  
  function new(string name = "yuu_ahb_slave_response_sequence");
    super.new(name);
  endfunction

  task pre_body();
    cfg = p_sequencer.cfg;
  endtask
endclass

`endif
