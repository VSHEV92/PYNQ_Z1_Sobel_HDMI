set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports clk_125]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS33} [get_ports reset_button]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports bw_en]

#HDMI Rx

set_property -dict {PACKAGE_PIN P19 IOSTANDARD TMDS_33} [get_ports RX_TMDS_clk_n]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD TMDS_33} [get_ports RX_TMDS_clk_p]
set_property -dict {PACKAGE_PIN W20 IOSTANDARD TMDS_33} [get_ports {RX_TMDS_data_n[0]}]
set_property -dict {PACKAGE_PIN V20 IOSTANDARD TMDS_33} [get_ports {RX_TMDS_data_p[0]}]
set_property -dict {PACKAGE_PIN U20 IOSTANDARD TMDS_33} [get_ports {RX_TMDS_data_n[1]}]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD TMDS_33} [get_ports {RX_TMDS_data_p[1]}]
set_property -dict {PACKAGE_PIN P20 IOSTANDARD TMDS_33} [get_ports {RX_TMDS_data_n[2]}]
set_property -dict {PACKAGE_PIN N20 IOSTANDARD TMDS_33} [get_ports {RX_TMDS_data_p[2]}]
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports HPD]
set_property -dict {PACKAGE_PIN U14 IOSTANDARD LVCMOS33} [get_ports DDC_scl_io]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports DDC_sda_io]

#HDMI Tx
set_property -dict {PACKAGE_PIN L17 IOSTANDARD TMDS_33} [get_ports TX_TMDS_clk_n]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD TMDS_33} [get_ports TX_TMDS_clk_p]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD TMDS_33} [get_ports {TX_TMDS_data_n[0]}]
set_property -dict {PACKAGE_PIN K17 IOSTANDARD TMDS_33} [get_ports {TX_TMDS_data_p[0]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD TMDS_33} [get_ports {TX_TMDS_data_n[1]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD TMDS_33} [get_ports {TX_TMDS_data_p[1]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD TMDS_33} [get_ports {TX_TMDS_data_n[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD TMDS_33} [get_ports {TX_TMDS_data_p[2]}]

