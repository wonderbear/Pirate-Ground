//
//  Tile.h
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Weapon.h"
#import "Armor.h"
#import "TreasureChest.h"

@interface Tile : NSObject

@property (strong, nonatomic) NSString *localeDescription;
@property (strong, nonatomic) NSString *tileImage;
@property (strong, nonatomic) NSString *actionButtonName;
@property (nonatomic) BOOL canAct;
@property (nonatomic) BOOL treasureChestPresent;
@property (strong, nonatomic) TreasureChest *treasureChest;

@end
