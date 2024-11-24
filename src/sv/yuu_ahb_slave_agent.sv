/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_SLAVE_AGENT_SV
`define GUARD_YUU_AHB_SLAVE_AGENT_SV

// Class: yuu_ahb_slave_agent
// Container class for AHB slave.
class yuu_ahb_slave_agent extends uvm_agent;
  // Variable: cfg
  // AHB slave agent configuration object.
  yuu_ahb_slave_config cfg;

  // Variable: sequencer
  // AHB slave sequencer.
  yuu_ahb_slave_sequencer sequencer;

  // Variable: driver
  // AHB slave driver.
  yuu_ahb_slave_driver driver;

  // Variable: monitor
  // AHB slave monitor.
  yuu_ahb_slave_monitor monitor;

  // Variable: coverage
  // AHB slave functional coverage collector.
  yuu_ahb_coverage coverage;

  // Variable: analyzer
  // AHB slave throughput analyzer.
  yuu_ahb_analyzer analyzer;

  // Variable: out_driver_port
  // Analysis port out from driver.
  uvm_analysis_port #(yuu_ahb_slave_item) out_driver_port;

  // Variable: out_driver_port
  // Analysis port out from driver.
  uvm_analysis_port #(yuu_ahb_item) out_monitor_port;

  `uvm_component_utils_begin(yuu_ahb_slave_agent)
  `uvm_component_utils_end

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass

// Function: new
// Constructor of object.
function yuu_ahb_slave_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

// Function: build_phase
// UVM built-in method.
function void yuu_ahb_slave_agent::build_phase(uvm_phase phase);
  if (!uvm_config_db#(yuu_ahb_slave_config)::get(null, get_full_name(), "cfg", cfg) && cfg == null)
    `uvm_fatal("build_phase", "Cannot get slave configuration");
  if (cfg == null) `uvm_fatal("build_phase", "Get a null slave configuration")

  monitor = yuu_ahb_slave_monitor::type_id::create("monitor", this);
  monitor.cfg = cfg;
  if (cfg.is_active == UVM_ACTIVE) begin
    uvm_config_db#(yuu_ahb_slave_config)::set(this, "sequencer", "cfg", cfg);
    sequencer = yuu_ahb_slave_sequencer::type_id::create("sequencer", this);
    driver = yuu_ahb_slave_driver::type_id::create("driver", this);
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
  if (cfg.coverage_enable) begin
    coverage = yuu_ahb_coverage::type_id::create("coverage", this);
    coverage.cfg = cfg;
  end
  if (cfg.analysis_enable) begin
    analyzer = yuu_ahb_analyzer::type_id::create("analyzer", this);
    analyzer.cfg = cfg;
  end
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_slave_agent::connect_phase(uvm_phase phase);
  out_monitor_port = monitor.out_monitor_port;

  if (cfg.is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
    out_driver_port = driver.out_driver_port;
  end
  if (cfg.coverage_enable) begin
    monitor.out_monitor_port.connect(coverage.analysis_export);
  end
  if (cfg.analysis_enable) begin
    monitor.out_monitor_port.connect(analyzer.analysis_export);
  end
endfunction

`endif
