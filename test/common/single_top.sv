/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
module single_top;
  reg  hclk;
  reg  hreset_n;

  yuu_ahb_master_interface  master_if();
  yuu_ahb_slave_interface   slave_if();

  logic hready0, hready1;
  assign master_if.hclk     = hclk;
  assign slave_if.hclk      = hclk;
  assign master_if.hreset_n = hreset_n;
  assign slave_if.hreset_n  = hreset_n;

  assign slave_if.haddr     = master_if.haddr;
  assign slave_if.htrans    = master_if.htrans;
  assign slave_if.hburst    = master_if.hburst;
  assign slave_if.hwrite    = master_if.hwrite;
  assign slave_if.hsize     = master_if.hsize ;
  assign slave_if.hwdata    = master_if.hwdata;
  assign slave_if.hmaster   = master_if.hmaster;
  assign slave_if.hmastlock = master_if.hmastlock;
  assign slave_if.hprot     = master_if.hprot;
  assign slave_if.hnonsec   = master_if.hnonsec;
  assign master_if.hrdata   = slave_if.hrdata;
  assign master_if.hresp    = slave_if.hresp;
  assign slave_if.hready_i  = hready0;
  assign slave_if.hsel      = (master_if.haddr >= 32'h80000000) ? 1'b1 : 1'b0;
  assign master_if.hready_i = hready0;
  assign hready0 = slave_if.hready_o;

  initial begin
    uvm_config_db #(virtual yuu_ahb_master_interface)::set(uvm_root::get(), "uvm_test_top", "yuu_ahb_master_interface", master_if);
    uvm_config_db #(virtual yuu_ahb_slave_interface)::set(uvm_root::get(), "uvm_test_top", "yuu_ahb_slave_interface", slave_if);
    run_test();
  end

  initial begin
    hclk = 1'b1;
    hreset_n = 1'b0;
    #11 hreset_n = 1'b1;
  end

  always #7 hclk = ~hclk;
endmodule
