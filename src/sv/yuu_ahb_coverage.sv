/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2020 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_COVERAGE_SV
`define YUU_AHB_COVERAGE_SV

// Class: yuu_ahb_coverage
// AHB functional coverage collector, which receives transaction out from monitor to 
// process.
class yuu_ahb_coverage extends uvm_subscriber #(yuu_ahb_item);
  // Variable: cfg
  // AHB agent configuration object.
  yuu_ahb_agent_config  cfg;

  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool        events;

  // Variable: item
  // Transaction received from monitor for coverage sampling.
  yuu_ahb_item item;

  // Variable: trans
  // HTRANS received from monitor for coverage sampling.
  yuu_ahb_trans_e trans;

  // Variable: resp
  // HRESP received from monitor for coverage sampling.
  yuu_ahb_response_e resp;

  // Coverage: ahb_transaction_common_cg
  // Basic coverage group of collect direction, length, size, 
  // burst and other coverpoints.
  covergroup ahb_transaction_common_cg();
    direction: coverpoint item.direction {
      bins ahb_write = {WRITE};
      bins ahb_read = {READ};
    }

    length: coverpoint item.len;

    size:   coverpoint item.size {
      bins ahb_size8 = {SIZE8};
      bins ahb_size16 = {SIZE16};
      bins ahb_size32 = {SIZE32};
      bins ahb_size64 = {SIZE64};
      bins ahb_size128 = {SIZE128};
      bins ahb_size256 = {SIZE256};
      bins ahb_size512 = {SIZE512};
      bins ahb_size1024 = {SIZE1024};
    }

    burst:  coverpoint item.burst {
      bins ahb_signle = {SINGLE};
      bins ahb_incr = {INCR};
      bins ahb_wrap4 = {WRAP4};
      bins ahb_incr4 = {INCR4};
      bins ahb_wrap8 = {WRAP8};
      bins ahb_incr8 = {INCR8};
      bins ahb_wrap16 = {WRAP16};
      bins ahb_incr16 = {INCR16};
    }

    master: coverpoint item.master;
    lock:   coverpoint item.lock;
    nonsec: coverpoint item.nonsec;
    excl:   coverpoint item.excl;
  endgroup
  
  // Coverage: ahb_trans_cg
  // HTRANS information expected to sample.
  covergroup ahb_trans_cg();
    trans: coverpoint trans {
      bins ahb_busy = {BUSY};
      bins ahb_nonseq = {NONSEQ};
      bins ahb_seq  = {SEQ};
    }
  endgroup
  
  // Coverage: ahb_response_cg
  // HRESP information expected to sample.
  covergroup ahb_response_cg();
    response: coverpoint resp {
      bins ahb_okay   = {OKAY};
      bins ahb_error  = {ERROR};
    }
  endgroup

  `uvm_component_utils_begin(yuu_ahb_coverage)
  `uvm_component_utils_end

  extern                   function      new(string name, uvm_component parent);
  extern           virtual function void build_phase(uvm_phase phase);
  extern           virtual function void connect_phase(uvm_phase phase);

  extern           virtual function void write(yuu_ahb_item t);
endclass

// Function: new
// Constructor of object.
function yuu_ahb_coverage::new(string name, uvm_component parent);
  super.new(name, parent);
  ahb_transaction_common_cg = new;
  ahb_trans_cg = new;
  ahb_response_cg = new;
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_coverage::build_phase(uvm_phase phase);
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_coverage::connect_phase(uvm_phase phase);
  this.events = cfg.events;
endfunction

// Function: write
// UVM built-in method. A user implementation of uvm_analysis_imp.
// In this class, user can override this method to add, remove or 
// update user coverage group sampling.
function void yuu_ahb_coverage::write(yuu_ahb_item t);
  item = yuu_ahb_item::type_id::create("item");
  item.copy(t);

  ahb_transaction_common_cg.sample();
  foreach (t.trans[i]) begin
    trans = t.trans[i];
    ahb_trans_cg.sample();
  end
  foreach (t.response[i]) begin
    resp = t.response[i];
    ahb_response_cg.sample();
  end
endfunction

`endif