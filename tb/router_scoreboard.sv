class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)
  uvm_tlm_analysis_fifo #(write_xtn) wr_fifo[];
  uvm_tlm_analysis_fifo #(read_xtn) rd_fifo[];
  router_env_config env_cfg;
  write_xtn wr_data;
  write_xtn wr_cov_data;
  read_xtn rd_data;
  read_xtn rd_cov_data;
  int data_verified_count;

  covergroup wr_cov;
    option.per_instance = 1;
    CHANNEL: coverpoint wr_cov_data.header[1:0]{
                                                bins LOW = {2'b00};
                                                bins MED = {2'b01};
                                                bins HIGH = {2'b10};
                                               }
    PAYLOAD_SIZE: coverpoint wr_cov_data.header[7:2]{
                                                bins LOW_PACKET = {[1:15]};
                                                bins MED_PACKET = {[16:30]};
                                                bins HIGH_PACKET = {[31:63]};
                                               }
   CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL, PAYLOAD_SIZE;
                        
  endgroup: wr_cov

  covergroup rd_cov;
    option.per_instance = 1;
    CHANNEL: coverpoint rd_cov_data.header[1:0]{
                                                bins LOW = {2'b00};
                                                bins MED = {2'b01};
                                                bins HIGH = {2'b10};
                                               }
    PAYLOAD_SIZE: coverpoint rd_cov_data.header[7:2]{
                                                bins LOW_PACKET = {[1:15]};
                                                bins MED_PACKET = {[16:30]};
                                                bins HIGH_PACKET = {[31:63]};
                                               }
   CHANNEL_X_PAYLOAD_SIZE: cross CHANNEL, PAYLOAD_SIZE;
                        
  endgroup: rd_cov

  extern function new(string name = "router_scoreboard", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
  extern function void check_data(read_xtn xtn);

endclass: router_scoreboard

function router_scoreboard::new(string name = "router_scoreboard", uvm_component parent);
 super.new(name, parent);
 wr_cov = new();
 rd_cov = new();
endfunction:new

function void router_scoreboard::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config", env_cfg))
    `uvm_fatal("router_scoreboard", "Failed to get the env_config")
  wr_fifo = new[env_cfg.no_of_src];
  rd_fifo = new[env_cfg.no_of_dst];

  wr_data = write_xtn::type_id::create("wr_data");
  rd_data = read_xtn::type_id::create("rd_data");

  if(env_cfg.has_src_agent) begin
   foreach(wr_fifo[i])
    begin
      wr_fifo[i] = new($sformatf("wr_fifo[%0d]",i), this);
    end
  end

  if(env_cfg.has_dst_agent) begin
   foreach(rd_fifo[i])
    begin
      rd_fifo[i] = new($sformatf("rd_fifo[%0d]",i), this);
    end
  end
endfunction: build_phase

task router_scoreboard::run_phase(uvm_phase phase);
  super.run_phase(phase);
  fork
    begin
      forever
        begin
            wr_fifo[0].get(wr_data);
            `uvm_info("WR SB[0]", "wr_data", UVM_LOW);
            wr_data.print();
            wr_cov_data = wr_data;
            wr_cov.sample();
        end
    end
    begin
      forever
        begin
          fork:A
            begin
              rd_fifo[0].get(rd_data);
              `uvm_info("RD SB[0]", "rd_data", UVM_LOW);
              rd_data.print();
              check_data(rd_data);
              rd_cov_data = rd_data;
              rd_cov.sample();
            end
            begin
              rd_fifo[1].get(rd_data);
              `uvm_info("RD SB[1]", "rd_data", UVM_LOW);
              rd_data.print();
              check_data(rd_data);
              rd_cov_data = rd_data;
              rd_cov.sample();
            end
            begin
              rd_fifo[2].get(rd_data);
              `uvm_info("RD SB[2]", "rd_data", UVM_LOW);
              rd_data.print();
              check_data(rd_data);
              rd_cov_data = rd_data;
              rd_cov.sample();
            end
          join_any
          disable A;
        end
    end
  join
  
endtask: run_phase

function void router_scoreboard::check_data(read_xtn xtn);
  if(wr_data.header == xtn.header)
    `uvm_info("SB_HEADER_INFO", "Matched Successfully", UVM_LOW)
  else
    `uvm_info("SB_HEADER_INFO", "Mismatched", UVM_LOW)
  if(wr_data.payload == xtn.payload)
    `uvm_info("SB_PAYLOAD_INFO", "Matched Successfully", UVM_LOW)
  else
    `uvm_info("SB_PAYLOAD_INFO", "Mismatched", UVM_LOW)
  if(wr_data.parity == xtn.parity)
    `uvm_info("SB_PARITY_INFO", "Matched Successfully", UVM_LOW)
  else
    `uvm_info("SB_PARITY_INFO", "Mismatched", UVM_LOW)
  data_verified_count++;
endfunction: check_data

function void router_scoreboard::report_phase(uvm_phase phase);
  super.report_phase(phase);
  `uvm_info("SB", $sformatf("No. of data verified:%0d", data_verified_count), UVM_LOW)
endfunction: report_phase