/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2019 seabeam@yahoo.com - Licensed under the Apache License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef YUU_AHB_SLAVE_MEMORY_SV
`define YUU_AHB_SLAVE_MEMORY_SV

class yuu_ahb_slave_memory extends uvm_object;
  yuu_ahb_slave_config  cfg;

  protected yuu_ahb_data_t val[yuu_ahb_addr_t];

  `uvm_object_utils(yuu_ahb_slave_memory)

  function new(string name="yuu_ahb_slave_memory");
    super.new(name);
  endfunction

  task write(input yuu_ahb_addr_t addr, input yuu_ahb_data_t data, input bit[3:0] strob = 4'hF);
    foreach (strob[i]) begin
      if (strob[i])
        val[addr][i*8+:8] = data[i*8+:8];
    end
  endtask

  task read(input yuu_ahb_addr_t addr, output yuu_ahb_data_t data);
    if (val.exists(addr))
      data = val[addr];
    else begin
      case(cfg.mem_init_pattern)
        PATTERN_ALL_0:  data = 'h0;
        PATTERN_ALL_1:  data = -'h1;
        PATTERN_55:     for (int i=0; i<$ceil(real'(cfg.bus_width)/real'(32)); i++) begin
                          data |= 32'h5555_5555<<(i*32);
                        end
        PATTERN_AA:     for (int i=0; i<$ceil(real'(cfg.bus_width)/real'(32)); i++) begin
                          data |= 32'hAAAA_AAAA<<(i*32);
                        end
        PATTERN_5A:     for (int i=0; i<$ceil(real'(cfg.bus_width)/real'(32)); i++) begin
                          data |= 32'h5A5A_5A5A<<(i*32);
                        end
        PATTERN_A5:     for (int i=0; i<$ceil(real'(cfg.bus_width)/real'(32)); i++) begin
                          data |= 32'hA5A5_A5A5<<(i*32);
                        end
        PATTERN_RANDOM: for (int i=0; i<$ceil(real'(cfg.bus_width)/real'(32)); i++) begin
                          data |= $random()<<(i*32);
                        end
        default:        data = 'h0;
      endcase
    end
  endtask
endclass

`endif
