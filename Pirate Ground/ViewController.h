//
//  ViewController.h
//  Pirate Ground
//
//  Created by Loh, Peter on 10/30/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"
#import "Boss.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) Character *character;
@property (strong, nonatomic) Boss *boss;

@end