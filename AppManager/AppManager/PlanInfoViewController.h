//
//  PlanInfoViewController.h
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlanInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *planType;
@property (weak, nonatomic) IBOutlet UILabel *cardUsing;
- (IBAction)changeCardAction:(id)sender;

@end
