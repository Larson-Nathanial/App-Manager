//
//  StartScreen.h
//  AppManager
//
//  Created by Nathan Larson on 12/22/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScreen : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *watchIntroOutlet;
@property (weak, nonatomic) IBOutlet UIButton *getStartedOutlet;
- (IBAction)watchIntroAction:(id)sender;
- (IBAction)getStartedAction:(id)sender;

@end
