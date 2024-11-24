/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_REG_EXTENSION_SV
`define GUARD_YUU_AHB_REG_EXTENSION_SV

// Class: yuu_ahb_reg_extension
// Register extension for adapter.
class yuu_ahb_reg_extension extends uvm_object;
  // Variable: byte_offset
  // Byte address base on register address.
  yuu_ahb_addr_t byte_offset;

  // Variable: data
  // Register payload.
  yuu_ahb_data_t data[];

  // Variable: size
  // User defined HSIZE.
  yuu_ahb_size_e size;

  // Variable: burst
  // User defined HBURST.
  yuu_ahb_burst_e burst = yuu_ahb_pkg::INCR;

  // Variable: prot0
  // User defined HPROT[0].
  yuu_ahb_prot0_e prot0 = DATA_ACCESS;

  // Variable: prot1
  // User defined HPROT[1].
  yuu_ahb_prot1_e prot1 = PRIVILEGED_ACCESS;

  // Variable: prot2
  // User defined HPROT[2].
  yuu_ahb_prot2_e prot2 = NON_BUFFERABLE;

  // Variable: prot3
  // User defined HPROT[3].
  yuu_ahb_prot3_e prot3 = NON_CACHEABLE;

  // Variable: master
  // User defined HMASTER.
  bit[3:0] master;

  // Variable: lock
  // User defined HMASTLOCK.
  bit lock;

  // Variable: nonsec
  // User defined HNONSEC.
  yuu_ahb_nonsec_e nonsec = NON_SECURE;

  // Variable: excl
  // User defined HEXCL.
  yuu_ahb_excl_e excl = NON_EXCLUSIVE;

  `uvm_object_utils(yuu_ahb_reg_extension)

  // Function: new
  // Constructor of object.
  function new(string name="yuu_ahb_reg_extension");
    super.new(name);
  endfunction
endclass

`endif
