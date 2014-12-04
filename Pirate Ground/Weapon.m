//
//  Weapon.m
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import "Weapon.h"

@implementation Weapon

@synthesize weaponName;
@synthesize weaponDamageDone;

- (instancetype)initWithName: (NSString *)name withDamage: (int)damage
{
    Weapon *newWeapon = [[Weapon alloc] init];
    newWeapon.weaponName = name;
    newWeapon.weaponDamageDone = damage;
    return newWeapon;
}

@end
