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
    
    cv::Mat src = input.clone();
    // Map the src to the samples    
    std::vector<cv::Mat> imgRGB;
    cv::split(src,imgRGB);
    int n = src.total();
    cv::Mat samples(n,3,CV_8U);
    for(int i=0;i!=3;++i)
        imgRGB[i].reshape(1,n).copyTo(samples.col(i));
    samples.convertTo(samples,CV_32F);
    
    // Apply K-means to find labels and centers
    int clusterCount = 2;
    cv::Mat labels;
    int attempts = 5;
    cv::Mat centers;
    cv::kmeans(samples, clusterCount, labels,
               cv::TermCriteria(CV_TERMCRIT_ITER | CV_TERMCRIT_EPS,
                                10, 0.01),
               attempts, cv::KMEANS_PP_CENTERS, centers);
    
    // Find dominant color by computing histogram of labels
    int nbins = 3; // lets hold 256 levels
    int hsize[] = { nbins }; // just one dimension
    float range[] = { 0, 2 };
    const float *ranges[] = { range };
    int chnls[] = {0};
    cv::Mat hist;
    labels.convertTo(labels,CV_32F);
    calcHist(&labels, 1, chnls, cv::Mat(),hist,1,hsize,ranges);
    int max = hist.row(0).at<int>(0);
    int maxIndex = 0;
    for (int i = 1; i < 3; i++) {
        int curVal = hist.row(i).at<int>(0);
        if (curVal > max) {
            max = curVal;
            maxIndex = i;
        }
    }
    cv::Mat dominantColor = centers.row(maxIndex);
    cv::Vec3d dominantColorVec;
    dominantColorVec[0] = (double)dominantColor.col(0).at<float>(0);
    dominantColorVec[1] = (double)dominantColor.col(1).at<float>(0);
    dominantColorVec[2] = (double)dominantColor.col(2).at<float>(0);
    
    return dominantColorVec;
}


+ (NSString *) rgbColorToName:(cv::Vec3d)input {
    // Initialize set of colors
    NSDictionary *colorSet = @{@"Blue"          : [NSArray arrayWithObjects: @0, @0, @255, nil],
                               @"Red"           : [NSArray arrayWithObjects: @255, @0, @0, nil],
                               @"Lime"          : [NSArray arrayWithObjects: @0, @255, @0, nil],
                               @"White"         : [NSArray arrayWithObjects: @255, @255, @255, nil],
                               @"Maroon"        : [NSArray arrayWithObjects: @128, @0, @0, nil],
                               @"Dark red"      : [NSArray arrayWithObjects: @139, @0, @0, nil],
                               @"Firebrick"     : [NSArray arrayWithObjects: @178, @34, @34, nil],
                               @"Crimson"       : [NSArray arrayWithObjects: @220, @20, @60, nil],
                               @"Tomato"        : [NSArray arrayWithObjects: @255, @99, @71, nil],
                               @"Coral"         : [NSArray arrayWithObjects: @255, @127, @80, nil],
                               @"Indian red"    : [NSArray arrayWithObjects: @205, @92, @92, nil],
                               @"Light coral"   : [NSArray arrayWithObjects: @240, @128, @128, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],
                               @"Black"         : [NSArray arrayWithObjects: @0, @0, @0, nil],};
    
    // Init containers
    NSMutableDictionary *minColors = [[NSMutableDictionary alloc]init];;
    NSMutableArray *colorValues = [[NSMutableArray alloc]init];;
    
    // Create color set of colors using euclidean distance
    for (NSString *key in colorSet) {
        int rd, gd, bd;
        NSArray *curColor = [colorSet objectForKey:key];
        rd = (int)pow((double)([curColor[0] intValue] - input[0]), (double)2);
        gd = (int)pow((double)([curColor[1] intValue] - input[1]), (double)2);
        bd = (int)pow((double)([curColor[2] intValue] - input[2]), (double)2);
        int colorSum = rd + gd + bd;
        NSNumber *colorSumObj = [NSNumber numberWithInt:colorSum];
        [colorValues addObject:colorSumObj];
        [minColors setValue:key forKey:[NSString stringWithFormat:@"%d", colorSum]];
    }
    
    // Sort values
    NSArray *sortedColorValues = [colorValues sortedArrayUsingComparator:^(id obj1, id obj2) {
        if ([obj1 integerValue] > [obj2 integerValue])
            return (NSComparisonResult)NSOrderedDescending;
        if ([obj1 integerValue] < [obj2 integerValue])
            return (NSComparisonResult)NSOrderedAscending;
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    // Return minimum color value - closest match
    NSNumber *minVal = sortedColorValues[0];
    NSString *colorName = [minColors objectForKey:[NSString stringWithFormat:@"%d", [minVal intValue]]];
    return colorName;
}

@end