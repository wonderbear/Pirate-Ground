//
//  Character.h
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Armor.h"
#import "Weapon.h"

@interface Character : NSObject

@property (nonatomic) int characterHealth;
@property (strong, nonatomic) Armor *armorWorn;
@property (strong, nonatomic) Weapon *weaponHeld;
@property (nonatomic) CGPoint currentLocation;

@end
