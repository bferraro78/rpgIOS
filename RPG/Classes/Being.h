//
//  Being.h
//  RPG
//
//  Created by james schuler on 4/18/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef Being_h
#define Being_h
@interface Being : NSObject

@property NSString *name;
@property int level;
@property int health; // HEALTH IS HEROES TOTAL HEALTH
@property int combatHealth; // COMBAT HEALTH IS USED TO DETERMINE HEALTH IN ONE INSTANCE OF COMBAT
@property int strn;
@property int inti;
@property int dext;
@property int vit;
@property NSString *elementSpec;

-(NSMutableDictionary*)beingToDictionary;
-(id)loadBeingFromDictionary:(NSDictionary*)partyHeroStats;

@end

#endif /* Being_h */
