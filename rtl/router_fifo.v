module router_fifo (clock,resetn,soft_reset,write_enb,read_enb,lfd_state,data_in,empty,full,data_out);
parameter width=9,depth=16;
input clock,resetn,write_enb,read_enb,soft_reset,lfd_state;
input [width-2:0] data_in;
reg [4:0] wr_ptr,rd_ptr;
output full,empty;
output reg [width-2:0] data_out;
reg [6:0] count;
integer i;

reg [width-1:0] mem [depth-1:0];
reg temp;//one extra cycle to delay lfd_state;
 
wire[4:0] next_wr_ptr;
assign next_wr_ptr = wr_ptr + 1'b1;
//logic for full and empty
assign full=((next_wr_ptr[4]!=rd_ptr[4])&& (next_wr_ptr[3:0]==rd_ptr[3:0]));
assign empty=(wr_ptr==rd_ptr);

always@(posedge clock)
begin
  if(!resetn)
  temp<=1'b0;
  else
  temp<=lfd_state;//delaying lfd_state by 1 clock to latch the header byte
end
//fifo write logic
always@(posedge clock)
begin
if(!resetn)
begin
for(i=0;i<16;i=i+1)
mem[i]<=0;

wr_ptr<=0;

end

else if(soft_reset)
begin
for(i=0;i<16;i=i+1)
mem[i]<=0;

wr_ptr<=0;

end

else if(write_enb&&!full)
begin
{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={temp,data_in};
wr_ptr<=wr_ptr+1'b1;
end
end

//fifo read logic
always@(posedge clock)
begin
if(!resetn)
begin
data_out<=0;
rd_ptr<=0;
end

else if(soft_reset)
begin
data_out<=8'bz;
rd_ptr<=0;
end

else if(count==0)
begin
data_out<=8'bz;
end

else if(read_enb&&!empty)
begin
data_out<=mem[rd_ptr[3:0]][7:0];
rd_ptr<=rd_ptr+1'b1;
end
else
data_out<=8'bz;
end

//counter logic
always@(posedge clock)
begin
if(!resetn)
count<=1'b0;

else if(soft_reset)
count<=1'b0;

else if(mem[rd_ptr[3:0]][8]==1'b1)
count<=mem[rd_ptr[3:0]][7:2]+1'b1;

else if(read_enb&&!empty)
count<=count-1'b1;

else
count<=count;
end

endmodule
