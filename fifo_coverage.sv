`ifndef FIFO_COVERAGE_SV
`define FIFO_COVERAGE_SV

class fifo_coverage extends uvm_subscriber #(fifo_seq_item);
  `uvm_component_utils(fifo_coverage)

  fifo_seq_item cov_item;

  covergroup fifo_cg @(cov_item);
    option.per_instance = 1;

    
    wdata_cp : coverpoint cov_item.wdata {
      bins low   = {[0:63]};
      bins mid   = {[64:127]};
      bins high  = {[128:191]};
      bins upper = {[192:255]};
    }

    
    rdata_cp : coverpoint cov_item.rdata {
      bins low   = {[0:63]};
      bins mid   = {[64:127]};
      bins high  = {[128:191]};
      bins upper = {[192:255]};
    }

    
    op_cp : coverpoint {cov_item.write, cov_item.read} {
      bins write_op = {2'b10};
      bins read_op  = {2'b01};
      bins illegal  = {2'b11};
    }

    
    wfull_cp : coverpoint cov_item.wfull {
      bins full = {1};
      bins notfull = {0};
    }

    rempty_cp: coverpoint cov_item.rempty {
      bins empty = {1};
      bins notempty = {0};
    }

  
    op_x_wdata : cross op_cp, wdata_cp;
    op_x_rdata : cross op_cp, rdata_cp;
    bad_ops : cross op_cp, wfull_cp, rempty_cp;

  endgroup : fifo_cg

  function new(string name, uvm_component parent);
    super.new(name, parent);
    fifo_cg = new();
  endfunction

  virtual function void write(fifo_seq_item t);
    cov_item = t;
    fifo_cg.sample();
    `uvm_info("COV", $sformatf("Coverage sampled: wdata=0x%0h, rdata=0x%0h, write=%0d, read=%0d, full=%0d, empty=%0d",
                                t.wdata, t.rdata, t.write, t.read, t.wfull, t.rempty), UVM_LOW)
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV_REPORT", "Final Coverage Report", UVM_LOW)
    uvm_report_info("COV",
      $sformatf("Coverage = %0.2f%%", fifo_cg.get_inst_coverage()), UVM_NONE);
  endfunction

endclass : fifo_coverage

`endif
