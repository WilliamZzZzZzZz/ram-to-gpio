`ifndef AHBRAM_VIRTUAL_SEQUENCER_SV
`define AHBRAM_VIRTUAL_SEQUENCER_SV

class ahbram_virtual_sequencer extends uvm_sequencer;

        ahbram_configuration cfg;
        ahb_master_sequencer ahb_mst_sqr;

        `uvm_component_utils(ahbram_virtual_sequencer)

        function new(string name = "ahbram_virtual_sequencer", uvm_component parent);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
                if(!uvm_config_db#(ahbram_configuration)::get(this,"", "cfg",cfg)) begin
                        `uvm_fatal("GETCFG", "cannot get config object from config DB")
                end
        endfunction

        
endclass

`endif 
