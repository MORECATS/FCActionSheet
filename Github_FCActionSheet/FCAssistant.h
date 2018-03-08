//
//  FCAssistant.h
//
//  Created by William Steven Brohawn on 03/10/2017.
//  Copyright © 2017 Brohawn. All rights reserved.
//

#define CFMainScreenBounds              [UIScreen mainScreen].bounds
#define CFIsiPhoneX                     MAX(CFMainScreenBounds.size.width, CFMainScreenBounds.size.height) == 812

#define CFStrokeHeight                  (1.0f / [UIScreen mainScreen].scale)

#import <UIKit/UIKit.h>

@interface UIDevice( FCDeviceAssistant )

+ (void)impactFeedbackIfAvailable;

@end

@interface UIBezierPath( FCBezierPathAssistant )

+ (UIBezierPath *)smoothRoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius;
+ (UIBezierPath*)bezierPathWithSmoothRoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius;

@end

@interface UIColor( FCColorAssistant )

+ (UIColor *)colorRGB:(CGFloat)R :(CGFloat)G :(CGFloat)B :(CGFloat)A;

@end



