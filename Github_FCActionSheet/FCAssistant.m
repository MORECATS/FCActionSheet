//
//  FCAssistant.m
//
//  Created by William Steven Brohawn on 03/10/2017.
//  Copyright © 2017 Brohawn. All rights reserved.
//

#import "FCAssistant.h"

@implementation UIDevice( VCAnnotateDevice )

+ (void)impactFeedbackIfAvailable
{
    if( NSClassFromString(@"UIImpactFeedbackGenerator") )
    {
        UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [generator prepare];
        [generator impactOccurred];
    }
}

@end

#define TOP_LEFTR(X, Y)     CGPointMake(rect.origin.x + X * limitedRadius,\
                                        rect.origin.y + Y * limitedRadius)
#define TOP_RIGHT(X, Y)     CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
                                        rect.origin.y + Y * limitedRadius)
#define BTM_RIGHT(X, Y)     CGPointMake(rect.origin.x + rect.size.width - X * limitedRadius,\
                                        rect.origin.y + rect.size.height - Y * limitedRadius)
#define BTM_LEFTR(X, Y)     CGPointMake(rect.origin.x + X * limitedRadius,\
                                        rect.origin.y + rect.size.height - Y * limitedRadius)

@implementation UIBezierPath( FCBezierPathAssistant )

+ (UIBezierPath *)smoothRoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius
{
    return [UIBezierPath bezierPathWithSmoothRoundedRect:rect cornerRadius:radius];
}

+ (UIBezierPath *)bezierPathWithSmoothRoundedRect:(CGRect)rect cornerRadius:(CGFloat)radius
{
    UIBezierPath* path = UIBezierPath.bezierPath;
    CGFloat limit = MIN(rect.size.width, rect.size.height) / 2 / 1.52866483;
    CGFloat limitedRadius = MIN(radius, limit);
    
    [path     moveToPoint:TOP_LEFTR(1.52866483, 0.00000000)];
    [path  addLineToPoint:TOP_RIGHT(1.52866471, 0.00000000)];
    [path addCurveToPoint:TOP_RIGHT(0.66993427, 0.06549600)
            controlPoint1:TOP_RIGHT(1.08849323, 0.00000000)
            controlPoint2:TOP_RIGHT(0.86840689, 0.00000000)];
    [path  addLineToPoint:TOP_RIGHT(0.63149399, 0.07491100)];
    [path addCurveToPoint:TOP_RIGHT(0.07491176, 0.63149399)
            controlPoint1:TOP_RIGHT(0.37282392, 0.16905899)
            controlPoint2:TOP_RIGHT(0.16906013, 0.37282401)];
    [path addCurveToPoint:TOP_RIGHT(0.00000000, 1.52866483)
            controlPoint1:TOP_RIGHT(0.00000000, 0.86840701)
            controlPoint2:TOP_RIGHT(0.00000000, 1.08849299)];
    [path  addLineToPoint:BTM_RIGHT(0.00000000, 1.52866471)];
    [path addCurveToPoint:BTM_RIGHT(0.06549569, 0.66993493)
            controlPoint1:BTM_RIGHT(0.00000000, 1.08849323)
            controlPoint2:BTM_RIGHT(0.00000000, 0.86840689)];
    [path  addLineToPoint:BTM_RIGHT(0.07491111, 0.63149399)];
    [path addCurveToPoint:BTM_RIGHT(0.63149399, 0.07491111)
            controlPoint1:BTM_RIGHT(0.16905883, 0.37282392)
            controlPoint2:BTM_RIGHT(0.37282392, 0.16905883)];
    [path addCurveToPoint:BTM_RIGHT(1.52866471, 0.00000000)
            controlPoint1:BTM_RIGHT(0.86840689, 0.00000000)
            controlPoint2:BTM_RIGHT(1.08849323, 0.00000000)];
    [path  addLineToPoint:BTM_LEFTR(1.52866483, 0.00000000)];
    [path addCurveToPoint:BTM_LEFTR(0.66993397, 0.06549569)
            controlPoint1:BTM_LEFTR(1.08849299, 0.00000000)
            controlPoint2:BTM_LEFTR(0.86840701, 0.00000000)];
    [path  addLineToPoint:BTM_LEFTR(0.63149399, 0.07491111)];
    [path addCurveToPoint:BTM_LEFTR(0.07491100, 0.63149399)
            controlPoint1:BTM_LEFTR(0.37282401, 0.16905883)
            controlPoint2:BTM_LEFTR(0.16906001, 0.37282392)];
    [path addCurveToPoint:BTM_LEFTR(0.00000000, 1.52866471)
            controlPoint1:BTM_LEFTR(0.00000000, 0.86840689)
            controlPoint2:BTM_LEFTR(0.00000000, 1.08849323)];
    [path  addLineToPoint:TOP_LEFTR(0.00000000, 1.52866483)];
    [path addCurveToPoint:TOP_LEFTR(0.06549600, 0.66993397)
            controlPoint1:TOP_LEFTR(0.00000000, 1.08849299)
            controlPoint2:TOP_LEFTR(0.00000000, 0.86840701)];
    [path  addLineToPoint:TOP_LEFTR(0.07491100, 0.63149399)];
    [path addCurveToPoint:TOP_LEFTR(0.63149399, 0.07491100)
            controlPoint1:TOP_LEFTR(0.16906001, 0.37282401)
            controlPoint2:TOP_LEFTR(0.37282401, 0.16906001)];
    [path addCurveToPoint:TOP_LEFTR(1.52866483, 0.00000000)
            controlPoint1:TOP_LEFTR(0.86840701, 0.00000000)
            controlPoint2:TOP_LEFTR(1.08849299, 0.00000000)];
    [path closePath];
    return path;
}

@end

@implementation UIColor( FCColorAssistant )

+ (UIColor *)colorRGB:(CGFloat)R :(CGFloat)G :(CGFloat)B :(CGFloat)A
{
    if( [UIColor instancesRespondToSelector:@selector(colorWithDisplayP3Red:green:blue:alpha:)] )
    {
        return [UIColor colorWithDisplayP3Red:R / 255.0f green:G / 255.0f blue:B / 255.0f alpha:A];
    }
    else
    {
        return [UIColor colorWithRed:R / 255.0f green:G / 255.0f blue:B / 255.0f alpha:A];
    }
}

@end



