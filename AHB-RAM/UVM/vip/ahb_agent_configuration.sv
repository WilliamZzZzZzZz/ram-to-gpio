`ifndef AHB_AGENT_CONFIGURATION_SV
`define AHB_AGENT_CONFIGURATION_SV

class ahb_agent_configuration extends uvm_object;

        bit is_active = 1;

        `uvm_object_utils_begin(ahb_agent_configuration)
        `uvm_object_utils_end

        function new(string name = "ahb_agent_configuration");
                super.new(name);
        endfunction

endclass

`endif 
