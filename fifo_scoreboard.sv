class fifo_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(fifo_scoreboard)

    uvm_analysis_export #(fifo_seq_item) wr_export;
    uvm_analysis_export #(fifo_seq_item) rd_export;

    uvm_tlm_analysis_fifo #(fifo_seq_item) wr_fifo;
    uvm_tlm_analysis_fifo #(fifo_seq_item) rd_fifo;

    fifo_seq_item wr_queue[$];
    int match_count, mismatch_count;
    int total_writes = 0;
    int total_reads = 0;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_export = new("wr_export", this);
        rd_export = new("rd_export", this);
        wr_fifo = new("wr_fifo", this);
        rd_fifo = new("rd_fifo", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        wr_export.connect(wr_fifo.analysis_export);
        rd_export.connect(rd_fifo.analysis_export);
    endfunction

    virtual task run_phase(uvm_phase phase);
        fifo_seq_item wr_item, rd_item;

        forever begin
            fork
                begin
                    wr_fifo.get(wr_item);
                    if (wr_item.write) begin
                        total_writes++;
                        wr_queue.push_back(wr_item);
                        `uvm_info("SCB", $sformatf("Stored write %0d: 0x%0h, Queue size: %0d",
                                                 total_writes, wr_item.wdata, wr_queue.size()), UVM_MEDIUM)
                    end
                end
                begin
                    rd_fifo.get(rd_item);
                    if (rd_item.read) begin
                        total_reads++;
                        if (wr_queue.size() > 0) begin
                            wr_item = wr_queue.pop_front();
                            if (rd_item.rdata === wr_item.wdata) begin
                                match_count++;
                                `uvm_info("SCB", $sformatf("MATCH %0d: Expected=0x%0h, Actual=0x%0h",
                                                         match_count, wr_item.wdata, rd_item.rdata), UVM_MEDIUM)
                            end else begin
                                mismatch_count++;
                                `uvm_error("SCB", $sformatf("MISMATCH %0d: Expected=0x%0h, Actual=0x%0h",
                                                          mismatch_count, wr_item.wdata, rd_item.rdata))
                            end
                        end else begin
                            `uvm_error("SCB", $sformatf("Read %0d attempted but no data in queue! Read data: 0x%0h",
                                                      total_reads, rd_item.rdata))
                        end
                    end
                end
            join
        end
    endtask

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCB", $sformatf("FINAL: Total Writes=%0d, Total Reads=%0d, Matches=%0d, Mismatches=%0d, Queue Size=%0d",
                                 total_writes, total_reads, match_count, mismatch_count, wr_queue.size()), UVM_LOW)
        if (mismatch_count == 0 && wr_queue.size() == 0 && total_writes == total_reads) begin
            `uvm_info("SCB", "*** TEST PASSED ***", UVM_NONE)
        end else begin
            `uvm_error("SCB", "*** TEST FAILED ***")
        end
    endfunction
endclass
