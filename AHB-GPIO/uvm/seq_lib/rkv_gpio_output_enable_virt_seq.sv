`ifndef RKV_GPIO_OUTPUT_ENABLE_VIRT_SEQ_SV
`define RKV_GPIO_OUTPUT_ENABLE_VIRT_SEQ_SV

class rkv_gpio_output_enable_virt_seq extends rkv_gpio_base_virtual_sequence;
        `uvm_object_utils(rkv_gpio_output_enable_virt_seq)

        function new(string name = "rkv_gpio_output_enable_virt_seq");
                super.new(name);
        endfunction

        virtual task body();
                bit [3:0] pin_id;
                super.body();
                `uvm_info(get_type_name(), "Entered...", UVM_LOW)
                
                // Test 1: 逐位测试 OUTENSET/OUTENCLR
                repeat(20) begin
                        std::randomize(pin_id);
                        test_single_bit_outen(pin_id);
                end
                
                // Test 2: 多位同时操作测试
                test_multi_bit_outen();
                
                // Test 3: SET/CLR 交替操作测试
                test_set_clr_interaction();
                
                // Test 4: 输出使能�?PORTOUT 联动测试
                test_outen_portout_linkage();
                
                `uvm_info(get_type_name(), "Exiting...", UVM_LOW)
        endtask

        // 测试单个引脚的输出使�?SET/CLR 功能
        task test_single_bit_outen(bit[3:0] id);
                bit [15:0] outen_rd, expected;
                
                // Step 1: 清除该位的输出使�?
                rgm.OUTENCLR.write(status, 1 << id);
                wait_cycles(2);
                rgm.OUTENSET.read(status, outen_rd);
                expected = outen_rd & ~(1 << id);
                if(outen_rd[id] != 0) begin
                        `uvm_error(get_type_name(), $sformatf("OUTENCLR failed for pin[%0d], expected 0, got %0b", id, outen_rd[id]))
                end else begin
                        `uvm_info(get_type_name(), $sformatf("OUTENCLR pin[%0d] PASSED", id), UVM_LOW)
                end
                
                // Step 2: 设置该位的输出使�?
                rgm.OUTENSET.write(status, 1 << id);
                wait_cycles(2);
                rgm.OUTENSET.read(status, outen_rd);
                if(outen_rd[id] != 1) begin
                        `uvm_error(get_type_name(), $sformatf("OUTENSET failed for pin[%0d], expected 1, got %0b", id, outen_rd[id]))
                end else begin
                        `uvm_info(get_type_name(), $sformatf("OUTENSET pin[%0d] PASSED", id), UVM_LOW)
                end
                
                // Step 3: 验证 PORTEN 输出信号
                if(vif.porten[id] != 1) begin
                        `uvm_error(get_type_name(), $sformatf("PORTEN mismatch for pin[%0d], expected 1, got %0b", id, vif.porten[id]))
                end else begin
                        `uvm_info(get_type_name(), $sformatf("PORTEN pin[%0d] correctly reflects OUTENSET", id), UVM_LOW)
                end
                
                // Step 4: 再次清除并验�?PORTEN
                rgm.OUTENCLR.write(status, 1 << id);
                wait_cycles(2);
                if(vif.porten[id] != 0) begin
                        `uvm_error(get_type_name(), $sformatf("PORTEN not cleared for pin[%0d], expected 0, got %0b", id, vif.porten[id]))
                end else begin
                        `uvm_info(get_type_name(), $sformatf("PORTEN pin[%0d] correctly cleared", id), UVM_LOW)
                end
        endtask

        // 测试多位同时操作
        task test_multi_bit_outen();
                bit [15:0] set_pattern, clr_pattern;
                bit [15:0] outen_rd, expected;
                
                `uvm_info(get_type_name(), "Testing multi-bit OUTEN operations...", UVM_LOW)
                
                // 先清除所有位
                rgm.OUTENCLR.write(status, 16'hFFFF);
                wait_cycles(2);
                
                // 设置随机模式
                set_pattern = $urandom();
                rgm.OUTENSET.write(status, set_pattern);
                wait_cycles(2);
                
                // 验证寄存器�?
                rgm.OUTENSET.read(status, outen_rd);
                compare_data(set_pattern, outen_rd);
                
                // 验证 PORTEN 信号
                compare_data(set_pattern, vif.porten);
                
                // 清除部分�?
                clr_pattern = $urandom();
                rgm.OUTENCLR.write(status, clr_pattern);
                wait_cycles(2);
                
                expected = set_pattern & ~clr_pattern;
                rgm.OUTENSET.read(status, outen_rd);
                compare_data(expected, outen_rd);
                compare_data(expected, vif.porten);
        endtask

        // 测试 SET �?CLR 交替操作的累积效�?
        task test_set_clr_interaction();
                bit [15:0] outen_rd;
                
                `uvm_info(get_type_name(), "Testing SET/CLR interaction...", UVM_LOW)
                
                // 清除所�?
                rgm.OUTENCLR.write(status, 16'hFFFF);
                wait_cycles(2);
                
                // 连续 SET 操作应累�?
                rgm.OUTENSET.write(status, 16'h00FF);
                wait_cycles(1);
                rgm.OUTENSET.write(status, 16'hFF00);
                wait_cycles(2);
                
                rgm.OUTENSET.read(status, outen_rd);
                compare_data(16'hFFFF, outen_rd);
                
                // 连续 CLR 操作应累积清�?
                rgm.OUTENCLR.write(status, 16'h0F0F);
                wait_cycles(1);
                rgm.OUTENCLR.write(status, 16'hF0F0);
                wait_cycles(2);
                
                rgm.OUTENSET.read(status, outen_rd);
                compare_data(16'h0000, outen_rd);
        endtask

        // 测试输出使能�?PORTOUT 的联动关�?
        task test_outen_portout_linkage();
                bit [15:0] test_data;
                bit [3:0] pin_id;
                
                `uvm_info(get_type_name(), "Testing OUTEN-PORTOUT linkage...", UVM_LOW)
                
                std::randomize(pin_id);
                test_data = 16'h0000;
                test_data[pin_id] = 1'b1;
                
                // 先禁用输出使�?
                rgm.OUTENCLR.write(status, 1 << pin_id);
                wait_cycles(2);
                
                // 写入 DATAOUT
                rgm.DATAOUT.write(status, test_data);
                wait_cycles(2);
                
                // 验证：PORTEN=0 时，PORTOUT 应仍然输出数据（DUT 设计特性）
                // PORTEN 只是控制三态使能，不影�?PORTOUT �?
                if(vif.portout[pin_id] != 1'b1) begin
                        `uvm_error(get_type_name(), $sformatf("PORTOUT[%0d] should be 1 even when PORTEN=0", pin_id))
                end
                
                // 使能输出
                rgm.OUTENSET.write(status, 1 << pin_id);
                wait_cycles(2);
                
                // 验证 PORTEN �?PORTOUT 都正�?
                if(vif.porten[pin_id] != 1'b1) begin
                        `uvm_error(get_type_name(), $sformatf("PORTEN[%0d] should be 1", pin_id))
                end
                if(vif.portout[pin_id] != 1'b1) begin
                        `uvm_error(get_type_name(), $sformatf("PORTOUT[%0d] should be 1", pin_id))
                end
                
                `uvm_info(get_type_name(), $sformatf("OUTEN-PORTOUT linkage test PASSED for pin[%0d]", pin_id), UVM_LOW)
        endtask

endclass

`endif
