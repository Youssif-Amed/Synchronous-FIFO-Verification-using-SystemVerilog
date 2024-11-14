import transaction_pkg::*;
import func_cover_pkg::*;
import scoreboard_pkg::*;
import shared_pkg::*;

module FIFO_monitor (FIFO_if.MONITOR FIFOif);
    FIFO_transaction FIFO_mon_tr;
    FIFO_scoreboard  FIFO_mon_sb;
    FIFO_coverage    FIFO_mon_cov;

    initial begin
        FIFO_mon_tr    = new();
        FIFO_mon_cov   = new();
        FIFO_mon_sb    = new();
        //repeat(2) @(negedge FIFOif.clk);
        //@(negedge FIFOif.clk);
        forever begin : FOREVER
            @(negedge FIFOif.clk);
            sample_data_if_to_class_tr();

            fork
                begin
                //process-1
                FIFO_mon_cov.sample_data(FIFO_mon_tr);
                end

                //process-2
                begin
                // $display("%t, check ---",$time);
                FIFO_mon_sb.check_data(FIFO_mon_tr);
                end
            join
            if(test_finished)begin
                $display("Test finished : Correct: %0d, Errors: %0d",correct_count,error_count);
            end
        end
    end 

    task sample_data_if_to_class_tr();
        FIFO_mon_tr.data_in    = FIFOif.data_in; 
        FIFO_mon_tr.rst_n      = FIFOif.rst_n;
        FIFO_mon_tr.wr_en      = FIFOif.wr_en;
        FIFO_mon_tr.rd_en      = FIFOif.rd_en;
        FIFO_mon_tr.data_out   = FIFOif.data_out;
        FIFO_mon_tr.wr_ack     = FIFOif.wr_ack;
        FIFO_mon_tr.overflow   = FIFOif.overflow;
        FIFO_mon_tr.underflow  = FIFOif.underflow;
        FIFO_mon_tr.full       = FIFOif.full;
        FIFO_mon_tr.almostfull = FIFOif.almostfull;
        FIFO_mon_tr.empty      = FIFOif.empty;
        FIFO_mon_tr.almostempty = FIFOif.almostempty;
    endtask 

endmodule