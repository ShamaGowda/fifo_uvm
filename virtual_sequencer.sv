class virtual_sequencer extends uvm_sequencer;
    `uvm_component_utils(virtual_sequencer)

    write_sequencer wt_seqr;
    read_sequencer rd_seqr;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
endclass
