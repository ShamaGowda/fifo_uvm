`include "fifo_pkg.sv"
import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

`timescale 1ns/1ns

`include "interface.sv"
`include "design.sv"

module top;
    bit wclk, rclk;


    initial begin
        wclk = 0;
        forever #5 wclk = ~wclk;
    end

    initial begin
        rclk = 0;

        forever #10 rclk = ~rclk;
    end

    fifo_if fifo_if_inst(.wclk(wclk), .rclk(rclk));


    FIFO #(.DSIZE(8), .ASIZE(4)) dut (
        .rdata (fifo_if_inst.rdata),
        .wfull (fifo_if_inst.wfull),
        .rempty(fifo_if_inst.rempty),
        .wdata (fifo_if_inst.wdata),
        .winc  (fifo_if_inst.winc),
        .wclk  (wclk),
        .wrst_n(fifo_if_inst.wrst_n),
        .rinc  (fifo_if_inst.rinc),
        .rclk  (rclk),
        .rrst_n(fifo_if_inst.rrst_n)
    );


    initial begin

        fifo_if_inst.wrst_n = 0;
        fifo_if_inst.rrst_n = 0;
        fifo_if_inst.wdata  = 0;
        fifo_if_inst.winc   = 0;
        fifo_if_inst.rinc   = 0;


        uvm_config_db#(virtual fifo_if)::set(null, "*", "vif", fifo_if_inst);

        `uvm_info("TOP", "Starting UVM test at time 0", UVM_LOW)
        run_test("base_test");
    end


    initial begin
        $dumpfile("fifo_waves.vcd");
        $dumpvars(0, top);
        `uvm_info("TOP", "Waveform dumping enabled", UVM_LOW)
    end


    initial begin
        #500000000;
        `uvm_info("TOP", "Simulation timeout", UVM_LOW)
        $finish;
    end
    initial begin
        #1;
        forever begin
            @(fifo_if_inst.wrst_n or fifo_if_inst.rrst_n);
            $display("[%0t] RESET: Write_Rst_n=%b, Read_Rst_n=%b",
                     $time, fifo_if_inst.wrst_n, fifo_if_inst.rrst_n);
        end
    end
    endmodule
