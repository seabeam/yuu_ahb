/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_ADAPTER_SV
`define YUU_AHB_MASTER_ADAPTER_SV

class yuu_ahb_master_adapter extends uvm_reg_adapter;
  yuu_ahb_master_config cfg;

  `uvm_object_utils(yuu_ahb_master_adapter)

  function new(string name = "yuu_ahb_master_adapter");
    super.new(name);
  endfunction

  virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
    yuu_ahb_master_item reg_item = yuu_ahb_master_item::type_id::create("reg_item");

    if (cfg == null)
      `uvm_fatal("reg2bus", "Adapter can't get configuration")

    reg_item.cfg = cfg;
    reg_item.randomize() with {
      direction == {rw.kind == UVM_READ} ? READ : WRITE;
      len     == 0;
      data[0] == rw.data;
      size    == cfg.bus_width;
      burst   == SINGLE;
      idle_delay == 0;
    };

    return reg_item;
  endfunction

  virtual function void bus2reg(uvm_sequence_item bus_item,
                                ref uvm_reg_bus_op rw);
    yuu_ahb_item item;

    if (!$cast(item, bus_item))
      `uvm_fatal("bus2reg", "Provided bus_item is not of the correct type(yuu_ahb_item)")
    
    rw.kind = int'(item.direction) ? UVM_WRITE : UVM_READ;
    rw.addr = item.address[0];
    rw.data = item.data[0];
    rw.status = (item.response[0] == OKAY) ? UVM_IS_OK : UVM_NOT_OK;
  endfunction
endclass

`endif
