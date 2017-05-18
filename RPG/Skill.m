//
//  Skill.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Skill.h"
@implementation Skill

NSString *moveName;
NSString *moveDescription;
BOOL spell;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription spell:(BOOL)aSpell {
    _moveName = aMoveName;
    _moveDescription = aMoveDescription;
    _spell = aSpell;
    return self;
}


/* Actual bodies are put in the Ability Class */
-(int)getCombatResourceCost:(int)totalResource { return 0; }
-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap { }
-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter { }







@end