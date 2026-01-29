`ifndef AHB_MASTER_AGENT_SV
`define AHB_MASTER_AGENT_SV

class ahb_master_agent extends uvm_agent;

        ahb_agent_configuration cfg;

        ahb_master_driver driver;

        ahb_master_monitor monitor;

        ahb_master_sequencer sequencer;

        virtual ahb_if vif;

        `uvm_component_utils(ahb_master_agent)

        function new(string name = "ahb_master_agent", uvm_component parent = null );
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(ahb_agent_configuration)::get(this,"","cfg", cfg)) begin
                `uvm_fatal("GETCFG","cannot get config object from config DB")
                end
                if(!uvm_config_db#(virtual ahb_if)::get(this,"","vif", vif)) begin
                `uvm_fatal("GETVIF","cannot get vif handle from config DB")
                end

                monitor = ahb_master_monitor::type_id::create("monitor", this);

                //while agent under the mode "active", must using driver and sequencer  
                if(cfg.is_active) begin
                        driver = ahb_master_driver::type_id::create("driver", this);
                        sequencer = ahb_master_sequencer::type_id::create("sequencer", this);
                end
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                monitor.vif = vif;
                if(cfg.is_active) begin
                        driver.seq_item_port.connect(sequencer.seq_item_export);
                        driver.vif = vif;
                        sequencer.vif = vif;
                end
        endfunction

        task run_phase(uvm_phase phase);
                super.run_phase(phase);
        endtask

endclass

`endif 
