class read_monitor extends uvm_monitor;
    `uvm_component_utils(read_monitor)

//    virtual read_interface vif;
    uvm_analysis_port #(fifo_seq_item) item_collected_port;
  virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
//        if (!uvm_config_db#(virtual read_interface)::get(this, "", "read_vif", vif)) begin
  //          `uvm_fatal("NO_VIF", "Read interface not found")
    //    end
if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
   `uvm_fatal("NO_VIF", "fifo_if not found")

    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            fifo_seq_item item = fifo_seq_item::type_id::create("item");
            @(vif.rd_mon_cb);
            if (vif.rrst_n && vif.rd_mon_cb.rinc && !vif.rd_mon_cb.rempty) begin
                item.read = 1;
                item.write = 0;
                item.rdata = vif.rd_mon_cb.rdata;
                item.rempty = vif.rd_mon_cb.rempty;
                item_collected_port.write(item);
                `uvm_info("RD_MON", $sformatf("Captured read: 0x%0h, empty=%0d", item.rdata, item.rempty), UVM_HIGH)
            end
        end
    endtask
endclass

