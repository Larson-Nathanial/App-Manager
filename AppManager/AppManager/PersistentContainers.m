//
//  PersistentContainers.m
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import "PersistentContainers.h"

@implementation PersistentContainers

+ (PersistentContainers *)persistentContainers
{
    static PersistentContainers *persistentContainers = nil;
    
    if (!persistentContainers) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            persistentContainers = [[self alloc] initPrivate];
        });
    }
    return persistentContainers;
}

- (instancetype)initPrivate
{
    self = [super init];
    self.imagesDictionary = [NSMutableDictionary new];
    return self;
}

@end
