`ifndef AHBRAM_SMOKE_VIRTUAL_SEQUENCE_SV
`define AHBRAM_SMOKE_VIRTUAL_SEQUENCE_SV

class ahbram_smoke_virtual_sequence extends ahbram_base_virtual_sequence;
    `uvm_object_utils(ahbram_smoke_virtual_sequence)

    function new(string name = "ahbram_smoke_virtual_sequence");
        super.new(name);
    endfunction

    virtual task body();
        bit [31:0] addr, data;    
        super.body();

        `uvm_info("body", "entering...", UVM_LOW)
        for(int i=0; i<10; i++) begin
            `uvm_info("debug-count", $sformatf("loop count: %0d", i), UVM_LOW)
            std::randomize(addr) with {addr[1:0] == 0; addr inside {['h1000:'h1FFF]};};
            //data = 0x00 0x11 0x22 0x33 0x44 0x55...
            std::randomize(data) with {data == (i << 4) +i;};
            `uvm_do_with(single_write, {addr == local::addr; data == local::data;})
            `uvm_do_with(single_read, {addr == local::addr;})
            wr_val = data;
            rd_val = single_read.data;
            //to test the data write in whether is equal to the data read out
            compare_data(wr_val, rd_val);
        end
        `uvm_info("body", "exiting...", UVM_LOW)
    endtask
    
endclass

`endif 