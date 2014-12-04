//
//  Armor.h
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Armor : NSObject

@property (nonatomic, strong) NSString *armorName;
@property (nonatomic) int armorProtection;

- (instancetype)initWithName: (NSString *)name withProtection: (int)protection;

@end
