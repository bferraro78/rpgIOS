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

-(id)initmoveName:(NSString*)aMoveName resourceCost:(int)aResourceCost
            spell:(BOOL)aSpell ElementSpec:(NSString*)aElementSpec {
    
    [super initmoveName:aMoveName spell:aSpell ElementSpec:aElementSpec];
    _vanishResourceCost = aResourceCost;
    
    return self;
}


-(int)getCombatResourceCost:(int)totalResource { return (int)((float)(self.vanishResourceCost/100.0)*(float)totalResource); }

-(NSString*)getMoveDescription {
    return [NSString stringWithFormat:@"%i %@\nHide in the shadows. Take no damage for two turns. Any action will remove you from the shadows.",
            [self getCombatResourceCost:mainCharacter.getResource], [mainCharacter getResourceName]];
}

-(void)activateHeroMove:(NSMutableDictionary*)elementMap Enemy:(Enemy *)e {
    printf("Vanish!!");
    
    /* Insert Vanish Dot */
    mainCharacter.combatBuffLibrary[VANISH] = [[Buff alloc] initvalue:0 duration:2];
}

-(void)activateEnemyMove:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    printf("Enemey uses Vanish...");
    
    /* Insert Vanish Dot */
    e.enemyBuffLibrary[VANISH] = [[Buff alloc] initvalue:0 duration:2];
    
}

@end
