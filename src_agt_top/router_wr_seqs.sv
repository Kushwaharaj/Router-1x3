class router_wr_seqs extends uvm_sequence #(write_xtn);
  `uvm_object_utils(router_wr_seqs)
  

  extern function new(string name = "router_wr_seqs");

endclass: router_wr_seqs

function router_wr_seqs::new(string name = "router_wr_seqs");
 super.new(name);
endfunction:new

class router_small_wr_seqs extends router_wr_seqs;
  `uvm_object_utils(router_small_wr_seqs)
  bit [1:0] addr;
  extern function new(string name = "router_small_wr_seqs");
  extern task body();

endclass: router_small_wr_seqs

function router_small_wr_seqs::new(string name = "router_small_wr_seqs");
 super.new(name);
endfunction:new

task router_small_wr_seqs::body();
  if(!uvm_config_db #(bit [1:0])::get(null, get_full_name(), "bit[1:0]", addr))
     `uvm_fatal("router_small_wr_seqs", "Failed to get the addr in router_small_wr_seqs");
  req = write_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize() with{req.header[7:2] inside {[1:15]};
                              req.header[1:0] == addr;});
  finish_item(req);
  req.print();
endtask: body


class router_medium_wr_seqs extends router_wr_seqs;
  `uvm_object_utils(router_medium_wr_seqs)
  bit [1:0] addr;
  extern function new(string name = "router_medium_wr_seqs");
  extern task body();

endclass: router_medium_wr_seqs

function router_medium_wr_seqs::new(string name = "router_medium_wr_seqs");
 super.new(name);
endfunction:new

task router_medium_wr_seqs::body();
  if(!uvm_config_db #(bit [1:0])::get(null, get_full_name(), "bit[1:0]", addr))
    `uvm_fatal("router_medium_wr_seqs", "Failed to get the addr in router_medium_wr_seqs");
  req = write_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize() with{req.header[7:2] inside{[16:30]};
                              req.header[1:0] == addr;});
  finish_item(req);
  req.print();
endtask: body


class router_big_wr_seqs extends router_wr_seqs;
  `uvm_object_utils(router_big_wr_seqs)
  bit [1:0] addr;
  extern function new(string name = "router_big_wr_seqs");
  extern task body();

endclass: router_big_wr_seqs

function router_big_wr_seqs::new(string name = "router_big_wr_seqs");
 super.new(name);
endfunction:new

task router_big_wr_seqs::body();
  if(!uvm_config_db #(bit [1:0])::get(null, get_full_name(), "bit[1:0]", addr))
    `uvm_fatal("router_big_wr_seqs", "Failed to get the addr in router_big_wr_seqs");
  req = write_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize() with{req.header[7:2] inside{[31:63]};
                              req.header[1:0] == addr;});
  finish_item(req);
  req.print();
endtask: body

