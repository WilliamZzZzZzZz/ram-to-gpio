`ifndef RKV_GPIO_MASKED_VIRT_SEQ_SV
`define RKV_GPIO_MASKED_VIRT_SEQ_SV

class rkv_gpio_masked_virt_seq extends rkv_gpio_base_virtual_sequence;
    `uvm_object_utils(rkv_gpio_masked_virt_seq)

    function new(string name = "rkv_gpio_masked_virt_seq");
        super.new(name);
    endfunction

    virtual task body();
        bit [31:0] addr, data;
        bit [3:0] pin_id;
        super.body();
        `uvm_info(get_type_name(), "Entered...", UVM_LOW)
        repeat(20) begin
            
        end
        `uvm_info(get_type_name(), "Exiting...", UVM_LOW)
    endtask

    task lower_byte_masked_access();
        bit [15:0]  initial_val, write_val;
        bit [7:0]   mask_byte;


        uvm_status_e status;

        initial_val = 16'hFFFF;
        write_val   = 16'h0000;
        mask_byte   = $urandom();
        rgm.DATA.write(status, initial_val);
        
    endtask

endclass

`endif 