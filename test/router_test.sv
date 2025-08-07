class router_base_test extends uvm_test;
  `uvm_component_utils(router_base_test)

   router_env router_envh;
   router_env_config env_cfg;

   router_wr_agt_config m_wr_agent_cfg[];
   router_rd_agt_config m_rd_agent_cfg[];

   int has_src_agent = 1;
   int has_dst_agent = 1;
   int no_of_src = 1;
   int no_of_dst = 3;

  extern function new(string name = "router_base_test", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void end_of_elaboration_phase(uvm_phase phase);
  extern task config_router();
endclass: router_base_test

function router_base_test::new(string name = "router_base_test", uvm_component parent);
 super.new(name, parent);
endfunction:new

task router_base_test::config_router();
  if(has_src_agent)
    m_wr_agent_cfg = new[no_of_src];
    foreach(m_wr_agent_cfg[i]) begin
      m_wr_agent_cfg[i] = router_wr_agt_config::type_id::create($sformatf("m_wr_agent_cfg[%0d]",i));
      if(!uvm_config_db #(virtual router_if)::get(this,"", "vif", m_wr_agent_cfg[i].vif))
        `uvm_fatal("VIF CONFIG", "Failed to get the vif");
      m_wr_agent_cfg[i].is_active = UVM_ACTIVE;
      env_cfg.m_wr_agent_cfg[i] = m_wr_agent_cfg[i];
    end

  if(has_dst_agent)
    m_rd_agent_cfg = new[no_of_dst];
    foreach(m_rd_agent_cfg[i]) begin
      m_rd_agent_cfg[i] = router_rd_agt_config::type_id::create($sformatf("m_rd_agent_cfg[%0d]",i));
      if(!uvm_config_db #(virtual router_if)::get(this,"", $sformatf("vif_%0d", i), m_rd_agent_cfg[i].vif))
        `uvm_fatal("VIF CONFIG", "Failed to get the vif");
      m_rd_agent_cfg[i].is_active = UVM_ACTIVE;
      env_cfg.m_rd_agent_cfg[i] = m_rd_agent_cfg[i];
    end
  
  env_cfg.has_src_agent = has_src_agent;
  env_cfg.has_dst_agent = has_dst_agent;
  env_cfg.no_of_src = no_of_src;
  env_cfg.no_of_dst = no_of_dst;
endtask: config_router

function void router_base_test::build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_cfg = router_env_config::type_id::create("env_cfg");

  if(has_src_agent)
    begin
      env_cfg.m_wr_agent_cfg = new[no_of_src];
    end
  
  if(has_dst_agent)
    begin
      env_cfg.m_rd_agent_cfg = new[no_of_dst];
    end
  config_router();

  uvm_config_db #(router_env_config)::set(this,"*","router_env_config",env_cfg);
  router_envh=router_env::type_id::create("router_envh", this);
endfunction

function void router_base_test::end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction: end_of_elaboration_phase

class router_small_test extends router_base_test;
  `uvm_component_utils(router_small_test)
  router_vsmall_sequence small_wr_seqh;
   bit [1:0] addr;
   extern function new(string name="router_small_test",uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);

endclass

function router_small_test::new(string name="router_small_test",uvm_component parent);
    super.new(name,parent);
endfunction

function void router_small_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task  router_small_test::run_phase(uvm_phase phase);
 begin
   phase.raise_objection(this);
   repeat(3) 
    begin
     addr = {$random}%3;
     uvm_config_db #(bit [1:0])::set(this,"*", "bit[1:0]", addr);
     small_wr_seqh=router_vsmall_sequence::type_id::create("small_wr_seqh");
     small_wr_seqh.start(router_envh.v_seqrh);
    end
   phase.drop_objection(this);
 end
endtask

class router_medium_test extends router_base_test;
  `uvm_component_utils(router_medium_test)
   router_vmedium_sequence medium_wr_seqh;
   bit [1:0] addr;
   extern function new(string name="router_medium_test",uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);
endclass

function router_medium_test::new(string name="router_medium_test",uvm_component parent);
    super.new(name,parent);
endfunction

function void router_medium_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task  router_medium_test::run_phase(uvm_phase phase);
 begin
   phase.raise_objection(this);
   repeat(2) 
    begin
     addr = {$random}%3;
     uvm_config_db #(bit [1:0])::set(this,"*", "bit[1:0]", addr);
     medium_wr_seqh=router_vmedium_sequence::type_id::create("medium_wr_seqh");
     medium_wr_seqh.start(router_envh.v_seqrh);
    
    end
   phase.drop_objection(this);
 end
endtask

class router_big_test extends router_base_test;
  `uvm_component_utils(router_big_test)
  router_vbig_sequence big_wr_seqh;
  bit [1:0] addr;
   extern function new(string name="router_big_test",uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);

endclass

function router_big_test::new(string name="router_big_test",uvm_component parent);
    super.new(name,parent);
endfunction

function void router_big_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

task router_big_test::run_phase(uvm_phase phase);
 begin
   
   phase.raise_objection(this);
   repeat(2) 
    begin
     addr = {$random}%3;
     uvm_config_db #(bit [1:0])::set(this,"*", "bit[1:0]", addr);
     big_wr_seqh=router_vbig_sequence::type_id::create("big_wr_seqh");
     big_wr_seqh.start(router_envh.v_seqrh);
    end
   #100;
   phase.drop_objection(this);
 end
endtask


