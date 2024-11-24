/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_ERROR_SV
`define GUARD_YUU_AHB_ERROR_SV

// Class: yuu_ahb_error
// AHB error object for application error scenario of sequence
class yuu_ahb_error extends uvm_object;
  // Variable: no_error_wt
  // Randomize constraint weight of NO_ERROR
  int unsigned no_error_wt = 100;

  // Variable: invalid_addr_wt
  // Randomize constraint weight of INVALID_ADDR
  int unsigned invalid_addr_wt = 0;

  // Variable: read_only_wt
  // Randomize constraint weight of READ_ONLY
  int unsigned read_only_wt = 0;

  // Variable: write_only_wt
  // Randomize constraint weight of WRITE_ONLY
  int unsigned write_only_wt = 0;

  // Variable: corrupt_data_wt
  // Randomize constraint weight of CORRUPT_DATA
  int unsigned corrupt_data_wt = 0;

  // Variable: error_type
  // Type of error scenario.
  rand yuu_ahb_error_type_e error_type;

  constraint c_error_type {
    error_type dist {
      NO_ERROR     := no_error_wt,
      INVALID_ADDR := invalid_addr_wt,
      READ_ONLY    := read_only_wt,
      WRITE_ONLY   := write_only_wt,
      CORRUPT_DATA := corrupt_data_wt
    };
  }


  `uvm_object_utils_begin(yuu_ahb_error)
    `uvm_field_enum(yuu_ahb_error_type_e, error_type, UVM_DEFAULT | UVM_NOCOMPARE)
  `uvm_object_utils_end

  // Function: new
  // Constructor of object.
  function new(string name = "yuu_ahb_error");
    super.new(name);
  endfunction
endclass

`endif
