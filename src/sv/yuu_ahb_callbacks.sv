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

// Class: yuu_ahb_master_driver_callback
// AHB master driver callback library.
class yuu_ahb_master_driver_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_master_driver_callback)

  // Function: new
  // Constructor of object.
  function new(string name="yuu_ahb_master_driver_callback");
    super.new(name);
  endfunction

  // Task: pre_send
  // Callback task before send transaction to bus.
  virtual task pre_send(yuu_ahb_master_driver driver, yuu_ahb_master_item item);
  endtask

  // Task: post_send
  // Callback task after send transaction to bus.
  virtual task post_send(yuu_ahb_master_driver driver, yuu_ahb_master_item item);
  endtask
endclass


// Class: yuu_ahb_master_monitor_callback
// AHB master monitor callback library.
class yuu_ahb_master_monitor_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_master_monitor_callback)

  // Function: new
  // Constructor of object.
  function new(string name="yuu_ahb_master_monitor_callback");
    super.new(name);
  endfunction

  // Task: pre_collect
  // Callback task before collect transaction on bus.
  virtual task pre_collect(yuu_ahb_master_monitor monitor, yuu_ahb_master_item item);
  endtask

  // Task: post_collect
  // Callback task after collect transaction on bus.
  virtual task post_collect(yuu_ahb_master_monitor monitor, yuu_ahb_master_item item);
  endtask
endclass


// Class: yuu_ahb_slave_driver_callback
// AHB slave driver callback library.
class yuu_ahb_slave_driver_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_slave_driver_callback)

  // Function: new
  // Constructor of object.
  function new(string name="yuu_ahb_slave_driver_callback");
    super.new(name);
  endfunction

  // Task: pre_send
  // Callback task before send transaction to bus.
  virtual task pre_send(yuu_ahb_slave_driver driver, yuu_ahb_slave_item item);
  endtask

  // Task: post_send
  // Callback task after send transaction to bus.
  virtual task post_send(yuu_ahb_slave_driver driver, yuu_ahb_slave_item item);
  endtask
endclass


// Class: yuu_ahb_slave_monitor_callback
// AHB slave monitor callback library.
class yuu_ahb_slave_monitor_callback extends uvm_callback;
  `uvm_object_utils(yuu_ahb_slave_monitor_callback)

  // Function: new
  // Constructor of object.
  function new(string name="yuu_ahb_slave_monitor_callback");
    super.new(name);
  endfunction

  // Task: pre_collect
  // Callback task before collect transaction on bus.
  virtual task pre_collect(yuu_ahb_slave_monitor monitor, yuu_ahb_slave_item item);
  endtask

  // Task: post_collect
  // Callback task after collect transaction on bus.
  virtual task post_collect(yuu_ahb_slave_monitor monitor, yuu_ahb_slave_item item);
  endtask
endclass

`endif