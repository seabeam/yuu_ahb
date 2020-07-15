/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef SLAVE_RAL_MODEL_SV 
`define SLAVE_RAL_MODEL_SV 

class reg_RA extends uvm_reg;
  rand uvm_reg_field F1;

  `uvm_object_utils(reg_RA)

  function new(string name = "RA");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction: new

  virtual function void build();
    this.F1 = new("F1");
    this.F1.configure(this, 32, 0, "RW", 0, 32'h0000_0000, 1, 0, 1);
  endfunction: build

endclass : reg_RA


class reg_RB extends uvm_reg;
  rand uvm_reg_field F1;
  rand uvm_reg_field F2;

  `uvm_object_utils(reg_RB)

  function new(string name = "RB");
    super.new(name, 32, UVM_NO_COVERAGE);
  endfunction: new

  virtual function void build();
    this.F1 = new("F1");
    this.F1.configure(this, 8, 0, "RW", 0, 8'h00, 1, 0, 1);
    this.F2 = new("F2");
    this.F2.configure(this, 8, 16, "RW", 0, 8'h00, 1, 0, 1);
  endfunction: build

endclass : reg_RB


class mem_MEM extends uvm_mem;
   `uvm_object_utils(mem_MEM)

   function new(string name = "MEM");
     super.new(name, 32'h100, 32, "RW", UVM_NO_COVERAGE);
   endfunction

endclass : mem_MEM


class block_common extends uvm_reg_block;
  rand reg_RA RA;
  rand reg_RB RB;
  rand mem_MEM MEM;

  function new(string name = "block_common");
    super.new(name, UVM_NO_COVERAGE);
  endfunction: new

  virtual function void build();
    this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);

    RA = new("RA");
    RA.configure(this, null, "");
    RA.build();
    this.default_map.add_reg(this.RA, 32'h0, "RW", 0);
    RB = new("RB");
    RB.configure(this, null, "");
    RB.build();
    this.default_map.add_reg(this.RB, 32'h4, "RW", 0);
    MEM = new("MEM");
    MEM.configure(this, "MEM");
    this.default_map.add_mem(this.MEM, 32'h100, "RW", 0);
  endfunction : build

  `uvm_object_utils(block_common)

endclass : block_common


class slave_ral_model extends uvm_reg_block;
  rand block_common common;

  `uvm_object_utils(slave_ral_model)

  function new(string name = "slave_ral_model");
    super.new(name);
  endfunction: new

  function void build();
    this.default_map = create_map("", 0, 4, UVM_LITTLE_ENDIAN, 0);

    this.common = new("common");
    this.common.configure(this, "common");
    this.common.build();
    this.default_map.add_submap(common.default_map, 32'h0);
  endfunction : build
endclass : slave_ral_model

`endif
