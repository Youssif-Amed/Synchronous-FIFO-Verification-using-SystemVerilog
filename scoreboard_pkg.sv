package scoreboard_pkg;
    import transaction_pkg::*;
    import shared_pkg::*;

    class FIFO_scoreboard;
        /*---------------Output Ports-----------------*/
        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        /*-------------FIFO memory Copy---------------*/
        logic [FIFO_WIDTH-1:0] mem_copy [FIFO_DEPTH-1:0];
        logic [$clog2(FIFO_DEPTH)-1:0]wr_ptr ;
        logic [$clog2(FIFO_DEPTH)-1:0]rd_ptr ;
        logic [$clog2(FIFO_DEPTH):0]count;
        // logic [FIFO_WIDTH-1:0]temp_data;


        /*-----------------Constructor----------------*/
        function new();
            this.data_out_ref    = 0;
            this.full_ref        = 0;
            this.empty_ref       = 1;
            this.almostfull_ref  = 0;
            this.almostempty_ref = 0;
            this.wr_ack_ref      = 0;
            this.overflow_ref    = 0;
            this.underflow_ref   = 0;
            /*-------------FIFO memory Init---------------*/
            // Intialize FIFO memory
            for (int i = 0 ; i< FIFO_DEPTH ; ++i ) begin
                mem_copy[i] = 0;
            end
            //temp_data = 0;
            wr_ptr = 0;
            rd_ptr = 0;
            count  = 0;
        endfunction // new


        function void check_data(input FIFO_transaction FIFO_score);
            reference_model(FIFO_score);

            // compare the data_out 
            if(FIFO_score.data_out != data_out_ref)begin
                error_count ++;
                $display("Error : data_out mismatch. Expected: %02h, GOT: %02h",data_out_ref,FIFO_score.data_out);
            end 

            // compare the full flag 
            else if(FIFO_score.full != full_ref)begin
                error_count ++;
                $display("Error : full mismatch. Expected: %01h, GOT: %01h",full_ref,FIFO_score.full);
            end 

            // compare the empty flag 
            else if(FIFO_score.empty != empty_ref)begin
                error_count ++;
                $display("Error : empty mismatch. Expected: %01h, GOT: %01h",empty_ref,FIFO_score.empty);
            end 

            // compare the almostfull flag 
            else if(FIFO_score.almostfull != almostfull_ref)begin
                error_count ++;
                $display("Error : almostfull mismatch. Expected: %01h, GOT: %01h",almostfull_ref,FIFO_score.almostfull);
            end 

            // compare the almostempty flag 
            else if(FIFO_score.almostempty != almostempty_ref)begin
                error_count ++;
                $display("Error : almostempty mismatch. Expected: %01h, GOT: %01h",almostempty_ref,FIFO_score.almostempty);
            end 

            // compare the Write acknowledge flag 
            else if(FIFO_score.wr_ack != wr_ack_ref)begin
                error_count ++;
                $display("Error : Write_ack mismatch. Expected: %01h, GOT: %01h",wr_ack_ref,FIFO_score.wr_ack);
            end 

            // compare the Overflow flag 
            else if(FIFO_score.overflow != overflow_ref)begin
                error_count ++;
                $display("Error : overflow mismatch. Expected: %01h, GOT: %01h",overflow_ref,FIFO_score.overflow);
            end 

            // compare the Underflow flag 
            else if(FIFO_score.underflow != underflow_ref)begin
                $display("Error : underflow mismatch. Expected: %01h, GOT: %01h",underflow_ref,FIFO_score.underflow);
                error_count ++;
            end 
            // all match
            else begin
                correct_count ++;
            end
            //Display final counts
            $display("%03t, Errors : %0d, Correct: %0d",$time,error_count,correct_count);
            return;
        endfunction

        function void reference_model(input FIFO_transaction FIFO_ref);
            // reset
            if (!FIFO_ref.rst_n) begin
                wr_ptr <= 0;
                rd_ptr <= 0;
                count <= 0;
                overflow_ref <= 0;
                underflow_ref <= 0;
                // reset output values
                // data_out_ref    = 0;
            end else begin
                //write operation
                if(FIFO_ref.wr_en && (count < FIFO_DEPTH)) begin
                    mem_copy[wr_ptr] <= FIFO_ref.data_in;
                    wr_ptr <= wr_ptr + 1 ;   
                    wr_ack_ref <= 1;
                    overflow_ref <= 0;
                end else begin
                    wr_ack_ref <= 0;
                    if(FIFO_ref.wr_en  && (count == FIFO_DEPTH))
                        overflow_ref <= 1;
                    else
                        overflow_ref <= 0;
                end

                //read operation
                if(FIFO_ref.rd_en &&  (count != 0))begin
                    data_out_ref <= mem_copy[rd_ptr];
                    rd_ptr <= rd_ptr + 1 ;
                    underflow_ref <= 0;
                end else begin 
                        if (FIFO_ref.rd_en && (count == 0))
                            underflow_ref <= 1;
                        else
                            underflow_ref <= 0;
                end 

                // count operation
                if(({FIFO_ref.wr_en, FIFO_ref.rd_en} == 2'b11) && (count == 0) )
                    count <= count + 1;
                else if(({FIFO_ref.wr_en, FIFO_ref.rd_en} == 2'b11) && (count == FIFO_DEPTH) )
                    count <= count - 1;
                else if	( FIFO_ref.wr_en && count != FIFO_DEPTH)  
                    count <= count + 1;
                else if ( FIFO_ref.rd_en && count != 0)
                    count <= count - 1;
            end

            //flags update
            full_ref        = (count == FIFO_DEPTH)? 1 : 0;
            empty_ref       = (count == 0)? 1 : 0;
            almostfull_ref  = (count == FIFO_DEPTH-1)? 1 : 0;
            almostempty_ref = (count == 1)? 1 : 0; 
        endfunction
    endclass
endpackage