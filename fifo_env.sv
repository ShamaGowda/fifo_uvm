class fifo_env extends uvm_env;
    `uvm_component_utils(fifo_env)
       fifo_coverage cov;

    write_agent wr_agent;
    read_agent rd_agent;
    virtual_sequencer v_seqr;
    fifo_scoreboard scb;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("ENV", "Building environment", UVM_LOW)
       cov = fifo_coverage::type_id::create("cov", this);

        wr_agent = write_agent::type_id::create("wr_agent", this);
        rd_agent = read_agent::type_id::create("rd_agent", this);
        v_seqr = virtual_sequencer::type_id::create("v_seqr", this);
        scb = fifo_scoreboard::type_id::create("scb", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("ENV", "Connecting environment", UVM_LOW)
       wr_agent.wr_ap.connect(cov.analysis_export);
       rd_agent.rd_ap.connect(cov.analysis_export);


        if (wr_agent.wt_seqr != null) begin
            v_seqr.wt_seqr = wr_agent.wt_seqr;
        end

        if (rd_agent.rd_seqr != null) begin
            v_seqr.rd_seqr = rd_agent.rd_seqr;
        end


        wr_agent.wr_ap.connect(scb.wr_export);
        rd_agent.rd_ap.connect(scb.rd_export);
    endfunction
endclass
