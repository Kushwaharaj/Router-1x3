class write_xtn extends uvm_sequence_item;
  `uvm_object_utils(write_xtn)

  rand bit [7:0] header;
  rand bit [7:0] payload[];
  bit [7:0] parity;

  constraint c1{header[1:0] != 2'b11;}
  constraint c2{payload.size == header[7:2];}
  constraint c3{payload.size != 0;}

  extern function new(string name = "write_xtn");
  extern function void do_print(uvm_printer printer);
  extern function void post_randomize();
 
endclass: write_xtn

function write_xtn::new(string name = "write_xtn");
 super.new(name);
endfunction:new

function void write_xtn::do_print(uvm_printer printer);
  printer.print_field("header", header, 8, UVM_BIN);
  foreach(payload[i])
    printer.print_field($sformatf("payload[%0d]",i), payload[i], 8, UVM_DEC);
  printer.print_field("parity", parity, 8, UVM_DEC);
endfunction: do_print

 function void write_xtn::post_randomize();
    parity = 0^header;
    foreach(payload[i])
      parity = parity^payload[i];
  endfunction: post_randomize