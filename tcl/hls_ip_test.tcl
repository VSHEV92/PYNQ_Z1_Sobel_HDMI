# скрипт для запуска теста IP ядра фильтра Собела
open_project Sobel_Filter

set_top sobel_filter

add_files hls_source/sobel_filter.cpp
add_files hls_source/sobel_filter.hpp
add_files -tb hls_source/sobel_filter.cpp

open_solution "solution1"
set_part {xc7z020-clg400-1}
create_clock -period 6.5 -name default

csim_design

exit
