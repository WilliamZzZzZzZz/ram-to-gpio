`ifndef RKV_GPIO_COV_SV
`define RKV_GPIO_COV_SV

class rkv_gpio_cov extends rkv_gpio_subscriber;

  `uvm_component_utils(rkv_gpio_cov)

    typedef enum bit [1:0] {
        HIGH_LEVEL    = 2'b00,
        LOW_LEVEL     = 2'b01,
        RISING_EDGE   = 2'b10,
        FALLING_EDGE  = 2'b11
    } int_type_e;

    bit [15:0] inten_val;
    bit [15:0] inttype_val;
    bit [15:0] intpol_val;
    bit [15:0] intstatus_val;
    bit [15:0] intclear_val;
    bit [3:0]  pin_id;
    int_type_e current_int_type;

    bit inten_updated;
    bit inttype_updated;
    bit intpol_updated;

    covergroup cg_interrupt_type;
        option.name = "interrupt_type_covergroup";
        option.per_instance = 1;
        INT_TYPE: coverpoint current_int_type {
            bins high_level     = {HIGH_LEVEL};
            bins low_level      = {LOW_LEVEL};
            bins rising_edge   = {RISING_EDGE};
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
    inten_updated   = 0;
    inttype_updated = 0;
    intpol_updated  = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction

  function void write(lvc_ahb_transaction tr);
    if(tr.xact_type == WRITE) begin
        case(tr.addr[15:0])
            RKV_ROUTER_REG_ADDR_INTENSET: begin
                inten_val = tr.data[0][15:0];
                inten_updated = 1;
                extract_pin_id();
            end
            RKV_ROUTER_REG_ADDR_INTTYPESET: begin
                inttype_val = tr.data[0][15:0];
                inttype_updated = 1;
                try_sample();
            end
            RKV_ROUTER_REG_ADDR_INTTYPECLR: begin
                inttype_val = inttype_val & ~tr.data[0][15:0];
                inttype_updated = 1;
                try_sample();
            end
            RKV_ROUTER_REG_ADDR_INTPOLSET: begin
                intpol_val = tr.data[0][15:0];
                intpol_updated = 1;
                try_sample();
            end
            RKV_ROUTER_REG_ADDR_INTPOLCLR: begin
                intpol_val = intpol_val & ~tr.data[0][15:0];
                intpol_updated = 1;
                try_sample();
            end            
            RKV_ROUTER_REG_ADDR_INTCLEAR: begin
                intclear_val = tr.data[0][15:0];
            end
        endcase
    end
  endfunction

  function void try_sample();
    if(inten_updated && inttype_updated && intpol_updated) begin
      calculate_int_type();
      cg_interrupt_type.sample();
      `uvm_info(get_type_name(), $sformatf("Sampled: pin_id=%0d, int_type=%s", pin_id, current_int_type.name()), UVM_MEDIUM)
      //reset status
      inten_updated   = 0;
      inttype_updated = 0;
      intpol_updated  = 0;
    end
  endfunction

  //which bit=1, means that bit is the pin be set to interrupt-function(1)
  function void extract_pin_id();
    for(int i = 0; i < 16; i++) begin
        if(inten_val[i]) begin
            pin_id = i[3:0];
            return;
        end
    end
  endfunction

  function void calculate_int_type();
    bit is_edge  = inttype_val[pin_id];     //0->level, 1->edge
    bit polarity = intpol_val[pin_id];      //0->low,  1->high

    if(!is_edge && polarity) begin
        current_int_type = HIGH_LEVEL;
    end
    else if(!is_edge && !polarity) begin
        current_int_type = LOW_LEVEL;
    end
    else if(is_edge && polarity) begin
        current_int_type = RISING_EDGE;
    end
    else if(is_edge && !polarity) begin
        current_int_type = FALLING_EDGE;
    end
  endfunction
  
  task do_listen_events();
    
  endtask

endclass

`endif 
