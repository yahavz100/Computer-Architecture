//Yahav Zarfati
#include <stdbool.h> 

/* Compute min and max of two integers, respectively */
#define MAX(a,b)(a > b ? a : b)
#define MIN(a,b)(a < b ? a : b)

typedef struct {
   unsigned char red;
   unsigned char green;
   unsigned char blue;
} pixel;

typedef struct {
    int red;
    int green;
    int blue;
} pixel_sum;

/* Function run on whole image, using the short equation, actually moving the right kernel
over each pixel and calculating right value, also check if needed filter.
*/
void blur(pixel* src, pixel* dst, bool filter) {
	int i, j;
	int end = n - 1;
	int kernelScale = 9;
	pixel_sum sum;
	int min_intensity;
	int max_intensity;
	//Move on all pixels
	for (i = 1; i < end; i++) {
		//Reduced calculations in loop - code motion
		int ibetd = (i - 1) * n;
		int ibetu = (i + 1) * n;
		int ibete = i * n;
		for (j = 1; j < end; j++) {
			//Reduced calculations in loop
			int jbetd = j - 1;
			int jbetu = j + 1;
			int p5 = ibete + j;
			int p1 = ibetd + jbetd;
			int p2 = ibetd + j;
			int p3 = ibetd + jbetu;
			int p4 = ibete + jbetd;	
			int p6 = ibete + jbetu;
			int p7 = ibetu + jbetd;
			int p8 = ibetu + j;
			int p9 = ibetu + jbetu;
			//Reduced calculations of memory access
			pixel a = src[p1];
			pixel b = src[p2];
			pixel c = src[p3];
			pixel d = src[p4];
			pixel e = src[p5];
			pixel f = src[p6];
			pixel g = src[p7];
			pixel h = src[p8];
			pixel k = src[p9];
			//Sum all pixels in kernel
			sum.red = a.red + b.red + c.red + d.red + e.red + f.red + g.red + h.red + k.red;	
			sum.blue = a.blue + b.blue + c.blue + d.blue + e.blue + f.blue + g.blue + h.blue + k.blue;
			sum.green = a.green + b.green + c.green + d.green + e.green + f.green + g.green + h.green + k.green;
			
			//Check if filter is needed
			if (filter) {
				int sumInt;
				int pMin, pMax;
				kernelScale = 7;
				//Set first pixel as default min and max
				min_intensity = a.red + a.blue + a.green;
				max_intensity = min_intensity;
				pMin = p1;
				pMax = p1;
				sumInt = b.red + b.blue + b.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					min_intensity = sumInt;
					pMin = p2;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					max_intensity = sumInt;
					pMax = p2;
				}
				sumInt = c.red + c.blue + c.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					min_intensity = sumInt;
					pMin = p3;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					max_intensity = sumInt;
					pMax = p3;
				}
				sumInt = d.red + d.blue + d.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					min_intensity = sumInt;
					pMin = p4;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					max_intensity = sumInt;
					pMax = p4;
				}
				sumInt = e.red + e.blue + e.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					min_intensity = sumInt;
					pMin = p5;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					max_intensity = sumInt;
					pMax = p5;
				}
				sumInt = f.red + f.blue + f.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					min_intensity = sumInt;
					pMin = p6;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					max_intensity = sumInt;
					pMax = p6;
				}
				sumInt = g.red + g.blue + g.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					min_intensity = sumInt;
					pMin = p7;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					max_intensity = sumInt;
					pMax = p7;
				}
				sumInt = h.red + h.blue + h.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					min_intensity = sumInt;
					pMin = p8;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					max_intensity = sumInt;
					pMax = p8;
				}
				sumInt = k.red + k.blue + k.green;
				//Check for min and max pixel
				if (sumInt <= min_intensity) {
					pMin = p9;
				}
				//Check for min and max pixel
				if (sumInt > max_intensity) {
					pMax = p9;
				}
				//Reduced calculations of memory access
				pixel max_pixel = src[pMax];
				pixel min_pixel = src[pMin];
				sum.red = sum.red - max_pixel.red - min_pixel.red;
				sum.blue = sum.blue - max_pixel.blue - min_pixel.blue;
				sum.green = sum.green - max_pixel.green - min_pixel.green;
			}

			// divide by kernel's weight
			sum.red = sum.red / kernelScale;
			sum.green = sum.green / kernelScale;
			sum.blue = sum.blue / kernelScale;

			// truncate each pixel's color values to match the range [0,255]
			dst[p5].red = (unsigned char)(MIN(MAX(sum.red, 0), 255));
			dst[p5].blue = (unsigned char)(MIN(MAX(sum.blue, 0), 255));
			dst[p5].green = (unsigned char)(MIN(MAX(sum.green, 0), 255));
		}
	}
}

/* Function run on whole image, using the short equation, actually moving the right kernel
over each pixel and calculating right value, also check if needed filter.
*/
	void sharp(pixel *src, pixel *dst) {
		int i, j;
		int end = n - 1;
		pixel_sum sum;
		int kNum = 9;
		//Move on all pixels
		for (i = 1; i < end; i++) {
			//Reduced calculations in loop - code motion
			int ibetd = (i - 1) * n;
			int ibetu = (i + 1) * n;
			int ibete = i * n;
			for (j = 1; j < end; j++) {
				//Reduced calculations in loop
				int jbetd = j - 1;
				int jbetu = j + 1;
				int p5 = ibete + j;
				int p1 = ibetd + jbetd;
				int p2 = ibetd + j;
				int p3 = ibetd + jbetu;
				int p4 = ibete + jbetd;	
				int p6 = ibete + jbetu;
				int p7 = ibetu + jbetd;
				int p8 = ibetu + j;
				int p9 = ibetu + jbetu;
				//Reduced calculations of memory access
				pixel a = src[p1];
				pixel b = src[p2];
				pixel c = src[p3];
				pixel d = src[p4];
				pixel e = src[p5];
				pixel f = src[p6];
				pixel g = src[p7];
				pixel h = src[p8];
				pixel k = src[p9];
				//Sum all pixels in kernel
				sum.red = e.red * kNum - a.red - b.red - c.red - d.red - f.red - g.red - h.red - k.red;
				sum.blue = e.blue * kNum - a.blue - b.blue - c.blue - d.blue - f.blue - g.blue - h.blue - k.blue;
				sum.green = e.green * kNum - a.green - b.green - c.green - d.green - f.green - g.green - h.green - k.green;

				// truncate each pixel's color values to match the range [0,255]
				dst[p5].red = (unsigned char)(MIN(MAX(sum.red, 0), 255));
				dst[p5].blue = (unsigned char)(MIN(MAX(sum.blue, 0), 255));
				dst[p5].green = (unsigned char)(MIN(MAX(sum.green, 0), 255));
			}
		}
	}


void myfunction(Image *image, char* srcImgpName, char* blurRsltImgName, char* sharpRsltImgName, char* filteredBlurRsltImgName, char* filteredSharpRsltImgName, char flag) {
	
	//Allocate memory, for image source, calculate size to avoid calculations
	int size = m * n * sizeof(pixel);
	pixel* dst = (pixel*)image->data;
	pixel* src = malloc(size);
	
	//Check if user input is 1 or different
	if (flag == '1') {	
		memcpy(src, dst, size);
		// blur image
		blur(src, dst, false);

		// write result image to file
		writeBMP(image, srcImgpName, blurRsltImgName);	
		
		memcpy(src, dst, size);
		// sharpen the resulting image
		sharp(src, dst);
		
		// write result image to file
		writeBMP(image, srcImgpName, sharpRsltImgName);	
	} else {
		memcpy(src, dst, size);
		// apply extermum filtered kernel to blur image
		blur(src, dst, true);

		// write result image to file
		writeBMP(image, srcImgpName, filteredBlurRsltImgName);
		
		memcpy(src, dst, size);
		// sharpen the resulting image
		sharp(src, dst);

		// write result image to file
		writeBMP(image, srcImgpName, filteredSharpRsltImgName);	
	}

	free(dst);
}
