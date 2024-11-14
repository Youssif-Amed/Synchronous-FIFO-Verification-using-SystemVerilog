vlib work
vlog -f src_files.list +cover -covercells -define SIM
# vsim -voptargs=+acc work.FIFO_top -cover -sv_seed random -l sim.log
# vsim -voptargs=+acc work.FIFO_top -cover -sv_seed "3664333789" -l sim.log
vsim -voptargs=+acc work.FIFO_top -cover

add wave /FIFO_top/FIFOif/*
add wave /FIFO_top/TEST/FIFO_tb_tr
add wave /FIFO_top/DUT/wr_ptr
add wave /FIFO_top/DUT/rd_ptr
add wave /FIFO_top/DUT/count
add wave /FIFO_top/MONITOR/FIFO_mon_sb.count
add wave /FIFO_top/DUT/mem
add wave /FIFO_top/MONITOR/FIFO_mon_sb.mem_copy
add wave /FIFO_top/MONITOR/FIFO_mon_sb
add wave /FIFO_top/MONITOR/FIFO_mon_tr
add wave /FIFO_top/MONITOR/FIFO_mon_sb.full_ref
add wave /FIFO_top/FIFOif.full
add wave /FIFO_top/MONITOR/FIFO_mon_sb.empty_ref
add wave /FIFO_top/FIFOif.empty
add wave /FIFO_top/MONITOR/FIFO_mon_sb.almostempty_ref
add wave /FIFO_top/FIFOif.almostempty
add wave /FIFO_top/MONITOR/FIFO_mon_sb.almostfull_ref
add wave /FIFO_top/FIFOif.almostfull
add wave /FIFO_top/MONITOR/FIFO_mon_sb.overflow_ref
add wave /FIFO_top/FIFOif.overflow
add wave /FIFO_top/MONITOR/FIFO_mon_sb.underflow_ref
add wave /FIFO_top/FIFOif.underflow

add wave /FIFO_top/DUT/Overflow_flag_assert
add wave /FIFO_top/DUT/underflow_flag_assert
add wave /FIFO_top/DUT/Async_assertion/full_flag_assert
add wave /FIFO_top/DUT/Async_assertion/empty_flag_assert
add wave /FIFO_top/DUT/Async_assertion/almostfull_flag_assert
add wave /FIFO_top/DUT/Async_assertion/almostempty_flag_assert

coverage save -onexit FIFO.ucdb
run -all

# vcover report FIFO.ucdb -details -annotate -all -output FIFO_cover_rpt.txt
# vcover report ALSU_tb.ucdb -details -annotate -all -output ALSU_cover_rpt.html
# vcover merge dff_merged.ucdb dff_t1.ucdb dff_t2.ucdb -du dff
