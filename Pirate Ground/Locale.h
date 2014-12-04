//
//  Locale.h
//  Pirate Ground
//
//  Created by Loh, Peter on 11/17/14.
//  Copyright (c) 2014 Loh, Peter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Locale : NSObject

@property (strong, nonatomic) NSString *localeDescription;
@property (strong, nonatomic) NSString *imageName;

- (instancetype)initWithDescription: (NSString *)description withImageName: (NSString *)imageName;

@end
