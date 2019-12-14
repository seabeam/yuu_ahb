/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_TYPE_SVH
`define YUU_AHB_TYPE_SVH

//typedef class yuu_ahb_master_item;
//typedef class yuu_ahb_slave_item;
//typedef uvm_sequencer #(yuu_ahb_master_item)  yuu_ahb_master_sequencer;
//typedef uvm_sequencer #(yuu_ahb_slave_item)   yuu_ahb_slave_sequencer;

typedef bit [`YUU_AHB_ADDR_WIDTH-1:0] yuu_ahb_addr_t;
typedef bit [`YUU_AHB_DATA_WIDTH-1:0] yuu_ahb_data_t;
typedef bit [`YUU_AHB_LANE_WIDTH-1:0] yuu_ahb_lane_t;

typedef enum bit{
  READ,
  WRITE
  } yuu_ahb_direction_e;

typedef enum bit[2:0]{
  SIZE8,
  SIZE16,
  SIZE32,
  SIZE64,
  SIZE128,
  SIZE256,
  SIZE512,
  SIZE1024
  } yuu_ahb_size_e;

typedef enum bit[2:0]{
  SINGLE,
  INCR,
  WRAP4,
  INCR4,
  WRAP8,
  INCR8,
  WRAP16,
  INCR16
  } yuu_ahb_burst_e;

typedef enum bit[1:0]{
  IDLE,
  BUSY,
  NONSEQ,
  SEQ
  } yuu_ahb_trans_e;

typedef enum bit{
  OPCODE_FETCH,
  DATA_ACCESS
  } yuu_ahb_prot0_e;

typedef enum bit{
  USER_ACCESS,
  PRIVILEGED_ACCESS
  } yuu_ahb_prot1_e;

typedef enum bit{
  NON_BUFFERABLE,
  BUFFERABLE
  } yuu_ahb_prot2_e;

typedef enum bit{
  NON_CACHEABLE,
  CACHEABLE
  } yuu_ahb_prot3_e;

typedef enum bit{
  NON_MODIFIABLE,
  MODIFIABLE
  } yuu_ahb_emt_prot3_e;

typedef enum bit{
  NO_LOOKUP,
  LOOK_UP
  } yuu_ahb_emt_prot4_e;

typedef enum bit{
  NO_ALLOCATE,
  ALLOCATE
  } yuu_ahb_emt_prot5_e;

typedef enum bit{
  NON_SHAREABLE,
  SHAREABLE
  } yuu_ahb_emt_prot6_e;

typedef enum bit{
  OKAY,
  ERROR
  } yuu_ahb_response_e;

typedef enum bit{
  SECURE,
  NON_SECURE
  } yuu_ahb_nonsec_e;

typedef enum bit{
  ABOUT_AFTER_ERROR,
  CONTINUE_AFTER_ERROR
  } yuu_ahb_error_behavior_e;

typedef enum bit[1:0]{
  FIRST,
  MIDDLE,
  LAST
  } yuu_ahb_location_e;

typedef enum bit[1:0]{
  MASTER,
  SLAVE,
  ARBITER,
  DECODER
  } yuu_ahb_agent_type_e;

typedef enum bit[2:0] {
  NO_ERROR,
  INVALID_ADDR,
  READ_ONLY,
  WRITE_ONLY,
  CURRUPT_DATA
  } yuu_ahb_error_type_e;

function yuu_amba_burst_type_e burst_ahb_to_amba(yuu_ahb_burst_e burst_type);
  case (burst_type)
    SINGLE, INCR, INCR4, INCR8, INCR16: burst_ahb_to_amba = yuu_amba_pkg::INCR;
                  WRAP4, WRAP8, WRAP16: burst_ahb_to_amba = yuu_amba_pkg::WRAP;
  endcase
endfunction

function yuu_amba_size_e size_ahb_to_amba(yuu_ahb_size_e size);
  return yuu_amba_size_e'(size);
endfunction

`endif
