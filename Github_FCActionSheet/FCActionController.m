//
//  FCActionController.m
//  WeeklyCourse
//
//  Created by William Steven Brohawn on 27/10/2017.
//  Copyright © 2017 William Steven Brohawn. All rights reserved.
//

#define kCActionTitleHeight   56
#define kCActionButtonHeight  48

#import "FCActionController.h"
#import "FCAssistant.h"

@implementation FCFotoView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIBezierPath *
    path = [UIBezierPath smoothRoundedRect:CGRectInset(self.bounds, 1, 1) cornerRadius:8.0f];
    
    [((CAShapeLayer *)self.layer.mask) setPath:[path CGPath]];
    
    path = [UIBezierPath smoothRoundedRect:CGRectInset(self.bounds, 2, 2) cornerRadius:7.0f];
    [self.decorateLayer setPath:[path CGPath]];
}

- (instancetype)init
{
    return [self initWithImage:nil];
}

- (instancetype)initWithImage:(UIImage *)image
{
    if( [super initWithImage:image] )
    {
        [self.layer setMask:[CAShapeLayer layer]];
        [self setDecorateLayer:({
            CAShapeLayer *f = [CAShapeLayer layer];
            [f setLineWidth:2.0f];
            [f setFillColor:[UIColor clearColor].CGColor];
            [f setStrokeColor:[UIColor colorWithWhite:0 alpha:.2f].CGColor];
            [self.layer addSublayer:f];
            f;
        })];
    }
    return self;
}

@end

@interface FCActionObject()

@property( nonatomic, assign ) FCActionType         actionType;

@property( nonatomic, strong ) NSString             *title;
@property( nonatomic, strong ) UIImage              *image;
@property( nonatomic, strong ) UIColor              *tintColor;

@end

@implementation FCActionObject

+ (instancetype)objectWithTitle:(NSString *)title
{
    FCActionObject *object = [FCActionObject new];
    object.actionType = FCActionTitle;
    object.title = title;
    return object;
}

+ (instancetype)objectWithTitle:(NSString *)title image:(UIImage *)image tintColor:(UIColor *)tintColor
{
    FCActionObject *object = [FCActionObject new];
    object.actionType = FCActionDefault;
    object.title = title;
    object.image = image;
    object.tintColor = tintColor;
    return object;
}

@end

@interface FCActionView : UIView

@property( nonatomic, assign ) BOOL                 actionEnable;
@property( nonatomic, assign ) BOOL                 actionSelected;
@property( nonatomic, assign ) CGFloat              preferHeight;

@property( nonatomic, strong ) UILabel              *titleLabel;

@end

@implementation FCActionView

- (void)setActionEnable:(BOOL)actionEnable
{
    if( _actionEnable != actionEnable )
    {
        _actionEnable  = actionEnable;
        
        [self actionEnableUpdating];
    }
}

- (void)actionEnableUpdating{}

- (void)setActionSelected:(BOOL)actionSelected
{
    if( _actionSelected != actionSelected )
    {
        _actionSelected  = actionSelected;
        
        [self actionSelectUpdating];
    }
}

- (void)actionSelectUpdating
{
    UIColor *backgroundColor = [UIColor colorWithWhite:0 alpha:self.actionSelected ? .12f : .0f];
    [UIView animateWithDuration:.25f delay:0 options:( 7 << 16 )
                     animations:^{ [self setBackgroundColor:backgroundColor]; }
                     completion:nil];
}

- (instancetype)init
{
    if( [super init] )
    {
        [self setActionEnable:YES];
        [self setUserInteractionEnabled:NO];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.heightAnchor constraintEqualToConstant:self.preferHeight].active = YES;
    }
    return self;
}

@end

@interface FCActionTitleView : FCActionView

@property( nonatomic, strong ) CAShapeLayer         *topBorder;

@end

@implementation FCActionTitleView

- (CGFloat)preferHeight
{
    return kCActionTitleHeight;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.topBorder setFrame:CGRectMake(0, 4, CGRectGetWidth(self.bounds), 1)];
}

- (instancetype)initWithTitle:(NSString *)title
{
    if( [super init] )
    {
        [self setActionEnable:NO];
        [self setTitleLabel:({
            UILabel *f = [[UILabel alloc] init];
            [f setText:title];
            [f setUserInteractionEnabled:NO];
            [f setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
            [f setTextColor:[UIColor blackColor]];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.topAnchor constraintEqualToAnchor:self.topAnchor constant:8].active = YES;
            [f.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16].active = YES;
            [f.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
            [f.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
            f;
        })];
        [self setTopBorder:({
            CAShapeLayer *f = [CAShapeLayer layer];
            [f setBackgroundColor:[UIColor colorWithWhite:211 / 255.0 alpha:1].CGColor];
            [self.layer addSublayer:f];
            f;
        })];
    }
    return self;
}

@end

@interface FCActionCell : FCActionView

@property( nonatomic, strong ) FCFotoView          *imageView;

@end

@implementation FCActionCell

- (CGFloat)preferHeight
{
    return kCActionButtonHeight;
}

- (void)actionEnableUpdating
{
    [self.titleLabel setTextColor:[self.titleLabel.textColor colorWithAlphaComponent:self.actionEnable ? 1 : .4f]];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image tintColor:(UIColor *)tintColor
{
    if( [super init] )
    {
        [self setImageView:({
            if( tintColor )
            {
                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            else
            {
                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            }
            FCFotoView *f = [[FCFotoView alloc] initWithImage:image];
            if( tintColor == nil )
            {
                f.decorateLayer.lineWidth = .0f;
            }
            [f setTintColor:tintColor];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:16].active = YES;
            [f.widthAnchor constraintEqualToConstant:32].active = YES;
            [f.heightAnchor constraintEqualToConstant:32].active = YES;
            [f.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
            f;
        })];
        [self setTitleLabel:({
            UILabel *f = [[UILabel alloc] init];
            [f setText:title];
            [f setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
            [f setTextColor:[self tintColor]];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
            [f.leftAnchor constraintEqualToAnchor:self.imageView.rightAnchor constant:16].active = YES;
            [f.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-16].active = YES;
            [f.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
            f;
        })];
    }
    return self;
}

@end

@interface FCActionCancel : FCActionView

@property( nonatomic, strong ) UIVisualEffectView               *blurView;

@end

@implementation FCActionCancel

- (CGFloat)preferHeight
{
    return kCActionTitleHeight;
}

- (void)actionSelectUpdating
{
    UIColor *textColor = [self.tintColor colorWithAlphaComponent:self.actionSelected ? .4f : 1.0f];
    [UIView animateWithDuration:.25f delay:0 options:( 7 << 16 )
                     animations:^{ [self.titleLabel setTextColor:textColor]; }
                     completion:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [((CAShapeLayer *)self.layer.mask) setPath:[UIBezierPath bezierPathWithSmoothRoundedRect:self.bounds
                                                                                cornerRadius:12].CGPath];
}

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image
{
    if( [super init] )
    {
        [self setActionEnable:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setMask:[CAShapeLayer layer]];
        [self setBlurView:({
            UIVisualEffectView *f = [[UIVisualEffectView alloc] init];
            if( @available(iOS 11.0, *) )
            {
                [f setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            }
            else
            {
                [f setBackgroundColor:[UIColor whiteColor]];
            }
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
            [f.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
            [f.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
            [f.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
            f;
        })];
        [self setTitleLabel:({
            UILabel *f = [[UILabel alloc] init];
            [f setText:title];
            [f setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
            [f setTextColor:[self tintColor]];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
            [f.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
            f;
        })];
    }
    return self;
}

@end

@interface FCActionContentView : UIView

@property( nonatomic, strong ) UIVisualEffectView               *backgroundView;

@end

@implementation FCActionContentView

- (void)layoutSubviews
{
    [super layoutSubviews];
    [((CAShapeLayer *)self.layer.mask) setPath:[UIBezierPath bezierPathWithSmoothRoundedRect:self.bounds
                                                                                cornerRadius:12].CGPath];
}

- (instancetype)init
{
    if( [super init] )
    {
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor clearColor]];
        [self.layer setMask:({
            CAShapeLayer *f = [CAShapeLayer layer];
            f.fillRule = kCAFillRuleEvenOdd;
            f;
        })];
        [self setBackgroundView:({
            UIVisualEffectView *f = [[UIVisualEffectView alloc] init];
            if( @available(iOS 11.0, *) )
            {
                [f setEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            }
            else
            {
                [f setBackgroundColor:[UIColor whiteColor]];
            }
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:f];
            [f.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
            [f.leftAnchor constraintEqualToAnchor:self.leftAnchor].active = YES;
            [f.rightAnchor constraintEqualToAnchor:self.rightAnchor].active = YES;
            [f.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
            f;
        })];
    }
    return self;
}

@end

typedef void (^FCActionExecutor)(NSString *action);

typedef NS_ENUM(NSUInteger, FCActionViewSize)
{
    FCActionViewCompact = 0,
    FCActionViewWide
};

@interface FCActionController()<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property( nonatomic, copy   ) FCActionExecutor                             actionExecutor;

@property( nonatomic, assign ) FCActionViewSize                             actionViewSize;

@property( nonatomic, strong ) UIControl                                    *backgroundControl;

@property( nonatomic, strong ) FCActionContentView                          *contentView;
@property( nonatomic, strong ) NSLayoutConstraint                           *contentHideConstraint;
@property( nonatomic, strong ) NSLayoutConstraint                           *contentShowConstraint;

@property( nonatomic, assign ) CGFloat                                      contentViewHeight;
@property( nonatomic, assign ) CGFloat                                      panReferenceLocation;

@property( nonatomic, strong ) NSMutableArray<__kindof FCActionView *>      *arrangedViews;
@property( nonatomic, strong ) FCActionCancel                               *actionCancel;

@property( nonatomic, strong ) UISelectionFeedbackGenerator                 *impactGenerator;
@property( nonatomic, strong ) UISelectionFeedbackGenerator                 *selectionFeedbackGenerator;

@end

@implementation FCActionController

+ (instancetype)actionExecutor:(FCActionExecutor)executor
{
    FCActionController *controller = [FCActionController new];
    controller.actionExecutor = executor;
    return controller;
}

- (instancetype)init
{
    if( [super init] )
    {
        [self setTransitioningDelegate:self];
        [self setModalPresentationStyle:UIModalPresentationCustom];
    }
    return self;
}

- (NSMutableArray<__kindof FCActionView *> *)arrangedViews
{
    if( _arrangedViews == nil )
    {
        _arrangedViews = [NSMutableArray array];
    }
    return _arrangedViews;
}

- (void)addActionObject:(FCActionObject *)object
{
    if( object.actionType == FCActionTitle )
    {
        FCActionTitleView *view = [[FCActionTitleView alloc] initWithTitle:object.title];
        [view.topBorder setHidden:self.arrangedViews.count == 0];
        [self.arrangedViews addObject:view];
    }
    else if( object.actionType == FCActionDefault )
    {
        [self.arrangedViews addObject:[[FCActionCell alloc] initWithTitle:object.title
                                                                    image:object.image
                                                                tintColor:object.tintColor]];
    }
}

- (void)setActionUnavailableForLastAction
{
    [self.arrangedViews.lastObject setActionEnable:NO];
}

- (void)setActionDestructiveForLastAction
{
    [self.arrangedViews.lastObject.titleLabel setTextColor:[UIColor colorRGB:255 :48 :86 :1.0f]];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context){
        [self layoutContentViewToSize:size];
    }completion:nil];
}

- (void)layoutContentViewToSize:(CGSize)size
{
    if( [self actionViewSize] == FCActionViewWide )
    {
        [self.contentShowConstraint setConstant:size.width > 414 ? (414 - 16) : (size.width - 16)];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setMultipleTouchEnabled:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    if( [self wantsWideSize] )
    {
        [self setActionViewSize:FCActionViewWide];
    }
    else if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        if( MIN(self.view.bounds.size.width, self.view.bounds.size.height) > 414 )
        {
            [self setActionViewSize:FCActionViewWide];
        }
        else
        {
            [self setActionViewSize:FCActionViewCompact];
        }
    }
    else
    {
        [self setActionViewSize:FCActionViewCompact];
    }
    
    [self setContentView:({
        FCActionContentView *f = [[FCActionContentView alloc] init];
        [f setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:f];
        if( [self actionViewSize] == FCActionViewCompact )
        {
            [f.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:10].active = YES;
            [f.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-10].active = YES;
            
            NSLayoutAnchor *bottomReferenceAnchor;
            if( @available(iOS 11.0, *) )
            {
                bottomReferenceAnchor = self.view.safeAreaLayoutGuide.bottomAnchor;
            }
            else
            {
                bottomReferenceAnchor = self.view.bottomAnchor;
            }
            
            self.contentHideConstraint = [f.topAnchor constraintEqualToAnchor:self.view.bottomAnchor];
            self.contentHideConstraint.active = YES;
            self.contentShowConstraint = [f.bottomAnchor constraintEqualToAnchor:bottomReferenceAnchor
                                                                        constant:CFIsiPhoneX ? -68 : -76];
            self.contentHideConstraint.active = YES;
        }
        else
        {
            [self setContentShowConstraint:[f.widthAnchor constraintEqualToConstant:320]];
            [self.contentShowConstraint setActive:YES];
            [self layoutContentViewToSize:self.view.frame.size];
            [f.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
            [f.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
            [f setTransform:CGAffineTransformMakeScale(1.12f, 1.12f)];
            [f setAlpha:0];
        }
        f;
    })];
    
    // Calculate the height
    [self setContentViewHeight:0];
    NSLayoutAnchor *referenceAnchor = self.contentView.topAnchor;
    for( FCActionView *view in self.arrangedViews )
    {
        [self.contentView addSubview:view];
        
        [view.topAnchor constraintEqualToAnchor:referenceAnchor].active = YES;
        [view.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
        [view.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
        
        referenceAnchor = view.bottomAnchor;
        self.contentViewHeight += view.preferHeight;
    }
    [self setContentViewHeight:self.contentViewHeight + 4];
    [self.contentView.heightAnchor constraintEqualToConstant:self.contentViewHeight].active = YES;
    
    if( [self actionViewSize] == FCActionViewCompact )
    {
        [self setActionCancel:({
            FCActionCancel *f = [[FCActionCancel alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                image:nil];
            [self.view addSubview:f];
            [f setTranslatesAutoresizingMaskIntoConstraints:NO];
            [f.topAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:10].active = YES;
            [f.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor].active = YES;
            [f.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor].active = YES;
            f;
        })];
    }
    
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapExecutor:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        tap;
    })];
    [self.view addGestureRecognizer:({
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panExecutor:)];
        pan.maximumNumberOfTouches = 1;
        pan;
    })];
}

- (FCActionView *)actionViewOnLocation:(CGPoint)location
{
    CGPoint contentLocation = [self.view convertPoint:location toView:self.contentView];
    FCActionView *result;
    for( FCActionView *view in self.arrangedViews )
    {
        if( CGRectContainsPoint(view.frame, contentLocation) && [view actionEnable] )
        {
            result = view;
            break;
        }
    }
    if( result == nil && [self actionCancel] )
    {
        if( CGRectContainsPoint(self.actionCancel.frame, location) )
        {
            result = self.actionCancel;
        }
    }
    return result;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    FCActionView *actionView = [self actionViewOnLocation:[[touches anyObject] locationInView:self.view]];
    
    if( actionView )
    {
        [actionView setBackgroundColor:[UIColor colorWithWhite:0 alpha:.12f]];
        [actionView setActionSelected:YES];
    }
}

- (void)tapExecutor:(UITapGestureRecognizer *)tap
{
    FCActionView *actionView = [self actionViewOnLocation:[tap locationInView:self.view]];
    
    if( actionView )
    {
        [self dismissViewControllerAnimated:YES completion:^{
            if( self.actionExecutor )
            {
                self.actionExecutor(actionView.titleLabel.text);
            }
        }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)panExecutor:(UIPanGestureRecognizer *)pan
{
    if( [pan state] == UIGestureRecognizerStateBegan )
    {
        [self setSelectionFeedbackGenerator:[UISelectionFeedbackGenerator new]];
        [self.selectionFeedbackGenerator prepare];
    }
    else if( [pan state] == UIGestureRecognizerStateChanged )
    {
        [self touchesOnLocation:[pan locationInView:self.view]];
    }
    else
    {
        FCActionView *actionView = [self actionViewOnLocation:[pan locationInView:self.view]];
        
        [self.arrangedViews enumerateObjectsUsingBlock:^(FCActionView *view, NSUInteger i, BOOL *stop){
            [view setActionSelected:NO];
        }];
        [self.actionCancel setActionSelected:NO];
        [self setSelectionFeedbackGenerator:nil];
        
        if( actionView )
        {
            [self dismissViewControllerAnimated:YES completion:^{
                if( self.actionExecutor )
                {
                    self.actionExecutor(actionView.titleLabel.text);
                }
            }];
        }
    }
}

- (void)touchesOnLocation:(CGPoint)location
{
    CGPoint locationInContent = [self.view convertPoint:location toView:self.contentView];
    
    __block FCActionView *hintedView;
    
    [self.arrangedViews enumerateObjectsUsingBlock:^(FCActionView *view, NSUInteger i, BOOL *stop){
        if( CGRectContainsPoint(view.frame, locationInContent) && [view actionEnable] == YES )
        {
            hintedView = view;
            if( [view actionSelected] == NO )
            {
                [self.selectionFeedbackGenerator selectionChanged];
                [self.selectionFeedbackGenerator prepare];
            }
            [view setActionSelected:YES];
        }
        else
        {
            [view setActionSelected:NO];
        }
    }];
    
    if( [self actionCancel] )
    {
        if( CGRectContainsPoint(self.actionCancel.frame, location) )
        {
            hintedView = self.actionCancel;
            if( [self.actionCancel actionSelected] == NO )
            {
                [self.selectionFeedbackGenerator selectionChanged];
                [self.selectionFeedbackGenerator prepare];
            }
            [self.actionCancel setActionSelected:YES];
        }
        else
        {
            [self.actionCancel setActionSelected:NO];
        }
    }
}

- (void)actionOnBackControl
{
    [self dismissViewControllerAnimated:YES completion:^{
        if( self.actionExecutor )
        {
            self.actionExecutor(nil);
        }
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .25f;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return presented == self ? self : nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return dismissed == self ? self : nil;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if( [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey] == self )
    {
        [self animatePresentationWithTransition:transitionContext];
    }
    else
    {
        [self animateDismissalWithTranition:transitionContext];
    }
}

- (void)animatePresentationWithTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIView *toView   = [transitionContext viewForKey:UITransitionContextToViewKey];
    [[transitionContext containerView] addSubview:toView];
    
    [self.view layoutIfNeeded];
    void (^animations)(void) = ^{
        if( [self actionViewSize] == FCActionViewCompact )
        {
            [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:.24f]];
            [self.contentHideConstraint setActive:NO];
            [self.contentShowConstraint setActive:YES];
            [self.view layoutIfNeeded];
        }
        else
        {
            [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:.24f]];
            [self.contentView setTransform:CGAffineTransformIdentity];
            [self.contentView setAlpha:1];
        }
    };
    void (^completion)(BOOL) = ^(BOOL f){ [transitionContext completeTransition:YES]; };
    [UIView animateWithDuration:.25f delay:0 options:( 7 << 16 ) animations:animations completion:completion];
}

- (void)animateDismissalWithTranition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    void (^animations)(void) = ^{
        if( [self actionViewSize] == FCActionViewCompact )
        {
            [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
            [self.contentShowConstraint setActive:NO];
            [self.contentHideConstraint setActive:YES];
            [self.view layoutIfNeeded];
        }
        else
        {
            [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
            [self.contentView setTransform:CGAffineTransformMakeScale(.89, .89)];
            [self.contentView setAlpha:0];
        }
    };
    void (^completion)(BOOL) = ^(BOOL f){ [transitionContext completeTransition:YES]; };
    [UIView animateWithDuration:.25f delay:0 options:( 7 << 16 ) animations:animations completion:completion];
}

@end
