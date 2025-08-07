class router_rd_driver extends uvm_driver #(read_xtn);
  `uvm_component_utils(router_rd_driver)

  router_rd_agt_config m_cfg;
  virtual router_if.DST_DRV vif;

  extern function new(string name = "router_rd_driver", uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern task send_to_dut(read_xtn xtn);

endclass: router_rd_driver

function router_rd_driver::new(string name = "router_rd_driver", uvm_component parent);
 super.new(name, parent);
endfunction:new

function void router_rd_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(router_rd_agt_config)::get(this,"", "router_rd_agt_config", m_cfg))
    `uvm_fatal("router_rd_driver", "Failed to get the config class in dst_drv")
endfunction: build_phase

function void router_rd_driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = m_cfg.vif;
endfunction: connect_phase

task router_rd_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever 
    begin
      seq_item_port.get_next_item(req);
      send_to_dut(req);
      seq_item_port.item_done();
    end
endtask: run_phase

task router_rd_driver::send_to_dut(read_xtn xtn);
 `uvm_info("ROUTER_RD_DRIVER","printing from driver",UVM_LOW) 
  wait(vif.dst_drv_cb.vld_out);
  repeat(xtn.no_of_cycles)
    @(vif.dst_drv_cb);
  
  vif.dst_drv_cb.read_enb <= 1;
  wait(!vif.dst_drv_cb.vld_out);
  vif.dst_drv_cb.read_enb <= 0;
// repeat(2)
//     @(vif.dst_drv_cb);

endtask: send_to_dut

