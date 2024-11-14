import shared_pkg::*;
import transaction_pkg::*;

module FIFO_tb (FIFO_if.TEST FIFOif);
    /*---------------------create a handler-----------------------*/
    FIFO_transaction FIFO_tb_tr;

    /*----------------------Stimulus test-------------------------*/
    initial begin
        FIFO_tb_tr = new();   // constructor the handle
        $display("Start Simulation");
        FIFOif.rst_n = 0;
        repeat(2) @(negedge FIFOif.clk); 
        FIFOif.rst_n = 1;
        connect_outputs();
        @(negedge FIFOif.clk); 
    
        /* connect the class_FIFO_transaction to FIFO_interface */
       // connect_class_to_if();
        
        /*---------------randomized the inputs-------------*/
        repeat(2000)begin
            assert(FIFO_tb_tr.randomize());
            connect_class_to_if();  
            @(negedge FIFOif.clk);
            connect_outputs();
        end
        
        $display("End Simulation");
        test_finished = 1;
        #5;
        $stop;
    end 

    /*-----Assign data of transaction class to interface----------*/
    task connect_class_to_if();
        FIFOif.data_in     = FIFO_tb_tr.data_in; 
        FIFOif.rst_n       = FIFO_tb_tr.rst_n;
        FIFOif.wr_en       = FIFO_tb_tr.wr_en;
        FIFOif.rd_en       = FIFO_tb_tr.rd_en;
    endtask 

    task reset_if_signals();
        FIFOif.data_in     = 0; 
        FIFOif.rst_n       = 0;
        FIFOif.wr_en       = 0;
        FIFOif.rd_en       = 0;
    endtask 
     
    /*----Assign output data of interface to transaction class----*/
    task connect_outputs();
        FIFO_tb_tr.data_out    = FIFOif.data_out;
        FIFO_tb_tr.wr_ack      = FIFOif.wr_ack;
        FIFO_tb_tr.overflow    = FIFOif.overflow;
        FIFO_tb_tr.full        = FIFOif.full;
        FIFO_tb_tr.empty       = FIFOif.empty;
        FIFO_tb_tr.almostempty = FIFOif.almostempty;
        FIFO_tb_tr.almostfull  = FIFOif.almostfull;
        FIFO_tb_tr.underflow   = FIFOif.underflow;
    endtask  
endmodule