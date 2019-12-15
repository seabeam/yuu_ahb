`ifndef TOP_SV
`define TOP_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

import yuu_common_pkg::*;
import yuu_amba_pkg::*;
import yuu_ahb_pkg::*;

class uvc_master_test_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(uvc_master_test_sequence)

  function new(string name="uvc_master_test_sequence");
    super.new(name);
  endfunction : new

  task body();
    uvm_event master_done = events.get("master_done");

    req = yuu_ahb_master_item::type_id::create("req");
    req.cfg = cfg;

    req.randomize() with {start_address == 32'h80000100;
                          len == 3;
                          size == SIZE32;
                          burst_type != WRAP;
                          foreach(data[i]) {
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == READ;};
    start_item(req);
    finish_item(req);

    req.randomize() with {start_address == 32'h80000100;
                          len == 3;
                          size == SIZE32;
                          burst_type != WRAP;
                          foreach(data[i]) {
                            data[i] == (i+'h1)<<i*8;
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == WRITE;};
    start_item(req);
    finish_item(req);

    req.randomize() with {start_address == 32'h80000100;
                          len == 15;
                          size == SIZE8;
                          burst_type != WRAP;
                          foreach(data[i]) {
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == READ;};
    start_item(req);
    finish_item(req);

    req.randomize() with {start_address == 32'h80000101;
                          len == 1;
                          size == SIZE8;
                          burst_type != WRAP;
                          foreach(data[i]) {
                            data[i] == (i+'h3)<<(i+1)*8;
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == WRITE;};
    start_item(req);
    finish_item(req);

    req.randomize() with {start_address == 32'h80000100;
                          len == 3;
                          size == SIZE32;
                          burst_type != WRAP;
                          foreach(data[i]) {
                            busy_delay[i] inside {[0:2]};
                          }
                          direction == READ;};
    start_item(req);
    finish_item(req);

    master_done.trigger();
  endtask
endclass : uvc_master_test_sequence


class yuu_slave_rsp_seqence extends yuu_ahb_slave_response_sequence;
  `uvm_object_utils(yuu_slave_rsp_seqence)

  function new(string name ="yuu_slave_rsp_seqence");
    super.new(name);
  endfunction

  task body();
    uvm_event master_done = events.get("master_done");

    forever begin
      `uvm_create(req)
      req.cfg = cfg;
      req.randomize() with {
        len == 0;
        //response[0] dist {ERROR:=1, OKAY:=1};
        response[0] == OKAY;
        wait_delay inside {[0:2]};
      };
      start_item(req);
      finish_item(req);
      if (master_done.is_on()) break;
    end
  endtask
endclass


class uvc_test extends uvm_test;
  virtual yuu_ahb_interface vif;

  yuu_ahb_env env;
  yuu_ahb_env_config cfg;

  uvm_event_pool events;

  `uvm_component_utils(uvc_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    events = new("events");
    cfg = new("cfg");
    cfg.events = events;
    uvm_config_db#(virtual yuu_ahb_interface)::get(null, get_full_name(), "yuu_ahb_interface", vif);

    cfg.ahb_if = vif;
    begin
      yuu_ahb_master_config m_cfg = new("e0_m0");
      m_cfg.index = 0;
      cfg.set_config(m_cfg);
      m_cfg.idle_enable = True;
      m_cfg.busy_enable = True;
    end
    begin
      yuu_ahb_slave_config  s_cfg = new("e0_s0");
      s_cfg.index = 0;
      s_cfg.set_map(0, 32'hF000_0000);
      s_cfg.mem_init_pattern = PATTERN_RANDOM;
      cfg.set_config(s_cfg);
    end

    uvm_config_db#(yuu_ahb_env_config)::set(this, "env", "cfg", cfg);
    env = yuu_ahb_env::type_id::create("env", this);
  endfunction : build_phase

  task main_phase(uvm_phase phase);
    uvc_master_test_sequence  mst_seq = new("mst_seq");
    yuu_slave_rsp_seqence     rsp_seq = new("rsp_seq");

    uvm_event master_done = events.get("master_done");

    phase.raise_objection(this);
    fork
      mst_seq.start(env.master[0].sequencer);
      rsp_seq.start(env.slave[0].sequencer);
    join
    //@(vif.master_if[0].mon_cb);
    phase.drop_objection(this);
  endtask : main_phase
endclass : uvc_test


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

  always #5  hclk = ~hclk;
endmodule

`endif
