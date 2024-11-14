////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT FIFOif);
 
localparam max_fifo_addr = $clog2(FIFOif.FIFO_DEPTH);

reg [FIFOif.FIFO_WIDTH-1:0] mem [FIFOif.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		wr_ptr <= 0;
		FIFOif.overflow <= 0;
	end else begin
		if (FIFOif.wr_en && count < FIFOif.FIFO_DEPTH) begin
			mem[wr_ptr] <= FIFOif.data_in;
			FIFOif.wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
			FIFOif.overflow <= 0;
		end
		else begin 
			FIFOif.wr_ack <= 0; 
			if (FIFOif.full && FIFOif.wr_en)
				FIFOif.overflow <= 1;  /* sequential output */
			else
				FIFOif.overflow <= 0;  /* sequential output */
		end
	end
end

always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		rd_ptr <= 0;
		FIFOif.underflow <= 0;
	end else begin
		if (FIFOif.rd_en && count != 0) begin  
			FIFOif.data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
			FIFOif.underflow = 0;
		end
		else begin
			if (FIFOif.rd_en && FIFOif.empty)
				FIFOif.underflow <= 1;  /* sequential output */
			else
				FIFOif.underflow <= 0;  /* sequential output */
		end
	end
end

always @(posedge FIFOif.clk or negedge FIFOif.rst_n) begin
	if (!FIFOif.rst_n) begin
		count <= 0;
	end
	else begin
		if(({FIFOif.wr_en, FIFOif.rd_en} == 2'b11) && FIFOif.empty )
			count <= count + 1;
		else if(({FIFOif.wr_en, FIFOif.rd_en} == 2'b11) && FIFOif.full )
			count <= count - 1;
		else if	( FIFOif.wr_en && !FIFOif.full)  
			count <= count + 1;
		else if ( FIFOif.rd_en && !FIFOif.empty)
			count <= count - 1;
	end
end

assign FIFOif.full = (count == FIFOif.FIFO_DEPTH)? 1 : 0;		
assign FIFOif.empty = (count == 0)? 1 : 0;
// assign underflow = (empty && rd_en)? 1 : 0; 
assign FIFOif.almostfull = (count == FIFOif.FIFO_DEPTH-1)? 1 : 0;  
assign FIFOif.almostempty = (count == 1)? 1 : 0;

`ifdef SIM
/*---------------------------Assertions---------------------------*/
    /*---------------------Async_assertions----------------------*/
    always_comb begin : Async_assertion
        /*----------full_assertion---------*/
        if(count == FIFOif.FIFO_DEPTH)begin
			full_flag_assert: assert final(FIFOif.full == 1'b1)
						else $error("full flag assertion failed ");
			full_flag_cover : cover (FIFOif.full == 1'b1);
        end 
        /*----------empty_assertion---------*/
        else if(count == 0)
            begin
                empty_flag_assert: assert final(FIFOif.empty == 1'b1)
                                else $error("empty flag assertion failed ");
                empty_flag_cover:  cover (FIFOif.empty == 1'b1);
            end
        /*-------almostfull_assertion-------*/
        else if(count == FIFOif.FIFO_DEPTH-1)
			begin
                almostfull_flag_assert: assert final(FIFOif.almostfull == 1'b1)
                            else $error("almostfull flag assertion failed ");
                almostfull_flag_cover:  cover (FIFOif.almostfull == 1'b1); 
            end
        /*-------almostempty_assertion------*/
        else if(count == 1)
			begin
                almostempty_flag_assert: assert final(FIFOif.almostempty == 1'b1)
                            else $error("almostempty flag assertion failed ");
                almostempty_flag_cover:  cover (FIFOif.almostempty == 1'b1); 
            end
    end

    /*---------------------Sync_assertions-----------------------*/
    /*------------overflow_assertion------------*/
    property overflow_seq;
        @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n) ((FIFOif.full & FIFOif.wr_en) |-> @(negedge FIFOif.clk) (FIFOif.overflow == 1'b1));
    endproperty
    Overflow_flag_assert: assert property (overflow_seq)
                else $error("Overflow flag assertion failed ");
    Overflow_flag_cover:  cover property (overflow_seq);

    /*------------underflow_assertion------------*/
    property underflow_seq;
        @(posedge FIFOif.clk) disable iff(!FIFOif.rst_n) ((FIFOif.empty & FIFOif.rd_en) |-> @(negedge FIFOif.clk) (FIFOif.underflow == 1'b1));
    endproperty
    underflow_flag_assert: assert property (underflow_seq)
                else $error("underflow flag assertion failed ");
    underflow_flag_cover:  cover property (underflow_seq);

`endif

endmodule