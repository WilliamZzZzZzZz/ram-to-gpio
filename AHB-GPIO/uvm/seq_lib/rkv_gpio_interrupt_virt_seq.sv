`ifndef RKV_GPIO_INTERRUPT_VIRT_SEQ_SV
`define RKV_GPIO_INTERRUPT_VIRT_SEQ_SV

class rkv_gpio_interrupt_virt_seq extends rkv_gpio_base_virtual_sequence;
    `uvm_object_utils(rkv_gpio_interrupt_virt_seq)

    function new(string name = "rkv_gpio_interrupt_virt_seq");
        super.new(name);
    endfunction

    virtual task body();
        bit [3:0] pin_id;
        super.body();
        `uvm_info(get_type_name(), "Entered body...", UVM_LOW)
        repeat(20) begin
            // pin_id = $urandom_range(0, 15);
            std::randomize(pin_id);
            // high_level_interrupt(pin_id);
            low_level_interrupt(pin_id);
        end
        `uvm_info(get_type_name(), "Exiting body...", UVM_LOW)
    endtask

    task high_level_interrupt(bit[3:0] id);
        bit [15:0] pin_dr, pin_rd; 
        set_high_level_interrupt(id);
        //assert pin to 1
        pin_dr[id] = 1;
        vif.drive_portin(pin_dr);
        wait_cycles(2);
        get_intstatus(pin_rd, id);
        compare_data(pin_dr, pin_rd);
        //keep the pin=1, do INTCLEAR, it should keep 1
        rgm.INTCLEAR.write(status, 1 << id);
        get_intstatus(pin_rd, id);
        compare_data(pin_dr, pin_rd);
        //deassert pin to 0, do INTCLEAR, it should be 0
        pin_dr[id] = 0;
        vif.drive_portin(pin_dr);
        wait_cycles(2);
        rgm.INTCLEAR.write(status, 1 << id);
        get_intstatus(pin_rd, id);
        compare_data(pin_dr, pin_rd);
    endtask

    task low_level_interrupt(bit[3:0] id);
        bit [15:0] pin_dr, pin_rd; 
        bit [15:0] before_clear, after_clear;
        set_low_level_interrupt(id);
        //assert pin to 0
        pin_dr[id] = 0;
        vif.drive_portin(pin_dr);
        wait_cycles(2);
        get_intstatus(before_clear, id);
        `uvm_info(get_type_name(), $sformatf("assert 0, pin_id: %d and pin_rd: %b",id, before_clear), UVM_LOW)
        // compare_data(pin_dr, pin_rd);
        //keep the pin=0, do INTCLEAR, it should keep 1
        rgm.INTCLEAR.write(status, 1 << id);
        get_intstatus(after_clear, id);
        `uvm_info(get_type_name(), $sformatf("keep 0 with INTCLEAR, pin_id: %d and pin_rd: %b",id, after_clear), UVM_LOW)
        compare_data(before_clear, after_clear);
        //deassert pin to 1, do INTCLEAR, it should be 0
        pin_dr[id] = 1;
        vif.drive_portin(pin_dr);
        wait_cycles(2);
        rgm.INTCLEAR.write(status, 1 << id);
        get_intstatus(pin_rd, id);
        `uvm_info(get_type_name(), $sformatf("deassert 1 with INTCLEAR, pin_id: %d and pin_rd: %b",id, pin_rd), UVM_LOW)
        // compare_data(pin_dr, pin_rd);
    endtask
endclass

`endif 