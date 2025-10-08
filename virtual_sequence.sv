class virtual_sequence extends uvm_sequence;

     `uvm_object_utils(virtual_sequence)

    `uvm_declare_p_sequencer(virtual_sequencer)

    write_sequence wr_seq;
    read_sequence rd_seq;
    rand int num_writes = 10000;
    rand int num_reads = 10000;

    function new(string name = "virtual_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("VSEQ", $sformatf("Starting virtual sequence: %0d writes, %0d reads",
                                   num_writes, num_reads), UVM_LOW)

        fork
            begin: write_thread
                `uvm_info("VSEQ", "Starting write sequence", UVM_LOW)
                wr_seq = write_sequence::type_id::create("wr_seq");
                wr_seq.num_transactions = num_writes;
                wr_seq.start(p_sequencer.wt_seqr);
                `uvm_info("VSEQ", "Write sequence completed", UVM_LOW)
            end

            begin: read_thread
               
                #500;
                `uvm_info("VSEQ", "Starting read sequence", UVM_LOW)
                rd_seq = read_sequence::type_id::create("rd_seq");
                rd_seq.num_transactions = num_reads;
                rd_seq.start(p_sequencer.rd_seqr);
                `uvm_info("VSEQ", "Read sequence completed", UVM_LOW)
            end
        join

        `uvm_info("VSEQ", "Virtual sequence completed", UVM_LOW)
    endtask
endclass
