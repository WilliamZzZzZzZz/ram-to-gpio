`ifndef AHBRAM_HTRANS_TEST_SV
`define AHBRAM_HTRANS_TEST_SV

class ahbram_htrans_test extends ahbram_base_test;
        `uvm_component_utils(ahbram_htrans_test)

        function new(string name = "ahbram_htrans_test", uvm_component parent);
                super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
                super.build_phase(phase);
        endfunction

        task run_phase(uvm_phase phase);
                ahbram_htrans_virtual_sequence seq = ahbram_htrans_virtual_sequence::type_id::create("this");
                super.run_phase(phase);

                phase.raise_objection(this);
                seq.start(env.virt_sqr);
                phase.drop_objection(this);
        endtask
endclass

`endif 
