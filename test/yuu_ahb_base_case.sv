`include "slave_ral_model.sv"

class yuu_ahb_base_case extends uvm_test;
  virtual yuu_ahb_interface vif;

  yuu_ahb_env env;
  yuu_ahb_env_config cfg;
  slave_ral_model model;
  yuu_ahb_master_adapter adapter;

  uvm_event_pool events;

  `uvm_component_utils(yuu_ahb_base_case)

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
      m_cfg.idle_enable = True;
      m_cfg.busy_enable = True;
      m_cfg.use_response = True;
      cfg.set_config(m_cfg);
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

    model = new("model");
    model.build();
    model.lock_model();
    model.reset();

    adapter = yuu_ahb_master_adapter::type_id::create("adapter");
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    adapter.cfg = cfg.mst_cfg[0];
    model.default_map.set_sequencer(env.sequencer.master_sequencer[0], adapter);
  endfunction
endclass
