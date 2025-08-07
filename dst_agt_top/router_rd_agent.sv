class router_rd_agent extends uvm_agent;
  `uvm_component_utils(router_rd_agent)

    router_rd_monitor monh;
	router_rd_sequencer seqrh;
	router_rd_driver drvh;
    router_rd_agt_config m_cfg;
  extern function new(string name = "router_rd_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass: router_rd_agent

function router_rd_agent::new(string name = "router_rd_agent", uvm_component parent = null);
 super.new(name, parent);
endfunction:new


function void router_rd_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		 if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
		   `uvm_fatal(get_full_name(),"failed to get cfg_object in rd_agent")
        
        monh=router_rd_monitor::type_id::create("monh",this);	
		 if(m_cfg.is_active == UVM_ACTIVE)
		  begin
		   drvh=router_rd_driver::type_id::create("drvh",this);
		   seqrh=router_rd_sequencer::type_id::create("seqrh",this);
		  end
		
endfunction

function void router_rd_agent::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
		if(m_cfg.is_active == UVM_ACTIVE)
		begin
		 drvh.seq_item_port.connect(seqrh.seq_item_export);
  		end
endfunction

