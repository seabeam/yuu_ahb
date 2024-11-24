/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_SLAVE_RESPONSE_SEQUENCE_SV
`define GUARD_YUU_AHB_SLAVE_RESPONSE_SEQUENCE_SV

class yuu_ahb_slave_response_sequence extends yuu_ahb_slave_sequence_base;
  `uvm_object_utils(yuu_ahb_slave_response_sequence)

  function new(string name = "yuu_ahb_slave_response_sequence");
    super.new(name);
  endfunction

  task body();
    uvm_event master_done = events.get("master_done");

    forever begin
      `uvm_create(req)
      req.cfg = cfg;
      req.randomize() with {
        len == 0;
        response[0] == OKAY;
        wait_delay inside {[0 : 8]};
      };
      start_item(req);
      finish_item(req);
    end
  endtask
endclass

`endif
