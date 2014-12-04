//
//  Factory.h
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Character.h"
#import "Boss.h"
#import "Locale.h"

@interface Factory : NSObject

- (Character *)generateCharacter;
- (Boss *)generateBoss;
- (NSArray *)generateMapWithBoss: (Boss *)boss;

@end