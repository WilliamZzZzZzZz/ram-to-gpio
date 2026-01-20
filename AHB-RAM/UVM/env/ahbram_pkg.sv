`ifndef AHBRAM_PKG_SV
`define AHBRAM_PKG_SV

package ahbram_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ahb_pkg::*;

    `include "ahbram_reg.sv"
    `include "ahbram_configuration.sv"
    `include "ahbram_reg_adapter.sv"
    `include "ahbram_subscriber.sv" 
    `include "ahbram_cov.sv"
    `include "ahbram_scoreboard.sv"       
    `include "ahbram_virtual_sequencer.sv"    
    `include "ahbram_env.sv"
    `include "ahbram_sequence_lib.svh"
    `include "ahbram_tests.svh"

endpackage

`endif 