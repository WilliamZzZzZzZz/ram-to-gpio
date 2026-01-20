`ifndef AHBRAM_RESET_W2R_VIRTUAL_SEQUENCE_SV
`define AHBRAM_RESET_W2R_VIRTUAL_SEQUENCE_SV

class ahbram_reset_w2r_virtual_sequence extends ahbram_base_virtual_sequence;

    `uvm_object_utils(ahbram_reset_w2r_virtual_sequence)

    function new(string name = "ahbram_reset_w2r_virtual_sequence");
        super.new(name);
    endfunction

    virtual task body();
        bit [31:0] addr, data,data1;
        bit [31:0] addr_q[$];
        bit [31:0] data_q[$];

        super.body();
        `uvm_info("reset-body","Entered...", UVM_LOW)

        //before reset, write 10 random data with random address, do normal compare
        for(int i=0; i<10; i++) begin
            std::randomize(addr) with {addr[1:0] == 0; addr inside {['h1000:'h1FFF]};};
            std::randomize(wr_val) with {wr_val == (i << 4) + i;};
            data = wr_val;
            addr_q.push_back(addr);
            data_q.push_back(data);
            `uvm_do_with(single_write, {addr == local::addr;
                                        data == local::data;})
            `uvm_do_with(single_read, {addr  == local::addr;})
            rd_val = single_read.data;
            compare_data(wr_val, rd_val);
        end

        //trigger reset
        vif.assert_reset(10);

        //after reset, read back the previous addresses, compare with init logic
        do begin
            addr = addr_q.pop_front();
            data1 = data_q.pop_front();
            `uvm_do_with(single_read, {addr == local::addr;})
            rd_val = single_read.data;

            compare_data(data1, rd_val);
            if(cfg.init_logic === 1'b0)
                compare_data(32'h0, rd_val);
            else if(cfg.init_logic === 1'bx)
                compare_data(32'hx, rd_val);
            else
                `uvm_error("TYPEERR", "type is not recognized")
        end while(addr_q.size() > 0);
    endtask

endclass

`endif 