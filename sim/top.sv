`ifndef TOP_SV
`define TOP_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

import yuu_common_pkg::*;
import yuu_amba_pkg::*;
import yuu_ahb_pkg::*;

`include "yuu_ahb_base_case.sv"
`include "yuu_ahb_direct_case.sv"
`include "yuu_ahb_ral_case.sv"

module top;
  reg  hclk;
  reg  hreset_n;

  yuu_ahb_interface ahb_if();

  assign ahb_if.master_if[0].hclk     = hclk;
  assign ahb_if.master_if[0].hreset_n = hreset_n;
  assign ahb_if.slave_if[0].hclk      = hclk;
  assign ahb_if.slave_if[0].hreset_n  = hreset_n;

  logic hready0, hready1;
  assign ahb_if.slave_if[0].haddr     = ahb_if.master_if[0].haddr;
  assign ahb_if.slave_if[0].htrans    = ahb_if.master_if[0].htrans;
  assign ahb_if.slave_if[0].hburst    = ahb_if.master_if[0].hburst;
  assign ahb_if.slave_if[0].hwrite    = ahb_if.master_if[0].hwrite;
  assign ahb_if.slave_if[0].hsize     = ahb_if.master_if[0].hsize ;
  assign ahb_if.slave_if[0].hwdata    = ahb_if.master_if[0].hwdata;
  assign ahb_if.slave_if[0].hmaster   = ahb_if.master_if[0].hmaster;
  assign ahb_if.slave_if[0].hmastlock = ahb_if.master_if[0].hmastlock;
  assign ahb_if.slave_if[0].hprot     = ahb_if.master_if[0].hprot;
  assign ahb_if.slave_if[0].hnonsec   = ahb_if.master_if[0].hnonsec;
  assign ahb_if.master_if[0].hrdata   = ahb_if.slave_if[0].hrdata;
  assign ahb_if.master_if[0].hresp    = ahb_if.slave_if[0].hresp;
  assign ahb_if.slave_if[0].hready_i  = hready0;
  assign ahb_if.slave_if[0].hsel      = 1'b1;
  assign ahb_if.master_if[0].hready_i = hready0;
  assign hready0 = ahb_if.slave_if[0].hready_o;

  initial begin
    uvm_config_db #(virtual yuu_ahb_interface)::set(uvm_root::get(), "uvm_test_top", "yuu_ahb_interface", ahb_if);
    run_test("uvc_test");
  end

  initial begin
    hclk      = 1'b1;
    hreset_n    = 1'b0;
    #11 hreset_n  = 1'b1;
  end

  always #7  hclk = ~hclk;
endmodule

`endif
