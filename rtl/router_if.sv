interface router_if(input bit clock);
logic pkt_valid;
logic [7:0] data_in, data_out;
logic reset_n;
logic vld_out;
logic read_enb;
logic busy, error;

bit clk;
assign clk = clock;
modport DUV_MP (input clk, reset_n, pkt_valid, data_in, read_enb,
             output data_out, vld_out, busy ,error);

clocking src_drv_cb @(posedge clock);
  default input #1 output #0;
  output pkt_valid;
  output reset_n;
  output data_in;
  input busy;
  input error;
endclocking: src_drv_cb
    
clocking src_mon_cb @(posedge clock);
  default input #1 output #0;
  input pkt_valid;
  input reset_n;
  input data_in;
  input busy;
  input error;
endclocking: src_mon_cb 

clocking dst_drv_cb @(posedge clock);
  default input #1 output #0;
  output read_enb;
  input vld_out;
endclocking: dst_drv_cb
    
clocking dst_mon_cb @(posedge clock);
  default input #1 output #0;
  input read_enb;
  input data_out;
endclocking: dst_mon_cb

modport SRC_DRV (clocking src_drv_cb);
modport SRC_MON (clocking src_mon_cb);
modport DST_DRV (clocking dst_drv_cb);
modport DST_MON (clocking dst_mon_cb);
endinterface: router_if