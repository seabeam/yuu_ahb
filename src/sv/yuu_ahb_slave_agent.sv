/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_AGENT_SV
`define YUU_AHB_SLAVE_AGENT_SV

class yuu_ahb_slave_agent extends uvm_agent;
  yuu_ahb_agent_config  cfg;

  yuu_ahb_slave_sequencer sequencer;
  yuu_ahb_slave_driver    driver;
  yuu_ahb_slave_monitor   monitor;
  yuu_ahb_collector       collector;
  yuu_ahb_analyzer        analyzer;

  uvm_analysis_port  #(yuu_ahb_item)  out_driver_port;
  uvm_analysis_port  #(yuu_ahb_item)  out_monitor_port;

  `uvm_component_utils_begin(yuu_ahb_slave_agent)
  `uvm_component_utils_end

  extern         function      new(string name, uvm_component parent);
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
endclass

function yuu_ahb_slave_agent::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

function void yuu_ahb_slave_agent::build_phase(uvm_phase phase);
  if (!uvm_config_db #(yuu_ahb_agent_config)::get(null, get_full_name(), "cfg", cfg) && cfg == null)
    `uvm_fatal("build_phase", "Cannot get slave configuration");
  if (cfg == null)
    `uvm_fatal("build_phase", "Get a null slave configuration")

  monitor = yuu_ahb_slave_monitor::type_id::create("monitor", this);
  monitor.cfg = cfg;
  if (cfg.is_active == UVM_ACTIVE) begin
    uvm_config_db #(yuu_ahb_agent_config)::set(this, "sequencer", "cfg", cfg);
    sequencer = yuu_ahb_slave_sequencer::type_id::create("sequencer", this);
    driver = yuu_ahb_slave_driver::type_id::create("driver", this);
    sequencer.cfg = cfg;
    driver.cfg = cfg;
  end
  if (cfg.coverage_enable) begin
    collector = yuu_ahb_collector::type_id::create("collector", this);
    collector.cfg = cfg;
  end
  if (cfg.analysis_enable) begin
    analyzer = yuu_ahb_analyzer::type_id::create("analyzer", this);
    analyzer.cfg = cfg;
  end
endfunction

function void yuu_ahb_slave_agent::connect_phase(uvm_phase phase);
  out_monitor_port = monitor.out_monitor_port;

  if (cfg.is_active == UVM_ACTIVE) begin
    driver.seq_item_port.connect(sequencer.seq_item_export);
    out_driver_port = driver.out_driver_port;
  end
  if (cfg.coverage_enable) begin
    monitor.out_monitor_port.connect(collector.analysis_export);
  end
  if (cfg.analysis_enable) begin
    monitor.out_monitor_port.connect(analyzer.analysis_export);
  end
endfunction

`endif