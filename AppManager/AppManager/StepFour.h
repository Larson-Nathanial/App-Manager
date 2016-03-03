//
//  StepFour.h
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepFour : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *nextOutlet;
- (IBAction)nextButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *monthlyOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *annualOutlet;
- (IBAction)monthlyAction:(id)sender;
- (IBAction)annualAction:(id)sender;

@end
