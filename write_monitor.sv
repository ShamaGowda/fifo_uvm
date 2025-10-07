
class write_monitor extends uvm_monitor;
    `uvm_component_utils(write_monitor)

//    virtual write_interface vif;
virtual fifo_if vif;

    uvm_analysis_port #(fifo_seq_item) item_collected_port;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
//        if (!uvm_config_db#(virtual write_interface)::get(this, "", "write_vif", vif)) begin
  //          `uvm_fatal("NO_VIF", "Write interface not found")
     //   end
if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
   `uvm_fatal("NO_VIF", "fifo_if not found")

    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            fifo_seq_item item = fifo_seq_item::type_id::create("item");
            @(vif.wr_mon_cb);
            if (vif.wrst_n && vif.wr_mon_cb.winc && !vif.wr_mon_cb.wfull) begin
                item.write = 1;
                item.read = 0;
                item.wdata = vif.wr_mon_cb.wdata;
                item.wfull = vif.wr_mon_cb.wfull;
                item_collected_port.write(item);
                `uvm_info("WR_MON", $sformatf("Captured write: 0x%0h, full=%0d", item.wdata, item.wfull), UVM_HIGH)
            end
        end
    endtask
endclass
