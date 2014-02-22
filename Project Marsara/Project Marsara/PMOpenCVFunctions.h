#import <UIKit/UIKit.h>

@interface OpenCVFunctions : NSObject

- (cv::Mat)cvMatFromUIImage:(UIImage *)image;
- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image;
- (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;

@end