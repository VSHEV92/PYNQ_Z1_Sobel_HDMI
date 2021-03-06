# PYNQ_Z1_Sobel_HDMI
Фильтр Собела и ввод/вывод видеопотока по HDMI

------

#### Иерархия файлов

- hls_source - исходные файлы IP ядра фильтра Собела
- digilent_ip - необходимые ядра из библиотеки Digilent
- constarints - xdc файлы проекта Vivado
- tcl - скрипты для запуска теста, упаковки ядра и сборки демонстрационного проекта

------

#### Запуск hls tcl-скриптов

Необходимо запустить Vivado HLS Command Promt, перейти директорию, где расположен README файл, и запустить скрипты с помощью представленных ниже выражений:

- Тест IP ядра фильтра Собела

  Исходное изображение - hls_source/origin.bmp

  Выходное изображение - hls_source/sobel_out.bmp

  ```
  vivado_hls -f tcl/hls_ip_test.tcl 
  ```

- Упаковка IP ядра фильтра Собела

  ```
  vivado_hls -f tcl/hls_package.tcl 
  ```
------

 #### Создание демонстрационного проекта

Необходимо запустить Vivado Tcl Shell, перейти директорию, где расположен README файл, и запустить скрипт с помощью представленного ниже выражения: 

```
vivado -mode batch –source tcl/sobel_hdmi.tcl -notrace
```

После выполнения скрипта, наобходимо в Vivado Tcl Shell ввести 

```
open_project sobel_hdmi/sobel_hdmi.xpr
start_gui
```

