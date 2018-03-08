//
//  FCActionController.h
//  WeeklyCourse
//
//  Created by William Steven Brohawn on 27/10/2017.
//  Copyright © 2017 William Steven Brohawn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCFotoView : UIImageView

@property( nonatomic, strong ) CAShapeLayer         *decorateLayer;

@end

typedef NS_ENUM(NSUInteger, FCActionType)
{
    FCActionTitle = 0, // Large title
    FCActionDefault    // Image on left & text on right
};

@interface FCActionObject : NSObject

// Convenient func for large title
+ (instancetype)objectWithTitle:(NSString *)title;

// Convenient func for cell
+ (instancetype)objectWithTitle:(NSString *)title image:(UIImage *)image tintColor:(UIColor *)tintColor;

@end

@interface FCActionController : UIViewController

// Always Pop in the center of the screen.
@property( nonatomic, assign ) BOOL         wantsWideSize;

+ (instancetype)actionExecutor:(void (^)(NSString *))executor;

- (void)addActionObject:(FCActionObject *)object;
- (void)setActionUnavailableForLastAction;
- (void)setActionDestructiveForLastAction;

@end
