`ifndef AHB_MASTER_TRANSACTION_SV
`define AHB_MASTER_TRANSACTION_SV

class ahb_master_transaction extends ahb_transaction;
  `uvm_object_utils_begin(ahb_master_transaction)
  `uvm_object_utils_end

  function new(string name = "ahb_master_transaction");
    super.new(name);
  endfunction


endclass


`endif 
