`ifndef AHBRAM_HTRANS_VIRTUAL_SEQUENCE_SV
`define AHBRAM_HTRANS_VIRTUAL_SEQUENCE_SV

class ahbram_htrans_virtual_sequence extends ahbram_base_virtual_sequence;

        `uvm_object_utils(ahbram_htrans_virtual_sequence)

        ahbram_htrans_write_sequence htrans_write;
        ahbram_htrans_read_sequence  htrans_read;

        int pass_count  = 0;
        int fail_count  = 0;
        int total_count = 0;

        function new(string name = "ahbram_htrans_virtual_sequence");
                super.new(name);
        endfunction

        virtual task body();
                super.body();
                test_idle_write_ignored();
        endtask

        virtual task test_idle_write_ignored();
                bit [31:0] addr;
                bit [31:0] initial_data;
                bit [31:0] idle_data;
                bit [31:0] read_val;

                `uvm_info(get_type_name(), "\n>>> Test 1: IDLE Write Ignored <<<", UVM_LOW)

                addr         = cfg.addr_start + 32'h700;
                initial_data = 32'h5555_5555;
                idle_data    = 32'hAAAA_AAAA;

                `uvm_info(get_type_name(), $sformatf("Step 1: NONSEQ Write in addr=0x%08X, data=0x%08X", addr, initial_data), UVM_MEDIUM)
                `uvm_do_with(htrans_write, {
                                                                        addr    == local::addr;
                                                                        data    == local::initial_data;
                                                                        htrans  == 2'b10;   //NONSEQ
                                                                        bsize   == BURST_SIZE_32BIT;
                })
                `uvm_info(get_type_name(), $sformatf("Step 2: IDLE Write in addr=0x%08X, data=0x%08X", addr, idle_data), UVM_MEDIUM)
                `uvm_do_with(htrans_write, {
                                                                        addr    == local::addr;
                                                                        data    == local::idle_data;
                                                                        htrans  == 2'b00;   //IDLE
                                                                        bsize   == BURST_SIZE_32BIT;
                })
                `uvm_info(get_type_name(), $sformatf("Step 3: htrans_read NONSEQ Read from addr=0x%08X", addr), UVM_MEDIUM)
                `uvm_do_with(htrans_read, {
                                                                        addr    == local::addr;
                                                                        htrans  == 2'b10;   //NONSEQ
                                                                        bsize   == BURST_SIZE_32BIT;
                })
                rd_val = htrans_read.data;
                `uvm_info(get_type_name(), $sformatf("Step 4: single_read from addr=0x%08X", addr), UVM_MEDIUM)
                `uvm_do_with(single_read, {
                                                                        addr    == local::addr;
                })
                read_val = single_read.data;
                `uvm_info(get_type_name(),"Step 5: htrans_read verify datas", UVM_MEDIUM)
                compare_data(rd_val, initial_data);
                `uvm_info(get_type_name(),"Step 6: single_read verify datas", UVM_MEDIUM)
                compare_data(read_val, initial_data);

        endtask



endclass

`endif 
