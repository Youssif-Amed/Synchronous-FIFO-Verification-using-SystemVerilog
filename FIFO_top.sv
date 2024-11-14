module FIFO_top ();
    bit clk;

    //clock generation
    initial begin
        clk = 0;
        forever
        #10 clk = ~clk;
    end

    // interface
    FIFO_if FIFOif (clk);
    //dut
    FIFO DUT (FIFOif);
    //testbench
    FIFO_tb TEST(FIFOif);
    //monitor
    FIFO_monitor MONITOR (FIFOif);

    // bind vending_machine vending_SVA vend_SVA_inst(Vend_SVA); 

endmodule