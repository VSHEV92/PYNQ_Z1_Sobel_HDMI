# скрипт для запуска теста IP ядра фильтра Собела
open_project Sobel_Filter

set_top sobel_filter

add_files hls_source/sobel_filter.cpp
add_files hls_source/sobel_filter.hpp
add_files -tb hls_source/sobel_filter.cpp

open_solution "solution1"
set_part {xc7z020-clg400-1}
create_clock -period 6.5 -name default

#config_sdx -target none
#config_export -format ip_catalog -rtl verilog -vivado_optimization_level 2 -vivado_phys_opt place -vivado_report_level 0
#set_clock_uncertainty 12.5%
#source "./test/solution1/directives.tcl"

csim_design
#csynth_design
#cosim_design
#export_design -rtl verilog -format ip_catalog
exit
