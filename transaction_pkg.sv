package transaction_pkg;
   /*----------------Parameters-----------------*/
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    class FIFO_transaction;

        /*---------------Input Ports-----------------*/
        randc logic [FIFO_WIDTH-1:0] data_in;
        rand  logic rst_n, wr_en, rd_en;
        /*---------------Output Ports-----------------*/
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow, underflow;
        logic full, empty, almostfull, almostempty;
        /*----------Constrains Distribution-----------*/
        int WR_EN_ON_DIST,RD_EN_ON_DIST;

        /*--------------Reset Constrains--------------*/
        constraint reset_const{
            rst_n dist { 1:= 90 , 0:=10 };
        }

        /*--------------Wr_en Constrains--------------*/
        constraint write_en_const{
            wr_en dist { 1:=WR_EN_ON_DIST , 0:=100-WR_EN_ON_DIST };
        }

        /*--------------rd_en Constrains--------------*/
        constraint read_en_const{
            rd_en dist { 1:=RD_EN_ON_DIST , 0:=(100-RD_EN_ON_DIST) };
        }

        /*----------------Constructor-----------------*/
        function new(logic rst_n = 1, int WR_EN_ON_DIST = 70, int RD_EN_ON_DIST = 30);
            this.RD_EN_ON_DIST = RD_EN_ON_DIST;
            this.WR_EN_ON_DIST = WR_EN_ON_DIST;
            this.rst_n = rst_n;
            this.data_in = 0;
            this.wr_en = 0;
            this.rd_en = 0;
        endfunction //new()
    endclass //FIFO_transaction

endpackage