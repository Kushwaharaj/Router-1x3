class router_wr_monitor extends uvm_monitor;
  `uvm_component_utils(router_wr_monitor)

  router_wr_agt_config m_cfg;
  virtual router_if.SRC_MON vif;
  uvm_analysis_port #(write_xtn) mon_port;

  extern function new(string name = "router_wr_monitor", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task collect_data();
endclass: router_wr_monitor

function router_wr_monitor::new(string name = "router_wr_monitor", uvm_component parent);
 super.new(name, parent);
endfunction:new

function void router_wr_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(router_wr_agt_config)::get(this," ", "router_wr_agt_config", m_cfg))
    `uvm_fatal("router_wr_monitor", "Failed to get the config class in src_mon");
  mon_port = new("mon_port",this);
endfunction: build_phase

function void router_wr_monitor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction: connect_phase

task router_wr_monitor::run_phase(uvm_phase phase);
  forever
    begin
      collect_data();
    end
endtask: run_phase

task router_wr_monitor::collect_data();
  write_xtn mon_data;
  mon_data = write_xtn::type_id::create("mon_data");

  while(!vif.src_mon_cb.pkt_valid)
     @(vif.src_mon_cb);
  mon_data.header = vif.src_mon_cb.data_in;
  @(vif.src_mon_cb)
  while(vif.src_mon_cb.busy)
     @(vif.src_mon_cb);

mon_data.payload = new[mon_data.header[7:2]];
 
 foreach(mon_data.payload[i])
  begin
   mon_data.payload[i] = vif.src_mon_cb.data_in;
   @(vif.src_mon_cb);
  end
 mon_data.parity = vif.src_mon_cb.data_in;
`uvm_info("ROUTER_WR_MONITOR",$sformatf("printing from monitor \n %s", mon_data.sprint()),UVM_LOW) 
 mon_port.write(mon_data);
endtask


