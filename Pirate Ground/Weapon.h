//
//  Weapon.h
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weapon : NSObject

@property (nonatomic, strong) NSString *weaponName;
@property (nonatomic) int weaponDamageDone;

- (instancetype)initWithName: (NSString *)name withDamage: (int)damage;

@end
