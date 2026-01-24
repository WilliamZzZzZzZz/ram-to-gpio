`ifndef RKV_GPIO_BASE_VIRTUAL_SEQUENCE_SV
`define RKV_GPIO_BASE_VIRTUAL_SEQUENCE_SV

class rkv_gpio_base_virtual_sequence extends uvm_sequence;

  rkv_gpio_config cfg;
  virtual rkv_gpio_if vif;
  rkv_gpio_rgm rgm;
  bit[31:0] wr_val, rd_val;
  uvm_status_e status;

  // element sequence declartion
  rkv_gpio_single_write_seq single_write;
  rkv_gpio_single_read_seq single_read;

  `uvm_object_utils(rkv_gpio_base_virtual_sequence)
  `uvm_declare_p_sequencer(rkv_gpio_virtual_sequencer)

  function new (string name = "rkv_gpio_base_virtual_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info("body", "Entered...", UVM_LOW)
    // get cfg from p_sequencer
    cfg = p_sequencer.cfg;
    vif = cfg.vif;
    rgm = cfg.rgm;
    // TODO in sub-class
    wait_ready_for_stim();
    `uvm_info("body", "Exiting...", UVM_LOW)
  endtask

  virtual function void compare_data(logic[31:0] val1, logic[31:0] val2, bit wild_compare = 0);
    if(wild_compare == 0) begin
      cfg.seq_check_count++;
      if(val1 === val2)
        `uvm_info("CMPSUC", $sformatf("val1 'h%0x === val2 'h%0x", val1, val2), UVM_LOW)
      else begin
        cfg.seq_check_error++;
        `uvm_error("CMPERR", $sformatf("val1 'h%0x !== val2 'h%0x", val1, val2))
      end
    end
    else begin
      foreach(val1[i]) begin
        if(val1[i] !== 1'bx && val2[i] !== 1'bx) begin
          if(val1[i] == val2[i]) begin
            `uvm_info("CMPSUC", $sformatf("val1 'h%0x === val2 'h%0x", val1, val2), UVM_LOW)
          end
          else begin
            cfg.seq_check_error++;
            `uvm_error("CMPERR", $sformatf("val1 'h%0x !== val2 'h%0x", val1, val2))
          end
        end
      end
    end

  endfunction


  task wait_reset_signal_assertted();
      @(posedge vif.rstn);
  endtask

  task wait_reset_signal_released();
      @(negedge vif.rstn);
  endtask

  task wait_cycles(int n = 1);
    repeat(n) @(posedge vif.clk);
  endtask

  task wait_ready_for_stim();
    wait_reset_signal_released();
    wait_cycles(10);
  endtask

  task get_portin(output bit [15:0] bits, input int id);
    bit temp_bits = 0;
    rgm.DATA.read(status, bits);
    if(id >= 0) begin
      temp_bits = bits[id];
      bits = 0;
      bits[id] = temp_bits;
    end
  endtask

  task set_portout_bits(logic [15:0] bits);
    logic [15:0] pout;
    uvm_status_e status;
    rgm.DATAOUT.read(status, pout);
    foreach(bits[i]) begin
      pout[i] = (bits[i] === 1'bx ? pout[i] : bits[i]); 
    end
    rgm.DATAOUT.write(status, pout);
  endtask

  task set_high_level_interrupt(bit[3:0] id);
    rgm.INTENCLR.write(status, 1 << id);
    rgm.INTENSET.write(status, 1 << id);
    rgm.INTPOLSET.write(status, 1 << id);
    rgm.INTTYPECLR.write(status, 1 << id);
  endtask

  task set_low_level_interrupt(bit[3:0] id);
    rgm.INTENCLR.write(status, 1 << id);
    rgm.INTENSET.write(status, 1 << id);
    rgm.INTPOLCLR.write(status, 1 << id);
    rgm.INTTYPECLR.write(status, 1 << id);
  endtask 

  task set_rising_level_interrupt(bit[3:0] id);
    rgm.INTENCLR.write(status, 1 << id);
    rgm.INTENSET.write(status, 1 << id);
    rgm.INTPOLSET.write(status, 1 << id);
    rgm.INTTYPESET.write(status, 1 << id);    
  endtask 

  task get_intstatus(output bit [15:0] bits, input int id);
    bit temp_bits = 0;
    rgm.INTSTATUS.read(status, bits);
    if(id >= 0) begin
      temp_bits = bits[id];
      bits = 0;
      bits[id] = temp_bits;
    end
  endtask  

endclass

`endif  
