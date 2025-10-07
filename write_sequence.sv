class write_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(write_sequence)

    rand int num_transactions = 10000;

    function new(string name = "write_sequence");
        super.new(name);
    endfunction

    virtual task body();
        fifo_seq_item req;

        for (int i = 0; i < num_transactions; i++) begin
            req = fifo_seq_item::type_id::create("req");
            start_item(req);


            if (!req.randomize() with {
                write == 1;
                read  == 0;
                wdata inside {[0:255]};
            }) begin
                `uvm_error("RANDOMIZE", "Randomization failed for write sequence");
            end

            finish_item(req);


            `uvm_info("WR_SEQ", $sformatf("Write transaction %0d: data=0x%0h", i, req.wdata), UVM_MEDIUM);


            #20;
        end

        `uvm_info("WR_SEQ", "Write sequence completed", UVM_LOW);
    endtask
endclass
