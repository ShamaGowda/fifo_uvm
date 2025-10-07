class write_agent extends uvm_agent;
    `uvm_component_utils(write_agent)

    write_driver wr_driver;
    write_sequencer wt_seqr;
    write_monitor wr_monitor;

    uvm_analysis_port #(fifo_seq_item) wr_ap;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_monitor = write_monitor::type_id::create("wr_monitor", this);
        wr_ap = new("wr_ap", this);

        if (is_active == UVM_ACTIVE) begin
            wr_driver = write_driver::type_id::create("wr_driver", this);
            wt_seqr = write_sequencer::type_id::create("wt_seqr", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        wr_monitor.item_collected_port.connect(wr_ap);

        if (is_active == UVM_ACTIVE) begin
            wr_driver.seq_item_port.connect(wt_seqr.seq_item_export);
        end
    endfunction
endclass

