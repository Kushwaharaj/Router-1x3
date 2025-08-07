module router_register(clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,
full_state,lfd_state,data_in,parity_done,low_pkt_valid,error,d_out);
input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0] data_in;
output reg parity_done,error;
output low_pkt_valid;
output reg [7:0] d_out;

reg [7:0] header_byte,fifo_full_state,internal_parity,packet_parity;//4 internal register declaration
wire parity_check;

always@(posedge clock)//Output logic
  begin
   if(!resetn)
     begin
      d_out<=8'b0;
     end
   else if(lfd_state)
      d_out<=header_byte;//header_byte output

   //payload byte output
   else if(pkt_valid && ld_state && !fifo_full)
      d_out<=data_in;
   else if(ld_state && fifo_full)
     begin
      fifo_full_state<=data_in;
       if(laf_state)
        d_out<=fifo_full_state;
       else
        d_out<=d_out;
     end

   //parity_byte output
   else if(~pkt_valid)
      d_out<=data_in;
   else
      d_out<=d_out;
  end

//storing header byte
always@(posedge clock)
  begin
   if(!resetn)
      header_byte<=8'b0;
   else if(detect_add && pkt_valid && data_in[1:0]!=2'b11)
      header_byte<=data_in;
   else
      header_byte<=header_byte;
  end

//parity done logic
always@(posedge clock)
  begin
   if((ld_state && ~fifo_full && ~pkt_valid)||(laf_state && ~pkt_valid))
      parity_done<=1'b1;
   else if(detect_add)
      parity_done<=1'b0;
   else
      parity_done<=parity_done;
  end

//parity calculation
//1) internal parity 
always@(posedge clock)
  begin
   if(!resetn)
      internal_parity<=8'b0;
   else if(detect_add)
      internal_parity<=internal_parity^header_byte;
   // else if(pkt_valid && !full_state)
   else if(pkt_valid && ld_state)
      internal_parity<=internal_parity^data_in;
   else
      internal_parity<=internal_parity;
  end
//2)packet parity
always@(posedge clock)
  begin
   if(!resetn)
      packet_parity<=8'b00000000;
   else if(~pkt_valid)
      packet_parity<=data_in;
   else 
      packet_parity<=packet_parity;
  end

//error logic
always@(posedge clock)
  begin
   if(!resetn)
      error<=1'b0;
   else if(!pkt_valid && rst_int_reg)
     begin
      if(parity_check)
       begin
        error<=1'b0;
        //packet_parity<=8'b0;
        //internal_parity<=8'b0;//it will create multilple drivers conflict while running in dc_shell
       end
      else
       begin
        error<=1'b1;
        //packet_parity<=8'b0;
        //internal_parity<=8'b0;
       end
     end
   else
      error<=error;
  end
// assign low_pkt_valid=(ld_state&&~pkt_valid);
assign low_pkt_valid=(ld_state&&~pkt_valid)||(laf_state && !pkt_valid);

assign parity_check=(packet_parity==internal_parity)?1'b1:1'b0;

endmodule
