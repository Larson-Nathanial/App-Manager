//
//  ProductList.h
//  AppManager
//
//  Created by Nathan Larson on 12/17/15.
//  Copyright (c) 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductList : UIViewController

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) NSString *categorySelected;
@property (nonatomic) NSString *categoryId;

@end
