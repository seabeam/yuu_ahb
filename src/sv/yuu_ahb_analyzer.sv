/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_ANALYZER_SV
`define GUARD_YUU_AHB_ANALYZER_SV

// Class: yuu_ahb_analyzer
// AHB throughput analyzer, which receives transaction out from monitor to process.
// It can be also used for any other process user defined and based on transaction.
class yuu_ahb_analyzer extends uvm_subscriber #(yuu_ahb_item);
  // Variable: cfg
  // AHB agent configuration object.
  yuu_ahb_agent_config cfg;

  // Variable: events
  // Global event pool for component communication.
  uvm_event_pool events;

  // Variable: m_start_time
  // The start time of AHB traffic want to measure on bus.
  protected time m_start_time;

  // Variable: m_end_time
  // The end time of AHB traffic want to measure on bus.
  protected time m_end_time;

  // Variable: m_start
  // Start flag of analysis, when True indecate that analysis is ongoing.
  protected boolean m_start = False;

  // Variable: m_count
  // Transaction count for analysis.
  protected int m_count = 0;

  `uvm_component_utils_begin(yuu_ahb_analyzer)
  `uvm_component_utils_end

  extern function new(string name, uvm_component parent);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);
  extern virtual function void report_phase(uvm_phase phase);

  extern virtual function void write(yuu_ahb_item t);
  extern protected virtual task measure_start();
  extern protected virtual task measure_end();
endclass

// Function: new
// Constructor of object.
function yuu_ahb_analyzer::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_analyzer::connect_phase(uvm_phase phase);
  this.events = cfg.events;
endfunction

// Task: run_phase
// UVM built-in method.
task yuu_ahb_analyzer::run_phase(uvm_phase phase);
  measure_start();
  measure_end();
endtask

// Function: report_phase
// UVM built-in method.
function void yuu_ahb_analyzer::report_phase(uvm_phase phase);
  real tput_rate;

  if (m_count == 0) begin
    `uvm_warning("report_phase", "Analyzer haven't received any transaction")
    return;
  end

  tput_rate = real'(m_count) / (m_end_time - m_start_time) * 1000;
  `uvm_info("report_phase", $sformatf("AHB speed is %f", tput_rate), UVM_LOW);
endfunction

// Function: write
// UVM built-in method. A user implemention of uvm_analysis_imp.
function void yuu_ahb_analyzer::write(yuu_ahb_item t);
  if (m_start) m_count += t.len + 1;
endfunction

// Task: measure_start
// Wait measure start event start, record the simulation time and set the start flag.
// Notice the index format of event is: {cfg.get_name()}_analyzer_measure_begin
task yuu_ahb_analyzer::measure_start();
  uvm_event e = events.get($sformatf("%s_analyzer_measure_begin", cfg.get_name()));

  e.wait_on();
  m_start_time = $realtime();
  m_start = True;
  `uvm_info("measure_start", $sformatf("%s analyzer start measure @ %t", cfg.get_name(),
                                       m_start_time), UVM_LOW)
endtask

// Task: measure_end
// Wait measure end event start, record the simulation time and clear the start flag.
// Notice the index format of event is: {cfg.get_name()}_analyzer_measure_end
task yuu_ahb_analyzer::measure_end();
  uvm_event e = events.get($sformatf("%s_analyzer_measure_end", cfg.get_name()));

  e.wait_on();
  m_end_time = $realtime();
  m_start = False;
  `uvm_info("measure_end", $sformatf("%s analyzer end measure @ %t", cfg.get_name(), m_end_time),
            UVM_LOW)
endtask

`endif
