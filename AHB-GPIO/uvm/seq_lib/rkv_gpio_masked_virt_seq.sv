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
            masked_access_protection();
        end
        `uvm_info(get_type_name(), "Exiting...", UVM_LOW)
    endtask

    task masked_access_protection();
        bit type_sel = 0;   //0->lower, 1->upper
        bit [15:0]  initial_val, write_val, final_val;
        bit [7:0]   mask_byte;
        bit [31:0]  target_addr;

        uvm_status_e status;
        uvm_reg_map map;

        map = rgm.get_default_map();
        initial_val = 16'hFFFF;
        write_val   = 16'h0000;
        mask_byte   = 8'h01;
        // mask_byte   = $urandom();
        // type_sel    = $urandom();
        rgm.DATA.write(status, initial_val);
        
        if(type_sel == 0) begin //lower-8bits
            target_addr = 32'h400 + (mask_byte << 2);   //0x400 + mask_byte*4
        end
        else begin              //uppper-8bits
            target_addr = 32'h800 + (mask_byte << 2);   //0x800 + mask_byte*4
        end
        map.write(status, target_addr, write_val);
        rgm.DATA.read(status, final_val);
        
        //compare 0-bit
        if(final_val[0] == 0) begin
            `uvm_info(get_type_name(), "0-bit changed successfully!", UVM_LOW)
        end
        else begin
            `uvm_info(get_type_name(), "0-bit changed failed", UVM_LOW)
        end
        //compare 1~7 bits
        if(final_val[1] == 1 && final_val[2] == 1 && final_val[3] == 1 && final_val[4] == 1 && final_val[5] == 1 && final_val[6] == 1 && final_val[7] == 1) begin
            `uvm_info(get_type_name(), "1~7 bits keep 1 successfully!", UVM_LOW)
        end
        else begin
            `uvm_info(get_type_name(), "1~7 bits keep 1 failed", UVM_LOW)
        end
    endtask

endclass

`endif 