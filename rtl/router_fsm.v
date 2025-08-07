module router_fsm(clock,resetn,pkt_valid,low_pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,
fifo_full,empty_0,empty_1,empty_2,data_in,busy,detect_add,ld_state,lfd_state,laf_state,full_state,
write_enb_reg,rst_int_reg);
input clock,resetn,pkt_valid,low_pkt_valid,parity_done,soft_reset_0,
soft_reset_1,soft_reset_2,fifo_full,empty_0,empty_1,empty_2;
input [1:0] data_in;
output busy,detect_add,ld_state,lfd_state,laf_state,full_state,write_enb_reg,rst_int_reg;
 
reg [1:0] addr;//temporary variable declaration
parameter decode_address=3'b000,
          load_first_data=3'b001,
          wait_till_empty=3'b010,
          load_data=3'b011,
          load_parity=3'b100,
          check_parity_error=3'b101,
          fifo_full_state=3'b110,
          load_after_full=3'b111;
          
reg [2:0] present_state,next_state;
always@(posedge clock)
 begin
  if(!resetn)
      addr <= 2'b00;
  else if(detect_add)//decides the address of out channel
      addr <= data_in;
 end
 
 //logic for present state
 always@(posedge clock)
  begin
   if(!resetn)
     present_state<=decode_address;//hard reset
   else if(((soft_reset_0)&&(data_in==2'b00))||((soft_reset_1)&&(data_in==2'b01))||((soft_reset_2)&&(data_in==2'b10)))
   //if there is soft_reset and also using same channel so we do here and operation
     present_state<=decode_address;
   else
     present_state<=next_state;
  end

//logic for next state-Combinational
always@(*)
  begin
   case(present_state)
   decode_address:
   begin
     if((pkt_valid && (data_in==2'b00) && empty_0)||(pkt_valid && (data_in==2'b01) && empty_1)||(pkt_valid && (data_in==2'b10) && empty_2))
       next_state=load_first_data; // lfd_state
     else if(((pkt_valid && (data_in==2'b00) && !empty_0)||(pkt_valid && (data_in==2'b01) && !empty_1)||(pkt_valid && (data_in==2'b10) && !empty_2)))
       next_state=wait_till_empty;//wait till empty state
     else
       next_state=decode_address;
   end

   wait_till_empty:
   begin
    if((empty_0 && (addr==2'b00))||(empty_1 && (addr==2'b01))||(empty_2 && (addr==2'b10)))
      next_state=load_first_data;
    else
      next_state=wait_till_empty;
   end

   load_first_data:
      next_state=load_data;

   load_data:
   begin
    if(fifo_full)
      next_state=fifo_full_state;
    else if(!fifo_full&&!pkt_valid)
      next_state=load_parity;
    else
      next_state=load_data;
   end
  
  load_parity:
   begin
      next_state=check_parity_error;
   end
   fifo_full_state:
   begin
    if(!fifo_full)
      next_state=load_after_full;
    else
      next_state=fifo_full_state;
   end

   load_after_full:
   begin
    if(!parity_done && low_pkt_valid)
      next_state=load_parity;
    else if(!parity_done && !low_pkt_valid)
      next_state=load_data;
    else if(parity_done)
      next_state=decode_address;
    else
      next_state=load_after_full;
   end

   

   check_parity_error:
   begin
    if(!fifo_full)
      next_state=decode_address;
    else 
      next_state=fifo_full_state;
   end
   default:
      next_state=decode_address;
   endcase
  end

//output logic
assign busy = ((present_state==load_first_data))||((present_state==load_parity))||((present_state==fifo_full_state))||((present_state==load_after_full))||((present_state==wait_till_empty))||((present_state==check_parity_error))?1'b1:1'b0;
assign detect_add = (present_state==decode_address)?1'b1:1'b0;
assign lfd_state = (present_state==load_first_data)?1'b1:1'b0;
assign ld_state = (present_state==load_data)?1'b1:1'b0;
assign write_enb_reg = ((present_state==load_data)||(present_state==load_after_full)||(present_state==load_parity))?1'b1:1'b0;
assign full_state = (present_state==fifo_full_state)?1'b1:1'b0;
assign laf_state = (present_state==load_after_full)?1'b1:1'b0;
assign rst_int_reg = (present_state==check_parity_error)?1'b1:1'b0;
endmodule
