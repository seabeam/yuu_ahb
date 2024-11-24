/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_MASTER_AGENT_SV
`define GUARD_YUU_AHB_MASTER_AGENT_SV

// Class: yuu_ahb_master_agent
// Container class for AHB master.
class yuu_ahb_master_agent extends uvm_agent;
  // Variable: cfg
  // AHB master agent configuration object.
  yuu_ahb_master_config cfg;

  // Variable: sequencer
  // AHB master sequencer.
  yuu_ahb_master_sequencer sequencer;

  // Variable: driver
  // AHB master driver.
  yuu_ahb_master_driver driver;

  // Variable: monitor
  // AHB master monitor.
  yuu_ahb_master_monitor monitor;

  // Variable: coverage
  // AHB master functional coverage collector.
  yuu_ahb_coverage coverage;

  // Variable: analyzer
  // AHB master throughput analyzer.
  yuu_ahb_analyzer analyzer;

  // Variable: adapter
  // AHB master register adapter.
  yuu_ahb_master_adapter adapter;

  // Variable: predictor
  // AHB master register predictor.
  yuu_ahb_master_predictor predictor;

  // Variable: out_driver_port
  // Analysis port out from driver.
  uvm_analysis_port #(yuu_ahb_master_item) out_driver_port;

  // Variable: out_monitor_port
  // Analysis port out from monitor after collecting.
  uvm_analysis_port #(yuu_ahb_item) out_monitor_port;

  `uvm_component_utils_begin(yuu_ahb_master_agent)
  `uvm_component_utils_end

  extern function new(string name, uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);
endclass

// Function: new
// Constructor of object.
function yuu_ahb_master_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

// Function: build_phase
// UVM built-in method.
function void yuu_ahb_master_agent::build_phase(uvm_phase phase);
  if (!uvm_config_db#(yuu_ahb_master_config)::get(
          null, get_full_name(), "cfg", cfg
      ) && cfg == null) begin
    `uvm_fatal("build_phase", "Cannot get master configuration");
  end

  monitor = yuu_ahb_master_monitor::type_id::create("monitor", this);
  monitor.cfg = cfg;
  if (cfg.is_active == UVM_ACTIVE) begin
    sequencer = yuu_ahb_master_sequencer::type_id::create("sequencer", this);
    driver = yuu_ahb_master_driver::type_id::create("driver", this);
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

  if (cfg.use_reg_model) begin
    adapter = yuu_ahb_master_adapter::type_id::create("adapter");
    adapter.cfg = cfg;
    adapter.provides_responses = 1;

    predictor = yuu_ahb_master_predictor::type_id::create("predictor", this);
    predictor.adapter = adapter;

    cfg.use_response = True;
  end
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_master_agent::connect_phase(uvm_phase phase);
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
  if (cfg.use_reg_model) begin
    monitor.out_monitor_port.connect(predictor.bus_in);
  end
endfunction

// Function: end_of_elaboration_phase
// UVM built-in method.
function void yuu_ahb_master_agent::end_of_elaboration_phase(uvm_phase phase);
  if (cfg.use_reg_model) begin
    if (predictor.map == null)
      `uvm_fatal("end_of_elaboration_phase",
                 "When register model used, the predictor map should be set")
  end
endfunction

`endif
