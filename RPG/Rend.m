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
            spell:(BOOL)aSpell {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell];
    _rendResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.rendResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap {
    printf("Rend!!");
    
    /* Insert Rend Dot */
    int damage = (mainCharacter.strn/2)+([mainCharacter getMH].attack+[mainCharacter getOH].attack);
    
    mainCharacter.buffLibrary[@"rendDot"] = [[Buff alloc] initvalue:damage duration:3];
    
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter {
    printf("Enemey uses Rend...");
    
    /* Insert Rend Dot */
    int damage = (e.enemyStrn/2)+(mainCharacter.level*3);
    
    mainCharacter.buffLibrary[@"rendDot"] = [[Buff alloc] initvalue:damage duration:3];
    
}

@end