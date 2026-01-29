`ifndef AHB_MONITOR_SV
`define AHB_MONITOR_SV

class ahb_monitor extends uvm_monitor;
        `uvm_component_utils(ahb_monitor)

        ahb_agent_configuration cfg;
        virtual ahb_if vif;
        uvm_analysis_port #(ahb_transaction) item_observed_port;

        function new(string name = "ahb_monitor", uvm_component parent = null);
                super.new(name, parent);
                item_observed_port = new("item_observed_port", this);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                super.run_phase(phase);
                //using join_none to allow other processes to run in parallel
                fork
                        monitor_transaction();
                join_none
        endtask

        //forever monitor the transaction
        task monitor_transaction();
                ahb_transaction t;
                forever begin
                        collect_transfer(t);
                        item_observed_port.write(t);
                end
        endtask

        task collect_transfer(output ahb_transaction t);
                t = ahb_transaction::type_id::create("t");
                //NSEQ always means start of a new transfer, so wait for it
                @(vif.cb_mon iff vif.cb_mon.htrans == NSEQ);
                //start collecting transaction info
                t.trans_type = trans_type_enum'(vif.cb_mon.htrans);
                t.xact_type  = xact_type_enum'(vif.cb_mon.hwrite);
                t.burst_type = burst_type_enum'(vif.cb_mon.hburst);
                t.burst_size = burst_size_enum'(vif.cb_mon.hsize);
                t.addr = vif.cb_mon.haddr;
                forever begin
                        monitor_valid_data(t);
                        if(t.trans_type == IDLE)
                                break;
                end
                t.response_type = t.all_beat_response[t.current_data_beat_num];
        endtask

        task monitor_valid_data(ahb_transaction t);
                @(vif.cb_mon iff vif.cb_mon.hready);
                t.increase_data();
                t.current_data_beat_num = t.data.size() - 1;
                //WRITE operation: monitor collect trans from hwdata
                //READ operation: monitor collect trans from hrdata 
                t.data[t.current_data_beat_num] = t.xact_type == WRITE ?
                                                                                                                vif.cb_mon.hwdata : vif.cb_mon.hrdata;
                t.all_beat_response[t.current_data_beat_num] = response_type_enum'(vif.cb_mon.hresp);
                t.trans_type = trans_type_enum'(vif.cb_mon.htrans);
        endtask
endclass

`endif 
