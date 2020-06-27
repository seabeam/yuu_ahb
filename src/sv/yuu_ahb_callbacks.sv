/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_CALLBACKS_SV
`define YUU_AHB_CALLBACKS_SV

typedef class yuu_ahb_master_driver;
typedef class yuu_ahb_master_monitor;
typedef class yuu_ahb_slave_driver;
typedef class yuu_ahb_slave_monitor;

class yuu_ahb_master_driver_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_master_driver_callback)

  function new(string name="yuu_ahb_master_driver_callback");
    super.new(name);
  endfunction

  virtual task pre_send(yuu_ahb_master_driver driver, yuu_ahb_item item);
  endtask

  virtual task post_send(yuu_ahb_master_driver driver, yuu_ahb_item item);
  endtask
endclass


class yuu_ahb_master_monitor_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_master_monitor_callback)

  function new(string name="yuu_ahb_master_monitor_callback");
    super.new(name);
  endfunction

  virtual task pre_collect(yuu_ahb_master_monitor monitor, yuu_ahb_item item);
  endtask

  virtual task post_collect(yuu_ahb_master_monitor monitor, yuu_ahb_item item);
  endtask
endclass


class yuu_ahb_slave_driver_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_slave_driver_callback)

  function new(string name="yuu_ahb_slave_driver_callback");
    super.new(name);
  endfunction

  virtual task pre_send(yuu_ahb_slave_driver driver, yuu_ahb_item item);
  endtask

  virtual task post_send(yuu_ahb_slave_driver driver, yuu_ahb_item item);
  endtask
endclass


class yuu_ahb_slave_monitor_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_slave_monitor_callback)

  function new(string name="yuu_ahb_slave_monitor_callback");
    super.new(name);
  endfunction

  virtual task pre_collect(yuu_ahb_slave_monitor monitor, yuu_ahb_item item);
  endtask

  virtual task post_collect(yuu_ahb_slave_monitor monitor, yuu_ahb_item item);
  endtask
endclass

`endif
