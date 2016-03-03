//
//  ImageCell.h
//  SBApp
//
//  Created by Nathan Larson on 10/3/15.
//  Copyright © 2015 Nathan Larson. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIScrollView *imageScroller;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (nonatomic, copy) void (^deleteImage)(id sender);

- (void)loadImages:(NSArray *)images;
@property (nonatomic) BOOL showDeleteButton;

@end
