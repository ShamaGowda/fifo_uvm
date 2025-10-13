class read_sequence extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(read_sequence)

    int num_transactions = 17;

    function new(string name = "read_sequence");
        super.new(name);
    endfunction

    virtual task body();
        fifo_seq_item req;

        for (int i = 0; i < num_transactions; i++) begin
            req = fifo_seq_item::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {
                winc == 0;
                rinc == 1;
            }) begin
                `uvm_error("RANDOMIZE", "Randomization failed for read sequence")
            end
            finish_item(req);
            `uvm_info("RD_SEQ", $sformatf("Read transaction %0d", i), UVM_MEDIUM)
           // #30;
        end
        `uvm_info("RD_SEQ", "Read sequence completed", UVM_LOW)
    endtask
endclass

class read_sequence1 extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(read_sequence1)

    int num_transactions = 10;

    function new(string name = "read_sequence1");
        super.new(name);
    endfunction

    virtual task body();
        fifo_seq_item req;

        for (int i = 0; i < num_transactions; i++) begin
            req = fifo_seq_item::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {
                winc == 0;
                rinc == 1;
            }) begin
                `uvm_error("RANDOMIZE", "Randomization failed for read sequence")
            end
            finish_item(req);
            `uvm_info("RD_SEQ", $sformatf("Read transaction %0d", i), UVM_MEDIUM)
            #30;
        end
        `uvm_info("RD_SEQ", "Read sequence completed", UVM_LOW)
    endtask
endclass


class read_sequence2 extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(read_sequence2)

    int num_transactions = 10;

    function new(string name = "read_sequence2");
        super.new(name);
    endfunction

    virtual task body();
        fifo_seq_item req;

        for (int i = 0; i < num_transactions; i++) begin
            req = fifo_seq_item::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {
                winc == 0;
                rinc == 1;
            }) begin
                `uvm_error("RANDOMIZE", "Randomization failed for read sequence")
            end
            finish_item(req);
            `uvm_info("RD_SEQ", $sformatf("Read transaction %0d", i), UVM_MEDIUM)
    //        #30;
        end
        `uvm_info("RD_SEQ", "Read sequence completed", UVM_LOW)
    endtask
endclass


class read_sequence3 extends uvm_sequence #(fifo_seq_item);
    `uvm_object_utils(read_sequence3)

    int num_transactions = 10;

    function new(string name = "read_sequence2");
        super.new(name);
    endfunction

    virtual task body();
        fifo_seq_item req;

        for (int i = 0; i < num_transactions; i++) begin
            req = fifo_seq_item::type_id::create("req");
            start_item(req);
            if (!req.randomize() with {
                winc == 0;
                rinc == 1;
            }) begin
                `uvm_error("RANDOMIZE", "Randomization failed for read sequence")
            end
            finish_item(req);
            `uvm_info("RD_SEQ", $sformatf("Read transaction %0d", i), UVM_MEDIUM)
            #30;
        end
        `uvm_info("RD_SEQ", "Read sequence completed", UVM_LOW)
    endtask
endclass
