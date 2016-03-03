//
//  SquareLayoutCell.h
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareLayoutCell : UICollectionViewCell

- (void)loadImageForProductId:(NSString *)file_name;

@property (weak, nonatomic) IBOutlet UILabel *product_title;
@property (weak, nonatomic) IBOutlet UILabel *product_price;
@property (weak, nonatomic) IBOutlet UIView *imageCoverView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *listingImage;

@end
