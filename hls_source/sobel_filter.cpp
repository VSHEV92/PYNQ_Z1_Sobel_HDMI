#include "sobel_filter.hpp"

void sobel_filter(	AXI_STREAM_RGB& INPUT_STREAM,
					AXI_STREAM_GRAY& OUTPUT_STREAM
					)
{

#pragma HLS INTERFACE ap_ctrl_none port=return

#pragma HLS INTERFACE axis port=INPUT_STREAM
#pragma HLS INTERFACE axis port=OUTPUT_STREAM

RGB_IMAGE  img_0(MAX_HEIGHT, MAX_WIDTH);
GRAY_IMAGE img_1(MAX_HEIGHT, MAX_WIDTH);
GRAY_IMAGE img_2(MAX_HEIGHT, MAX_WIDTH);
RGB_IMAGE  img_3(MAX_HEIGHT, MAX_WIDTH);

#pragma HLS dataflow

hls::AXIvideo2Mat(INPUT_STREAM, img_0);

hls::CvtColor<HLS_BGR2GRAY>(img_0, img_1);

hls::Sobel<1,0,3>(img_1, img_2);

hls::CvtColor<HLS_GRAY2RGB>(img_2, img_3);

hls::Mat2AXIvideo(img_3, OUTPUT_STREAM);

}
