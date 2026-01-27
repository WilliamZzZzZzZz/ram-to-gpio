`ifndef RKV_GPIO_MASKED_VIRT_SEQ_SV
`define RKV_GPIO_MASKED_VIRT_SEQ_SV

class rkv_gpio_masked_virt_seq extends rkv_gpio_base_virtual_sequence;
    `uvm_object_utils(rkv_gpio_masked_virt_seq)

    function new(string name = "rkv_gpio_masked_virt_seq");
        super.new(name);
    endfunction

    virtual task body();
        bit [31:0] addr, data;
        rand bit [15:0] initial_val, write_val;
        rand bit [7:0]  mask_byte;
        super.body();
        `uvm_info(get_type_name(), "Entered...", UVM_LOW)
        repeat(20) begin
            masked_access_protection();
        end
          
        `uvm_info(get_type_name(), "Exiting...", UVM_LOW)
    endtask

    task masked_access_protection();
        bit type_sel = 0;   //0->lower, 1->upper
        bit [15:0]  final_val, expected_val;
        bit [31:0]  target_addr;
        uvm_status_e status;

        //set expected value
        expected_val[7:0]   = (write_val[7:0] & mask_byte) | (initial_val[7:0] & ~mask_byte);
        expected_val[15:8]  = initial_val[15:8];
        //calculate address
        if(type_sel == 0) begin //lower-8bits
            target_addr = 32'h400 + (mask_byte << 2);   //0x400 + mask_byte*4
        end
        else begin              //uppper-8bits
            target_addr = 32'h800 + (mask_byte << 2);   //0x800 + mask_byte*4
        end
        //process data
        `uvm_do_with(single_write, {addr == RKV_ROUTER_REG_ADDR_DATA;
                                    data == initial_val;})
        `uvm_do_with(single_write, {addr == target_addr;
                                    data == write_val;})
        `uvm_do_with(single_read, {addr == RKV_ROUTER_REG_ADDR_DATAOUT;})
        final_val = single_read.data;
        
        //do compare
        if(final_val == expected_val) begin
            `uvm_info(get_type_name(), "every bits' masked-access PASSED!")
        end
        else begin
            `uvm_error(get_type_name(), $sformatf("FAILED: expected_val: 0x%04X, actual_val: 0x%04X", expected_val, final_val))
            for(int i = 0; i < 16; i++) begin
               if(final_val[i] != expected_val[i]) begin
                    `uvm_info(get_type_name(), $sformatf("bit[%0d] mismatch, expected %0b, actual %0b", i, expected_val[i], final_val[i]))
               end 
            end
        end
        `uvm_info(get_type_name(), $sformatf("Initial Value:    %b", initial_val), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Write Value:      %b", write_val), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Mask Byte:        %b", mask_byte), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Expected Value:   %b", expected_val), UVM_LOW)
        `uvm_info(get_type_name(), $sformatf("Final Value:      %b", final_val), UVM_LOW)

    endtask

endclass

`endif 