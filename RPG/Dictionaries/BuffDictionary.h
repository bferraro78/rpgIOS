//
//  BuffDictionary.h
//  RPG
//
//  Created by Ben Ferraro on 5/18/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef BuffDictionary_h
#define BuffDictionary_h
#import "Constants.h"
@interface BuffDictionary : NSObject


@property NSMutableDictionary *buffLibrary;
@property NSMutableDictionary *buffLibToName;

+(void)loadBuffLibrary;
+(NSString*)getDescription:(NSString*)s;
+(NSString*)getName:(NSString*)s;

@end

#endif /* BuffDictionary_h */
