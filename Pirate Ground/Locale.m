//
//  Locale.m
//  Pirate Ground
//
//  Created by Loh, Peter on 11/17/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import "Locale.h"

@implementation Locale

@synthesize localeDescription;
@synthesize imageName;

- (instancetype)initWithDescription: (NSString *)description withImageName: (NSString *)image
{
    Locale *newLocale = [[Locale alloc] init];
    newLocale.localeDescription = description;
    newLocale.imageName = image;
    
    return newLocale;
}

@end
