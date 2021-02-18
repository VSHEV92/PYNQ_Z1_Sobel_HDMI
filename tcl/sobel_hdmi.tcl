# --------------------------------------------------------------
# ------- Cкрипт для автоматического создания проекта ----------
# --------------------------------------------------------------
# Демонстрационный проект для платы PYNQ Z1 Board. Данные 
# принимаются по HDMI, фильтруются и выдаются в HDMI 
# -----------------------------------------------------------

set Project_Name sobel_hdmi

# если проект с таким именем существует удаляем его
close_sim -quiet 
close_project -quiet
if { [file exists $Project_Name] != 0 } { 
	file delete -force $Project_Name
	puts "Delete old Project"
}

# создаем проект
create_project $Project_Name ./$Project_Name -part xc7z020clg400-1

# запускаем скрипт по упаковке ядра и добавляем репозиторий
if { [file exists Sobel_Filter/solution1/impl/ip] == 0 } {
	puts "-------------------------------------------" 
	puts "--- Run Sobel filter hls package script ---"
	puts "-------------------------------------------" 
	close_project -quiet
} 

# добавляем репозитории ядер к проекту
set_property  ip_repo_paths  {digilent_ip Sobel_Filter/solution1/impl/ip} [current_project]
update_ip_catalog

# настраиваем ip cache
config_ip_cache -import_from_project -use_cache_location ip_cache

# добавляем xdc файлы к проекту
add_files -fileset constrs_1 constarints/debug.xdc
add_files -fileset constrs_1 constarints/pins.xdc 
add_files -fileset constrs_1 constarints/timing.xdc

# создаем block design
create_bd_design "design_1"

# clock wizard
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} CONFIG.MMCM_CLKOUT0_DIVIDE_F {5.000} CONFIG.CLKOUT1_JITTER {114.829}] [get_bd_cells clk_wiz_0]
make_bd_pins_external  [get_bd_pins clk_wiz_0/clk_in1]
set_property CONFIG.FREQ_HZ 125000000 [get_bd_ports clk_in1_0]
set_property name clk_125 [get_bd_ports clk_in1_0]
make_bd_pins_external  [get_bd_pins clk_wiz_0/reset]
set_property name reset_button [get_bd_ports reset_0]

make_bd_pins_external  [get_bd_pins clk_wiz_0/locked]
set_property name HPD [get_bd_ports locked_0]

# DVI to RGB
create_bd_cell -type ip -vlnv digilentinc.com:ip:dvi2rgb:2.0 dvi2rgb_0
set_property -dict [list CONFIG.kRstActiveHigh {false} CONFIG.kClkRange {1} CONFIG.kEdidFileName {dgl_1080p_cea.data}] [get_bd_cells dvi2rgb_0]
make_bd_intf_pins_external  [get_bd_intf_pins dvi2rgb_0/TMDS]
set_property name RX_TMDS [get_bd_intf_ports TMDS_0]

make_bd_intf_pins_external  [get_bd_intf_pins dvi2rgb_0/DDC]
set_property name DDC [get_bd_intf_ports DDC_0]

# RGB to DVI
create_bd_cell -type ip -vlnv digilentinc.com:ip:rgb2dvi:1.4 rgb2dvi_0
set_property -dict [list CONFIG.kRstActiveHigh {false}] [get_bd_cells rgb2dvi_0]
make_bd_intf_pins_external  [get_bd_intf_pins rgb2dvi_0/TMDS]
set_property name TX_TMDS [get_bd_intf_ports TMDS_0]

# video in to axis
create_bd_cell -type ip -vlnv xilinx.com:ip:v_vid_in_axi4s:4.0 v_vid_in_axi4s_0
set_property -dict [list CONFIG.C_ADDR_WIDTH {5}] [get_bd_cells v_vid_in_axi4s_0]

# axis to video out
create_bd_cell -type ip -vlnv xilinx.com:ip:v_axi4s_vid_out:4.0 v_axi4s_vid_out_0
set_property -dict [list CONFIG.C_ADDR_WIDTH {11} CONFIG.C_HYSTERESIS_LEVEL {1000}] [get_bd_cells v_axi4s_vid_out_0]

# video timing controller
create_bd_cell -type ip -vlnv xilinx.com:ip:v_tc:6.2 v_tc_0
set_property -dict [list CONFIG.HAS_AXI4_LITE {false} CONFIG.horizontal_blank_detection {false} CONFIG.auto_generation_mode {true} CONFIG.vertical_blank_detection {false}] [get_bd_cells v_tc_0]

# sobel filter
create_bd_cell -type ip -vlnv xilinx.com:hls:sobel_filter:1.0 sobel_filter_0

# соединение тактовых сигналов
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins dvi2rgb_0/RefClk]
connect_bd_net [get_bd_pins dvi2rgb_0/PixelClk] [get_bd_pins v_vid_in_axi4s_0/aclk]
connect_bd_net [get_bd_pins dvi2rgb_0/PixelClk] [get_bd_pins sobel_filter_0/ap_clk]
connect_bd_net [get_bd_pins dvi2rgb_0/PixelClk] [get_bd_pins v_axi4s_vid_out_0/aclk]
connect_bd_net [get_bd_pins dvi2rgb_0/PixelClk] [get_bd_pins rgb2dvi_0/PixelClk]
connect_bd_net [get_bd_pins dvi2rgb_0/PixelClk] [get_bd_pins v_tc_0/clk]

# подключение сигналов сброса
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins dvi2rgb_0/pRst_n]
connect_bd_net [get_bd_pins clk_wiz_0/locked] [get_bd_pins dvi2rgb_0/aRst_n]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_vid_in_axi4s_0/aresetn]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins sobel_filter_0/ap_rst_n]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_axi4s_vid_out_0/aresetn]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins rgb2dvi_0/aRst_n]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_tc_0/resetn]

# подключение сигналов Clock Enable
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_vid_in_axi4s_0/vid_io_in_ce]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_vid_in_axi4s_0/aclken]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_vid_in_axi4s_0/axis_enable]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_axi4s_vid_out_0/aclken]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_axi4s_vid_out_0/vid_io_out_ce]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_tc_0/clken]
connect_bd_net [get_bd_pins dvi2rgb_0/pLocked] [get_bd_pins v_tc_0/det_clken]

connect_bd_net [get_bd_pins v_axi4s_vid_out_0/vtg_ce] [get_bd_pins v_tc_0/gen_clken]

# подключение сигналов видеоданных
connect_bd_intf_net [get_bd_intf_pins dvi2rgb_0/RGB] [get_bd_intf_pins v_vid_in_axi4s_0/vid_io_in]
connect_bd_intf_net [get_bd_intf_pins v_vid_in_axi4s_0/video_out] [get_bd_intf_pins sobel_filter_0/INPUT_STREAM]
connect_bd_intf_net [get_bd_intf_pins sobel_filter_0/OUTPUT_STREAM] [get_bd_intf_pins v_axi4s_vid_out_0/video_in]
connect_bd_intf_net [get_bd_intf_pins v_axi4s_vid_out_0/vid_io_out] [get_bd_intf_pins rgb2dvi_0/RGB]

# подключение сигналов video timing controller
connect_bd_intf_net [get_bd_intf_pins v_tc_0/vtiming_in] [get_bd_intf_pins v_vid_in_axi4s_0/vtiming_out]
connect_bd_intf_net [get_bd_intf_pins v_tc_0/vtiming_out] [get_bd_intf_pins v_axi4s_vid_out_0/vtiming_in]

regenerate_bd_layout
validate_bd_design
save_bd_design
close_bd_design [get_bd_designs design_1]

# создаем hld wrapper
make_wrapper -files [get_files sobel_hdmi/sobel_hdmi.srcs/sources_1/bd/design_1/design_1.bd] -top
add_files -norecurse sobel_hdmi/sobel_hdmi.srcs/sources_1/bd/design_1/hdl/design_1_wrapper.v