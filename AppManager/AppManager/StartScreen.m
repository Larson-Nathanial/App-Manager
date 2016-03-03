//
//  StartScreen.m
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "StartScreen.h"
#import "LoginCreateAccount.h"

@implementation StartScreen

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Welcome";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 / 255.0 green:128.0 / 255.0 blue:204.0 / 255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.watchIntroOutlet.layer.cornerRadius = 3.0;
    self.getStartedOutlet.layer.cornerRadius = 3.0;
}

- (IBAction)watchIntroAction:(id)sender {
    // Take to YouTube to watch the video.
}

- (IBAction)getStartedAction:(id)sender {
    [self.navigationController pushViewController:[LoginCreateAccount new] animated:YES];
}

@end
