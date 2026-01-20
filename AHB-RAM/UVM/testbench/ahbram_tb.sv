module ahbram_tb;

    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import ahbram_pkg::*;

    logic clk;
    logic rstn;

    initial begin 
        clk = 0;
        forever #2ns clk = !clk;
    end

    ahb_blockram_32 #(.ADDRESSWIDTH(16)) dut(
        .HCLK(ahb_if.hclk)
        ,.HRESETn(ahb_if.hresetn)
        ,.HSELBRAM(1'b1)
        ,.HREADY(ahb_if.hready)
        ,.HTRANS(ahb_if.htrans)
        ,.HSIZE(ahb_if.hsize)
        ,.HWRITE(ahb_if.hwrite)
        ,.HADDR(ahb_if.haddr)
        ,.HWDATA(ahb_if.hwdata)
        ,.HREADYOUT(ahb_if.hready)
        ,.HRESP(ahb_if.hresp)
        ,.HRDATA(ahb_if.hrdata)
    );

    ahb_if ahb_if();
    assign ahb_if.hclk      = clk;
    assign ahb_if.hresetn   = rstn;
    assign ahb_if.hgrant    = 1'b1;

    ahbram_if ahbram_if();
    assign ahbram_if.clk    = clk;
    assign rstn             = ahbram_if.rstn;

    initial begin
        //uvm_root::get()               indicate this is a global setting
        //"uvm_test_top.env.ahb_mst"    indicate this setting point to the ahb_mst
        //"vif"                         indicate that ahb_mst would use "vif" to get the setting
        //ahb_if                        the actual interfaces instantiated in testbench
        //sum: this setting could let ahb_mst_agent access the AHB signals, than using these signals drive and monitor DUT 
        uvm_config_db#(virtual ahb_if)::set(uvm_root::get(), "uvm_test_top.env.ahb_mst", "vif", ahb_if);
        uvm_config_db#(virtual ahbram_if)::set(uvm_root::get(), "uvm_test_top", "vif", ahbram_if);
        uvm_config_db#(virtual ahbram_if)::set(uvm_root::get(), "uvm_test_top.env", "vif", ahbram_if);
        uvm_config_db#(virtual ahbram_if)::set(uvm_root::get(), "uvm_test_top.env.virt_sqr", "vif", ahbram_if);
        run_test();
    end

endmodule