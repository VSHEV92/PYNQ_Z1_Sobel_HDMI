#include <hls_video.h>
#include <ap_fixed.h>

#define MAX_WIDTH  1920
#define MAX_HEIGHT 1080

typedef hls::stream<ap_axiu<24,1,1,1> > AXI_STREAM_RGB;
typedef hls::stream<ap_axiu<24,1,1,1> > AXI_STREAM_GRAY;

typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC3> RGB_IMAGE;
typedef hls::Mat<MAX_HEIGHT, MAX_WIDTH, HLS_8UC1> GRAY_IMAGE;

void sobel_filter(AXI_STREAM_RGB& INPUT_STREAM, AXI_STREAM_GRAY& OUTPUT_STREAM);
