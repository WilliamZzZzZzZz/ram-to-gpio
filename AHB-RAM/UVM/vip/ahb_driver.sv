`ifndef AHB_DRIVER_SV
`define AHB_DRIVER_SV

class ahb_driver #(type REQ = ahb_transaction, type RSP = REQ) extends uvm_driver #(REQ, RSP);
    `uvm_component_utils(ahb_driver)
    ahb_agent_configuration cfg;
    virtual ahb_if vif;

    function new(string name = "ahb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            get_and_drive();
            reset_listener();
        join_none
    endtask

    virtual task get_and_drive();
        forever begin
            seq_item_port.get_next_item(req);       //waiting the transaction coming
            `uvm_info(get_type_name(), "sequencer got next item", UVM_HIGH)
            drive_transfer(req);
            //independent copy,line33~35
            void'($cast(rsp, req.clone()));
            rsp.set_sequence_id(req.get_sequence_id());
            rsp.set_transaction_id(req.get_transaction_id());
            seq_item_port.item_done(rsp);
            `uvm_info(get_type_name(), "sequencer item_done_triggered", UVM_HIGH)
        end
    endtask

    virtual task drive_transfer(REQ t);
        //finish in child class
    endtask

    virtual task reset_listener();
        //finish in child class
    endtask
    
endclass

`endif 