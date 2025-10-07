class read_agent extends uvm_agent;
    `uvm_component_utils(read_agent)

    read_driver rd_driver;
    read_sequencer rd_seqr;
    read_monitor rd_monitor;

    uvm_analysis_port #(fifo_seq_item) rd_ap;

    uvm_active_passive_enum is_active = UVM_ACTIVE;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rd_monitor = read_monitor::type_id::create("rd_monitor", this);
        rd_ap = new("rd_ap", this);

        if (is_active == UVM_ACTIVE) begin
            rd_driver = read_driver::type_id::create("rd_driver", this);
            rd_seqr = read_sequencer::type_id::create("rd_seqr", this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        rd_monitor.item_collected_port.connect(rd_ap);

        if (is_active == UVM_ACTIVE) begin
            rd_driver.seq_item_port.connect(rd_seqr.seq_item_export);
        end
    endfunction
endclass


