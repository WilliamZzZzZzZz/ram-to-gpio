`ifndef AHB_MASTER_SINGLE_SEQUENCE_SV
`define AHB_MASTER_SINGLE_SEQUENCE_SV

//single transfer, one transaction and only contain one beat!
//also means data size is 1
class ahb_master_single_sequence extends ahb_base_sequence;

    rand bit [`AHB_MAX_ADDR_WIDTH - 1:0] addr;
    rand bit [`AHB_MAX_DATA_WIDTH - 1:0] data;
    rand xact_type_enum xact;
    rand burst_size_enum bsize;

    rand bit [1:0] htrans;

    constraint single_trans_cstr {
        xact inside {READ, WRITE};
    }

    // constraint htrans_default_cstr{
    //     soft htrans == 2'b10;
    // }

    `uvm_object_utils(ahb_master_single_sequence)

    function new(string name = "ahb_master_single_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info(get_type_name(), "Starting sequence", UVM_HIGH)
        `uvm_do_with(req, {
                            addr == local::addr;
                            data.size() == 1;
                            data[0] == local::data;
                            burst_size == bsize;
                            burst_type == SINGLE;
                            xact_type == xact;
                            // trans_type == local::htrans;
                            })
        get_response(rsp);

        if(xact == READ) begin
            data = rsp.data[0];
        end
        `uvm_info(get_type_name(), $psprintf("Done sequence: %s", req.convert2string()), UVM_HIGH)
    endtask
endclass

`endif