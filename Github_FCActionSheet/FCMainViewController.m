//
//  FCMainViewController.m
//  Github_FCActionSheet
//
//  Created by William Steven Brohawn on 08/03/2018.
//  Copyright © 2018 William Steven Brohawn. All rights reserved.
//

#import <MessageUI/MessageUI.h>

#import "FCMainViewController.h"
#import "FCActionController.h"
#import "FCAssistant.h"

@interface FCMainViewController()

@property( nonatomic, strong ) UIButton             *button;
@property( nonatomic, strong ) UISwitch             *switchControl;

@end

@implementation FCMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setButton:({
        UIButton *aButton = [[UIButton alloc] init];
        [aButton setTitle:NSLocalizedString(@"Tap here", nil) forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [aButton setTitleColor:[UIColor colorWithWhite:1 alpha:.4f] forState:UIControlStateHighlighted];
        [aButton setBackgroundColor:[self.view tintColor]];
        [aButton setContentEdgeInsets:UIEdgeInsetsMake(0, 44, 0, 44)];
        [aButton addTarget:self
                    action:@selector(showActionSheetViewController)
          forControlEvents:UIControlEventTouchUpInside];
        [aButton.layer setMask:[CAShapeLayer layer]];
        [aButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:aButton];
        [aButton.heightAnchor constraintEqualToConstant:48.0f].active = YES;
        [aButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
        [aButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
        aButton;
    })];
    
    UILabel *aLabel = [[UILabel alloc] init];
    [aLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    [aLabel setText:NSLocalizedString(@"Wants Wide Size", nil)];
    [aLabel setTextColor:[UIColor blackColor]];
    [aLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:aLabel];
    [aLabel.topAnchor constraintEqualToAnchor:self.button.bottomAnchor constant:24.0f].active = YES;
    [aLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-30.0f].active = YES;
    
    [self setSwitchControl:({
        UISwitch *aSwitch = [[UISwitch alloc] init];
        [aSwitch setOnTintColor:self.view.tintColor];
        [aSwitch setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.view addSubview:aSwitch];
        [aSwitch.leftAnchor constraintEqualToAnchor:aLabel.rightAnchor constant:16.0f].active = YES;
        [aSwitch.centerYAnchor constraintEqualToAnchor:aLabel.centerYAnchor].active = YES;
        aSwitch;
    })];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIBezierPath *path = [UIBezierPath smoothRoundedRect:self.button.bounds cornerRadius:8.0f];
    [((CAShapeLayer *)self.button.layer.mask) setPath:[path CGPath]];
}

- (void)showActionSheetViewController
{
    NSString *const kTestAction00 = NSLocalizedString(@"Email", nil);
    NSString *const kTestAction01 = NSLocalizedString(@"iMessage", nil);
    NSString *const kTestAction02 = NSLocalizedString(@"Tell a Friend", nil);
    NSString *const kTestAction03 = NSLocalizedString(@"Rate on the App Store", nil);
    
    FCActionController *actionController = [FCActionController actionExecutor:^(NSString *action){ NSLog(@"%@", action); }];
    [actionController setWantsWideSize:self.switchControl.isOn];

    [actionController addActionObject:[FCActionObject objectWithTitle:NSLocalizedString(@"Advice & Questions", nil)]];

    [actionController addActionObject:[FCActionObject objectWithTitle:kTestAction00
                                                                image:[UIImage imageNamed:@"Email30"]
                                                            tintColor:[self.view tintColor]]];
    if( [MFMailComposeViewController canSendMail] == NO )
    {
        [actionController setActionUnavailableForLastAction];
    }
    [actionController addActionObject:[FCActionObject objectWithTitle:kTestAction01
                                                                image:[UIImage imageNamed:@"Chat30"]
                                                            tintColor:[UIColor colorRGB:75 :215 :99 :1]]];
    if( [MFMessageComposeViewController canSendText] == NO )
    {
        [actionController setActionUnavailableForLastAction];
    }


    [actionController addActionObject:[FCActionObject objectWithTitle:NSLocalizedString(@"Enjoying?", nil)]];
    
    [actionController addActionObject:[FCActionObject objectWithTitle:kTestAction02
                                                                image:[UIImage imageNamed:@"Friend30"]
                                                            tintColor:[UIColor colorRGB:255 :44 :85 :1]]];
    [actionController addActionObject:[FCActionObject objectWithTitle:kTestAction03
                                                                image:[UIImage imageNamed:@"Star30"]
                                                            tintColor:[UIColor colorRGB:255 :197 :39 :1]]];

    [self presentViewController:actionController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
