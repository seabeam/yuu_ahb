/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_ENV_SV
`define GUARD_YUU_AHB_ENV_SV 

// Class: yuu_ahb_env
// AHB environment class, a container of masters and slaves
class yuu_ahb_env extends uvm_env;
  // Variable: cfg
  // AHB agent configuration object.
  yuu_ahb_env_config cfg;

  // Variable: master
  // AHB master agent instances.
  yuu_ahb_master_agent master[];

  // Variable: slave
  // AHB slave agent instances.
  yuu_ahb_slave_agent slave[];

  // Variable: vsequencer
  // AHB virtual sequencer handle.
  yuu_ahb_virtual_sequencer vsequencer;

  `uvm_component_utils(yuu_ahb_env)

  extern function new(string name, uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

  extern protected virtual function void address_check();
endclass

// Function: new
// Constructor of object.
function yuu_ahb_env::new(string name, uvm_component parent);
  super.new(name, parent);
endfunction

// Function: build_phase
// UVM built-in method.
function void yuu_ahb_env::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db#(yuu_ahb_env_config)::get(
          null, get_full_name(), "cfg", cfg
      ) && cfg == null) begin
    `uvm_fatal("build_phase", "Cannot get env configuration.");
  end

  vsequencer = yuu_ahb_virtual_sequencer::type_id::create("vsequencer", this);

  master = new[cfg.mst_cfg.size()];
  vsequencer.master_sequencer = new[cfg.mst_cfg.size()];
  foreach (master[i]) begin
    if (cfg.mst_cfg[i].index != -1) begin
      uvm_config_db#(yuu_ahb_master_config)::set(this, $sformatf("master[%0d]", i), "cfg",
                                                 cfg.mst_cfg[i]);
      master[i] = yuu_ahb_master_agent::type_id::create($sformatf("master[%0d]", i), this);
    end
  end

  slave = new[cfg.slv_cfg.size()];
  vsequencer.slave_sequencer = new[cfg.slv_cfg.size()];
  foreach (slave[i]) begin
    if (cfg.slv_cfg[i].index != -1) begin
      uvm_config_db#(yuu_ahb_slave_config)::set(this, $sformatf("slave[%0d]", i), "cfg",
                                                cfg.slv_cfg[i]);
      slave[i] = yuu_ahb_slave_agent::type_id::create($sformatf("slave[%0d]", i), this);
    end
  end

  address_check();

  vsequencer.cfg = cfg;
endfunction

// Function: connect_phase
// UVM built-in method.
function void yuu_ahb_env::connect_phase(uvm_phase phase);
  foreach (cfg.mst_cfg[i]) begin
    cfg.mst_cfg[i].events = cfg.events;
    vsequencer.master_sequencer[i] = master[i].sequencer;
  end
  foreach (cfg.slv_cfg[i]) begin
    cfg.slv_cfg[i].events = cfg.events;
    vsequencer.slave_sequencer[i] = slave[i].sequencer;
  end
endfunction


// Function: address_check
// Check master/slave's address conflict
function void yuu_ahb_env::address_check();
  yuu_ahb_addr_t addr_ass [int];
  yuu_ahb_addr_t low_addr [$];
  yuu_ahb_addr_t high_addr[$];

  foreach (cfg.slv_cfg[i]) begin
    if (cfg.slv_cfg[i].index != -1) begin
      if (!cfg.slv_cfg[i].is_multi_range()) begin
        low_addr.push_back(cfg.slv_cfg[i].maps[0].get_low());
        high_addr.push_back(cfg.slv_cfg[i].maps[0].get_high());
      end else begin
        for (int j = 0; j < cfg.slv_cfg[i].maps.size(); j++) begin
          low_addr.push_back(cfg.slv_cfg[i].maps[j].get_low());
          high_addr.push_back(cfg.slv_cfg[i].maps[j].get_high());
        end
      end
    end
  end

  foreach (low_addr[i]) begin
    addr_ass[2*i]   = low_addr[i];
    addr_ass[2*i+1] = high_addr[i];

    if (low_addr[i] == high_addr[i])
      `uvm_warning("address_check", $sformatf("Low address equals to high address(%0h)", low_addr[i]
                   ))
  end

  begin
    yuu_ahb_addr_t q0[$];
    yuu_ahb_addr_t q1[$];

    q0 = addr_ass.unique();
    q1 = q0;
    q0.sort();
    if (q0 != q1 || (addr_ass.size() > q0.size())) begin
      `uvm_warning("address_check", "Address range has overlapping")
    end
  end
endfunction

`endif
