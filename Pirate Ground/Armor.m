//
//  Armor.m
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import "Armor.h"

@implementation Armor

@synthesize armorName;
@synthesize armorProtection;

- (instancetype)initWithName: (NSString *)name withProtection: (int)protection
{
    Armor *newArmor = [[Armor alloc] init];
    newArmor.armorName = name;
    newArmor.armorProtection = protection;
    return newArmor;
}

@end