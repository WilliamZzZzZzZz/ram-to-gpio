`ifndef AHBRAM_BASE_ELEMENT_SEQUENCE_SV
`define AHBRAM_BASE_ELEMENT_SEQUENCE_SV

class ahbram_base_element_sequence extends uvm_sequence;

    ahbram_configuration cfg;
    virtual ahbram_if vif;
    bit[31:0] wr_val, rd_val;
    uvm_status_e status;
    `uvm_object_utils(ahbram_base_element_sequence)
    `uvm_declare_p_sequencer(ahbram_virtual_sequencer)

    function new(string name = "ahbram_base_element_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("body", "entering...", UVM_LOW)
        //get configuration from p_sequencer
        cfg = p_sequencer.cfg;
        vif = cfg.vif;
        `uvm_info("body", "exiting...", UVM_LOW)        
    endtask

    virtual function void compare_data(logic[31:0] val1, logic[31:0] val2);
        cfg.seq_check_count++;
        if(val1 === val2)
            `uvm_info("CMP-SUCCESS", $sformatf("val1 'h%0x === val2 'h%0x", val1, val2), UVM_LOW)
        else
            cfg.seq_check_error++;
            `uvm_error("CMP-SUCCESS", $sformatf("val1 'h%0x !== val2 'h%0x", val1, val2))
    endfunction

endclass

`endif 