`ifndef RKV_GPIO_COV_SV
`define RKV_GPIO_COV_SV

class rkv_gpio_cov extends rkv_gpio_subscriber;

  `uvm_component_utils(rkv_gpio_cov)

    typedef enum bit [1:0] {
        HIGH_LEVEL    = 2'b00;
        LOW_LEVEL     = 2'b01;
        RISING_EDGE   = 2'b10;
        FALLING_EDGE  = 2'b11;
    } int_type_e;

    bit [15:0] inten_val;
    bit [15:0] inttype_val;
    bit [15:0] intpol_val;
    bit [15:0] intstatus_val;
    bit [15:0] intclear_val;
    bti [3:0]  pin_id;
    int_type_e current_int_type;

    covergroup cg_interrupt_type;
        option.name = "interrupt_type_covergroup";

        INT_TYPE: coverpoint current_int_type {
            bins high_level     = {HIGH_LEVEL};
            bins low_level      = {LOW_LEVEL};
            bins rising_level   = {RISING_EDGE};
            bins falling_edge   = {FALLING_EDGE};
        }

        PIN_ID: coverpoint pin_id {
            bins pin_low[4]  = {[0:3]};
            bins pin_mid[4]  = {[4:7]};
            bins pin_high[4] = {[8:11]};
            bins pin_top[4]  = {[12:15]};
        }
        INT_TYPE_X_PIN: cross INT_TYPE, PIN_ID;
    endgroup    

  function new (string name = "rkv_gpio_cov", uvm_component parent);
    super.new(name, parent);
    cg_interrupt_type = new();
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void write(lvc_ahb_transaction tr);
    cg_interrupt_type.sample(tr);
  endfunction

  task do_listen_events();
    
  endtask

endclass

`endif 
