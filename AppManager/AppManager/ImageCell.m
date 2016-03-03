//
//  ImageCell.m
//  SBApp
//
//  Created by Nathan Larson on 10/3/15.
//  Copyright © 2015 Nathan Larson. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()<UIScrollViewDelegate>

@end

@implementation ImageCell

- (void)loadImages:(NSArray *)images
{
    self.imageScroller.delegate = self;
    
    for (int i = 0; i < self.imageScroller.subviews.count; i++) {
        if ([self.imageScroller.subviews[i] isKindOfClass:[UIImageView class]]) {
            [self.imageScroller.subviews[i] removeFromSuperview];
            
        }
        
    }
    for (int i = 0; i < self.imageScroller.subviews.count; i++) {
        if ([self.imageScroller.subviews[i] isKindOfClass:[UIButton class]]) {
            [self.imageScroller.subviews[i] removeFromSuperview];
            
        }
        
    }

    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = images.count - 1;
    
    self.imageScroller.contentSize = CGSizeMake(self.contentView.bounds.size.width * images.count, self.contentView.bounds.size.width);
    
    for (int i = 0; i < (int)images.count; i++) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.frame = CGRectMake(self.contentView.bounds.size.width * i, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.width);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake((self.contentView.bounds.size.width * (i + 1)) - 59.0, 10.0, 44.0, 44.0);
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/%@", images[i]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                imageView.image = [[UIImage alloc] initWithData:data];
                [self.imageScroller bringSubviewToFront:button];
            });
        });
        [self.imageScroller addSubview:imageView];
        
        if (self.showDeleteButton) {
            button.backgroundColor = [UIColor redColor];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"X" forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:36.0]];
            [button addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            button.layer.cornerRadius = 2.0;
            
            [self.imageScroller addSubview:button];
        }
        
        
    }
    [self.imageScroller setContentOffset:CGPointMake(self.contentView.bounds.size.width * (images.count - 1), 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    self.pageControl.currentPage = page;
}

-(void)deletePhoto:(UIButton *)sender
{
    self.deleteImage(sender);
}


@end
