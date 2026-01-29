`ifndef AHB_BASE_SEQUENCE_SV
`define AHB_BASE_SEQUENCE_SV

class ahb_base_sequence extends uvm_sequence #(ahb_transaction);
        `uvm_object_utils(ahb_base_sequence)

        function new(string name = "ahb_base_sequence");
                super.new(name);
        endfunction
        
endclass

`endif 
