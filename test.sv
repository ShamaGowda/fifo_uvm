`include "uvm_macros.svh"
import uvm_pkg::*;

class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    fifo_env env;
    virtual_sequence v_seq;

    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("TEST", "Building test", UVM_LOW)
        env = fifo_env::type_id::create("env", this);
        v_seq = virtual_sequence::type_id::create("v_seq");


        v_seq.num_writes = 10000;
        v_seq.num_reads = 10000;
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this, "Starting test");
        `uvm_info("TEST", "Starting test run phase", UVM_LOW)


        apply_reset();


        `uvm_info("TEST", "Starting virtual sequence", UVM_LOW)
        v_seq.start(env.v_seqr);


        #10000;
        `uvm_info("TEST", "Test completed", UVM_LOW)
        phase.drop_objection(this, "Test completed");
    endtask

    virtual task apply_reset();
        `uvm_info("TEST", "Applying reset", UVM_LOW)


        env.wr_agent.wr_driver.vif.wrst_n <= 0;
        env.rd_agent.rd_driver.vif.rrst_n <= 0;


        repeat(10) @(posedge env.wr_agent.wr_driver.vif.wclk);


        env.wr_agent.wr_driver.vif.wrst_n <= 1;
        env.rd_agent.rd_driver.vif.rrst_n <= 1;

        `uvm_info("TEST", "Reset released", UVM_LOW)


        repeat(5) @(posedge env.wr_agent.wr_driver.vif.wclk);
    endtask
endclass
