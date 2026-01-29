`ifndef AHBRAM_HTRANS_READ_SEQUENCE_SV
`define AHBRAM_HTRANS_READ_SEQUENCE_SV

class ahbram_htrans_read_sequence extends ahbram_base_element_sequence;

        `uvm_object_utils(ahbram_htrans_read_sequence)

        rand bit [31:0] addr;
        rand bit [31:0] data;
        rand bit [1:0]  htrans;
        rand burst_size_enum bsize;

        constraint htrans_read_cstr {
                soft addr[1:0]  == 0;
                soft htrans[1:0] == 2'b10;
                soft bsize == BURST_SIZE_32BIT;
        }

        function new(string name  = "ahbram_single_read_sequence");
                super.new(name);
        endfunction

        virtual task body();
                ahb_master_single_sequence ahb_single;
                `uvm_info("htrans-body", "ENTER_HTRANS_BODY...", UVM_LOW)
                `uvm_do_on_with(ahb_single, p_sequencer.ahb_mst_sqr,{
                                                                                                                addr == local::addr;
                                                                                                                xact == READ;
                                                                                                                bsize == local::bsize;
                                                                                                                htrans == local::htrans;
                })
                data = ahb_single.data;
                `uvm_info("htrans-body", "EXIT_HTRANS_BODY...", UVM_LOW)
        endtask
endclass

`endif 
