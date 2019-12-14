/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_ITEM_SVH
`define YUU_AHB_ITEM_SVH

class yuu_ahb_item extends yuu_amba_item;
  rand yuu_ahb_data_t       data[];
       yuu_ahb_trans_e      trans[];
  rand yuu_ahb_response_e   response[];
  rand yuu_ahb_direction_e  direction;
  rand yuu_ahb_size_e       size;
  rand yuu_ahb_burst_e      burst;
  rand yuu_ahb_prot0_e      prot0 = DATA_ACCESS;
  rand yuu_ahb_prot1_e      prot1 = PRIVILEGED_ACCESS;
  rand yuu_ahb_prot2_e      prot2 = NON_BUFFERABLE;
  rand yuu_ahb_prot3_e      prot3 = NON_CACHEABLE;
  rand yuu_ahb_emt_prot3_e  prot3_emt = NON_MODIFIABLE;
  rand yuu_ahb_emt_prot4_e  prot4_emt = NO_LOOKUP;
  rand yuu_ahb_emt_prot5_e  prot5_emt = NO_ALLOCATE;
  rand yuu_ahb_emt_prot6_e  prot6_emt = NON_SHAREABLE;
       bit[3:0]             master;
  rand bit                  lock = 1'b0;
  rand yuu_ahb_nonsec_e     nonsec = NON_SECURE;

       yuu_ahb_location_e   location[];
       real                 start_time;
       real                 end_time;

  `uvm_object_utils_begin(yuu_ahb_item)
    `uvm_field_array_int   (                      data,           UVM_ALL_ON)
    `uvm_field_array_enum  (yuu_ahb_trans_e,      trans,          UVM_ALL_ON)
    `uvm_field_array_enum  (yuu_ahb_response_e,   response,       UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_direction_e,  direction,      UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_size_e,       size,           UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_burst_e,      burst,          UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_prot0_e,      prot0,          UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_prot1_e,      prot1,          UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_prot2_e,      prot2,          UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_prot3_e,      prot3,          UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_emt_prot3_e,  prot3_emt,      UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_emt_prot4_e,  prot4_emt,      UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_emt_prot5_e,  prot5_emt,      UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_emt_prot6_e,  prot6_emt,      UVM_ALL_ON)
    `uvm_field_int         (                      master,         UVM_ALL_ON)
    `uvm_field_int         (                      lock,           UVM_ALL_ON)
    `uvm_field_enum        (yuu_ahb_nonsec_e,     nonsec,         UVM_ALL_ON)
    `uvm_field_array_enum  (yuu_ahb_location_e,   location,       UVM_PRINT | UVM_COPY)
    `uvm_field_real        (                      start_time,     UVM_PRINT | UVM_COPY)
    `uvm_field_real        (                      end_time,       UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  constraint c_ahb_size {
    data.size() == len+1;
    response.size() == len+1;
  }

  constraint c_ahb_burst_type {
    burst == yuu_ahb_pkg::SINGLE -> len == 1-1;
    burst inside {yuu_ahb_pkg::INCR4, yuu_ahb_pkg::WRAP4}   -> len == 4-1;
    burst inside {yuu_ahb_pkg::INCR8, yuu_ahb_pkg::WRAP8}   -> len == 8-1;
    burst inside {yuu_ahb_pkg::INCR16, yuu_ahb_pkg::WRAP16} -> len == 16-1;

    (burst inside {yuu_ahb_pkg::SINGLE, yuu_ahb_pkg::INCR, yuu_ahb_pkg::INCR4, yuu_ahb_pkg::INCR8, yuu_ahb_pkg::INCR16}) <-> burst_type == yuu_amba_pkg::INCR;
    (burst inside {yuu_ahb_pkg::WRAP4, yuu_ahb_pkg::WRAP8, yuu_ahb_pkg::WRAP16}) <-> burst_type == yuu_amba_pkg::WRAP;

    soft burst dist {yuu_ahb_pkg::SINGLE:/10, yuu_ahb_pkg::INCR4:/20, yuu_ahb_pkg::INCR8:/20, yuu_ahb_pkg::INCR16:/20, yuu_ahb_pkg::INCR:/21, yuu_ahb_pkg::WRAP4:/3, yuu_ahb_pkg::WRAP8:/3, yuu_ahb_pkg::WRAP16:/3};
  }

  constraint c_ahb_burst_size {
    size == SIZE8    <-> burst_size == YUU_AMBA_BYTE_1;
    size == SIZE16   <-> burst_size == YUU_AMBA_BYTE_2;
    size == SIZE32   <-> burst_size == YUU_AMBA_BYTE_4;
    size == SIZE64   <-> burst_size == YUU_AMBA_BYTE_8;
    size == SIZE128  <-> burst_size == YUU_AMBA_BYTE_16;
    size == SIZE256  <-> burst_size == YUU_AMBA_BYTE_32;
    size == SIZE512  <-> burst_size == YUU_AMBA_BYTE_64;
    size == SIZE1024 <-> burst_size == YUU_AMBA_BYTE_128;
  }

  constraint c_ahb_align {
    address_aligned_enable == True;
  }

  constraint c_ahb_1k_boundary {
    if (burst_type == yuu_amba_pkg::INCR) {
      start_address[9:0]+(len+1)*number_bytes <= 1024;
    }
    // WRAP never cross 1K
  }

  extern function      new(string name = "yuu_ahb_item");
  extern function void post_randomize();
  extern function void command_process();
  extern function void data_process();
endclass

function yuu_ahb_item::new(string name = "yuu_ahb_item");
  super.new(name);
endfunction

function void yuu_ahb_item::post_randomize();
  super.post_randomize();

  command_process();
  data_process();
endfunction

function void yuu_ahb_item::command_process();
  // Location
  location = new[len+1];
  foreach (location[i])
    location[i] = MIDDLE;
  location[0]   = FIRST;
  location[len] = LAST;
endfunction

function void yuu_ahb_item::data_process();
  if (direction == READ)
    foreach (data[i])
      data[i] = 0;
  return;
endfunction

`endif
