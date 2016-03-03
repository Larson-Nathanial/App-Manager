//
//  PolicyEditor.h
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"

@interface PolicyEditor : UIViewController

// Can be refund, shipping or returns
@property (nonatomic) NSString *policyType;
@property (nonatomic) ProductObject *productObject;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
