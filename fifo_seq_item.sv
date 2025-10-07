class fifo_seq_item extends uvm_sequence_item;
    randc  bit [7:0] wdata;
    randc bit write;
    randc bit read;
    bit [7:0] rdata;
    bit wfull;
    bit rempty;

    `uvm_object_utils_begin(fifo_seq_item)
        `uvm_field_int(wdata, UVM_ALL_ON)
        `uvm_field_int(write, UVM_ALL_ON)
        `uvm_field_int(read, UVM_ALL_ON)
        `uvm_field_int(rdata, UVM_ALL_ON)
        `uvm_field_int(wfull, UVM_ALL_ON)
        `uvm_field_int(rempty, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "fifo_seq_item");
        super.new(name);
    endfunction

    constraint valid_operation {
        write != read;
    }
endclass
