#import "PMSImageProcessing.h"

@implementation PMSImageProcessing

#pragma mark - OpenCV functions for converting between Mat and UIImage

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image {
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

#pragma mark - Color analysis functions

+ (cv::Vec3d)findDominantColor:(cv::Mat)input {
    
    // Split input into channels
    cv::vector<cv::Mat> bgr_planes;
    split(input, bgr_planes);
    
    /// Establish the number of bins
    int histSize = 256;
    
    /// Set the ranges ( for B,G,R) )
    float range[] = { 0, 256 } ;
    const float* histRange = { range };
    
    bool uniform = true; bool accumulate = false;
    
    cv::Mat b_hist, g_hist, r_hist;
    
    /// Compute the histograms:
    calcHist( &bgr_planes[0], 1, 0, cv::Mat(), b_hist, 1, &histSize, &histRange, uniform, accumulate );
    calcHist( &bgr_planes[1], 1, 0, cv::Mat(), g_hist, 1, &histSize, &histRange, uniform, accumulate );
    calcHist( &bgr_planes[2], 1, 0, cv::Mat(), r_hist, 1, &histSize, &histRange, uniform, accumulate );
    
    double b_maxVal, g_maxVal, r_maxVal;
    minMaxLoc(b_hist, 0, &b_maxVal, 0, 0);
    minMaxLoc(g_hist, 0, &g_maxVal, 0, 0);
    minMaxLoc(r_hist, 0, &r_maxVal, 0, 0);
    
    cv::Vec3d dominantColor = {b_maxVal/1000, g_maxVal/1000, r_maxVal/1000};
    
    return dominantColor;
}

+ (NSString *) rgbColor:(cv::Vec3d){
    
    //Set vector values to R,G,B
    double r = cv::Vec3d[0]
    double g = cv::Vec3d[1]
    double b = cv::Vec3d[2]
    
    
    if(b>=150 && R<=50 && G<=50){
        return NSString = "Blue"
    } else if(r>=180 && g<=40 && b<=40){
        return NSString = "Red"
    } else if(r>=190 && g>=190 && b<=100){
        return NSString = "Yellow"
    } else if ((r>b-10)||(b>r-10)) && ((b>g+20 || r>g+20)){
        return NSString = "Purple"
    } else if (g>=100 && b<=50 && r<=50){
        return NSString = "Green"
    } else if (r>=200 && g>=200 && g<=100 && b>=60){
        return NSString ="Orange"
    } else if (r>=240 && g>=240 && b>=240){
        return NSString = "White"
    } else if (r==0 && b==0 && g==0){
        return NSString = "Black"
    } else if (r>g>b && (r-50)>g && (g-50)>b){
        return NSString = "Brown"
    } else if (((r<=(g+5) && r>=(g-5)) && ((r<=(b+5) && g>=(b-5)) && ((b<=(r+5)) && (b>=(r-5)))){
        return NSString = "Gray"
    }
}



@end