class router_env extends uvm_env;
  `uvm_component_utils(router_env)

    router_wr_agt_top src_agt_top[];
    router_rd_agt_top dst_agt_top[];

    router_scoreboard sb;
    router_virtual_sequencer v_seqrh;
    router_env_config env_cfg;

  extern function new(string name = "router_env", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass: router_env

function router_env::new(string name = "router_env", uvm_component parent);
 super.new(name, parent);
endfunction:new

function void router_env::build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
    `uvm_fatal("router_env", "failed to get the router_env_config")
  if(env_cfg.has_src_agent) 
   begin
      src_agt_top = new[env_cfg.no_of_src];
      foreach(src_agt_top[i])
       begin
        uvm_config_db #(router_wr_agt_config)::set(this,$sformatf("src_agt_top[%0d]*", i),"router_wr_agt_config",env_cfg.m_wr_agent_cfg[i]);
        src_agt_top[i] = router_wr_agt_top::type_id::create($sformatf("src_agt_top[%0d]",i),this);
       end
   end

  if(env_cfg.has_dst_agent) 
   begin
      dst_agt_top = new[env_cfg.no_of_dst];
      foreach(dst_agt_top[i])
       begin
        uvm_config_db #(router_rd_agt_config)::set(this,$sformatf("dst_agt_top[%0d]*", i),"router_rd_agt_config",env_cfg.m_rd_agent_cfg[i]);
        dst_agt_top[i] = router_rd_agt_top::type_id::create($sformatf("dst_agt_top[%0d]",i),this);
       end
   end

   if(env_cfg.has_scoreboard) 
   begin
   sb = router_scoreboard::type_id::create("sb",this); 
   end

   if(env_cfg.has_virtual_sequencer)
     begin
       v_seqrh = router_virtual_sequencer::type_id::create("v_seqrh", this);
     end
     
endfunction:build_phase

function void router_env::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(env_cfg.has_virtual_sequencer)
    begin
      foreach(v_seqrh.wr_seqrh[i])
        v_seqrh.wr_seqrh[i] = src_agt_top[i].agnth.seqrh;
      foreach(v_seqrh.rd_seqrh[i])
        v_seqrh.rd_seqrh[i] = dst_agt_top[i].agnth.seqrh;
    end
  
  if(env_cfg.has_scoreboard)
    begin
     foreach(src_agt_top[i])
       src_agt_top[i].agnth.monh.mon_port.connect(sb.wr_fifo[i].analysis_export);
      foreach(dst_agt_top[i])
        dst_agt_top[i].agnth.monh.mon_port.connect(sb.rd_fifo[i].analysis_export);
    end
endfunction:connect_phase
