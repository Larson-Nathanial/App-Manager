//
//  MyInfoViewController.h
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *businessName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *emailAddress;
@property (weak, nonatomic) IBOutlet UITextField *password;
@end
