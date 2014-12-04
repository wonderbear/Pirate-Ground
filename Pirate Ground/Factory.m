//
//  Factory.m
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import "Factory.h"
#import "Locale.h"
#import "Tile.h"
#import "TreasureChest.h"
#import "Character.h"
#import "Boss.h"

@interface Factory ()

@property (strong, nonatomic) NSMutableArray *columnOne;
@property (strong, nonatomic) NSMutableArray *columnTwo;
@property (strong, nonatomic) NSMutableArray *columnThree;
@property (strong, nonatomic) NSMutableArray *columnFour;
@property (strong, nonatomic) NSArray *tiles;
@property (strong, nonatomic) Tile *tileToPopulate;
@property (strong, nonatomic) Character *character;
@property (strong, nonatomic) Boss *boss;
@property (strong, nonatomic) NSMutableArray *locales;
@property (strong, nonatomic) NSNumber *descriptionCount;
@property int numberOfTreasureChests;
@property (strong, nonatomic) NSMutableArray *weaponList;
@property (strong, nonatomic) NSMutableArray *armorList;

@end

@implementation Factory

- (Character*)generateCharacter
{
    _character = [[Character alloc] init];
    
    Weapon *initialWeapon = [[Weapon alloc] init];
    initialWeapon.weaponName = @"Dagger";
    initialWeapon.weaponDamageDone = 10;
    _character.weaponHeld = initialWeapon;
    
    Armor *initialArmor = [[Armor alloc] init];
    initialArmor.armorName = @"Cloth";
    initialArmor.armorProtection = 15;
    _character.armorWorn = initialArmor;
    
    _character.characterHealth = 100 + _character.armorWorn.armorProtection;
    
    _character.currentLocation = CGPointMake(0, 0);
    
    return _character;
}

- (Boss *)generateBoss
{
    _boss = [[Boss alloc] init];
    _boss.bossHealth = 150;
    
    Weapon *initialWeapon = [[Weapon alloc] init];
    initialWeapon.weaponName = @"Cutlass";
    initialWeapon.weaponDamageDone = 25;
    _boss.bossDamage = initialWeapon.weaponDamageDone;
    _boss.weaponHeld = initialWeapon;
    
    Armor *initialArmor = [[Armor alloc] init];
    initialArmor.armorProtection = 15;
    
    _boss.currentLocation = [self generateBossHideout];
    
    return _boss;
}

- (CGPoint)generateBossHideout
{
    int i;
    do {
        i = arc4random() % 4;
    } while (i < 2);
    
    int j = arc4random() % 3;
    
    return CGPointMake(i, j);
}

- (NSArray *)generateMapWithBoss:(Boss *)boss
{
    _columnOne = [[NSMutableArray alloc] init];
    _columnTwo = [[NSMutableArray alloc] init];
    _columnThree = [[NSMutableArray alloc] init];
    _columnFour = [[NSMutableArray alloc] init];
    
    _columnOne = [self generateColumn:_columnOne];
    _columnTwo = [self generateColumn:_columnTwo];
    _columnThree = [self generateColumn:_columnThree];
    _columnFour = [self generateColumn:_columnFour];
    
    _tiles = [[NSArray alloc] initWithObjects:_columnOne, _columnTwo, _columnThree, _columnFour, nil];
    
    _boss = boss;
    [self initializeStartingTile];
    [self initializeBossHideout];
    [self populateTiles];
    
    return _tiles;
}

- (id)generateColumn: (NSMutableArray *)columnID
{
    NSMutableArray *columnArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 4; i++) {
        [columnArray addObject:[self generateTiles]];
    }
    
    columnID = columnArray;
    return columnID;
}

- (id)generateTiles
{
    Tile *newTile = [[Tile alloc] init];
    return newTile;
}

- (void)initializeStartingTile
{
    _tileToPopulate = [[_tiles objectAtIndex:0] objectAtIndex:0];
    _tileToPopulate.localeDescription = @"You have been stranded on an island by your mutinous crew. Unfortunately for you, this island belongs to the fearsome pirate, Captain Dreadhook. The only way to get off the island is to defeat Dreadhook in combat and sail off on his flagship, the Flayed Goat.\n\nYou are on the shore of Dreadhook Isle. There is nothing but sand, water, and palm trees swaying in the breeze.";
    _tileToPopulate.tileImage = @"Start.jpg";
    _tileToPopulate.canAct = NO;
    _tileToPopulate.treasureChestPresent = NO;
}

- (void)initializeBossHideout
{
    _tileToPopulate = [[_tiles objectAtIndex:_boss.currentLocation.x] objectAtIndex:_boss.currentLocation.y];
    _tileToPopulate.localeDescription = @"Captain Dreadhook stands before you brandishing his cutlass. 'Scurvy dog! What're ya doing on me island? Draw steel and prepare to meet thy doom.'";
    _tileToPopulate.tileImage = @"PirateBoss.jpg";
    _tileToPopulate.canAct = YES;
    _tileToPopulate.treasureChestPresent = NO;
}

- (void)populateTiles
{
    _tileToPopulate = [[Tile alloc] init];
    _numberOfTreasureChests = 0;
    
    [self initializeLocales];
    [self initializeWeaponList];
    [self initializeArmorList];
    
    _descriptionCount = [[NSNumber alloc] initWithUnsignedLong:[_locales count]];
    for (int tileXPosition = 0; tileXPosition < 4; tileXPosition++) {
        for (int tileYPosition = 0; tileYPosition < 3; tileYPosition++) {
            _tileToPopulate = [[_tiles objectAtIndex:tileXPosition] objectAtIndex:tileYPosition];
            if ((tileXPosition != 0 || tileYPosition != 0) && (tileXPosition != _boss.currentLocation.x || tileYPosition != _boss.currentLocation.y)){
                Locale *currentLocale = [[Locale alloc] init];
                currentLocale = [self assignLocale];
                _tileToPopulate.localeDescription = currentLocale.localeDescription;
                _tileToPopulate.tileImage = currentLocale.imageName;
                [self treasureChestPresent];
            }
        }
    }
}

- (void)initializeLocales
{
    Locale *locale1 = [[Locale alloc] initWithDescription:@"The sound of screeching is accompanied by a hail of coconuts raining down on you from above." withImageName:@"Monkey.jpg"];
    Locale *locale2 = [[Locale alloc] initWithDescription:@"Tall trees with hanging vines surround you. The vegetation is so thick it is almost dark as night even though it is still midday." withImageName:@"Jungle.jpg"];
    Locale *locale3 = [[Locale alloc] initWithDescription:@"The sea breeze feels good on your skin as you climb up a steep hill looking out across the island. You can see thick jungle and a castle off in the distance." withImageName:@"Hill.jpg"];
    Locale *locale4 = [[Locale alloc] initWithDescription:@"Having ventured into a small clearing you stop to rest. The sun is fierce and is beating down upon you. A bottle of rum would go down nice around now." withImageName:@"Clearing.jpg"];
    Locale *locale5 = [[Locale alloc] initWithDescription:@"You hear something in the grass and crouch down, waiting. It is eerily quiet. Minutes pass before you decide it is safe to continue." withImageName:@"Grass.jpg"];
    Locale *locale6 = [[Locale alloc] initWithDescription:@"The grasses suddenly rustle around you and a warthog explodes out from them. Instinctively, you raise your weapon and strike the beast, killing it in a single blow!" withImageName:@"Warthog.jpg"];
    Locale *locale7 = [[Locale alloc] initWithDescription:@"Hours pass and the sun is still beating down upon you. You begin to feel faint as heat exhaustion begins to take hold." withImageName:@"Sun.jpg"];
    Locale *locale8 = [[Locale alloc] initWithDescription:@"Is it a mirage? No, there is a small pond in the distance. You rush to it and quench your burning thirst." withImageName:@"Pond.jpg"];
    Locale *locale9 = [[Locale alloc] initWithDescription:@"Some shade would be a welcome relief. You should find some shelter from the sun to rest." withImageName:@"Shelter.jpg"];
    Locale *locale10 = [[Locale alloc] initWithDescription:@"Nervously, you work through the thick undergrowth. You emerge in a clearing, surprising a jaguar feasting on its recent kill. Snarling, it leaps at you and slashes your leg before you are able to fight it off." withImageName:@"Jaguar.jpg"];
    
    _locales = [[NSMutableArray alloc] initWithObjects:locale1, locale2, locale3, locale4, locale5, locale6, locale7, locale8, locale9, locale10, nil];
}

- (void)initializeWeaponList
{
    _weaponList = [[NSMutableArray alloc] init];
    Weapon *weapon1 = [[Weapon alloc] initWithName:@"Club" withDamage:8];
    [_weaponList addObject:weapon1];
    Weapon *weapon2 = [[Weapon alloc] initWithName:@"Rapier" withDamage:30];
    [_weaponList addObject:weapon2];
    Weapon *weapon3 = [[Weapon alloc] initWithName:@"Pistol" withDamage:200];
    [_weaponList addObject:weapon3];
}

- (void)initializeArmorList
{
    _armorList = [[NSMutableArray alloc] init];
    Armor *armor1 = [[Armor alloc] initWithName:@"Leather Shirt" withProtection:20];
    [_armorList addObject:armor1];
    Armor *armor2 = [[Armor alloc] initWithName:@"Round Shield" withProtection:30];
    [_armorList addObject:armor2];
    Armor *armor3 = [[Armor alloc] initWithName:@"Chain Shirt" withProtection:40];
    [_armorList addObject:armor3];
}

- (Locale *)assignLocale
{
    int i = arc4random() % [_locales count];
    Locale *currentLocale = [[Locale alloc] init];
    currentLocale = [_locales objectAtIndex:i];
    [_locales removeObjectAtIndex:i];
    _descriptionCount = [NSNumber numberWithUnsignedLong:[_locales count]];
    return currentLocale;
}

- (void)treasureChestPresent
{
    _tileToPopulate.treasureChest = [[TreasureChest alloc] init];
    int i = arc4random() % 20;
    if ((i > 15) && (_numberOfTreasureChests < 2)) {
        _tileToPopulate.canAct = YES;
        _tileToPopulate.treasureChestPresent = YES;
        _tileToPopulate.localeDescription = [_tileToPopulate.localeDescription stringByAppendingFormat:@"\n\nYou spot a treasure chest on the ground, partially obscured by vegetation."];
        int isWeaponOrArmorChest = arc4random() % 3;
        switch (isWeaponOrArmorChest) {
            case 1:
                [self getArmorItem];
                break;
                
            default:
                [self getWeaponItem];
                break;
        }
        
        _numberOfTreasureChests++;
    } else {
        _tileToPopulate.canAct = NO;
        _tileToPopulate.treasureChestPresent = NO;
    }
}

- (void)getArmorItem
{
    _tileToPopulate.treasureChest.isWeapon = NO;
    int randomArmor = arc4random() % 6;
    switch (randomArmor) {
        case 1:
            if ([_armorList objectAtIndex:2]) {
                _tileToPopulate.treasureChest.armor = [_armorList objectAtIndex:2];
                [_armorList removeObjectAtIndex:2];
                break;
            }
            
        case 2:
            if ([_armorList objectAtIndex:1]) {
                _tileToPopulate.treasureChest.armor = [_armorList objectAtIndex:1];
                [_armorList removeObjectAtIndex:1];
                break;
            }
            
        case 3:
            if ([_armorList objectAtIndex:1]) {
                _tileToPopulate.treasureChest.armor = [_armorList objectAtIndex:1];
                [_armorList removeObjectAtIndex:1];
                break;
            }
            
        default:
            if ([_armorList objectAtIndex:0]) {
                _tileToPopulate.treasureChest.armor = [_armorList objectAtIndex:0];
                [_armorList removeObjectAtIndex:0];
                break;
            }
    }
    
}

- (void)getWeaponItem
{
    _tileToPopulate.treasureChest.isWeapon = YES;
    int randomWeapon = arc4random() % 6;
    switch (randomWeapon) {
        case 1:
            if ([_weaponList objectAtIndex:2]) {
                _tileToPopulate.treasureChest.weapon = [_weaponList objectAtIndex:2];
                [_weaponList removeObjectAtIndex:2];
                break;
            }
            
        case 2:
            if ([_weaponList objectAtIndex:1]) {
                _tileToPopulate.treasureChest.weapon = [_weaponList objectAtIndex:1];
                [_weaponList removeObjectAtIndex:1];
                break;
            }
            
        case 3:
            if ([_weaponList objectAtIndex:1]) {
                _tileToPopulate.treasureChest.weapon = [_weaponList objectAtIndex:1];
                [_weaponList removeObjectAtIndex:1];
                break;
            }
            
        default:
            if ([_weaponList objectAtIndex:0]) {
                _tileToPopulate.treasureChest.weapon = [_weaponList objectAtIndex:0];
                [_weaponList removeObjectAtIndex:0];
                break;
            }
    }
}

@end