//
//  PlanInfoViewController.m
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import "PlanInfoViewController.h"
#import "Connection.h"
#import "ChangeCard.h"

@interface PlanInfoViewController ()
@property (nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) UIView *coverView;
@end

@implementation PlanInfoViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255.0 green:245.0 / 255.0 blue:245.0 / 255.0 alpha:1.0];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = @"Plan Info";
    titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:22.0];
    titleLabel.frame = CGRectMake(0, 0, 150, 30);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    _coverView = [UIView new];
    _coverView.frame = self.view.frame;
    _coverView.backgroundColor = [UIColor colorWithWhite:245.0 / 255.0 alpha:1.0];
    [self.view addSubview:_coverView];
    
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicator.tintColor = [UIColor colorWithRed:244.0 / 255.0 green:88.0 / 255.0 blue:0.0 / 255.0 alpha:1.0];
    _activityIndicator.center = self.view.center;
    [_activityIndicator startAnimating];
    [_coverView addSubview:_activityIndicator];
    _coverView.alpha = 0.0;
    
    [self loadPlanInfo];
}

- (void)loadPlanInfo
{
    [UIView animateWithDuration:0.3 animations:^{
        _coverView.alpha = 1.0;
    }];
    dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(aQueue, ^{
        
        NSArray *array = [[Connection connection] loadPlanInformationForAccountId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.planType.text = [[array objectAtIndex:0] valueForKey:@"plan"];
            self.cardUsing.text = [NSString stringWithFormat:@"Card ending in %@", [[array objectAtIndex:0] valueForKey:@"last_four"]];
            
            [UIView animateWithDuration:0.3 animations:^{
                _coverView.alpha = 0.0;
            }];
        });
        
    });
}

- (IBAction)changeCardAction:(id)sender {
    
    ChangeCard *viewcontroller = [ChangeCard new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewcontroller];
    [self presentViewController:navController animated:YES completion:nil];
    
}

@end
