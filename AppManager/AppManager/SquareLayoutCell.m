//
//  SquareLayoutCell.m
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "SquareLayoutCell.h"
#import "PersistentContainers.h"

@implementation SquareLayoutCell

- (void)loadImageForProductId:(NSString *)file_name
{
    self.listingImage.image = nil;
    self.imageCoverView.alpha = 1.0;
    
    if ([[[PersistentContainers persistentContainers] imagesDictionary] objectForKey:file_name]) {
        
        self.listingImage.image = [[[PersistentContainers persistentContainers] imagesDictionary] objectForKey:file_name];
        [UIView animateWithDuration:0.3 animations:^{
            self.imageCoverView.alpha = 0.0;
        }];
        
    }else {
        
        dispatch_queue_t aQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(aQueue, ^{
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.appselevated.com/%@", file_name]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data != nil) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.listingImage.image = [[UIImage alloc] initWithData:data];
                    [[[PersistentContainers persistentContainers] imagesDictionary] setObject:[[UIImage alloc] initWithData:data] forKey:file_name];
                    [self.activityIndicator stopAnimating];
                    [UIView animateWithDuration:0.3 animations:^{
                        self.imageCoverView.alpha = 0.0;
                    }];
                });
            }
        });
    }
}


@end
