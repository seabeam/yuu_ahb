class yuu_master_direct_sequence extends yuu_ahb_master_sequence_base;
  `uvm_object_utils(yuu_master_direct_sequence)

  function new(string name="yuu_master_direct_sequence");
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
endclass : yuu_master_direct_sequence


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


class yuu_ahb_direct_case extends uvm_test;
  virtual yuu_ahb_interface vif;

  yuu_ahb_env env;
  yuu_ahb_env_config cfg;

  uvm_event_pool events;

  `uvm_component_utils(yuu_ahb_direct_case)

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
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    yuu_master_direct_sequence  mst_seq = new("mst_seq");
    yuu_slave_rsp_seqence     rsp_seq = new("rsp_seq");

    uvm_event master_done = events.get("master_done");

    phase.raise_objection(this);
    fork
      mst_seq.start(env.sequencer.master_sequencer[0]);
      rsp_seq.start(env.sequencer.slave_sequencer[0]);
    join
    phase.drop_objection(this);
  endtask : run_phase
endclass : yuu_ahb_direct_case
