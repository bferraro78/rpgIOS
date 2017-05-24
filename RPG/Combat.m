//
//  Combat.m
//  RPG
//
//  Created by Ben Ferraro on 5/17/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Combat.h"
/** All Combat -- Handles damage, healing, buffs **/
@implementation Combat

+(void)initCombat:(Hero*)mainCharacter {
    /** Reset player Health/BUFFS/DEBUFFS **/
    [mainCharacter resetHealth]; // Resets combat health to full health
    [mainCharacter resetLibraries]; // resets buff libraries (Buffs, poisonPassive)
    [mainCharacter resetCombatResource]; // Sets combat resource to start of combat
    
    /* Generate Enemy */
    Enemy *e = [EnemyDictionary generateRandomEnemy:mainCharacter];
    
    // DEBUGGGINNNNN
    printf("ENEMY HEALTH %u\n", e.enemyHealth);
    printf("HERO HEALTH %u\n", mainCharacter.health);
    
    /* Start Combat Loop */
    BOOL death =  true;
    while (death) {
    
        /** Print Health Bars **/
        
        
        /*** Damage Gathering Stage -- Contains all abilities that deal damage ***/
        
        /** Element Damage hasmaps -- stores damage for the turn **/
        NSMutableDictionary *heroElementMap = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *enemyElementMap = [[NSMutableDictionary alloc] init];
        /* Load damages to 0 */
        heroElementMap[@"FIRE"] = [NSNumber numberWithInt:0];
        heroElementMap[@"COLD"] = [NSNumber numberWithInt:0];
        heroElementMap[@"ARCANE"] = [NSNumber numberWithInt:0];
        heroElementMap[@"POISON"] = [NSNumber numberWithInt:0];
        heroElementMap[@"LIGHTNING"] = [NSNumber numberWithInt:0];
        heroElementMap[@"PHYSICAL"] = [NSNumber numberWithInt:0];
        
        enemyElementMap[@"FIRE"] = [NSNumber numberWithInt:0];
        enemyElementMap[@"COLD"] = [NSNumber numberWithInt:0];
        enemyElementMap[@"ARCANE"] = [NSNumber numberWithInt:0];
        enemyElementMap[@"POISON"] = [NSNumber numberWithInt:0];
        enemyElementMap[@"LIGHTNING"] = [NSNumber numberWithInt:0];
        enemyElementMap[@"PHYSICAL"] = [NSNumber numberWithInt:0];
        
        
/*** If lightning spec, start while loop here that goes one extra time *
    * Calles genrateDamage twice and just keeps adding damage to element map. */
        
        /** Set up Moves **/
        // Basic Attack - skillSet[0]
        NSString *heroMoveName = [mainCharacter.skillSet objectAtIndex:0];
        NSString *enemyMoveName = [e selectAttack];
    

        [SkillDictionary generateDamage:mainCharacter Enemy:e heroMoveName:heroMoveName enemyMoveName:enemyMoveName heroElementMap:heroElementMap enemeyElementMap:enemyElementMap];
        
        // Generate Damage will load hero and enemey
        //"elementMaps" - hold the damage for that turn.
        // Then passed into the manageBuffs to handle any buffLibrary spells.
        // Buffs libraries will be loaded.
        // Everything that happens in Move.java/ManageBuffs() that is not a lingering spell
        // will be handled in the splles specifc class
    

        
        /** Apply damage/buffs/debuffs for both hero and enemy **/
        [self heroManageBuffs:mainCharacter ElementMap:heroElementMap];
        [self enemyManageBuffs:e ElementMap:enemyElementMap];
    
        printf("\nHero after manageBUFF DAMGE\n");
        for (NSString* dam in heroElementMap) {
            NSInteger value = [[heroElementMap objectForKey:dam] integerValue];
            printf("%s ", [dam UTF8String]);
            printf("%ld\n", (long)value);
        }
        
        printf("\nEnemy after manageBUFF DAMGE\n");
        for (NSString* dam in heroElementMap) {
            NSInteger value = [[enemyElementMap objectForKey:dam] integerValue];
            printf("%s ", [dam UTF8String]);
            printf("%ld\n", (long)value);
        }
        
/** END LIGHTNING EXTRA TURN WHILE LOOP **/
    
        /*** Damage Reduction Stage -- Contains all abilities that reduce damage ***/
        
        /* Quickly total hero/enemy damage for certain buffs in reduction stage  (Like Vanish) */
        int heroDamage = 0;
        for (NSString* dam in heroElementMap) {
            int value = [[heroElementMap objectForKey:dam] intValue];
            heroDamage += (int)value;
        }
        
        int enemyDamage = 0;
        for (NSString* dam in enemyElementMap) {
            int value = [[enemyElementMap objectForKey:dam] intValue];
            enemyDamage += (int)value;
        }
        
        printf("Hero Dam before reduction %u\n", heroDamage);
        printf("Enemy Dam before reduction %u\n", enemyDamage);
        
        /** This will reduce damage based on armor/resistances, then return a total damage **/
        /* Hero */
        int totalHeroDamageTaken = [self heroDamageReduction:mainCharacter EnemyDamageMap:enemyElementMap HeroDamage:heroDamage];
        
        
        
        /* Enemy */
        int totalEnemyDamageTaken =[self enemyDamageReduction:e HeroDamageMap:heroElementMap EnemyDamage:enemyDamage];

        printf("Total Hero Damage Taken %u\n", totalHeroDamageTaken);
        printf("Total Enemy Damage Taken %u\n", totalEnemyDamageTaken);
        
        /*** Final Take Damage Stage ***/
        /* enemy takes damage */
        printf("Damage Done: %i\n", totalEnemyDamageTaken);
        [e takeDamage:totalEnemyDamageTaken];
        
        /* Hero takes damage */
        printf("Damage Taken: %i\n", totalHeroDamageTaken);
        [mainCharacter takeDamage:totalHeroDamageTaken];
        
        
        /** Print Hero Damage Log **/
        for(NSString* currentKey in mainCharacter.buffLibrary) {
            printf("%s ",[[BuffDictionary getDescription:currentKey] UTF8String]);
            printf( "%s]n", [[(Buff*)[mainCharacter.buffLibrary  objectForKey:currentKey] toString] UTF8String]);
        }
        
        /** Reduce Durations **/
        /* Hero */
        for(NSString* currentKey in mainCharacter.buffLibrary) {
            [[mainCharacter.buffLibrary objectForKey:currentKey] decreaseDuration];
        }
        /* Enemy */
        for(NSString* currentKey in e.enemyBuffLibrary) {
            [[e.enemyBuffLibrary objectForKey:currentKey] decreaseDuration];
        }
        
        
        
        /** DEATH **/
        if (e.enemyCombatHealth <= 0) {
            printf("Enemy Has Died!!!");
            
            [mainCharacter increaseExp:[e getExp:mainCharacter]]; // INCRESE HERO EXP
            [mainCharacter changePurse:[e goldDrop]]; // increase gold amount
            
            printf("\nLoot: \n");
            NSMutableArray *loot = [[NSMutableArray alloc] init];
            [loot addObject:[ItemDictionary generateRandomItem:true]];
            [mainCharacter receiveLoot:loot]; // TODO -- RANDOMZIE LOOT WITH ITMES/ARMOR/WEPS
            
            death = false;
        }
        
        /* TODO WHAT TO DO IN TIE */
        /* Hero dies, reset active Items */
        if (mainCharacter.combatHealth <= 0)  {
            printf("Hero Has Died :(");
            [mainCharacter resetActiveItems];
            death = false;
        }
        
        // DEBUGGGIN
//        death = false;
        
        printf("\n\n---NEW TURN---\n\n");
        
        
    } // END COMBAT -- END death WHILE

}



/*** Apply damage/buffs/debuffs/armor/resistances ***/
/** HERO DAMAGE/BUFFS **/
+(void)heroManageBuffs:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap {
    
    int fireDamage = [elementMap[@"FIRE"] intValue];
    int lightningDamage = [elementMap[@"LIGHTNING"] intValue];
    int coldDamage = [elementMap[@"COLD"] intValue];
    int poisonDamage = [elementMap[@"POISON"] intValue];
    int arcaneDamage = [elementMap[@"ARCANE"] intValue];
    int physicalDamage = [elementMap[@"PHYSICAL"] intValue];
    
    /* Take into account extra crit Chance */
    Buff *critExtraChance = (Buff*)mainCharacter.buffLibrary[@"critDamage"];
    int critExtra;
    if (critExtraChance != nil) {
        critExtra = critExtraChance.value;
        [mainCharacter.buffLibrary removeObjectForKey:@"critDamage"]; // Remove
    } else {
        critExtra = 0;
    }
    
    /* Check if hit is CRIT */
    BOOL crit = false;
    if ([self critChance:critExtra Hero:mainCharacter]) {
        crit = true;
    }
    
    /** Elemental Spec - POISON POISON DOT PASSIVE **/
    if ([mainCharacter.elementSpec isEqualToString:@"POSION"]) {
        /** DOT IS 25% of what the damage is over two turns **/
        
        /* Handle Damage from Buff Library */
        for(NSString* currentKey in mainCharacter.buffLibrary) {
            Buff* b = (Buff*)[mainCharacter.buffLibrary objectForKey:currentKey];
            int poisonDotDamage = (float)b.value*0.25;
            printf("%i", poisonDotDamage);
            if (poisonDotDamage > 0 && [currentKey rangeOfString:@"stone"].location != NSNotFound) {
                // Then this is a damage that is not a DOT and Not already A Poison Passive Dot
                [mainCharacter.poisonPassiveDots addObject:[[Buff alloc] initvalue:poisonDotDamage duration:2]];
            }
        }
        
        /** Turn Damage from elements/physical into a dot **/
        int damageFromTurn =  fireDamage + lightningDamage + coldDamage + poisonDamage + arcaneDamage + physicalDamage;
        if (damageFromTurn > 0) {
            int tmp = (float)damageFromTurn*0.25;
            [mainCharacter.poisonPassiveDots addObject:[[Buff alloc] initvalue:tmp duration:2]];
        }
        
        /* Carry Out Damage from Poison Passive Dots */
        for (int i = 0; i < [mainCharacter.poisonPassiveDots count]; i++) {
            Buff *passiveDot = [mainCharacter.poisonPassiveDots objectAtIndex:i];
            printf( "%s", [[BuffDictionary getDescription:@"poisonPassiveDot"] UTF8String]);
            printf("%u", (int)passiveDot.value);
            poisonDamage += passiveDot.value;
        }
        /* Decrease Duration */
        for (int i = 0; i < [mainCharacter.poisonPassiveDots count]; i++) {
            Buff *passiveDot = [mainCharacter.poisonPassiveDots objectAtIndex:i];
            [passiveDot decreaseDuration];
        }
        /* Remove if nessicary */
        for (int i = 0; i < [mainCharacter.poisonPassiveDots count]; i++) {
            Buff *passiveDot = [mainCharacter.poisonPassiveDots objectAtIndex:i];
            if (passiveDot. duration == 0) {
                [mainCharacter.poisonPassiveDots removeObjectAtIndex:i];
            }
        }
    }
    
    
    /** HANDLE LINGERING SPELLS/ABILITIES **/
    // Rend Dot
    Buff *rendDot = (Buff*)mainCharacter.buffLibrary[@"rendDot"];
    if (rendDot != nil) {
        int rendDamage = rendDot.value;
        
        /* Remove */
        if (rendDot.duration == 0) {
            [mainCharacter.buffLibrary removeObjectForKey:@"rendDot"];
        } else {
            /* Deal Rend DOT Damage */
            if ([mainCharacter.getMH.weaponElement  isEqualToString:@"FIRE"]) {
                fireDamage += rendDamage;
            } else if ([mainCharacter.getMH.weaponElement  isEqualToString:@"COLD"]) {
                coldDamage += rendDamage;
            } else if ([mainCharacter.getMH.weaponElement  isEqualToString:@"ARCANE"]) {
                arcaneDamage += rendDamage;
            } else if ([mainCharacter.getMH.weaponElement  isEqualToString:@"POISON"]) {
                poisonDamage += rendDamage;
            } else if ([mainCharacter.getMH.weaponElement  isEqualToString:@"LIGHTNING"]) {
                lightningDamage += rendDamage;
            } else { // NO ELEMENT
                physicalDamage += rendDamage;
            }
        }
    }
    
    // Fireball Dot
    Buff *fireDot = (Buff*)mainCharacter.buffLibrary[@"fireDot"];
    if (fireDot != nil) {
        int fireDotDamage = fireDot.value;
        
        /* Remove */
        if (fireDot.duration == 0) {
            [mainCharacter.buffLibrary removeObjectForKey:@"fireDot"];
        } else {
            /* Take FIREDOT Damage */
            fireDamage += fireDotDamage;
        }
    }
    
    // Heal Dot
    Buff *healDot = (Buff*)mainCharacter.buffLibrary[@"healDot"];
    if (healDot != nil) {
        int healDamage = healDot.value;
        
        /* Remove if times is up */
        if (healDot.duration == 0) {
            [mainCharacter.buffLibrary removeObjectForKey:@"healDot"];
        } else {
            /* Heal Player*/
            if (crit) {
                [mainCharacter takeDamage:(healDamage*2)];
            } else {
                [mainCharacter takeDamage:healDamage];
            }
        }
    }
    
    /* Resistance damage bonus, this this from resistanceOffenseMap. Use those elemental numbers to increase that elements damage by percentage */
    fireDamage = (fireDamage+(int)(([mainCharacter.resistanceOffenseMap[@"FIRE"] floatValue]/(float)100.00)*(float)fireDamage));
    
    lightningDamage = (lightningDamage+(int)(([mainCharacter.resistanceOffenseMap[@"LIGHTNING"] floatValue]/(float)100.00)*(float)lightningDamage));
    coldDamage = (coldDamage+(int)(([mainCharacter.resistanceOffenseMap[@"COLD"] floatValue]/(float)100.00)*(float)coldDamage));
    poisonDamage = (poisonDamage+(int)(([mainCharacter.resistanceOffenseMap[@"POISON"] floatValue]/(float)100.00)*(float)poisonDamage));
    arcaneDamage = (arcaneDamage+(int)(([mainCharacter.resistanceOffenseMap[@"ARCANE"] floatValue]/(float)100.00)*(float)arcaneDamage));
    
    /* Applys crits */
    if (crit) {
        fireDamage = fireDamage*2;
        lightningDamage = lightningDamage*2;
        coldDamage = coldDamage*2;
        poisonDamage = poisonDamage*2;
        arcaneDamage = arcaneDamage*2;
        physicalDamage = physicalDamage*2;
    }
    
    /* PRINT UP ALL ELEMENTAL/PHYSICAL damage */
    
    /* Put elemental damage into hashmap */
    elementMap[@"FIRE"] = [NSNumber numberWithInt: fireDamage];
    elementMap[@"LIGHTNING"] = [NSNumber numberWithInt:lightningDamage];
    elementMap[@"COLD"] = [NSNumber numberWithInt:coldDamage];
    elementMap[@"POISON"] = [NSNumber numberWithInt:poisonDamage];
    elementMap[@"ARCANE"] =[NSNumber numberWithInt: arcaneDamage];
    elementMap[@"PHYSICAL"] = [NSNumber numberWithInt:physicalDamage];
    
    /** Resource Regain **/
    /* INCREASE RESOURCES ONLY IF IT IS BELOW THEIR MAX RESOURCE */
    if ([[mainCharacter getResourceName] isEqualToString:@"Mana"]) {
        int regen = mainCharacter.inti/2;
        if (([mainCharacter getCombatResource]+regen)  <= [mainCharacter getResource]) {
            [mainCharacter regenCombatResource:regen];
        } else {
            /* Set Resource to Max */
            [mainCharacter resetCombatResource];
        }
        
    } else if ([[mainCharacter getResourceName] isEqualToString:@"Energy"]) {
        int regen = 15;
        if (([mainCharacter getCombatResource]+regen)  <= [mainCharacter getResource]) {
            [mainCharacter regenCombatResource:regen];
        } else {
            /* Set Resource to Max */
            [mainCharacter resetCombatResource];
        }
    }
}

/*** Apply damage/buffs/debuffs/armor/resistances ***/
/** enemy DAMAGE/BUFFS **/
+(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
    
    int fireDamage = [elementMap[@"FIRE"] intValue];
    int lightningDamage = [elementMap[@"LIGHTNING"] intValue];
    int coldDamage = [elementMap[@"COLD"] intValue];
    int poisonDamage = [elementMap[@"POISON"] intValue];
    int arcaneDamage = [elementMap[@"ARCANE"] intValue];
    int physicalDamage = [elementMap[@"PHYSICAL"] intValue];
    
    /** HANDLE LINGERING SPELLS/ABILITIES **/
    // Rend Dot
    Buff *rendDot = (Buff*)e.enemyBuffLibrary[@"rendDot"];
    if (rendDot != nil) {
        int rendDamage = rendDot.value;
        
        /* Remove */
        if (rendDot.duration == 0) {
            [e.enemyBuffLibrary removeObjectForKey:@"rendDot"];
        } else {
            /* Deal Rend DOT Damage */
            if ([e.enemyElement  isEqualToString:@"FIRE"]) {
                fireDamage += rendDamage;
            } else if ([e.enemyElement  isEqualToString:@"COLD"]) {
                coldDamage += rendDamage;
            } else if ([e.enemyElement  isEqualToString:@"ARCANE"]) {
                arcaneDamage += rendDamage;
            } else if ([e.enemyElement  isEqualToString:@"POISON"]) {
                poisonDamage += rendDamage;
            } else if ([e.enemyElement  isEqualToString:@"LIGHTNING"]) {
                lightningDamage += rendDamage;
            } else { // NO ELEMENT
                physicalDamage += rendDamage;
            }
        }
    }
    
    // Fireball Dot
    Buff *fireDot = (Buff*)e.enemyBuffLibrary[@"fireDot"];
    if (fireDot != nil) {
        int fireDotDamage = fireDot.value;
        
        /* Remove */
        if (fireDot.duration == 0) {
            [e.enemyBuffLibrary removeObjectForKey:@"fireDot"];
        } else {
            /* Take FIREDOT Damage */
            fireDamage += fireDotDamage;
        }
    }
    
    // Heal Dot
    Buff *healDot = (Buff*)e.enemyBuffLibrary[@"healDot"];
    if (healDot != nil) {
        int healDamage = healDot.value;
        
        /* Remove if times is up */
        if (healDot.duration == 0) {
            [e.enemyBuffLibrary removeObjectForKey:@"healDot"];
        } else {
            /* Heal Player*/
            [e takeDamage:healDamage];
        }
    }
    
    /* Put elemental damage into hashmap */
    elementMap[@"FIRE"] = [NSNumber numberWithInt:fireDamage];
    elementMap[@"LIGHTNING"] = [NSNumber numberWithInt:lightningDamage];
    elementMap[@"COLD"] = [NSNumber numberWithInt:coldDamage];
    elementMap[@"POISON"] = [NSNumber numberWithInt:poisonDamage];
    elementMap[@"ARCANE"] =[NSNumber numberWithInt: arcaneDamage];
    elementMap[@"PHYSICAL"] = [NSNumber numberWithInt:physicalDamage];
}


/** Determine Damage Reduction **/
+(int)heroDamageReduction:(Hero*)mainCharacter EnemyDamageMap:(NSMutableDictionary*)enemyDamageMap
               HeroDamage:(int) heroDamage {
    
    int fireDamage = [enemyDamageMap[@"FIRE"] intValue];
    int lightningDamage = [enemyDamageMap[@"LIGHTNING"] intValue];
    int coldDamage = [enemyDamageMap[@"COLD"] intValue];
    int poisonDamage = [enemyDamageMap[@"POISON"] intValue];
    int arcaneDamage = [enemyDamageMap[@"ARCANE"] intValue];
    int physicalDamage = [enemyDamageMap[@"PHYSICAL"] intValue];
    
    printf("\n\nDAMAGES IN HERO DAM REDUCTiON\n");
    printf("Fire: %u\n", fireDamage);
    printf("%u\n", lightningDamage);
    printf("%u\n", coldDamage);
    printf("%u\n", poisonDamage);
    printf("%u\n", arcaneDamage);
    printf("%u\n", physicalDamage);
    
    
    /* Armor Reduction */
    float floatFinalDamage = (float)physicalDamage * (float)([mainCharacter getArmorRating]/100.0);
    int intFinalDamageReduce = (int)(physicalDamage - floatFinalDamage);
    
    /* Resistance damage reduction, this this from resistanceDefenseMap. Use those elemental numbers to decrease that elements damage by percentage */
    
    fireDamage = (fireDamage-(int)(([mainCharacter.resistanceDefenseMap[@"FIRE"] floatValue]/(float)100.00)*(float)fireDamage));
    lightningDamage = (lightningDamage-(int)(([mainCharacter.resistanceDefenseMap[@"LIGHTNING"] floatValue]/(float)100.00)*(float)lightningDamage));
    coldDamage = (coldDamage-(int)(([mainCharacter.resistanceDefenseMap[@"COLD"] floatValue]/(float)100.00)*(float)coldDamage));
    poisonDamage = (poisonDamage-(int)(([mainCharacter.resistanceDefenseMap[@"POISON"] floatValue]/(float)100.00)*(float)poisonDamage));
    arcaneDamage = (arcaneDamage-(int)(([mainCharacter.resistanceDefenseMap[@"ARCANE"] floatValue]/(float)100.00)*(float)arcaneDamage));
    
    
    
    printf("\n%i\n", fireDamage);
    printf("%i\n", lightningDamage);
    printf("%i\n", coldDamage);
    printf("%i\n", poisonDamage);
    printf("%i\n", arcaneDamage);
    printf("%i\n", physicalDamage);
    printf("\n\n");
    
    
    /* Total damage reduction */
    intFinalDamageReduce += (fireDamage + lightningDamage + coldDamage + poisonDamage + arcaneDamage);
    
    /* Freeze Cone Reduction */
    Buff *frozen = (Buff*)mainCharacter.buffLibrary[@"frozen"];
    if (frozen != nil) {
        
        /* Remove */
        if (frozen.duration == 0) {
            [mainCharacter.buffLibrary removeObjectForKey:@"frozen"];
        } else {
            intFinalDamageReduce -= (int)((float)intFinalDamageReduce*(float).25);
        }
    }
    
    // Vanish Buff, take no damage for 2 turns
    Buff *vanish = (Buff*)mainCharacter.buffLibrary[@"vanish"];
    if (vanish != nil) {
        /* Remove */
        if (vanish.duration == 0 || heroDamage != 0) {
            [mainCharacter.buffLibrary removeObjectForKey:@"vanish"];
        } else {
            // HERO TAKES NO DAMAGE
            intFinalDamageReduce = 0;
        }
    }
    
    if (intFinalDamageReduce < 0) {
        intFinalDamageReduce = 0;
    }
    
    return intFinalDamageReduce;
}


+(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage {
    
    int fireDamage = [heroDamageMap[@"FIRE"] intValue];
    int lightningDamage = [heroDamageMap[@"LIGHTNING"] intValue];
    int coldDamage = [heroDamageMap[@"COLD"] intValue];
    int poisonDamage = [heroDamageMap[@"POISON"] intValue];
    int arcaneDamage = [heroDamageMap[@"ARCANE"] intValue];
    int physicalDamage = [heroDamageMap[@"PHYSICAL"] intValue];
    
    /* Armor Reduction */
    float floatFinalDamage = (float)physicalDamage * (float)([e getArmorRating]/100.0);
    int intFinalDamageReduce = (int)(physicalDamage - floatFinalDamage);
    
    /* Total damage reduction */
    intFinalDamageReduce += (fireDamage + lightningDamage + coldDamage + poisonDamage + arcaneDamage);
    
    /* Freeze Cone Reduction */
    Buff *frozen = (Buff*)e.enemyBuffLibrary[@"frozen"];
    if (frozen != nil) {
        
        /* Remove */
        if (frozen.duration == 0) {
            [e.enemyBuffLibrary removeObjectForKey:@"frozen"];
        } else {
            intFinalDamageReduce -= (int)((float)intFinalDamageReduce*(float).25);
        }
    }
    
    // Vanish Buff, take no damage for 2 turns
    Buff *vanish = (Buff*)e.enemyBuffLibrary[@"vanish"];
    if (vanish != nil) {
        /* Remove */
        if (vanish.duration == 0 || enemyDamage != 0) {
            [e.enemyBuffLibrary removeObjectForKey:@"vanish"];
        } else {
            // HERO TAKES NO DAMAGE
            intFinalDamageReduce = 0;
        }
    }
    
    if (intFinalDamageReduce < 0) {
        intFinalDamageReduce = 0;
    }
    
    return intFinalDamageReduce;
}



+(BOOL)critChance:(int)extraChance Hero:(Hero*)mainCharacter {
    int critChance = arc4random_uniform(100);
    if (critChance < ([mainCharacter getCritical]+extraChance)) {
        printf("\n~~~~~~~~~~~~CRITICAL HIT~~~~~~~~~~~~");
        return true;
    }
    return false;
    
    return true;
}





@end