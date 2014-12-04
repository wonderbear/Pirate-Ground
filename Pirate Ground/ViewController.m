//
//  ViewController.m
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import "ViewController.h"
#import "Factory.h"
#import "Tile.h"
#import "Character.h"
#import "Weapon.h"
#import "Armor.h"
#import "Boss.h"

@interface ViewController ()

@property (strong, nonatomic) NSArray *map;
@property (strong, nonatomic) Tile *currentTile;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITextView *localeText;
@property (strong, nonatomic) IBOutlet UILabel *healthGauge;
@property (strong, nonatomic) IBOutlet UILabel *damageGauge;
@property (strong, nonatomic) IBOutlet UILabel *weaponEquipped;
@property (strong, nonatomic) IBOutlet UILabel *armorWorn;

@property (strong, nonatomic) IBOutlet UIButton *eButton;
@property (strong, nonatomic) IBOutlet UIButton *sButton;
@property (strong, nonatomic) IBOutlet UIButton *wButton;
@property (strong, nonatomic) IBOutlet UIButton *nButton;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;

@property (strong, nonatomic) NSString *characterAttackMessage;
@property (strong, nonatomic) NSString *bossAttackMessage;
@property (strong, nonatomic) NSString *attackResultsText;
@property (strong, nonatomic) NSString *attackButton;


@end

@implementation ViewController

@synthesize character;
@synthesize boss;

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self startupGreeting];
    Factory *factory = [[Factory alloc] init];
    
    character = [factory generateCharacter];
    [self refreshCharacterStats];
    boss = [factory generateBoss];
    _map = [factory generateMapWithBoss:boss];
    
    _currentTile = [[Tile alloc] init];
    [self evaluateCurrentTile];
}

//- (void)startupGreeting
//{
//    UIAlertController *introduction = [UIAlertController alertControllerWithTitle:@"Ahoy!" message:@"You have been stranded on a desert island by your mutinous crew. Unfortunately for you, this island belongs to the fearsome pirate, Captain Dreadhook. The only way to get off the island is to defeat Dreadhook and sail off on his flagship, the Flayed Goat." preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *continueButton = [UIAlertAction actionWithTitle:@"Continue" style:UIAlertActionStyleDefault handler:nil];
//    [introduction addAction:continueButton];
//    [self presentViewController:introduction animated:NO completion:nil];
//}

- (void)refreshCharacterStats
{
    self.healthGauge.text = [NSString stringWithFormat:@"%i", character.characterHealth];
    self.damageGauge.text = [NSString stringWithFormat:@"%i", character.weaponHeld.weaponDamageDone];
    self.weaponEquipped.text = character.weaponHeld.weaponName;
    self.armorWorn.text = character.armorWorn.armorName;
}

- (void)evaluateCurrentTile
{
    _currentTile = [[_map objectAtIndex:character.currentLocation.x] objectAtIndex:character.currentLocation.y];
    [_actionButton setTitle:@"" forState:UIControlStateNormal];
    self.localeText.text = _currentTile.localeDescription;
    self.image.image = [UIImage imageNamed:_currentTile.tileImage];
    [self evaluateMovementOptions];
    [self evaluateActionOption];
    
}

- (void)evaluateMovementOptions
{
    _eButton.enabled = [self tileExistsAtPoint:CGPointMake(character.currentLocation.x + 1, character.currentLocation.y)];
    _sButton.enabled = [self tileExistsAtPoint:CGPointMake(character.currentLocation.x, character.currentLocation.y - 1)];
    _wButton.enabled = [self tileExistsAtPoint:CGPointMake(character.currentLocation.x - 1, character.currentLocation.y)];
    _nButton.enabled = [self tileExistsAtPoint:CGPointMake(character.currentLocation.x, character.currentLocation.y + 1)];
    
}

- (BOOL)tileExistsAtPoint:(CGPoint)point
{
    if (point.x >= 0 && point.y >= 0 && point.x < [_map count] && point.y < [[_map objectAtIndex:point.x] count]) {
        return YES;
    } else {
        return NO;
    }
}

- (void)evaluateActionOption
{
    if (_currentTile.canAct) {
        _actionButton.hidden = NO;
        if (_currentTile.treasureChestPresent) {
            [_actionButton setTitle:@"Open chest" forState:UIControlStateNormal];
        } else {
            [_actionButton setTitle:@"Attack" forState:UIControlStateNormal];
        }
    } else {
        _actionButton.hidden = YES;
    }
}

- (IBAction)eButtonPressed:(id)sender {
    character.currentLocation = CGPointMake(character.currentLocation.x + 1, character.currentLocation.y);
    [self evaluateCurrentTile];
}

- (IBAction)sButtonPressed:(id)sender {
    character.currentLocation = CGPointMake(character.currentLocation.x, character.currentLocation.y - 1);
    [self evaluateCurrentTile];
    
}

- (IBAction)wButtonPressed:(id)sender {
    character.currentLocation = CGPointMake(character.currentLocation.x - 1, character.currentLocation.y);
    [self evaluateCurrentTile];
    
}

- (IBAction)nButtonPressed:(id)sender {
    character.currentLocation = CGPointMake(character.currentLocation.x, character.currentLocation.y + 1);
    [self evaluateCurrentTile];
    
}

- (IBAction)action:(id)sender {
    if (_currentTile.treasureChestPresent) {
        [self openTreasureChest];
    } else {
        [self attackBoss];
    }
}

- (void)openTreasureChest
{
    NSString *treasureItem = [[NSString alloc] init];
    if (_currentTile.treasureChest.isWeapon) {
        treasureItem = _currentTile.treasureChest.weapon.weaponName;
    } else {
        treasureItem = _currentTile.treasureChest.armor.armorName;
    }
    UIAlertController *treasureChestFound = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"You have found a %@. Do you want to equip it?", treasureItem] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    [treasureChestFound addAction:cancelButton];
    UIAlertAction *equipItem = [UIAlertAction actionWithTitle:@"Equip item" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (_currentTile.treasureChest.isWeapon) {
            Weapon *weaponToTransfer = [[Weapon alloc] initWithName:character.weaponHeld.weaponName withDamage:character.weaponHeld.weaponDamageDone];
            character.weaponHeld.weaponName = _currentTile.treasureChest.weapon.weaponName;
            character.weaponHeld.weaponDamageDone = _currentTile.treasureChest.weapon.weaponDamageDone;
            _currentTile.treasureChest.weapon.weaponName = weaponToTransfer.weaponName;
            _currentTile.treasureChest.weapon.weaponDamageDone = weaponToTransfer.weaponDamageDone;
            [self refreshCharacterStats];
        } else {
            Armor *armorToTransfer = [[Armor alloc] initWithName:character.armorWorn.armorName withProtection:character.armorWorn.armorProtection];
            character.armorWorn.armorName = _currentTile.treasureChest.armor.armorName;
            character.armorWorn.armorProtection = _currentTile.treasureChest.armor.armorProtection;
            character.characterHealth = character.characterHealth + character.armorWorn.armorProtection;
            _currentTile.treasureChest.armor.armorName = armorToTransfer.armorName;
            _currentTile.treasureChest.armor.armorProtection = armorToTransfer.armorProtection;
            [self refreshCharacterStats];
        }
    }];
    [treasureChestFound addAction:equipItem];
    [self presentViewController:treasureChestFound animated:NO completion:nil];
}

- (void)attackBoss
{
    int firstAttack = arc4random() % 100;
    if (firstAttack > 55) {
        [self characterAttack];
        [self bossAttack];
        //        _attackResultsText = [NSString stringWithFormat:@"%@\n\n%@", characterAttackMessage, _bossAttackMessage];
    } else {
        [self bossAttack];
        [self characterAttack];
        //        _attackResultsText = [NSString stringWithFormat:@"%@\n\n%@", _bossAttackMessage, characterAttackMessage];
    }
}

- (void)characterAttack
{
    int attackRoll = arc4random() % 20;
    if (attackRoll > 12) {
        int damageTaken = arc4random() % character.weaponHeld.weaponDamageDone;
        boss.bossHealth = boss.bossHealth - damageTaken;
        
        if (boss.bossHealth > 0) {
            _characterAttackMessage = [NSString stringWithFormat:@"Your attack on Dreadhook is successful. He takes %i points of damage. Dreadhook scowls at you as he prepares to attack.", damageTaken];
            _attackButton = @"Continue";
        } else {
            _characterAttackMessage = @"You hit Dreadhook with a fatal blow! As he slumps to the ground, you hear him utter, 'Inconceiveable!'. Grabbing his famed hook as proof of your deed, you make your way to the Flayed Goat and take the wheel as its new Captain. Once again, you return to the high seas in search of fame and fortune!\n\nYou have defeated one of the mightiest pirates in history, Captain Dreadhook.\n\nWould you like to play again?";
            _attackButton = @"Try again";
            //handler:^(UIAlertAction *action) {
            //        [self viewDidLoad];
        }
    } else {
        _characterAttackMessage = @"Your attack misses its intended mark as Dreadhook easily steps out of the way. You ready yourself for his next move.";
        _attackButton = @"Continue";
    }
    _attackResultsText = _characterAttackMessage;
    [self attackResults];
}

- (void)bossAttack
{
    int attackRoll = arc4random() % 20;
    if (attackRoll > 11) {
        int damageTaken = arc4random() % boss.weaponHeld.weaponDamageDone;
        character.characterHealth = character.characterHealth - damageTaken;
        [self refreshCharacterStats];
        if (character.characterHealth > 0) {
            _bossAttackMessage = [NSString stringWithFormat:@"Dreadhook lunges at you and successfully hits you. You have received %i points of damage. You raise your weapon and prepare to strike back.", damageTaken];
            _attackButton = @"Continue";
        } else {
            _bossAttackMessage = @"As Dreadhook's cutlass enters your body you realize that you have reached the end of your journey.\n\nYou have died at the hands of Dreadhook. Would you like to restart?";
            _attackButton = @"Try again";
            //handler:^(UIAlertAction *action) {
            //      [self viewDidLoad];
        }
    } else {
        _bossAttackMessage = @"Dreadhook swings his cutlass in a vicious arc, but only slices air! You successfully dodge the attack. You prepare to counter.";
        _attackButton = @"Continue";
    }
    _attackResultsText = _characterAttackMessage;
    [self attackResults];
}

- (void)attackResults
{
    UIAlertController *attackResultsMessage = [UIAlertController alertControllerWithTitle:@"" message:_attackResultsText preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *attackMessageButton = [UIAlertAction actionWithTitle:_attackButton style:UIAlertActionStyleDefault handler:nil];
    [attackResultsMessage addAction:attackMessageButton];
    [self presentViewController:attackResultsMessage animated:NO completion:nil];
}

- (IBAction)resetButtonPressed:(id)sender {
    [self viewDidLoad];
}

@end