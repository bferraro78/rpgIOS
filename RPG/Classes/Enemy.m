//
//  Enemy.m
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Enemy.h"
@implementation Enemy

NSString *enemyName;
int enemyLevel;
int enemyHealth;
int enemyCombatHealth;
int enemyStrn;
int enemyInti;
int enemyDext;
int enemyArmor;
int enemyExp;
NSString *enemyElement;

NSMutableArray *enemySkillSet;
NSMutableDictionary *enemyBuffLibrary;
NSMutableDictionary *enemyDebuffLibrary;


-(id)initenemyName:(NSString*)aEnemyName enemyElement:(NSString*)aEnemyElement enemySkillSet:(NSMutableArray*)aEnemySkillSet enemyStrn:(int)aEnemyStrn enemyInti:(int) aEnemyInti enemyDext:(int)aEnemyDext enemyHealth:(int)aEnemyHealth
        enemyArmor:(int)aEnemyArmor {
    _enemyName = aEnemyName;
    _enemyElement = aEnemyElement;
    _enemyStrn = aEnemyStrn;
    _enemyInti = aEnemyInti;
    _enemyDext = aEnemyDext;
    _enemyHealth = aEnemyHealth;
    _enemyArmor = aEnemyArmor;
    _enemyBuffLibrary = [[NSMutableDictionary alloc] init];
    _enemyDebuffLibrary = [[NSMutableDictionary alloc] init];
    _enemySkillSet = [[NSMutableArray alloc] init];
    
    _combatDamageElementMap = [[NSMutableDictionary alloc] init];
    _combatDamageElementMap[FIRE] = [NSNumber numberWithInt:0];
    _combatDamageElementMap[COLD] = [NSNumber numberWithInt:0];
    _combatDamageElementMap[ARCANE] = [NSNumber numberWithInt:0];
    _combatDamageElementMap[POISON] = [NSNumber numberWithInt:0];
    _combatDamageElementMap[LIGHTNING] = [NSNumber numberWithInt:0];
    _combatDamageElementMap[PHYSICAL] = [NSNumber numberWithInt:0];
    
    [self setSkills:aEnemySkillSet];
    
    return self;
}

-(NSString*)selectAttack {
    int r = arc4random_uniform(100);
    int choice  = 0;
    if (r < 20) {
        choice = arc4random_uniform((unsigned int)[self.enemySkillSet count]-1)+1;
    }
    
    return [self.enemySkillSet objectAtIndex:choice];
}
-(void)setSkills:(NSMutableArray*)skills {
    for (id skill in skills) {
        [self.enemySkillSet addObject:skill];
    }
}

-(int)goldDrop {
    int r = arc4random_uniform(100);
    return r;
}
-(int)getExp {
    for (id item in mainCharacter.activeItems) {
        Item *tmp = (Item*) item;
        if ([tmp.getType rangeOfString:@"XPBoost"].location != NSNotFound) {
            /* Take into account the XPBOOST */
            self.enemyExp = (int)(self.enemyExp+(((float)[tmp getPotency]/100.0)*(float)self.enemyExp));
        }
    }
    return self.enemyExp;
}

-(float)getArmorRating { return (float)self.enemyArmor * (float)0.12; }


-(void)setHealth:(int)health {
    self.enemyHealth = health;
    self.enemyCombatHealth = self.enemyHealth;
    [self setExp];
}
-(void)setExp { self.enemyExp = (self.enemyHealth/3); }

-(void)takeDamage:(int)healthReductionOrIncrease {
    int oldCombatHealth = self.enemyCombatHealth;
    self.enemyCombatHealth = (oldCombatHealth-healthReductionOrIncrease);
    if (self.enemyCombatHealth > self.enemyHealth) {
        self.enemyCombatHealth = self.enemyHealth;
    }
}

-(NSMutableString*)printStats {
    NSMutableString *stats = [[NSMutableString alloc] init];
    
    [stats appendString:@"Enemy's Stats: \n"];
    [stats appendFormat:@"Name: %s\n" , [self.enemyName UTF8String]];
    [stats appendFormat:@"Element Spec: %s\n" , [self.enemyElement UTF8String]];
    
    [stats appendFormat:@"\n    STATS:%s\n" , ""];

    [stats appendFormat:@"Health: %u\n" , self.enemyHealth];
    [stats appendFormat:@"Armor: %u\n" , self.enemyArmor];
    [stats appendFormat:@"Strength: %u\n" , self.enemyStrn];
    [stats appendFormat:@"Initeligence: %u\n" , self.enemyInti];
    [stats appendFormat:@"Dexterity: %u\n" , self.enemyDext];
    
    return stats;
}

-(id)loadPartyMemberEnemy:(NSDictionary*)partyEnemyStats {
    _enemyName = partyEnemyStats[@"enemyName"];
    _enemyLevel = [partyEnemyStats[@"enemyLevel"] intValue];
    _enemyHealth = [partyEnemyStats[@"enemyHealth"] intValue];
    _enemyCombatHealth = [partyEnemyStats[@"enemyCombatHealth"] intValue];
    _enemyStrn = [partyEnemyStats[@"enemyStrn"] intValue];
    _enemyDext = [partyEnemyStats[@"enemyDext"] intValue];
    _enemyInti = [partyEnemyStats[@"enemyInti"] intValue];
    _enemyArmor = [partyEnemyStats[@"enemyArmor"] intValue];
    _enemyExp = [partyEnemyStats[@"enemyExp"] intValue];
    _enemyElement = partyEnemyStats[@"enemyElement"];
    return self;
}

-(NSMutableDictionary*)enemyPartyMemberToDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    jsonable[@"enemyName"] = _enemyName;
    jsonable[@"enemyLevel"] = [NSString stringWithFormat:@"%i", _enemyLevel];
    jsonable[@"enemyHealth"] = [NSString stringWithFormat:@"%i", _enemyHealth];
    jsonable[@"enemyCombatHealth"] = [NSString stringWithFormat:@"%i", _enemyCombatHealth];
    jsonable[@"enemyStrn"] = [NSString stringWithFormat:@"%i", _enemyStrn];
    jsonable[@"enemyInti"] = [NSString stringWithFormat:@"%i", _enemyInti];
    jsonable[@"enemyDext"] = [NSString stringWithFormat:@"%i", _enemyDext];
    jsonable[@"enemyArmor"] =  [NSString stringWithFormat:@"%i", _enemyArmor];
    jsonable[@"enemyExp"] =  [NSString stringWithFormat:@"%i", _enemyExp];
    jsonable[@"enemyElement"] = _enemyElement;
    return jsonable;
}


@end
