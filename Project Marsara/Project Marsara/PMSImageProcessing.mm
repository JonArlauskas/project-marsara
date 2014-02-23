//
//  PMSImageProcessing.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

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
    
    // Establish the number of bins
    int histSize = 256;
    
    // Set the ranges ( for B,G,R) )
    float range[] = { 0, 256 } ;
    const float* histRange = { range };
    
    bool uniform = true; bool accumulate = false;
    
    cv::Mat b_hist, g_hist, r_hist;
    
    // Compute the histograms:
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

+ (double)findDominantColorHSV:(cv::Mat)input {
    
    cv::Mat hsv;
    cvtColor(input, hsv, CV_BGR2HSV);
    
    std::vector<cv::Mat> channels;
    cv::split(hsv, channels);
    cv::Mat hue, hist;
    hue = channels[0];
    int histSize = 64;
    float hranges[] = { 0, 180};
    const float* ranges[] = { hranges };
    
    cv::calcHist(&hue, 1, 0, cv::Mat(), hist, 1, &histSize, ranges, true, false);
    
    double maxVal=0;
    minMaxLoc(hist, 0, &maxVal, 0, 0);
    return maxVal;
}

+ (NSString *) rgbColorToName:(cv::Vec3d)input {
    
    //Set vector values to R,G,B
    double r = input[0];
    double g = input[1];
    double b = input[2];
    
    NSString *color;
    if((b>g>r) && (b>= 128 && b<=255 && g<=255 && r<=255)){
        color = @"Blue";
    } else if((r>g>b) && (r>=128 && r<=255 && g<=255 && b<=255)){
        color = @"Red";
    } else if(r>=190 && g>=190 && b<=100){
        color = @"Yellow";
    } else if (((r>b-10)||(b>r-10)) && ((b>g+20 || r>g+20))){
        color = @"Purple";
    } else if ((g>b>r) && (g>= 128 && g<=255 && b<=255 && r<=255)){
        color = @"Green";
    } else if (r>=200 && g>=200 && g<=100 && b>=60){
        color = @"Orange";
    } else if (r>=240 && g>=240 && b>=240){
        color = @"White";
    } else if (r<=35 && b<=35 && g<=35){
        color = @"Black";
    } else if (r>g>b && (r-50)>g && (g-50)>b){
        color = @"Brown";
    } else if ((r<=(g+5) && r>=(g-5)) && ((r<=(b+5) && g>=(b-5)) && ((b<=(r+5)) && (b>=(r-5))))){
        color = @"Gray";
    } else {
        color = @"Brown";
    }
    return color;
}



@end