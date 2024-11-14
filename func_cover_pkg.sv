package func_cover_pkg;
    import transaction_pkg::*;
    import shared_pkg::*;

    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;  // handle of FIFO_transaction
        
        /*---------------Covergroup-----------------*/
        covergroup FIFO_COV ;
            wr_en_cp:       coverpoint F_cvg_txn.wr_en{
                bins wr_en_0 = {0};
                bins wr_en_1 = {1};
                //option.weight = 0;
            }
            rd_en_cp:       coverpoint F_cvg_txn.rd_en {
                bins  rd_en_0 = {0};
                bins  rd_en_1 = {1};
                //option.weight = 0;
            }
            wr_ack_cp:      coverpoint F_cvg_txn.wr_ack {
                bins  wr_ack_0 = {0};
                bins  wr_ack_1 = {1};
                //option.weight = 0;
            }
            overflow_cp:    coverpoint F_cvg_txn.overflow{
                bins  overflow_0 = {0};
                bins  overflow_1 = {1};
                //option.weight = 0;
            }
            underflow_cp:   coverpoint F_cvg_txn.underflow{
                bins  underflow_0 = {0};
                bins  underflow_1 = {1};
                //option.weight = 0;
            }
            full_cp:        coverpoint F_cvg_txn.full{
                bins  full_0 = {0};
                bins  full_1 = {1};
                //option.weight = 0;
            }
            almostfull_cp:  coverpoint F_cvg_txn.almostfull {
                bins  almostfull_0 = {0};
                bins  almostfull_1 = {1};
                //option.weight = 0;
            }
            empty_cp:       coverpoint F_cvg_txn.empty {
                bins  empty_0 = {0};
                bins  empty_1 = {1};
                //option.weight = 0;
            }
            almostempty_cp: coverpoint F_cvg_txn.almostempty {
                bins  almostempty_0 = {0};
                bins  almostempty_1 = {1};
                //option.weight = 0;
            }

            wr_ack_cross:      cross wr_en_cp, rd_en_cp,  wr_ack_cp;
            overflow_cross:    cross wr_en_cp, rd_en_cp,  overflow_cp;
            underflow_cross:   cross wr_en_cp, rd_en_cp,  underflow_cp;
            full_cross:        cross wr_en_cp, rd_en_cp,  full_cp;
            almostfull_cross:  cross wr_en_cp, rd_en_cp,  almostfull_cp;
            empty_cross:       cross wr_en_cp, rd_en_cp,  empty_cp;
            almostempty_cross: cross wr_en_cp, rd_en_cp,  almostempty_cp;
        endgroup

        /*--------------Constructor-----------------*/
        function new();
            F_cvg_txn = new();
            FIFO_COV  = new();
        endfunction //new()

        /*-------------Sample function--------------*/
        function void sample_data(input FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            FIFO_COV.sample();
        endfunction
    endclass //FIFO_coverage

endpackage