`ifndef AHBRAM_HTRANS_WRITE_SEQUENCE_SV
`define AHBRAM_HTRANS_WRITE_SEQUENCE_SV

class ahbram_htrans_write_sequence extends ahbram_base_element_sequence;

    `uvm_object_utils(ahbram_htrans_write_sequence)

    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit [1:0]  htrans;

    rand burst_size_enum bsize;

    constraint htrans_write_cstr {
        soft addr[1:0] == 0;
        soft htrans == 2'b10;       //default is NONSEQ        
        soft bsize == BURST_SIZE_32BIT;
    }

    function new(string name = "ahbram_htrans_write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        ahb_master_single_sequence ahb_single;
        `uvm_info("htrans-body", "ENTER_HTRANS_BODY...", UVM_LOW)
        `uvm_do_on_with(ahb_single, p_sequencer.ahb_mst_sqr,{
                                                            addr == local::addr;
                                                            data == local::data;
                                                            xact == WRITE;
                                                            bsize == local::bsize;
                                                            htrans == local::htrans;
        })

        `uvm_info("htrans-body", "EXIT_HTRANS_BODY...", UVM_LOW)
    endtask
endclass

`endif 