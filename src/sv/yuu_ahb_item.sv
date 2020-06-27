/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_ITEM_SV
`define YUU_AHB_ITEM_SV

class yuu_ahb_item extends uvm_sequence_item;
  // group: common
  yuu_ahb_agent_config cfg;

  // The start address issued by the master.
  rand yuu_ahb_addr_t       start_address;
  // The transaction payload
  rand yuu_ahb_data_t       data[];
  // The burst length.
  rand int unsigned         len;
       yuu_ahb_trans_e      trans[];
  rand yuu_ahb_response_e   response[];
  rand yuu_ahb_direction_e  direction;
  // The size of burst, 1 byte, 2 bytes etc. 
  rand yuu_ahb_burst_size_e burst_size;
  rand yuu_ahb_size_e       size;
  rand yuu_ahb_burst_e      burst;
  // The type of burst: FIXED, INCR or WRAP
  rand yuu_ahb_burst_type_e burst_type;
  rand yuu_ahb_prot0_e      prot0 = DATA_ACCESS;
  rand yuu_ahb_prot1_e      prot1 = PRIVILEGED_ACCESS;
  rand yuu_ahb_prot2_e      prot2 = NON_BUFFERABLE;
  rand yuu_ahb_prot3_e      prot3 = NON_CACHEABLE;
  rand yuu_ahb_emt_prot3_e  prot3_emt = NON_MODIFIABLE;
  rand yuu_ahb_emt_prot4_e  prot4_emt = NO_LOOKUP;
  rand yuu_ahb_emt_prot5_e  prot5_emt = NO_ALLOCATE;
  rand yuu_ahb_emt_prot6_e  prot6_emt = NON_SHAREABLE;
       bit[3:0]             master;
  rand bit                  lock    = 1'b0;
  rand yuu_ahb_nonsec_e     nonsec  = NON_SECURE;
  rand yuu_ahb_excl_e       excl    = NON_EXCLUSIVE;
  rand yuu_ahb_exokay_e     exokay  = EXOKAY;

  // The address of transfer N in a burst.
       yuu_ahb_addr_t       address[];
  // The aligned version of the start address.
       yuu_ahb_addr_t       aligned_address;
  // The lowest address of burst
       yuu_ahb_addr_t       low_boundary;
  // The highest address of burst
       yuu_ahb_addr_t       high_boundary;
  // The lowest address within a wrapping burst.
       yuu_ahb_addr_t       wrap_boundary;
  // The byte lane of the lowest addressed byte of a transfer.
       yuu_ahb_lane_t       lower_byte_lane[];
  // The byte lane of the highest addressed byte of a transfer.
       yuu_ahb_lane_t       upper_byte_lane[];
  // The maximum number of bytes in each data transfer.
       int unsigned         number_bytes;
  // The total number of data transfers within a burst.
       int unsigned         burst_length;
  // The number of byte lanes in the data bus.
       int unsigned         data_bus_bytes;

  rand boolean address_aligned_enable = False;
       
       yuu_ahb_location_e   location[];
       real                 start_time;
       real                 end_time;

  constraint c_ahb_size {
    data.size() == len+1;
    response.size() == len+1;
    burst_size <= $clog2(`YUU_AHB_DATA_WIDTH/8);
  }

  constraint c_ahb_align {
    address_aligned_enable == True;
    burst_type == AHB_WRAP -> address_aligned_enable == True;
    if (address_aligned_enable) { 
      burst_size == BYTE2   -> start_address[0]   == 1'b0;
      burst_size == BYTE4   -> start_address[1:0] == 2'b0;
      burst_size == BYTE8   -> start_address[2:0] == 3'b0;
      burst_size == BYTE16  -> start_address[3:0] == 4'b0;
      burst_size == BYTE32  -> start_address[4:0] == 5'b0;
      burst_size == BYTE64  -> start_address[5:0] == 6'b0;
      burst_size == BYTE128 -> start_address[6:0] == 7'b0;
    }
  }

  constraint c_ahb_burst_type {
    burst == SINGLE -> len == 1-1;
    burst inside {INCR4, WRAP4}   -> len == 4-1;
    burst inside {INCR8, WRAP8}   -> len == 8-1;
    burst inside {INCR16, WRAP16} -> len == 16-1;

    (burst inside {SINGLE, INCR, INCR4, INCR8, INCR16}) <-> burst_type == AHB_INCR;
    (burst inside {WRAP4, WRAP8, WRAP16}) <-> burst_type == AHB_WRAP;

    soft burst dist {SINGLE:/10, INCR4:/20, INCR8:/20, INCR16:/20, INCR:/21, WRAP4:/3, WRAP8:/3, WRAP16:/3};
  }

  constraint c_ahb_burst_size {
    size == SIZE8    <-> burst_size == BYTE1;
    size == SIZE16   <-> burst_size == BYTE2;
    size == SIZE32   <-> burst_size == BYTE4;
    size == SIZE64   <-> burst_size == BYTE8;
    size == SIZE128  <-> burst_size == BYTE16;
    size == SIZE256  <-> burst_size == BYTE32;
    size == SIZE512  <-> burst_size == BYTE64;
    size == SIZE1024 <-> burst_size == BYTE128;
  }


  constraint c_ahb_exclusive {
    excl == 1'b1 -> len == 0;
  }

  constraint c_ahb_1k_boundary {
    if (burst_type == AHB_INCR) {
      start_address[9:0]+(len+1)*number_bytes <= 1024;
    }
    // WRAP never cross 1K
  }

  // group: master
  rand int unsigned idle_delay;
  rand int unsigned busy_delay[];

  constraint c_idle {
    soft idle_delay inside {[0:16]};
    if (!cfg.idle_enable) {
      idle_delay == 0;
    }
  }

  constraint c_busy {
    busy_delay.size() == len+1;
    foreach (busy_delay[i]) {
      soft busy_delay[i] inside {[0:16]};
      if (!cfg.busy_enable || len == 0) {
        busy_delay[i] == 0;
      }
    }
  }

  // group: slave
  rand int unsigned wait_delay;

  constraint c_len {
    cfg.agent_type == SLAVE -> len == 0;
    len < `YUU_AHB_MAX_BURST_LENGTH;
  }

  constraint c_wait {
    soft wait_delay inside {[0:16]};
    if (!cfg.wait_enable) {
      wait_delay == 0;
    }
  }

  `uvm_object_utils_begin(yuu_ahb_item)
    `uvm_field_int        (                      len,             UVM_ALL_ON | UVM_DEC)
    `uvm_field_int        (                      start_address,   UVM_ALL_ON)
    `uvm_field_array_int  (                      address,         UVM_ALL_ON)
    `uvm_field_array_int  (                      data,            UVM_ALL_ON)
    `uvm_field_array_enum (yuu_ahb_trans_e,      trans,           UVM_ALL_ON)
    `uvm_field_array_enum (yuu_ahb_response_e,   response,        UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_direction_e,  direction,       UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_size_e,       size,            UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_burst_e,      burst,           UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_prot0_e,      prot0,           UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_prot1_e,      prot1,           UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_prot2_e,      prot2,           UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_prot3_e,      prot3,           UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_emt_prot3_e,  prot3_emt,       UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_emt_prot4_e,  prot4_emt,       UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_emt_prot5_e,  prot5_emt,       UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_emt_prot6_e,  prot6_emt,       UVM_ALL_ON)
    `uvm_field_int        (                      master,          UVM_ALL_ON)
    `uvm_field_int        (                      lock,            UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_nonsec_e,     nonsec,          UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_excl_e,       excl,            UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_exokay_e,     exokay,          UVM_ALL_ON)
    `uvm_field_array_enum (yuu_ahb_location_e,   location,        UVM_PRINT | UVM_COPY)
    `uvm_field_int        (                      low_boundary,    UVM_ALL_ON)
    `uvm_field_int        (                      high_boundary,   UVM_ALL_ON)
    `uvm_field_int        (                      number_bytes,    UVM_ALL_ON)
    `uvm_field_int        (                      burst_length,    UVM_ALL_ON)
    `uvm_field_int        (                      data_bus_bytes,  UVM_ALL_ON)
    `uvm_field_int        (                      aligned_address, UVM_ALL_ON)
    `uvm_field_int        (                      wrap_boundary,   UVM_ALL_ON)
    `uvm_field_array_int  (                      lower_byte_lane, UVM_COPY | UVM_PRINT)
    `uvm_field_array_int  (                      upper_byte_lane, UVM_COPY | UVM_PRINT)
    `uvm_field_enum       (yuu_ahb_burst_size_e, burst_size,      UVM_ALL_ON)
    `uvm_field_enum       (yuu_ahb_burst_type_e, burst_type,      UVM_ALL_ON)
    `uvm_field_enum       (boolean,              address_aligned_enable, UVM_COPY | UVM_PRINT)
    `uvm_field_real       (                      start_time,      UVM_PRINT | UVM_COPY)
    `uvm_field_real       (                      end_time,        UVM_PRINT | UVM_COPY)
    `uvm_field_int        (                      idle_delay,      UVM_PRINT | UVM_COPY)
    `uvm_field_array_int  (                      busy_delay,      UVM_PRINT | UVM_COPY)
    `uvm_field_int        (                      wait_delay,      UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  extern function      new(string name="yuu_ahb_item");
  extern function void pre_randomize();
  extern function void post_randomize();
  extern function void common_process();
  extern function void command_process();
  extern function void data_process();
endclass

function yuu_ahb_item::new(string name="yuu_ahb_item");
  super.new(name);
endfunction

function void yuu_ahb_item::pre_randomize();
  if (!uvm_config_db #(yuu_ahb_agent_config)::get(null, get_full_name(), "cfg", cfg) && cfg == null)
    `uvm_fatal("pre_randomize", "Cannot get AHB configuration in transaction")

  if (!cfg.use_protection_transfers) begin
    prot0.rand_mode(0);
    prot1.rand_mode(0);
    prot2.rand_mode(0);
    prot3_emt.rand_mode(0);
    prot4_emt.rand_mode(0);
    prot5_emt.rand_mode(0);
    prot6_emt.rand_mode(0);
  end
  if (!cfg.use_extended_memory_types) begin
    prot3_emt.rand_mode(0);
    prot4_emt.rand_mode(0);
    prot5_emt.rand_mode(0);
    prot6_emt.rand_mode(0);
  end
  if (!cfg.use_locked_transfers) begin
    lock.rand_mode(0);
  end
  if (!cfg.use_secure_transfers) begin
    nonsec.rand_mode(0);
  end
  if (!cfg.use_exclusive_transfers) begin
    excl.rand_mode(0);
  end
endfunction

function void yuu_ahb_item::post_randomize();
  common_process();
  command_process();
  data_process();
endfunction

function void yuu_ahb_item::common_process();
  if (burst_type == AHB_FIXED)
    len = 0;
  number_bytes = 1<<int'(burst_size);
  burst_length = len+1;
  aligned_address = (yuu_ahb_addr_t'(start_address/number_bytes))*number_bytes;
  address = new[burst_length];
  address[0] = start_address;
  if (burst_type == AHB_INCR || burst_type == AHB_FIXED) begin
    low_boundary  = start_address;
    high_boundary = aligned_address+number_bytes*burst_length;
    for (int n=1; n<burst_length; n++) begin
      address[n] = aligned_address+n*number_bytes;
    end
  end
  else if (burst_type == AHB_WRAP) begin
    boolean is_wrapped = False;
    int wrap_idx = 0;

    wrap_boundary = (yuu_ahb_addr_t'(start_address/(number_bytes*burst_length)))*(number_bytes*burst_length);
    low_boundary  = wrap_boundary;
    high_boundary = low_boundary+number_bytes*burst_length;
    for (int n=1; n<burst_length; n++) begin
      if (!is_wrapped)
        address[n] = aligned_address+n*number_bytes;
      else
        address[n] = low_boundary + (n-wrap_idx)*number_bytes;

      if (address[n] == high_boundary) begin
        address[n] = wrap_boundary;
        wrap_idx = n;
        is_wrapped = True;
      end
    end
  end

  data_bus_bytes = `YUU_AHB_DATA_WIDTH/8;
  lower_byte_lane = new[burst_length];
  upper_byte_lane = new[burst_length];
  lower_byte_lane[0] = start_address-(yuu_ahb_addr_t'(start_address/data_bus_bytes))*data_bus_bytes;
  upper_byte_lane[0] = aligned_address+(number_bytes-1)-(yuu_ahb_addr_t'(start_address/data_bus_bytes))*data_bus_bytes;
  for (int n=1; n<burst_length; n++) begin
    lower_byte_lane[n] = address[n]-(yuu_ahb_addr_t'(address[n]/data_bus_bytes))*data_bus_bytes;
    upper_byte_lane[n] = lower_byte_lane[n]+number_bytes-1;
  end
endfunction

function void yuu_ahb_item::command_process();
  // Location
  location = new[len+1];
  foreach (location[i])
    location[i] = MIDDLE;
  location[0]   = FIRST;
  location[len] = LAST;

  if (cfg.agent_type == MASTER) begin
    // Trans
    trans = new[len+1];
    foreach (trans[i])
      trans[i] = SEQ;
    trans[0] = NONSEQ;
    if (!cfg.use_busy_end || (cfg.use_busy_end && burst != INCR)) begin
      busy_delay[len] = 0;
    end
    busy_delay[0] = 0;
  end
endfunction

function void yuu_ahb_item::data_process();
  if (direction == READ)
    foreach (data[i])
      data[i] = 0;
  return;

  if (cfg.agent_type == MASTER) begin
    foreach (response[i])
      response[i] = OKAY;
  end
endfunction

`endif