/////////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 seabeam@qq.com - Licensed under the MIT License, Version 2.0
// For more information, see LICENCE in the main folder
/////////////////////////////////////////////////////////////////////////////////////
`ifndef GUARD_YUU_AHB_MASTER_RAW_SEQUENCE_SV
`define GUARD_YUU_AHB_MASTER_RAW_SEQUENCE_SV

// Class: yuu_ahb_master_raw_sequence
// Random master read after write sequence.
class yuu_ahb_master_raw_sequence extends yuu_ahb_master_sequence_base;
  protected yuu_ahb_master_item wr_queue[$], rd_queue[$];
  int check_count = 0;
  int unsigned passed, failed;
  boolean check_enable = True;

  `uvm_object_utils(yuu_ahb_master_raw_sequence)

  // Task: body
  // UVM built-in method.
  function new(string name = "yuu_ahb_master_raw_sequence");
    super.new(name);
  endfunction

  // Task: body
  // UVM built-in method.
  virtual task body();
    use_response_handler(1);
    repeat (n_item) begin
      yuu_ahb_master_item wr_req = yuu_ahb_master_item::type_id::create("wr_req");
      yuu_ahb_master_item rd_req = yuu_ahb_master_item::type_id::create("rd_req");

      `uvm_create(wr_req);
      wr_req.cfg = cfg;
      if (!wr_req.randomize() with {direction == WRITE;}) begin
        `uvm_fatal("body", "Transaction randomize error.")
      end
      `uvm_send(wr_req);
      wr_queue.push_back(wr_req);

      `uvm_create(rd_req);
      rd_req.copy(wr_req);
      rd_req.direction = READ;
      foreach (rd_req.data[i]) rd_req.data[i] = 'h0;
      `uvm_send(rd_req);
    end
  endtask

  virtual task post_start();
    if (check_enable) begin
      wait (check_count == n_item);

      `uvm_info("post_start", $sformatf("%0d/%0d check passed", passed, passed + failed), UVM_NONE)

      if (passed == 0 || failed != 0) `uvm_error("post_start", "Simulation failed")
      else `uvm_info("post_start", "Simulation passed", UVM_NONE)
    end
  endtask

  virtual function void response_handler(uvm_sequence_item response);
    if (!$cast(rsp, response)) `uvm_fatal("response_handler", "Invalid response type")
    else begin
      if (check_enable) begin
        if (rsp.direction == READ) rd_queue.push_back(rsp);
      end
    end

    if (wr_queue.size() && rd_queue.size()) compare_trans();
  endfunction

  virtual function void compare_trans();
    yuu_ahb_master_item wr_req, rd_rsp;

    wr_req = wr_queue.pop_front();
    rd_rsp = rd_queue.pop_front();

    if (wr_req.compare(rd_rsp)) passed++;
    else failed++;

    check_count++;
  endfunction
endclass

`endif
