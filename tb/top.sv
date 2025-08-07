module top;
   	
	// import router_pkg
    	import router_pkg::*;
   
	// import uvm_pkg.sv
	import uvm_pkg::*;

   	// Generate clock signal
	bit clock;  
	always 
		#10 clock=!clock;

	router_if in0(clock);
    router_if in1(clock);
	router_if in2(clock);
    router_if in3(clock);

   
	router_top dut(.clock(clock),
	               .resetn(in0.reset_n),
				   .pkt_valid(in0.pkt_valid),
				   .data_in(in0.data_in),
				   .read_enb_0(in1.read_enb),
				   .read_enb_1(in2.read_enb),
				   .read_enb_2(in3.read_enb),
				   .data_out_0(in1.data_out),
				   .data_out_1(in2.data_out),
				   .data_out_2(in3.data_out),
				   .vld_out_0(in1.vld_out),
				   .vld_out_1(in2.vld_out),
				   .vld_out_2(in3.vld_out),
				   .error(in0.error),
				   .busy(in0.busy)
	);
	
        initial
		 begin
			
			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif
            
			uvm_config_db #(virtual router_if)::set(null, "*", "vif", in0);
			uvm_config_db #(virtual router_if)::set(null, "*", "vif_0",in1);
			uvm_config_db #(virtual router_if)::set(null, "*", "vif_1",in2);
			uvm_config_db #(virtual router_if)::set(null, "*", "vif_2",in3);

            
			run_test();
		end

		
    property packet_valid;
	   @(posedge clock) 
	     $rose(in0.pkt_valid) |=> in0.busy;
	endproperty

	property stable;
	   @(posedge clock)
	      in0.busy |=> $stable(in0.data_in);
	endproperty
    
	A1: assert property(packet_valid);
	A2: assert property(stable);

	property read0;
	   @(posedge clock)
	      in1.vld_out |=> ##[0:29] in1.read_enb;
	endproperty

	property read1;
	   @(posedge clock)
	      in2.vld_out |=> ##[0:29] in2.read_enb;
	endproperty

	property read2;
	   @(posedge clock)
	      in3.vld_out |=> ##[0:29] in3.read_enb;
	endproperty

    A3: assert property(read0);
	A4: assert property(read1);
	A5: assert property(read2);

	property valid0;
	   bit [1:0] addr;
	   @(posedge clock)
	      ($rose(in0.pkt_valid), addr = in0.data_in[1:0]) ##3 (addr == 0) |-> in1.vld_out;
	endproperty

	property valid1;
	   bit [1:0] addr;
	   @(posedge clock)
	      ($rose(in0.pkt_valid), addr = in0.data_in[1:0]) ##3 (addr == 1) |-> in2.vld_out;
	endproperty

	property valid2;
	   bit [1:0] addr;
	   @(posedge clock)
	      ($rose(in0.pkt_valid), addr = in0.data_in[1:0]) ##3 (addr == 2) |-> in3.vld_out;
	endproperty

	property valid;
	   @(posedge clock)
	      $rose(in0.pkt_valid) |-> ##3 (in1.vld_out || in2.vld_out || in3.vld_out);
	endproperty

    A6: assert property(valid0);
	A7: assert property(valid1);
	A8: assert property(valid2);
	A9: assert property(valid);

	property read_0;
	   @(posedge clock)
	      in1.vld_out ##1 $fell(in1.vld_out) |=> !in1.read_enb;
	endproperty

	property read_1;
	   @(posedge clock)
	      in2.vld_out ##1 $fell(in2.vld_out) |=> !in2.read_enb;
	endproperty

	property read_2;
	   @(posedge clock)
	      in3.vld_out ##1 $fell(in3.vld_out) |=> !in3.read_enb;
	endproperty
   
    A10: assert property(read_0);
	A11: assert property(read_1);
	A12: assert property(read_2);

endmodule

