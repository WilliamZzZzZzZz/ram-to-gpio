`ifndef AHB_MASTER_SEQUENCER_SV
`define AHB_MASTER_SEQUENCER_SV

class ahb_master_sequencer extends ahb_sequencer;
    ahb_agent_configuration cfg;
    virtual ahb_if vif;

    `uvm_component_utils(ahb_master_sequencer)

    function new(string name = "ahb_master_sequencer", uvm_component parent = null);
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
    endtask

endclass

`endif 
