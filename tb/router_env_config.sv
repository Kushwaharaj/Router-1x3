class router_env_config extends uvm_object;
`uvm_object_utils(router_env_config)
  bit has_scoreboard = 1;
  bit has_functional_coverage = 0;
  bit has_dst_agent = 1;
  bit has_src_agent = 1;
  bit has_virtual_sequencer = 1;
  router_wr_agt_config m_wr_agent_cfg[];
  router_rd_agt_config m_rd_agent_cfg[];
  int no_of_src;
  int no_of_dst;

extern function new(string name = "router_env_config");

endclass
function router_env_config::new(string name = "router_env_config");
  super.new(name);
endfunction:new
