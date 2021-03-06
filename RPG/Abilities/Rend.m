//
//  Rend.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rend.h"
@implementation Rend

int rendResourceCost;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell ElementSpec:aElementSpec];
    _rendResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return 10; }

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Rend!!");
    
    /* Insert Rend Dot */
    int damage = (mainCharacter.strn/2)+([[mainCharacter getMH] getSwing]+[[mainCharacter getOH] getSwing]);
    
    e.enemyDebuffLibrary[@"rendDot"] = [[Buff alloc] initvalue:damage duration:3];
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Rend...");
    
    /* Insert Rend Dot */
    int damage = (e.enemyStrn/2)+(mainCharacter.level*3);
    
    mainCharacter.debuffLibrary[@"rendDot"] = [[Buff alloc] initvalue:damage duration:3];
    
}

@end
