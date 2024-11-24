/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_PKG_SV
`define GUARD_YUU_AHB_PKG_SV

`include "yuu_ahb_macros.svh"
`include "yuu_ahb_interface.svi"

package yuu_ahb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import yuu_common_pkg::*;

  `include "yuu_ahb_type.sv"
  `include "yuu_ahb_error.sv"
  `include "yuu_ahb_agent_config.sv"
  `include "yuu_ahb_master_config.sv"
  `include "yuu_ahb_slave_config.sv"
  `include "yuu_ahb_env_config.sv"
  `include "yuu_ahb_item.sv"
  `include "yuu_ahb_master_item.sv"
  `include "yuu_ahb_slave_item.sv"
  `include "yuu_ahb_reg_extension.sv"
  `include "yuu_ahb_callbacks.sv"
  `include "yuu_ahb_analyzer.sv"
  `include "yuu_ahb_coverage.sv"

  `include "yuu_ahb_master_adapter.sv"
  `include "yuu_ahb_master_sequencer.sv"
  `include "yuu_ahb_master_driver.sv"
  `include "yuu_ahb_master_monitor.sv"
  `include "yuu_ahb_master_agent.sv"

  `include "yuu_ahb_slave_sequencer.sv"
  `include "yuu_ahb_slave_driver.sv"
  `include "yuu_ahb_slave_monitor.sv"
  `include "yuu_ahb_slave_agent.sv"

  `include "yuu_ahb_virtual_sequencer.sv"
  `include "yuu_ahb_virtual_sequence.sv"
  `include "yuu_ahb_env.sv"

  `include "yuu_ahb_master_sequence_base.sv"
  `include "yuu_ahb_master_write_sequence.sv"
  `include "yuu_ahb_master_read_sequence.sv"
  `include "yuu_ahb_master_raw_sequence.sv"
  `include "yuu_ahb_slave_sequence_base.sv"
  `include "yuu_ahb_slave_response_sequence.sv"
endpackage

`endif
