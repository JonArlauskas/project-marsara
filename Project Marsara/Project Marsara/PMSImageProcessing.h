//
//  PMSImageProcessing.h
//  Project Marsara
//
//  Created by Nicolas Langley on 2/22/14.
//  Copyright (c) 2014 theregime. All rights reserved.
//

@interface PMSImageProcessing : NSObject

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (cv::Vec3d)findDominantColor:(cv::Mat)input;
+ (NSString *) rgbColorToName:(cv::Vec3d)input;
+ (double)findDominantColorHSV:(cv::Mat)input;

@end