class write_driver extends uvm_driver #(fifo_seq_item);
    `uvm_component_utils(write_driver)


  virtual fifo_if vif;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

      if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
             `uvm_fatal("NO_VIF", "fifo_if not found")

    endfunction

    virtual task run_phase(uvm_phase phase);

        vif.wr_drv_cb.wdata <= 0;
        vif.wr_drv_cb.winc <= 0;
        vif.wrst_n <= 1;

        forever begin
            seq_item_port.get_next_item(req);
            drive_write(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive_write(fifo_seq_item item);
        if (item.write) begin
            int wait_count = 0;

            //while (vif.wr_drv_cb.wfull && wait_count < 50) begin
              //  @(posedge vif.wclk);
                //wait_count++;
                //`uvm_info("WR_DRV", $sformatf("FIFO full, waiting to write (wait_count=%0d)", wait_count), UVM_HIGH)
           // end

           // if (vif.wr_drv_cb.wfull) begin
             //   `uvm_warning("WR_DRV", "FIFO still full after timeout, skipping write")
               // return;
            //end

            @(vif.wr_drv_cb);
            vif.wr_drv_cb.wdata <= item.wdata;
            vif.wr_drv_cb.winc <= 1;
            `uvm_info("WR_DRV", $sformatf("Driving write: data=0x%0h, full=%0d", item.wdata, vif.wr_drv_cb.wfull), UVM_MEDIUM)

            @(vif.wr_drv_cb);
            vif.wr_drv_cb.winc <= 0;
        end
    endtask
endclass
