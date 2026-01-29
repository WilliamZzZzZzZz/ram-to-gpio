`ifndef AHBRAM_SINGLE_READ_SEQUENCE_SV
`define AHBRAM_SINGLE_READ_SEQUENCE_SV

class ahbram_single_read_sequence extends ahbram_base_element_sequence;
        rand bit [31:0] addr;
        rand bit [31:0] data;
        rand burst_size_enum bsize;
        constraint single_read_cstr {
                soft addr[1:0] == 0;
                soft bsize == BURST_SIZE_32BIT;
        }

        `uvm_object_utils(ahbram_single_read_sequence)
        function new(string name = "ahbram_single_read_sequence");
                super.new(name);
        endfunction

        virtual task body();
                ahb_master_single_sequence ahb_single;
                `uvm_info("body", "entering...", UVM_LOW)
                `uvm_do_on_with(ahb_single, p_sequencer.ahb_mst_sqr,{
                                                                                                                        addr == local::addr;
                                                                                                                        xact == READ;
                                                                                                                        bsize == local::bsize;
                })
                data = ahb_single.data;
                `uvm_info("body", "exiting...", UVM_LOW)
        endtask
endclass

`endif 
