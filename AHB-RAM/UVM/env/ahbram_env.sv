`ifndef AHBRAM_ENV_SV
`define AHBRAM_ENV_SV

class ahbram_env extends uvm_env;

    ahb_master_agent ahb_mst;
    ahbram_configuration cfg;
    ahbram_virtual_sequencer virt_sqr;
    ahbram_rgm rgm;
    ahbram_reg_adapter adapter;
    uvm_reg_predictor #(ahb_transaction) predictor; 
    ahbram_cov cov;   
    ahbram_scoreboard scb;

    `uvm_component_utils(ahbram_env)

    function new(string name = "ahbram_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(ahbram_configuration)::get(this, "", "cfg", cfg)) begin
            `uvm_fatal("GETCFG", "cannot get config object from config DB")
        end
        uvm_config_db#(ahbram_configuration)::set(this, "virt_sqr", "cfg", cfg);
        uvm_config_db#(ahbram_configuration)::set(this, "cov", "cfg", cfg);
        uvm_config_db#(ahbram_configuration)::set(this, "scb", "cfg", cfg);
        uvm_config_db#(ahb_agent_configuration)::set(this, "ahb_mst", "cfg", cfg.ahb_cfg);

        ahb_mst = ahb_master_agent::type_id::create("ahb_mst", this);
        virt_sqr = ahbram_virtual_sequencer::type_id::create("virt_sqr", this);

        if(!uvm_config_db#(ahbram_rgm)::get(this, "", "rgm", rgm)) begin
            rgm = ahbram_rgm::type_id::create("rgm", this);
            rgm.build();
        end

        uvm_config_db#(ahbram_rgm)::set(this, "*", "rgm", rgm);
        adapter = ahbram_reg_adapter::type_id::create("adapter", this);
        cov = ahbram_cov::type_id::create("cov", this);
        predictor = uvm_reg_predictor#(ahb_transaction)::type_id::create("predictor", this);
        scb = ahbram_scoreboard::type_id::create("scb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        virt_sqr.ahb_mst_sqr = ahb_mst.sequencer;
        rgm.map.set_sequencer(ahb_mst.sequencer, adapter);
        ahb_mst.monitor.item_observed_port.connect(predictor.bus_in);
        predictor.map = rgm.map;
        predictor.adapter = adapter;        
        ahb_mst.monitor.item_observed_port.connect(cov.ahb_trans_observed_imp);
        ahb_mst.monitor.item_observed_port.connect(scb.ahb_trans_observed_imp);
    endfunction

    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction

    function void report_phase(uvm_phase phase);
        string reports = "\n";
        super.report_phase(phase);
        reports = {reports, $sformatf("=============================================== \n")};
        reports = {reports, $sformatf("CURRENT TEST SUMMARY \n")};
        reports = {reports, $sformatf("SEQUENCE CHECK COUNT : %0d \n", cfg.seq_check_count)};
        reports = {reports, $sformatf("SEQUENCE CHECK ERROR : %0d \n", cfg.seq_check_error)};
        reports = {reports, $sformatf("SCOREBOARD CHECK COUNT : %0d \n", cfg.scb_check_count)};
        reports = {reports, $sformatf("SCOREBOARD CHECK ERROR : %0d \n", cfg.scb_check_error)};
        reports = {reports, $sformatf("=============================================== \n")};
        `uvm_info("TEST_SUMMARY", reports, UVM_LOW)
    endfunction

endclass

`endif 