`ifndef AHB_CONFIGURATION_SV
`define AHB_CONFIGURATION_SV

class ahb_configuration extends uvm_object;
    `uvm_object_utils_begin(ahb_configuration)
    `uvm_object_utils_end

    function new(string name = "ahb_configuration");
        super.new(name);
    endfunction
endclass

`endif 