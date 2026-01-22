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
        repeat(10) begin
            pin_id = $urandom_range(0, 15);
            high_level_interrupt(pin_id);
        end
        `uvm_info(get_type_name(), "Exiting body...", UVM_LOW)
    endtask

    task high_level_interrupt(bit[3:0] id);
        bit [15:0] pin_dr, pin_rd;
        //clear
        rgm.INTENCLR.write(status, 1 << id);
        //configure to high-level-interrupt    
        set_high_level_interrupt(id);
        //assert pin to 1
        pin_dr[id] = 1;
        vif.drive_portin(pin_dr);
        wait_cycles(2);
        //read INTSTATUS, it should be 1
        rgm.INISTATUS.read(status, pin_rd);
        //compare
        compare_data(pin_dr, pin_rd);
    endtask
endclass

`endif 