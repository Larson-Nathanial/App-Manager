//
//  ProductDetailsViewController.h
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductObject.h"

@interface ProductDetailsViewController : UIViewController

@property (nonatomic) NSString *categorySelected;
@property (nonatomic) NSString *categoryId;
@property (nonatomic) ProductObject *productObject;
@property (nonatomic) BOOL viewingFromOrder;

@end
