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

# добавляем xdc файлы к проекту
add_files -fileset constrs_1 constarints/debug.xdc
add_files -fileset constrs_1 constarints/pins.xdc 
add_files -fileset constrs_1 constarints/timing.xdc

# создаем block design
create_bd_design "design_1"