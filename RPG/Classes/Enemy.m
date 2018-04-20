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

int enemyArmor;
int enemyExp;

NSMutableArray *enemySkillSet;
NSMutableDictionary *enemyBuffLibrary;
NSMutableDictionary *enemyDebuffLibrary;


-(id)initenemyName:(NSString*)aEnemyName enemyElement:(NSString*)aEnemyElement enemySkillSet:(NSMutableArray*)aEnemySkillSet enemyStrn:(int)aEnemyStrn enemyInti:(int) aEnemyInti enemyDext:(int)aEnemyDext enemyHealth:(int)aEnemyHealth
        enemyArmor:(int)aEnemyArmor {
    self.name = aEnemyName;
    self.elementSpec = aEnemyElement;
    self.strn = aEnemyStrn;
    self.inti = aEnemyInti;
    self.dext = aEnemyDext;
    self.health = aEnemyHealth;
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

-(void)setExp { self.enemyExp = (self.health/3); }

-(void)takeDamage:(int)healthReductionOrIncrease {
    int oldCombatHealth = self.combatHealth;
    self.combatHealth = (oldCombatHealth-healthReductionOrIncrease);
    if (self.combatHealth > self.health) {
        self.combatHealth = self.health;
    }
}

-(NSMutableString*)printStats {
    NSMutableString *stats = [[NSMutableString alloc] init];
    
    [stats appendString:@"Enemy's Stats: \n"];
    [stats appendFormat:@"Name: %s\n" , [self.name UTF8String]];
    [stats appendFormat:@"Element Spec: %s\n" , [self.elementSpec UTF8String]];
    
    [stats appendFormat:@"\n    STATS:%s\n" , ""];

    [stats appendFormat:@"Health: %u\n" , self.health];
    [stats appendFormat:@"Armor: %u\n" , self.enemyArmor];
    [stats appendFormat:@"Strength: %u\n" , self.strn];
    [stats appendFormat:@"Initeligence: %u\n" , self.inti];
    [stats appendFormat:@"Dexterity: %u\n" , self.dext];
    
    return stats;
}

-(id)loadEnemyBeingFromDictionary:(NSDictionary*)partyEnemyStats {
    self.name = partyEnemyStats[@"enemyName"];
    self.level = [partyEnemyStats[@"enemyLevel"] intValue];
    self.health = [partyEnemyStats[@"enemyHealth"] intValue];
    self.combatHealth = [partyEnemyStats[@"enemyCombatHealth"] intValue];
    self.strn = [partyEnemyStats[@"enemyStrn"] intValue];
    self.dext = [partyEnemyStats[@"enemyDext"] intValue];
    self.inti = [partyEnemyStats[@"enemyInti"] intValue];
    _enemyArmor = [partyEnemyStats[@"enemyArmor"] intValue];
    _enemyExp = [partyEnemyStats[@"enemyExp"] intValue];
    self.elementSpec = partyEnemyStats[@"enemyElement"];
    return self;
}

-(NSMutableDictionary*)beingToDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    jsonable[@"enemyName"] = self.name;
    jsonable[@"class"] = ENEMY;
    jsonable[@"enemyLevel"] = [NSString stringWithFormat:@"%i", self.level];
    jsonable[@"enemyHealth"] = [NSString stringWithFormat:@"%i", self.health];
    jsonable[@"enemyCombatHealth"] = [NSString stringWithFormat:@"%i", self.combatHealth];
    jsonable[@"enemyStrn"] = [NSString stringWithFormat:@"%i", self.strn];
    jsonable[@"enemyInti"] = [NSString stringWithFormat:@"%i", self.inti];
    jsonable[@"enemyDext"] = [NSString stringWithFormat:@"%i", self.dext];
    jsonable[@"enemyArmor"] =  [NSString stringWithFormat:@"%i", _enemyArmor];
    jsonable[@"enemyExp"] =  [NSString stringWithFormat:@"%i", _enemyExp];
    jsonable[@"enemyElement"] = self.elementSpec;
    return jsonable;
}


@end
