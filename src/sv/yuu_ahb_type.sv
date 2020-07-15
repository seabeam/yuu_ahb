/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_TYPE_SV
`define YUU_AHB_TYPE_SV

  typedef bit [`YUU_AHB_ADDR_WIDTH-1:0] yuu_ahb_addr_t;
  typedef bit [`YUU_AHB_DATA_WIDTH-1:0] yuu_ahb_data_t;
  typedef bit [`YUU_AHB_LANE_WIDTH-1:0] yuu_ahb_lane_t;
  typedef class yuu_ahb_item;
  typedef uvm_reg_predictor #(yuu_ahb_item) yuu_ahb_master_predictor;
  typedef yuu_common_memory yuu_ahb_slave_memory;
  
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
  
  typedef enum bit[2:0] {
    BYTE1,
    BYTE2,
    BYTE4,
    BYTE8,
    BYTE16,
    BYTE32,
    BYTE64,
    BYTE128
    } yuu_ahb_burst_size_e;

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

  typedef enum bit[1:0] {
    AHB_FIXED,
    AHB_INCR,
    AHB_WRAP
    } yuu_ahb_burst_type_e;

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
    NON_EXCLUSIVE,
    EXCLUSIVE
    } yuu_ahb_excl_e;
  
  typedef enum bit{
    EXERROR,
    EXOKAY
    } yuu_ahb_exokay_e;
  
  typedef enum bit{
    CONTINUE_AFTER_ERROR,
    ABORT_AFTER_ERROR
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
    CORRUPT_DATA
    } yuu_ahb_error_type_e;

`endif