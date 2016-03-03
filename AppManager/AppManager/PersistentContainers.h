//
//  PersistentContainers.h
//  WhiteLabelForAppManager
//
//  Created by Nathan Larson on 11/18/15.
//  Copyright © 2015 appselevated. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistentContainers : NSObject

+ (PersistentContainers *)persistentContainers;

@property (nonatomic) NSMutableDictionary *imagesDictionary;

@end
