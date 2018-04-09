//
//  Skill.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//


#import "Skill.h"
@implementation Skill

NSString *moveName;
NSString *moveDescription;
BOOL spell;
NSString *skillElementSpec;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    _moveName = aMoveName;
    _moveDescription = aMoveDescription;
    _spell = aSpell;
    _skillElementSpec = aElementSpec;
    return self;
}

/* Actual bodies are put in the Ability Class */
-(int)getCombatResourceCost:(int)totalResource { return 0; }
-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e { }
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap { }

@end
