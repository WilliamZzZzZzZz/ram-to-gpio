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
            std::randomize(pin_id);
            high_level_interrupt(pin_id);
            low_level_interrupt(pin_id);
            rising_edge_interrupt(pin_id);
            falling_edge_interrupt(pin_id);
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

    task rising_edge_interrupt(bit[3:0] id);
        bit [15:0] pin_dr, pin_rd;
        bit [15:0] falling_check, rising_check, clear_check;
        set_rising_edge_interrupt(id);
        generate_rising_edge(pin_dr, id);       
        get_intstatus(rising_check, id);
        compare_data(pin_dr, rising_check);
        generate_falling_edge(pin_dr, id);
        get_intstatus(falling_check, id);
        compare_data(rising_check, falling_check);
        rgm.INTCLEAR.write(status, 1 << id);
        get_intstatus(clear_check, id);
        compare_data(clear_check, 0);
    endtask
    
    task falling_edge_interrupt(bit[3:0] id);
        bit [15:0] pin_dr, pin_rd;
        bit [15:0] falling_check, rising_check, clear_check;
        set_falling_edge_interrupt(id);
        generate_falling_edge(pin_dr, id);       
        get_intstatus(falling_check, id);
        generate_rising_edge(pin_dr, id);
        get_intstatus(rising_check, id);
        compare_data(falling_check, rising_check);
        rgm.INTCLEAR.write(status, 1 << id);
        get_intstatus(clear_check, id);
        compare_data(clear_check, 0);
    endtask

    task generate_rising_edge(ref bit[15:0] pin_dr, bit[3:0] id);
        pin_dr[id] = 0;
        vif.drive_portin(pin_dr);
        wait_cycles(3);
        pin_dr[id] = 1;
        vif.drive_portin(pin_dr);
        wait_cycles(3);
    endtask

    task generate_falling_edge(ref bit[15:0] pin_dr, bit[3:0] id);
        pin_dr[id] = 1;
        vif.drive_portin(pin_dr);
        wait_cycles(3);
        pin_dr[id] = 0;
        vif.drive_portin(pin_dr);
        wait_cycles(3);        
    endtask

endclass

`endif 