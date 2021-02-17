#include <hls_opencv.h>
#include "sobel_filter.hpp"

int main () {

// исходные и выходные избражения и axis-потоки
IplImage* src;
IplImage* dst;
AXI_STREAM_RGB src_axi;
AXI_STREAM_GRAY dst_axi;

src = cvLoadImage("../../../../hls_source/origin.bmp");
dst = cvCreateImage(cvGetSize(src), src->depth, src->nChannels);

// преобразование входного изображения в axis
IplImage2AXIvideo(src, src_axi);

// вызов тестируемой функции
sobel_filter(src_axi, dst_axi);

// преобразование axis в выходное изображение
AXIvideo2IplImage(dst_axi, dst);

// запись выходного изображения 
cvSaveImage("../../../../hls_source/sobel_out.bmp", dst);

cvReleaseImage(&src);
cvReleaseImage(&dst);

return 0;
}
