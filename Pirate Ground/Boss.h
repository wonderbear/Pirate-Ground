//
//  Boss.h
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Armor.h"
#import "Weapon.h"

@interface Boss : NSObject

@property (nonatomic, strong) NSString *bossName;
@property (nonatomic) int bossHealth;
@property (nonatomic) int bossDamage;
@property (strong, nonatomic) Armor *armorWorn;
@property (strong, nonatomic) Weapon *weaponHeld;
@property (nonatomic) CGPoint currentLocation;

@end
