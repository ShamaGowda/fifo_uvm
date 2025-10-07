interface fifo_if(input bit wclk, input bit rclk);

  logic [7:0] wdata;
  logic       winc;
  logic       wrst_n;
  logic       wfull;

  logic [7:0] rdata;
  logic       rinc;
  logic       rrst_n;
  logic       rempty;

  clocking wr_drv_cb @(posedge wclk);
    output wdata, winc;
    input  wfull;
  endclocking

  clocking wr_mon_cb @(posedge wclk);
    input  wdata, winc, wfull;
  endclocking

  clocking rd_drv_cb @(posedge rclk);
    output rinc;
    input  rempty, rdata;
  endclocking

  clocking rd_mon_cb @(posedge rclk);
    input  rinc, rempty, rdata;
  endclocking

  modport WR_DRIVER  (clocking wr_drv_cb, output wrst_n);
  modport WR_MONITOR (clocking wr_mon_cb, input wrst_n);
  modport RD_DRIVER  (clocking rd_drv_cb, output rrst_n);
  modport RD_MONITOR (clocking rd_mon_cb, input rrst_n);


  property no_write_when_full;
    @(posedge wclk) disable iff (!wrst_n) !(winc && wfull);
  endproperty
  assert_no_write_when_full: assert property(no_write_when_full)
    else `uvm_error("SVA", "Write attempted when FIFO is FULL");

  property no_read_when_empty;
    @(posedge rclk) disable iff (!rrst_n) !(rinc && rempty);
  endproperty
  assert_no_read_when_empty: assert property(no_read_when_empty)
    else `uvm_error("SVA", "Read attempted when FIFO is EMPTY");

  property full_and_empty_never_same_w;
    @(posedge wclk) !(wfull && rempty);
  endproperty
  assert_full_and_empty_never_same_w: assert property(full_and_empty_never_same_w)
    else `uvm_error("SVA", "FIFO flagged FULL and EMPTY at same time");

  property full_and_empty_never_same_r;
    @(posedge rclk) !(wfull && rempty);
  endproperty
  assert_full_and_empty_never_same_r: assert property(full_and_empty_never_same_r)
    else `uvm_error("SVA", "FIFO flagged FULL and EMPTY at same time");

  property reset_clears_fifo;
    @(posedge wclk) (!wrst_n) |-> (wfull==0 && rempty==1);
  endproperty
  assert_reset_clears_fifo: assert property(reset_clears_fifo)
    else `uvm_error("SVA", "FIFO not cleared correctly after reset");

endinterface
