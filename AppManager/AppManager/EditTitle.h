//
//  EditTitle.h
//  AppManager
//
//  Created by Nathan Larson on 12/18/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"

@interface EditTitle : UIViewController

@property (nonatomic) ProductObject *productObject;
@property (weak, nonatomic) IBOutlet UITextField *productTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *productPriceTextField;
@property (weak, nonatomic) IBOutlet UITextField *productShippingTextField;
@property (weak, nonatomic) IBOutlet UITextField *productQuantityTextField;

@end
