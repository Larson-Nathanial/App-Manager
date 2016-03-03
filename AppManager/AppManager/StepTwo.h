//
//  StepTwo.h
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepTwo : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *nextOutlet;
- (IBAction)nextButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

@end
