//
//  StepOne.h
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepOne : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *nextOutlet;
- (IBAction)nextButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *businessNameField;

@end
