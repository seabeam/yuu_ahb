/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MACROS_SVH
`define YUU_AHB_MACROS_SVH
  // Macro: YUU_AHB_MAX_MASTER_NUM
  // Max number of masters in environment.
  `ifndef YUU_AHB_MAX_MASTER_NUM
  `define YUU_AHB_MAX_MASTER_NUM  1
  `endif

  // Macro: YUU_AHB_MAX_SLAVE_NUM
  // Max number of slaves in environment.
  `ifndef YUU_AHB_MAX_SLAVE_NUM
  `define YUU_AHB_MAX_SLAVE_NUM  1
  `endif

  // Macro: YUU_AHB_MAX_ADDR_WIDTH
  // Max width of address line.
  `ifndef YUU_AHB_MAX_ADDR_WIDTH
  `define YUU_AHB_MAX_ADDR_WIDTH   32
  `endif

  // Macro: YUU_AHB_MAX_DATA_WIDTH
  // Max width of data line.
  `ifndef YUU_AHB_MAX_DATA_WIDTH
  `define YUU_AHB_MAX_DATA_WIDTH   32
  `endif

  // Macro: YUU_AHB_LANE_WIDTH
  // Max width of data lane. User should not change this macro.
  `define YUU_AHB_LANE_WIDTH  $clog2(`YUU_AHB_MAX_DATA_WIDTH/8)

  // Macro: YUU_AHB_MASTER_SETUP_TIME
  // Setup time used for master interface.
  `ifndef YUU_AHB_MASTER_SETUP_TIME
  `define YUU_AHB_MASTER_SETUP_TIME  1
  `endif

  // Macro: YUU_AHB_MASTER_HOLD_TIME
  // Hold time used for master interface.
  `ifndef YUU_AHB_MASTER_HOLD_TIME
  `define YUU_AHB_MASTER_HOLD_TIME   1
  `endif

  // Macro: YUU_AHB_SLAVE_SETUP_TIME
  // Setup time used for slave interface.
  `ifndef YUU_AHB_SLAVE_SETUP_TIME
  `define YUU_AHB_SLAVE_SETUP_TIME   1
  `endif

  // Macro: YUU_AHB_SLAVE_HOLD_TIME
  // Hold time used for slave interface.
  `ifndef YUU_AHB_SLAVE_HOLD_TIME
  `define YUU_AHB_SLAVE_HOLD_TIME    1
  `endif

  // Macro: YUU_AHB_MAX_DELAY
  // Default setting for max delay of busy, idle and wait cycles.
  `ifndef YUU_AHB_MAX_DELAY
  `define YUU_AHB_MAX_DELAY   16
  `endif

  // Macro: YUU_AHB_MAX_BURST_LENGTH
  // Max length of burst for transaction randomize.
  `ifndef YUU_AHB_MAX_BURST_LENGTH
  `define YUU_AHB_MAX_BURST_LENGTH  32
  `endif

`endif