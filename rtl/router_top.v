module router_top(
    input clock,
    input resetn,
    input pkt_valid,
    input [7:0] data_in,
    input read_enb_0,
    input read_enb_1,
    input read_enb_2,
    output [7:0] data_out_0,
    output [7:0] data_out_1,
    output [7:0] data_out_2,
    output vld_out_0,
    output vld_out_1,
    output vld_out_2,
    output error,
    output busy
);

// Internal signals
wire [2:0] write_enb;
wire [7:0] d_out;


// Instantiate FSM
router_fsm FSM (clock,resetn,pkt_valid,low_pkt_valid,parity_done,soft_reset_0, soft_reset_1, soft_reset_2,fifo_full,empty_0,empty_1,
empty_2,data_in[1:0],busy,detect_add,ld_state,lfd_state,laf_state,full_state,write_enb_reg,rst_int_reg);

// Instantiate Register
router_register REGISTER(clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,data_in,
parity_done,low_pkt_valid,error,d_out);
 
// Instantiate Synchronizer
router_synchronizer SYNCHRONIZER(clock,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,
data_in[1:0],full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb,vld_out_0,vld_out_1,vld_out_2,
soft_reset_0,soft_reset_1,soft_reset_2,fifo_full);

// Instantiate FIFO for Port 0
router_fifo FIFO_0(clock,resetn,soft_reset_0,write_enb[0],read_enb_0,lfd_state,d_out,empty_0,full_0,data_out_0);

  // Instantiate FIFO for Port 0
router_fifo FIFO_1(clock,resetn,soft_reset_1,write_enb[1],read_enb_1,lfd_state,d_out,empty_1,full_1,data_out_1);

  // Instantiate FIFO for Port 0
router_fifo FIFO_2(clock,resetn,soft_reset_2,write_enb[2],read_enb_2,lfd_state,d_out,empty_2,full_2,data_out_2);
endmodule

//`timescale 1ns / 1ps
//module router_top(
//    input clock,
//    input resetn,
//    input pkt_valid,
//    input [7:0] data_in,
//    input read_enb_0,
//    input read_enb_1,
//    input read_enb_2,
//    output [7:0] data_out_0,
//    output [7:0] data_out_1,
//    output [7:0] data_out_2,
//    output vld_out_0,
//    output vld_out_1,
//    output vld_out_2,
//    output error,
//    output busy
//);

//    // Internal signals
//    wire [2:0] write_enb;
//    wire detect_add, ld_state, lfd_state, laf_state, full_state, write_enb_reg, rst_int_reg, parity_done, low_pkt_valid;
//    wire fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2;
//    wire soft_reset_0, soft_reset_1, soft_reset_2;
//    wire [7:0] d_out;

//    // Instantiate FSM
//    router_fsm FSM (
//        .clock(clock),
//        .resetn(resetn),
//        .packet_valid(pkt_valid),
//        .low_packet_valid(low_pkt_valid),
//        .parity_done(parity_done),
//        .soft_reset_0(soft_reset_0),
//        .soft_reset_1(soft_reset_1),
//        .soft_reset_2(soft_reset_2),
//        .fifo_full(fifo_full),
//        .fifo_empty_0(fifo_empty_0),
//        .fifo_empty_1(fifo_empty_1),
//        .fifo_empty_2(fifo_empty_2),
//        .data_in(data_in[1:0]),
//        .busy(busy),
//        .detect_add(detect_add),
//        .ld_state(ld_state),
//        .lfd_state(lfd_state),
//        .laf_state(laf_state),
//        .full_state(full_state),
//        .write_enb_reg(write_enb_reg),
//        .rst_int_reg(rst_int_reg)
//    );

//    // Instantiate Register
//    router_register REGISTER (
//        .clock(clock),
//        .resetn(resetn),
//        .pkt_valid(pkt_valid),
//        .fifo_full(fifo_full),
//        .rst_int_reg(rst_int_reg),
//        .detect_add(detect_add),
//        .ld_state(ld_state),
//        .laf_state(laf_state),
//        .full_state(full_state),
//        .lfd_state(lfd_state),
//        .data_in(data_in),
//        .parity_done(parity_done),
//        .low_pkt_valid(low_pkt_valid),
//        .err(error),
//        .d_out(d_out)
//    );

//    // Instantiate Synchronizer
//    router_synchronizer SYNCHRONIZER (
//        .clock(clock),
//        .resetn(resetn),
//        .detect_add(detect_add),
//        .write_enb_reg(write_enb_reg),
//        .read_enb_0(read_enb_0),
//        .read_enb_1(read_enb_1),
//        .read_enb_2(read_enb_2),
//        .data_in(data_in[1:0]),
//        .full_0(fifo_full),
//        .full_1(fifo_full),
//        .full_2(fifo_full),
//        .empty_0(fifo_empty_0),
//        .empty_1(fifo_empty_1),
//        .empty_2(fifo_empty_2),
//        .write_enb(write_enb),
//        .vld_out_0(vld_out_0),
//        .vld_out_1(vld_out_1),
//        .vld_out_2(vld_out_2),
//        .soft_reset_0(soft_reset_0),
//        .soft_reset_1(soft_reset_1),
//        .soft_reset_2(soft_reset_2),
//        .fifo_full(fifo_full)
//    );

//    // Instantiate FIFO for Port 0
//    router_fifo FIFO_0 (
//        .clock(clock),
//        .resetn(resetn),
//        .soft_reset(soft_reset_0),
//        .write_enb(write_enb[0]),
//        .read_enb(read_enb_0),
//        .lfd_state(lfd_state),
//        .data_in(d_out),
//        .empty(fifo_empty_0),
//        .full(fifo_full),
//        .data_out(data_out_0)
//    );

//    // Instantiate FIFO for Port 1
//    router_fifo FIFO_1 (
//        .clock(clock),
//        .resetn(resetn),
//        .soft_reset(soft_reset_1),
//        .write_enb(write_enb[1]),
//        .read_enb(read_enb_1),
//        .lfd_state(lfd_state),
//        .data_in(d_out),
//        .empty(fifo_empty_1),
//        .full(fifo_full),
//        .data_out(data_out_1)
//    );

//    // Instantiate FIFO for Port 2
//    router_fifo FIFO_2 (
//        .clock(clock),
//        .resetn(resetn),
//        .soft_reset(soft_reset_2),
//        .write_enb(write_enb[2]),
//        .read_enb(read_enb_2),
//        .lfd_state(lfd_state),
//        .data_in(d_out),
//        .empty(fifo_empty_2),
//        .full(fifo_full),
//        .data_out(data_out_2)
//    );

//endmodule


