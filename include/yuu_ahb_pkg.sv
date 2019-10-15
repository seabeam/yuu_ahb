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

  import yuu_amba_pkg::*;
  import yuu_common_pkg::*;

  `include "yuu_ahb_common_pkg.svh"
  `include "yuu_ahb_master_pkg.svh"
  //`include "yuu_ahb_slave_pkg.svh"
  //`include "yuu_ahb_env_pkg.svh"
endpackage

`endif
