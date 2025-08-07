class router_rd_seqs extends uvm_sequence #(read_xtn);
  `uvm_object_utils(router_rd_seqs)

  extern function new(string name = "router_rd_seqs");

endclass: router_rd_seqs

function router_rd_seqs::new(string name = "router_rd_seqs");
 super.new(name);
endfunction:new

class router_rd_seq1 extends router_rd_seqs;
  `uvm_object_utils(router_rd_seq1)

  extern function new(string name = "router_rd_seq1");
  extern task body();
endclass: router_rd_seq1

function router_rd_seq1::new(string name = "router_rd_seq1");
 super.new(name);
endfunction:new

task router_rd_seq1::body();
  req = read_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize() with {req.no_of_cycles inside {[1:28]};});
  finish_item(req);
endtask

class router_rd_seq2 extends router_rd_seqs;
  `uvm_object_utils(router_rd_seq2)

  extern function new(string name = "router_rd_seq2");
  extern task body();
endclass: router_rd_seq2

function router_rd_seq2::new(string name = "router_rd_seq2");
 super.new(name);
endfunction:new

task router_rd_seq2::body();
  req = read_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize() with {req.no_of_cycles inside {[30:40]};});
  finish_item(req);
endtask

