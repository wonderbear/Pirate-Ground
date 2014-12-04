//
//  TreasureChest.h
//  Pirate Ground
//
//  Created by Loh, Peter on 11/20/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weapon.h"
#import "Armor.h"

@interface TreasureChest : NSObject

@property BOOL isWeapon;
@property Weapon *weapon;
@property Armor *armor;

@end