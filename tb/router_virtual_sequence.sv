class router_vbase_sequence extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(router_vbase_sequence)

  router_virtual_sequencer v_seqrh;
  router_wr_sequencer wr_seqrh[];
  router_rd_sequencer rd_seqrh[];
  router_env_config env_cfg;

  router_small_wr_seqs small_wr_seqh;
  router_medium_wr_seqs medium_wr_seqh;
  router_big_wr_seqs big_wr_seqh;

  router_rd_seq1 rd_seqh1;
  router_rd_seq2 rd_seqh2;

  extern function new(string name = "router_vbase_sequence");
  extern task body();
endclass

function router_vbase_sequence::new(string name = "router_vbase_sequence");
  super.new(name);
endfunction

task router_vbase_sequence::body();
  if(!uvm_config_db #(router_env_config)::get(null, get_full_name(), "router_env_config", env_cfg))
     `uvm_fatal(get_full_name(), "Failed to get the env_cfg")
  wr_seqrh = new[env_cfg.no_of_src];
  rd_seqrh = new[env_cfg.no_of_dst];
  if(!$cast(v_seqrh, m_sequencer))
    `uvm_fatal(get_full_name(), "Failed to cast")
  if(env_cfg.has_src_agent)
    begin
      foreach(wr_seqrh[i])
      wr_seqrh[i] = v_seqrh.wr_seqrh[i];
    end
  if(env_cfg.has_dst_agent)
    begin
      foreach(rd_seqrh[i])
      rd_seqrh[i] = v_seqrh.rd_seqrh[i];
    end
endtask: body

class router_vsmall_sequence extends router_vbase_sequence;
  `uvm_object_utils(router_vsmall_sequence)
  bit [1:0] addr;
  extern function new(string name = "router_vsmall_sequence");
  extern task body();
endclass: router_vsmall_sequence

function router_vsmall_sequence::new(string name = "router_vsmall_sequence");
  super.new(name);
endfunction

task router_vsmall_sequence::body();
  super.body();
  if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(), "bit[1:0]", addr))
   `uvm_fatal(get_full_name(), "Failed to get the addr")
  
  if(env_cfg.has_src_agent)
    begin
      small_wr_seqh = router_small_wr_seqs::type_id::create("small_wr_seqh");
    end

  if(env_cfg.has_dst_agent)
    begin
      rd_seqh1 = router_rd_seq1::type_id::create("rd_seqh1");
      rd_seqh2 = router_rd_seq2::type_id::create("rd_seqh2");
    end

  fork 
      begin
      foreach(wr_seqrh[i])
        small_wr_seqh.start(wr_seqrh[i]);
      end
      begin
        if(addr == 2'b00) 
          begin
            rd_seqh1.start(rd_seqrh[0]);
          //rd_seqh2.start(rd_seqrh[0]);
          end
        if(addr == 2'b01) 
          begin
            rd_seqh1.start(rd_seqrh[1]);
          //rd_seqh2.start(rd_seqrh[1]);
          end
        if(addr == 2'b10) 
          begin
            rd_seqh1.start(rd_seqrh[2]);
          //rd_seqh2.start(rd_seqrh[2]);
          end
      end
  join
endtask: body

class router_vmedium_sequence extends router_vbase_sequence;
  `uvm_object_utils(router_vmedium_sequence)
  bit [1:0] addr;
  extern function new(string name = "router_vmedium_sequence");
  extern task body();
endclass: router_vmedium_sequence

function router_vmedium_sequence::new(string name = "router_vmedium_sequence");
  super.new(name);
endfunction

task router_vmedium_sequence::body();
  super.body();
  if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(), "bit[1:0]", addr))
   `uvm_fatal(get_full_name(), "Failed to get the addr")
  
  if(env_cfg.has_src_agent)
    begin
      medium_wr_seqh = router_medium_wr_seqs::type_id::create("medium_wr_seqh");
    end

  if(env_cfg.has_dst_agent)
    begin
      rd_seqh1 = router_rd_seq1::type_id::create("rd_seqh1");
      rd_seqh2 = router_rd_seq2::type_id::create("rd_seqh2");
    end

  fork 
      begin
      foreach(wr_seqrh[i])
        medium_wr_seqh.start(wr_seqrh[i]);
      end
      begin
        if(addr == 2'b00) 
          begin
            rd_seqh1.start(rd_seqrh[0]);
          //rd_seqh2.start(rd_seqrh[0]);
          end
        if(addr == 2'b01) 
          begin
            rd_seqh1.start(rd_seqrh[1]);
          //rd_seqh2.start(rd_seqrh[1]);
          end
        if(addr == 2'b10) 
          begin
            rd_seqh1.start(rd_seqrh[2]);
          //rd_seqh2.start(rd_seqrh[2]);
          end
      end
  join
endtask: body


class router_vbig_sequence extends router_vbase_sequence;
  `uvm_object_utils(router_vbig_sequence)
   bit [1:0] addr;
  extern function new(string name = "router_vbig_sequence");
  extern task body();
endclass: router_vbig_sequence

function router_vbig_sequence::new(string name = "router_vbig_sequence");
  super.new(name);
endfunction

task router_vbig_sequence::body();
  super.body();
  if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(), "bit[1:0]", addr))
   `uvm_fatal(get_full_name(), "Failed to get the addr")
  
  if(env_cfg.has_src_agent)
    begin
      big_wr_seqh = router_big_wr_seqs::type_id::create("big_wr_seqh");
    end

  if(env_cfg.has_dst_agent)
    begin
      rd_seqh1 = router_rd_seq1::type_id::create("rd_seqh1");
      rd_seqh2 = router_rd_seq2::type_id::create("rd_seqh2");
    end

  fork 
      begin
      foreach(wr_seqrh[i])
        big_wr_seqh.start(wr_seqrh[i]);
      end
      begin
        if(addr == 2'b00) 
          begin
            rd_seqh1.start(rd_seqrh[0]);
          //rd_seqh2.start(rd_seqrh[0]);
          end
        if(addr == 2'b01) 
          begin
            rd_seqh1.start(rd_seqrh[1]);
          //rd_seqh2.start(rd_seqrh[1]);
          end
        if(addr == 2'b10) 
          begin
            rd_seqh1.start(rd_seqrh[2]);
          //rd_seqh2.start(rd_seqrh[2]);
          end
      end
  join
endtask: body
