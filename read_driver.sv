class read_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(read_driver)

//    virtual read_interface vif;
  virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
  //      if (!uvm_config_db#(virtual read_interface)::get(this, "", "read_vif", vif)) begin
      //      `uvm_fatal("NO_VIF", "Read interface not found")
    //    end
   if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
   `uvm_fatal("NO_VIF", "fifo_if not found")

    endfunction

    virtual task run_phase(uvm_phase phase);
        // Initialize signals
        vif.rd_drv_cb.rinc <= 0;
        vif.rrst_n <= 1;

        forever begin
            seq_item_port.get_next_item(req);
            drive_read(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_read(fifo_seq_item item);
        if (item.read) begin
            int wait_count = 0;
            // Wait until not empty with timeout
            //while (vif.rd_drv_cb.rempty && wait_count < 50) begin
              //  @(posedge vif.rclk);
                //wait_count++;
                //`uvm_info("RD_DRV", $sformatf("FIFO empty, waiting to read (wait_count=%0d)", wait_count), UVM_HIGH)
            //end

            //if (vif.rd_drv_cb.rempty) begin
              //  `uvm_warning("RD_DRV", "FIFO still empty after timeout, skipping read")
                //return;
           // end

            @(vif.rd_drv_cb);
            vif.rd_drv_cb.rinc <= 1;
            `uvm_info("RD_DRV", $sformatf("Driving read, empty=%0d", vif.rd_drv_cb.rempty), UVM_MEDIUM)

            @(vif.rd_drv_cb);
            vif.rd_drv_cb.rinc <= 0;
            `uvm_info("RD_DRV", $sformatf("Read completed: data=0x%0h, empty=%0d", vif.rd_drv_cb.rdata, vif.rd_drv_cb.rempty), UVM_MEDIUM)
        end
    endtask
endclass
