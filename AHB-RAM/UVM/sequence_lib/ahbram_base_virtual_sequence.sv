`ifndef AHBRAM_BASE_VIRTUAL_SEQUENCE_SV
`define AHBRAM_BASE_VIRTUAL_SEQUENCE_SV

class ahbram_base_virtual_sequence extends uvm_sequence;

        ahbram_configuration cfg;
        virtual ahbram_if vif;
        bit[31:0] wr_val, rd_val;
        uvm_status_e status;

        ahbram_single_write_sequence single_write;
        ahbram_single_read_sequence  single_read;

        `uvm_object_utils(ahbram_base_virtual_sequence)
        `uvm_declare_p_sequencer(ahbram_virtual_sequencer)

        function new(string name = "ahbram_base_virtual_sequence");
                super.new(name);
        endfunction

        virtual task body();
                `uvm_info("body", "entered...", UVM_LOW)
                // get configuration from p_sequencer
                cfg = p_sequencer.cfg;
                vif = cfg.vif;
                wait_ready_for_stim();
                `uvm_info("body", "exiting...", UVM_LOW)
        endtask

        virtual function void compare_data(logic[31:0] val1, logic[31:0] val2);
                cfg.seq_check_count++;
                if(val1 === val2)
                        `uvm_info("CMP-SUCCESS", $sformatf("val1 'h%0x === val2 'h%0x", val1, val2), UVM_LOW)
                else begin
                        cfg.seq_check_error++;
                        `uvm_error("CMP-ERROR", $sformatf("val1 'h%0x === val2 'h%0x", val1, val2))
                end
        endfunction
  
        task wait_reset_signal_released();
                @(posedge vif.rstn);
        endtask

        task wait_cycles(int n);
                repeat(n) @(posedge vif.clk);
        endtask

        task wait_ready_for_stim();
                wait_reset_signal_released();
                wait_cycles(10);
        endtask


endclass

`endif 
