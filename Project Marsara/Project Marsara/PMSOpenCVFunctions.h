#import <UIKit/UIKit.h>

@interface PMSOpenCVFunctions : NSObject

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;
+ (cv::Vec3d)findDominantColor:(cv::Mat)input;

@end