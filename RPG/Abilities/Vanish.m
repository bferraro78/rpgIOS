//
//  Vanish.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vanish.h"
@implementation Vanish

int vanishResourceCost;

-(id)initmoveName:(NSString*)aMoveName moveDescription:(NSString*)aMoveDescription resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName moveDescription:aMoveDescription spell:aSpell ElementSpec:aElementSpec];
    _vanishResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.vanishResourceCost/100.0)*(float)totalResource); }

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Vanish!!");
    
    /* Insert Vanish Dot */
    mainCharacter.buffLibrary[@"vanish"] = [[Buff alloc] initvalue:0 duration:2];
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Vanish...");
    
    /* Insert Vanish Dot */
    e.enemyBuffLibrary[@"vanish"] = [[Buff alloc] initvalue:0 duration:2];
    
}

@end
