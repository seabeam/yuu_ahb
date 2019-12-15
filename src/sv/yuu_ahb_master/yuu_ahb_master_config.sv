/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_MASTER_CONFIG_SV
`define YUU_AHB_MASTER_CONFIG_SV

class yuu_ahb_master_config extends yuu_ahb_agent_config;
  virtual yuu_ahb_master_interface  vif;

  boolean idle_enable = True;
  boolean busy_enable = True;
  // Early burst termination burst continue
  boolean ebt_continue  = False;
  boolean use_busy_end  = False;
  boolean use_protection= False;
  boolean use_extended_memory_types = False;
  boolean use_lock    = False;
  boolean use_nonsec  = False;
  boolean use_response= False;

  yuu_ahb_error_behavior_e error_behavior;
  yuu_amba_addr_map addressable_maps[];

  `uvm_object_utils_begin(yuu_ahb_master_config)
    `uvm_field_enum        (boolean,                  idle_enable,      UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  busy_enable,      UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  ebt_continue,     UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  use_busy_end,     UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  use_protection,   UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  use_extended_memory_types, UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  use_lock,         UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  use_nonsec,       UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (boolean,                  busy_enable,      UVM_PRINT | UVM_COPY)
    `uvm_field_enum        (yuu_ahb_error_behavior_e, error_behavior,   UVM_PRINT | UVM_COPY)
    `uvm_field_array_object(                          addressable_maps, UVM_PRINT | UVM_COPY)
  `uvm_object_utils_end

  function new(string name = "yuu_ahb_master_config");
    super.new(name);
  endfunction

  // set_map
  //
  // Set master address range
  // low: low address boundary
  // high: high address boundary
  function void set_map(yuu_amba_addr_t low, yuu_amba_addr_t high);
    addressable_maps = new[1];
    addressable_maps[0] = yuu_amba_addr_map::type_id::create($sformatf("%s_addressable_maps[0]", this.get_name()));

    addressable_maps[0].set_map(low, high);
  endfunction

  function void set_maps(yuu_amba_addr_t lows[], yuu_amba_addr_t highs[]);
    if (lows.size() == 0|| highs.size() == 0)
      `uvm_error("set_maps", "The lows or highs array is empty")
    else if (lows.size() != highs.size())
      `uvm_error("set_maps", "The lows and highs array must in the same size")
    else begin
      addressable_maps = new[lows.size()];
      foreach (addressable_maps[i])
        addressable_maps[i] = yuu_amba_addr_map::type_id::create($sformatf("addressable_maps[%0d]", i));
      foreach (lows[i])
        addressable_maps[i].set_map(lows[i], highs[i]);
    end
  endfunction

  function yuu_amba_addr_map get_map();
    return this.addressable_maps[0];
  endfunction

  function void get_maps(ref yuu_amba_addr_map maps[]);
    maps = new[this.addressable_maps.size()];
    foreach (maps[i]) begin
      maps[i] = yuu_amba_addr_map::type_id::create($sformatf("map[%0d]", i));
      maps[i].copy(this.addressable_maps[i]);
    end
  endfunction

endclass

`endif
