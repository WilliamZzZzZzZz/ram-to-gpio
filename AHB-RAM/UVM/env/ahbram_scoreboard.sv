`ifndef AHBRAM_SCOREBOARD_SV
`define AHBRAM_SCOREBOARD_SV

class ahbram_scoreboard extends ahbram_subscriber;

    bit [31:0] mem [int unsigned];

    `uvm_component_utils(ahbram_scoreboard)

    function new(string name = "ahbram_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
    endtask

    virtual function void write(ahb_transaction tr);
        if(is_addr_vaild(tr.addr)) begin
            case(tr.xact_type)
                WRITE : store_data_with_hburst(tr);
                READ  : check_data_with_hburst(tr);
            endcase
        end
    endfunction

    function bit is_addr_vaild(bit [31:0] addr);
        if(addr >= cfg.addr_start && addr <= cfg.addr_end)
            return 1;
    endfunction

    function void store_data_with_hburst(ahb_transaction tr);
        case(tr.burst_type)
            SINGLE: begin 
                      store_data_with_hsize(tr, 0);
                    end
            INCR  : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            WRAP4 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            INCR4 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            WRAP8 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            INCR8 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            WRAP16: begin `uvm_error("TYPEERR", "burst type not supported yet") end
            INCR16: begin `uvm_error("TYPEERR", "burst type not supported yet") end
            default: begin `uvm_error("TYPEERR", "burst type not defined") end
        endcase
    endfunction

    function void store_data_with_hsize(ahb_transaction tr, int beat);
        case(tr.burst_size)
            BURST_SIZE_8BIT: mem[tr.addr] = tr.data[beat] & 32'h0000_00FF;
            BURST_SIZE_16BIT: mem[tr.addr] = tr.data[beat] & 32'h0000_FFFF;
            BURST_SIZE_32BIT: mem[tr.addr] = tr.data[beat] & 32'hFFFF_FFFF;
            BURST_SIZE_64BIT: begin `uvm_error("TYPEERR", "burst size not supported yet") end
            default: begin `uvm_error("TYPEERR", "burst size not defined") end
        endcase
    endfunction

    function bit check_data_with_hburst(ahb_transaction tr);
        case(tr.burst_type)
            SINGLE: begin 
                      check_data_with_hburst = (check_data_with_hsize(tr, 0));
                    end
            INCR  : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            WRAP4 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            INCR4 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            WRAP8 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            INCR8 : begin `uvm_error("TYPEERR", "burst type not supported yet") end
            WRAP16: begin `uvm_error("TYPEERR", "burst type not supported yet") end
            INCR16: begin `uvm_error("TYPEERR", "burst type not supported yet") end
            default: begin `uvm_error("TYPEERR", "burst type not defined") end
        endcase
        if(check_data_with_hburst)
            `uvm_info("DATACHK", $sformatf("ahbram[%0x] hburst[%s] is as expexted", tr.addr, tr.burst_type), UVM_HIGH)
        else begin
            cfg.scb_check_error++;
            `uvm_error("DATACHK", $sformatf("ahbram[%0x] hburst[%s] is NOT as expected ", tr.addr, tr.burst_type))
        end
    endfunction

    function bit check_data_with_hsize(ahb_transaction tr, int beat);
        bit [63:0] data;
        case(tr.burst_size)
        BURST_SIZE_8BIT : begin data = tr.data[beat] & 32'h0000_00FF; if(mem[tr.addr] == data) check_data_with_hsize = 1; end
        BURST_SIZE_16BIT: begin data = tr.data[beat] & 32'h0000_FFFF; if(mem[tr.addr] == data) check_data_with_hsize = 1; end
        BURST_SIZE_32BIT: begin data = tr.data[beat] & 32'hFFFF_FFFF; if(mem[tr.addr] == data) check_data_with_hsize = 1; end
        default: begin `uvm_error("TYPEERR", "burst size not defined") end
        endcase
        cfg.scb_check_count++;

        if(check_data_with_hsize)
            `uvm_info("DATACHK", $sformatf("ahbram[%0x] data expected 'h%0x = actual 'h%0x", tr.addr, mem[tr.addr], data), UVM_HIGH)
        else begin
            cfg.scb_check_error++;
            `uvm_error("DATACHK", $sformatf("ahbram[%0x] data mismatch! expected 'h%0x != actual 'h%0x", tr.addr, mem[tr.addr], data))
        end
    endfunction

endclass

`endif 