/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_PKG_SV
`define YUU_AHB_PKG_SV

`include "yuu_ahb_defines.svh"
`include "yuu_ahb_interface.svi"

package yuu_ahb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import yuu_common_pkg::*;

  `include "yuu_ahb_type.sv"
  `include "yuu_ahb_error.sv"
  `include "yuu_ahb_agent_config.sv"
  `include "yuu_ahb_env_config.sv"
  `include "yuu_ahb_item.sv"
  `include "yuu_ahb_callbacks.sv"
  `include "yuu_ahb_analyzer.sv"
  `include "yuu_ahb_collector.sv"

  `include "yuu_ahb_master_sequence_lib.sv"
  `include "yuu_ahb_master_adapter.sv"
  `include "yuu_ahb_master_sequencer.sv"
  `include "yuu_ahb_master_driver.sv"
  `include "yuu_ahb_master_monitor.sv"
  `include "yuu_ahb_master_agent.sv"

  `include "yuu_ahb_slave_sequence_lib.sv"
  `include "yuu_ahb_slave_sequencer.sv"
  `include "yuu_ahb_slave_driver.sv"
  `include "yuu_ahb_slave_monitor.sv"
  `include "yuu_ahb_slave_agent.sv"

  `include "yuu_ahb_virtual_sequencer.sv"
  `include "yuu_ahb_env.sv"
endpackage

`endif