//
//  Freezecone.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Freezecone.h"
@implementation Freezecone

int freezeconeResourceCost;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell];
    _freezeconeResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.freezeconeResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap {
    printf("Freezecone!!");
    
    /* Insert Damage */
    int damage = ((mainCharacter.level*5)+mainCharacter.inti)+([mainCharacter getMH].attack+[mainCharacter getOH].attack);
    
    elementMap[@"COLD"] = [NSNumber numberWithInt:damage];
    
    /* Take reduceed damage from enemy */
    mainCharacter.buffLibrary[@"frozen"] = [[Buff alloc] initvalue:0 duration:3];
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter {
    printf("Enemey uses Freezecone...");
    
    /* Insert Damage */
    int damage = e.enemyInti+(5*mainCharacter.level);
    
    elementMap[@"COLD"] = [NSNumber numberWithInt:damage];
    
    /* Take reduceed damage from enemy */
    e.enemyBuffLibrary[@"frozen"] = [[Buff alloc] initvalue:0 duration:3];
}

@end