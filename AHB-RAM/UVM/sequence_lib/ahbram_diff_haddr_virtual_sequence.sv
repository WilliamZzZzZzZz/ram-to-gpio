`ifndef AHBRAM_DIFF_HADDR_VIRTUAL_SEQUENCE_SV
`define AHBRAM_DIFF_HADDR_VIRTUAL_SEQUENCE_SV

class ahbram_diff_haddr_virtual_sequence extends ahbram_base_virtual_sequence;

    `uvm_object_utils(ahbram_diff_haddr_virtual_sequence)

    function new(string name = "ahbram_diff_haddr_virtual_sequence");
        super.new(name);
    endfunction

    virtual task body();
        bit [31:0] addr, data;
        super.body();
        `uvm_info("haddr-body", "Entered...", UVM_LOW)
        for(int i=0; i<(cfg.addr_end >>4); i++) begin
            std::randomize(addr) with {addr[1:0] == 0; addr inside {[cfg.addr_start:cfg.addr_end]};};
            std::randomize(wr_val) with {wr_val == (i << 8) + i;};
            data = wr_val;
            `uvm_do_with(single_write, {addr == local::addr;
                                        data == local::data;})
            `uvm_do_with(single_read, {addr == local::addr;})
            rd_val = single_read.data;
            compare_data(wr_val, rd_val);
        end
        `uvm_info("haddr-body", "Exiting...", UVM_LOW)
    endtask

endclass

`endif 