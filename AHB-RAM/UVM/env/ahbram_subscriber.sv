`ifndef AHBRAM_SUBSCRIBER_SV
`define AHBRAM_SUBSCRIBER_SV

class ahbram_subscriber extends uvm_component;

        uvm_analysis_imp #(ahb_transaction, ahbram_subscriber) ahb_trans_observed_imp;

        protected uvm_event_pool _ep;

        ahbram_configuration cfg;
        virtual ahbram_if vif;

        `uvm_component_utils(ahbram_subscriber);

        function new (string name = "ahbram_subscriber", uvm_component parent);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                ahb_trans_observed_imp = new("ahb_trans_observed_imp", this);
                if(!uvm_config_db#(ahbram_configuration)::get(this,"", "cfg", cfg)) begin
                        `uvm_fatal("GETCFG", "cannot get config object from config DB")
                end
                vif = cfg.vif;
                _ep = new("_ep");
        endfunction

        task run_phase(uvm_phase phase);
                super.run_phase(phase);
                do_events_trigger();
                do_listen_events();
        endtask

        virtual function void write(ahb_transaction tr);
        //because of the imp defination, this class must have a function name "write"
        //this function is created to deal with the input data from imp
        endfunction

        virtual task do_events_trigger();

        endtask

        virtual task do_listen_events();

        endtask;
endclass

`endif 
