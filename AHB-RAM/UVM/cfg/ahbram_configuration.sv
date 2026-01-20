`ifndef AHBRAM_CONFIGURATION_SV
`define AHBRAM_CONFIGURATION_SV

class ahbram_configuration extends uvm_object;

    int seq_check_count;    
    int seq_check_error;

    int scb_check_count;
    int scb_check_error;

    bit enable_cov = 1;
    bit enable_scb = 1;

    //addr_start and addr_end are set in "ahbram_base_test"
    bit [31:0] addr_start;
    bit [31:0] addr_end;
    int data_width;
    //memory initial value after reset,0 or x
    //we don't know the DUT(RAM) value after reset, so we should separately consider the 0 case and X case
    logic init_logic = 1'bx;

    ahb_agent_configuration ahb_cfg;
    virtual ahbram_if vif;
    ahbram_rgm rgm;

    `uvm_object_utils(ahbram_configuration)

    function new(string name = "ahbram_configuration");
        super.new(name);
        ahb_cfg = ahb_agent_configuration::type_id::create("ahb_cfg");
    endfunction 
endclass

`endif 