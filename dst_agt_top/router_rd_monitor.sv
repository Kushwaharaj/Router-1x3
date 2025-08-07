class router_rd_monitor extends uvm_monitor;
  `uvm_component_utils(router_rd_monitor)

   router_rd_agt_config m_cfg;
   virtual router_if.DST_MON vif;
   uvm_analysis_port #(read_xtn) mon_port;
  extern function new(string name = "router_rd_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();

endclass: router_rd_monitor

function router_rd_monitor::new(string name = "router_rd_monitor", uvm_component parent);
 super.new(name, parent);
endfunction:new

function void router_rd_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(router_rd_agt_config)::get(this,"", "router_rd_agt_config", m_cfg))
    `uvm_fatal("router_rd_monitor", "Failed to get the config class in dst_mon")
  mon_port = new("mon_port",this);
endfunction: build_phase

function void router_rd_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction: connect_phase

task router_rd_monitor::run_phase(uvm_phase phase);
 super.run_phase(phase);
 forever
   collect_data();
endtask

task router_rd_monitor::collect_data();
  read_xtn mon_data;
  mon_data = read_xtn::type_id::create("mon_data");
  
  wait(vif.dst_mon_cb.read_enb)
  @(vif.dst_mon_cb)
//  @(vif.dst_mon_cb)
   
  mon_data.header = vif.dst_mon_cb.data_out;
  mon_data.payload = new[mon_data.header[7:2]];
  @(vif.dst_mon_cb);

  foreach(mon_data.payload[i])
   begin
    mon_data.payload[i] = vif.dst_mon_cb.data_out;
    @(vif.dst_mon_cb);
   end
//  @(vif.dst_mon_cb)
    mon_data.parity = vif.dst_mon_cb.data_out;
    // repeat(2)
    //   @(vif.dst_mon_cb)
    `uvm_info("ROUTER_RD_MONITOR",$sformatf("printing from monitor \n %s", mon_data.sprint()),UVM_LOW) 
    mon_port.write(mon_data);
   
endtask
