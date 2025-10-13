class virtual_sequence extends uvm_sequence;
    `uvm_object_utils(virtual_sequence)
    `uvm_declare_p_sequencer(virtual_sequencer)


    write_sequence3 wr_seq3;
    read_sequence3 rd_seq3;
    write_sequence2 wr_seq2;
    read_sequence2 rd_seq2;
    write_sequence1 wr_seq1;
    read_sequence1 rd_seq1;
    write_sequence wr_seq;
    read_sequence rd_seq;
    rand int num_writes = 17;
    rand int num_reads = 17;

    function new(string name = "virtual_sequence");
        super.new(name);
    endfunction

    virtual task body();
        `uvm_info("VSEQ", $sformatf("Starting virtual sequence: %0d writes, %0d reads", num_writes, num_reads), UVM_LOW)

        fork
            begin: write_thread_1
                `uvm_info("VSEQ", "Starting write sequence", UVM_LOW)
                wr_seq = write_sequence::type_id::create("wr_seq");
                wr_seq.num_transactions = num_writes;
                wr_seq.start(p_sequencer.wt_seqr);
                `uvm_info("VSEQ", "Write sequence completed", UVM_LOW)
            end

            begin: read_thread_1
                #500;
                `uvm_info("VSEQ", "Starting read sequence", UVM_LOW)
                rd_seq = read_sequence::type_id::create("rd_seq");
                rd_seq.num_transactions = num_reads;
                rd_seq.start(p_sequencer.rd_seqr);
                `uvm_info("VSEQ", "Read sequence completed", UVM_LOW)
            end
        join
       fork
            begin: read_thread_2
                `uvm_info("VSEQ", "Starting read sequence 1", UVM_LOW)
                rd_seq1 = read_sequence1::type_id::create("rd_seq1");
                rd_seq1.num_transactions = num_reads;
                rd_seq1.start(p_sequencer.rd_seqr);
                `uvm_info("VSEQ", "Read sequence 1 completed", UVM_LOW)
            end
        join

       fork
            begin: write_thread_3
                `uvm_info("VSEQ", "Starting write sequence 2", UVM_LOW)
                wr_seq2 = write_sequence2::type_id::create("wr_seq2");
                wr_seq2.num_transactions = num_writes;
                wr_seq2.start(p_sequencer.wt_seqr);
                `uvm_info("VSEQ", "Write sequence 2 completed", UVM_LOW)
            end

            begin: read_thread_3
                `uvm_info("VSEQ", "Starting read sequence 2", UVM_LOW)
                rd_seq2 = read_sequence2::type_id::create("rd_seq2");
                rd_seq2.num_transactions = num_reads;
                rd_seq2.start(p_sequencer.rd_seqr);
                `uvm_info("VSEQ", "Read sequence 2 completed", UVM_LOW)
            end
        join

      fork
            begin: write_thread_4
                `uvm_info("VSEQ", "Starting write sequence 3", UVM_LOW)
                wr_seq3 = write_sequence3::type_id::create("wr_seq2");
                wr_seq3.num_transactions = num_writes;
                wr_seq3.start(p_sequencer.wt_seqr);
                `uvm_info("VSEQ", "Write sequence 3 completed", UVM_LOW)
            end


        join






        `uvm_info("VSEQ", "Virtual sequence completed", UVM_LOW)
    endtask
endclass
