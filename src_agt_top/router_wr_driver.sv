class router_wr_driver extends uvm_driver #(write_xtn);
  `uvm_component_utils(router_wr_driver)

  router_wr_agt_config m_cfg;
  virtual router_if.SRC_DRV vif;

  extern function new(string name = "router_wr_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(write_xtn xtn);

endclass: router_wr_driver

function router_wr_driver::new(string name = "router_wr_driver", uvm_component parent);
 super.new(name, parent);
endfunction:new

function void router_wr_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(router_wr_agt_config)::get(this,"", "router_wr_agt_config", m_cfg))
    `uvm_fatal("router_wr_driver", "Failed to get the config class in src_drv")
endfunction: build_phase

function void router_wr_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction: connect_phase

task router_wr_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  @(vif.src_drv_cb)
   vif.src_drv_cb.reset_n <= 1'b0;
  @(vif.src_drv_cb)
   vif.src_drv_cb.reset_n <= 1'b1;

  forever begin
    seq_item_port.get_next_item(req);
    send_to_dut(req);
    seq_item_port.item_done();
  end
endtask: run_phase

task router_wr_driver::send_to_dut(write_xtn xtn);
  `uvm_info("ROUTER_WR_DRIVER",$sformatf("printing from driver \n %s", xtn.sprint()),UVM_LOW) 
  
  vif.src_drv_cb.pkt_valid <= 1'b1;
  vif.src_drv_cb.data_in <= xtn.header;
  @(vif.src_drv_cb);
  while(vif.src_drv_cb.busy)
    @(vif.src_drv_cb);

  @(vif.src_drv_cb);
  foreach(xtn.payload[i]) 
  begin
    vif.src_drv_cb.data_in <= xtn.payload[i];
     @(vif.src_drv_cb);
  end
  vif.src_drv_cb.pkt_valid<=0;
  vif.src_drv_cb.data_in <= xtn.parity;
  
endtask: send_to_dut
