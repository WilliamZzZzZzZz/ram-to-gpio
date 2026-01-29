`ifndef AHBRAM_SINGLE_WRITE_SEQUENCE_SV
`define AHBRAM_SINGLE_WRITE_SEQUENCE_SV

class ahbram_single_write_sequence extends ahbram_base_element_sequence;

        rand bit [31:0] addr;
        rand bit [31:0] data;
        rand burst_size_enum bsize;
        constraint single_write_cstr{
                soft addr[1:0] == 0;
                soft bsize == BURST_SIZE_32BIT;
        }

        `uvm_object_utils(ahbram_single_write_sequence)
        function new(string name = "ahbram_single_write_sequence");
                super.new(name);
        endfunction

        virtual task body();
                ahb_master_single_sequence ahb_single;
                `uvm_info("body", "entering...", UVM_LOW)
                //use sequencer "ahb_mst_sqr" to transfer the sequence "ahb_single"
                `uvm_do_on_with(ahb_single, p_sequencer.ahb_mst_sqr,{
                                                                                                                        addr == local::addr;
                                                                                                                        data == local::data;
                                                                                                                        xact == WRITE;
                                                                                                                        bsize == local::bsize;
                })
                `uvm_info("body", "exiting...", UVM_LOW)
        endtask

endclass

`endif 
