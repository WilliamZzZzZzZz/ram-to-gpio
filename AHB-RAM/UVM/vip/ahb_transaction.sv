`ifndef AHB_TRANSACTION_SV
`define AHB_TRANSACTION_SV

class ahb_transaction extends uvm_sequence_item;

        rand bit [`AHB_MAX_DATA_WIDTH - 1:0]    data[];
        rand bit [`AHB_MAX_ADDR_WIDTH - 1:0]    addr = 0;

        rand burst_size_enum burst_size = BURST_SIZE_8BIT;

        rand burst_type_enum burst_type = SINGLE;

        rand xact_type_enum xact_type = IDLE_XACT;

        rand response_type_enum response_type = OKAY;

        trans_type_enum trans_type;

        //record the data'status in one beat
        //eg: INCR4 transformation: beat0:OKAY,beat1:OKAY,beat2:ERROR,beat3:OKAY
        //->all_beat_response = [OKAY, OKAY, ERROR, OKAY]
        response_type_enum all_beat_response[];

        int current_data_beat_num;

        status_enum status = INITIAL;

        rand bit idle_xact_hwrite = 1;

        `uvm_object_utils_begin(ahb_transaction)
        `uvm_field_array_int(data, UVM_ALL_ON)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_enum(burst_size_enum, burst_size, UVM_ALL_ON)
        `uvm_field_enum(burst_type_enum, burst_type, UVM_ALL_ON)
        `uvm_field_enum(xact_type_enum, xact_type, UVM_ALL_ON)
        `uvm_field_enum(response_type_enum, response_type, UVM_ALL_ON)
        `uvm_field_enum(trans_type_enum, trans_type, UVM_ALL_ON)
        `uvm_field_array_enum(response_type_enum, all_beat_response, UVM_ALL_ON)
        `uvm_field_int(current_data_beat_num, UVM_ALL_ON)
        `uvm_field_enum(status_enum, status, UVM_ALL_ON)    
        `uvm_object_utils_end


        function new(string name = "ahb_transaction");
                super.new(name);
        endfunction

        //increase one size of data and all_beat_response,and copy all original data to the new one 
        function void increase_data(int n = 1);
                data = new[data.size + n] (data);
                all_beat_response = new[all_beat_response.size + n] (all_beat_response);
        endfunction
endclass

`endif 
