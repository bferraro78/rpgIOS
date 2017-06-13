//
//  CombatViewController.m
//  RPG
//
//  Created by Ben Ferraro on 5/24/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import "CombatViewController.h"

@interface CombatViewController ()

@end

/** All Combat -- Handles damage, healing, buffs **/
@implementation CombatViewController

NSMutableAttributedString *combatSetText;
UITextView *moveView;
NSString *heroMoveName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    _combatSetText = [[NSMutableAttributedString alloc] init];
    _CombatText.editable = false;
    
    _HeroBuffsDebuffs.editable = false;
    _EnemyBuffsDebuffs.editable = false;
    
    /* Long Press Enemy */
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]      initWithTarget:self action:@selector(LabelLongPressed:)];
    longPress.minimumPressDuration = 0.5;  // Seconds
    longPress.numberOfTapsRequired = 0;
    [_EnemyLabel addGestureRecognizer:longPress];
    _EnemyLabel.userInteractionEnabled = YES;
    
    
    /* Generate Enemy */
    _e = [EnemyDictionary generateRandomEnemy:_mainCharacter];
    
    /* Set Active Skills */
    [_mainCharacter setActiveSkills];
    
    /* Set Buttons */
    [_SkillOne setTitle:[_mainCharacter.activeSkillSet objectAtIndex:0] forState:UIControlStateNormal];
    [_SkillTwo setTitle:[_mainCharacter.activeSkillSet objectAtIndex:1] forState:UIControlStateNormal];
    [_SkillThree setTitle:[_mainCharacter.activeSkillSet objectAtIndex:2] forState:UIControlStateNormal];
    [_SkillFour setTitle:[_mainCharacter.activeSkillSet objectAtIndex:3] forState:UIControlStateNormal];
    self.critButton.hidden = true;
    
    _heroMoveName = [[NSString alloc] init];
    
    
    /** Reset player Health/BUFFS/DEBUFFS **/
    [_mainCharacter resetHealth]; // Resets combat health to full health
    [_mainCharacter resetLibraries]; // resets buff libraries (Buffs, poisonPassive)
    [_mainCharacter resetCombatResource]; // Sets combat resource to start of combat
    
    
    
    // INITAL START FIGHT TEXT
    NSMutableString *startString = [[NSMutableString alloc] initWithFormat:@"%@ VS %@\n\n-----FIGHT!-----\n\n", _mainCharacter.name, self.e.enemyName];
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:startString];
    [self.combatSetText appendAttributedString:tmp];
    self.CombatText.attributedText = self.combatSetText;
}

- (IBAction)SkillOne:(id)sender {
    self.heroMoveName = [[NSString alloc] init];
    self.heroMoveName = [self.mainCharacter.skillSet objectAtIndex:0];
    /* INIT COMBAT TURN */
    [self initCombat:_mainCharacter];

}

- (IBAction)SkillTwo:(id)sender {
    self.heroMoveName = [[NSString alloc] init];
    self.heroMoveName = [self.mainCharacter.skillSet objectAtIndex:1];
    /* INIT COMBAT TURN */
    [self initCombat:_mainCharacter];
    
}

- (IBAction)SkillThree:(id)sender {
    self.heroMoveName = [[NSString alloc] init];
    self.heroMoveName = [self.mainCharacter.skillSet objectAtIndex:2];
    /* INIT COMBAT TURN */
    [self initCombat:_mainCharacter];
}


- (IBAction)SkillFour:(id)sender {
    self.heroMoveName = [[NSString alloc] init];
    self.heroMoveName = [self.mainCharacter.skillSet objectAtIndex:3];
    /* INIT COMBAT TURN */
    [self initCombat:_mainCharacter];
    
}

-(void)initCombat:(Hero*)mainCharacter {
 
    // DEBUGGGINNNNN
    printf("ENEMY HEALTH %u\n", self.e.enemyHealth);
    printf("HERO HEALTH %u\n", mainCharacter.health);
    
    /* DEATH BOOLEAN */
    BOOL death =  true;
        
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
    
    /** Set up Enemy Move **/
    NSString *enemyMoveName = [self.e selectAttack];
        
    // PRINT ATTACK NAME
    NSMutableString *attackString = [[NSMutableString alloc] initWithFormat:@"Hero Attack: %s\nEnemy Attack: %s\n", [self.heroMoveName UTF8String], [enemyMoveName UTF8String]];
    NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:attackString];
    [self.combatSetText appendAttributedString:tmp];
    self.CombatText.attributedText = self.combatSetText;

    
    [SkillDictionary generateDamage:mainCharacter Enemy:self.e heroMoveName:self.heroMoveName enemyMoveName:enemyMoveName heroElementMap:heroElementMap enemeyElementMap:enemyElementMap];
    
    // Generate Damage will load hero and enemey
    //"elementMaps" - hold the damage for that turn.
    // Then passed into the manageBuffs to handle any buffLibrary spells.
    // Buffs libraries will be loaded.
    // Everything that happens in Move.java/ManageBuffs() that is not a lingering spell
    // will be handled in the splles specifc class
    
    
    
    /** Apply damage/buffs/debuffs for both hero and enemy **/
    [self heroManageBuffs:mainCharacter ElementMap:heroElementMap Enemy:(Enemy*)self.e];
    [self enemyManageBuffs:self.e ElementMap:enemyElementMap Hero:mainCharacter];
    
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
    int totalHeroDamageTaken = [self heroDamageReduction:mainCharacter EnemyDamageMap:enemyElementMap HeroDamage:heroDamage Enemy:self.e];
    
    /* Enemy */
    int totalEnemyDamageTaken =[self enemyDamageReduction:self.e HeroDamageMap:heroElementMap EnemyDamage:enemyDamage Hero:mainCharacter];
    
    
    // PRINT DAMAGE
    NSMutableString *damageString = [[NSMutableString alloc] initWithFormat:@"Damage Done: %i\nDamage Taken: %i\n", totalEnemyDamageTaken, totalHeroDamageTaken];
    tmp = [[NSAttributedString alloc] initWithString:damageString];
    [self.combatSetText appendAttributedString:tmp];
    self.CombatText.attributedText = self.combatSetText;
    
    
    /*** Final Take Damage Stage ***/
    /* enemy takes damage */
    printf("Damage Done: %i\n", totalEnemyDamageTaken);
    [self.e takeDamage:totalEnemyDamageTaken];
    
    /* Hero takes damage */
    printf("Damage Taken: %i\n", totalHeroDamageTaken);
    [mainCharacter takeDamage:totalHeroDamageTaken];
    
    
    /** Print Hero/Enemy Buff/Debuffs **/
    NSMutableString *HeroBuffs = [[NSMutableString alloc] init];
    NSMutableString *EnemyBuffs = [[NSMutableString alloc] init];
    
    /* Clear Buff/Debuff Text */
    self.HeroBuffsDebuffs.text = @"";
    self.EnemyBuffsDebuffs.text = @"";
    
    
    for(NSString* heroBuff in mainCharacter.buffLibrary) {
        Buff *tmpBuff = (Buff*) mainCharacter.buffLibrary[heroBuff];
printf("Hero BUFF duration: %i", tmpBuff.duration);
        [HeroBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:heroBuff], tmpBuff.value];
    }
    
    for(NSString* heroDebuff in mainCharacter.debuffLibrary) {
        Buff *tmpDebuff = (Buff*) mainCharacter.debuffLibrary[heroDebuff];

        [HeroBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:heroDebuff], tmpDebuff.value];
    }
    
    for(NSString* enemyBuff in self.e.enemyBuffLibrary) {
        Buff *tmpEnemyBuff = (Buff*) self.e.enemyBuffLibrary[enemyBuff];

        [EnemyBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:enemyBuff], tmpEnemyBuff.value];
    }
    
    for(NSString* enemyDebuff in self.e.enemyDebuffLibrary) {
        Buff *tmpEnemyDebuff = (Buff*) self.e.enemyDebuffLibrary[enemyDebuff];
printf("EnemydurationREND: %i\n", tmpEnemyDebuff.duration);
        [EnemyBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:enemyDebuff], tmpEnemyDebuff.value];
    }
    
    self.HeroBuffsDebuffs.text = HeroBuffs;
    self.EnemyBuffsDebuffs.text = EnemyBuffs;
    

    
    
    /** Reduce Durations **/
    /* Hero */
    for(NSString* currentKey in mainCharacter.buffLibrary) {
        [[self.mainCharacter.buffLibrary objectForKey:currentKey] decreaseDuration];
    }
    for(NSString* currentKey in mainCharacter.debuffLibrary) {
        [[self.mainCharacter.debuffLibrary objectForKey:currentKey] decreaseDuration];
    }
    /* Enemy */
    for(NSString* currentKey in self.e.enemyBuffLibrary) {
        [[self.e.enemyBuffLibrary objectForKey:currentKey] decreaseDuration];
    }
    for(NSString* currentKey in self.e.enemyDebuffLibrary) {
        [[self.e.enemyDebuffLibrary objectForKey:currentKey] decreaseDuration];
    }
    
    
    /** DEATH **/
    if (self.e.enemyCombatHealth <= 0) {
        printf("Enemy Has Died!!!");
        
        [mainCharacter increaseExp:[self.e getExp:mainCharacter]]; // INCRESE HERO EXP
        [mainCharacter changePurse:[self.e goldDrop]]; // increase gold amount
        
        printf("\nLoot: \n");
        NSMutableArray *loot = [[NSMutableArray alloc] init];
        [loot addObject:[ItemDictionary generateRandomItem:true]];
        [mainCharacter receiveLoot:loot]; // TODO -- RANDOMZIE LOOT WITH ITMES/ARMOR/WEPS
        
        death = false;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        /* Hide Skill Buttons */
        self.SkillOne.hidden = true;
        self.SkillTwo.hidden = true;
        self.SkillThree.hidden = true;
        self.SkillFour.hidden = true;

    }
    
    /* TODO WHAT TO DO IN TIE */
    /* Hero dies, reset active Items */
    if (mainCharacter.combatHealth <= 0)  {
        printf("Hero Has Died :(");
        [mainCharacter resetActiveItems];
        
        death = false;
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
        /* Hide Skill Buttons */
        self.SkillOne.hidden = true;
        self.SkillTwo.hidden = true;
        self.SkillThree.hidden = true;
        self.SkillFour.hidden = true;
    }
    
    /* AUTO ROLL DOWN */
    NSRange range = NSMakeRange(self.CombatText.text.length - 1, 1);
    [self.CombatText scrollRangeToVisible:range];
    
    // PRINTING -- NEW TURN --
    if (death) {
        printf("\nNEW TURN");
        NSAttributedString *tmp = [[NSAttributedString alloc] initWithString:@"\n\n---NEW TURN---\n"];
        [self.combatSetText appendAttributedString:tmp];
        self.CombatText.attributedText = self.combatSetText;
    }
    
}



/*** Apply damage/buffs/debuffs/armor/resistances ***/
/** HERO DAMAGE/BUFFS **/
-(void)heroManageBuffs:(Hero*)mainCharacter ElementMap:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e {
    
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
        critExtra = 100;
    }
    
    /* Check if hit is CRIT */
    self.critHit = false;
    [self critChance:critExtra Hero:mainCharacter];
    printf("\n\nVALUE IS : %d\n\n", self.critHit);
    
    
    /** Elemental Spec - POISON POISON DOT PASSIVE **/
    if ([mainCharacter.elementSpec isEqualToString:@"POSION"]) {
        /** DOT IS 25% of what the damage is over two turns **/
        
        /* Handle Damage from Buff Library */
        for(NSString* currentKey in mainCharacter.buffLibrary) {
            Buff* b = (Buff*)[e.enemyDebuffLibrary objectForKey:currentKey];
            int poisonDotDamage = (float)b.value*0.25;
            printf("%i", poisonDotDamage);
            if (poisonDotDamage > 0 && [currentKey rangeOfString:@"Dot"].location != NSNotFound) {
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
            printf("%s", [[BuffDictionary getDescription:@"poisonPassiveDot"] UTF8String]);
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
    Buff *rendDot = (Buff*)e.enemyDebuffLibrary[@"rendDot"];
    if (rendDot != nil) {
        int rendDamage = rendDot.value;
        
        /* Remove */
        if (rendDot.duration == 0) {
            [e.enemyDebuffLibrary removeObjectForKey:@"rendDot"];
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
    Buff *fireDot = (Buff*)e.enemyDebuffLibrary[@"fireDot"];
    if (fireDot != nil) {
        int fireDotDamage = fireDot.value;
        
        /* Remove */
        if (fireDot.duration == 0) {
            [e.enemyDebuffLibrary removeObjectForKey:@"fireDot"];
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
            if (self.critHit) {
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
printf("\n\nVALUE IS : %d\n\n", self.critHit);
    if (self.critHit) {
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
-(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap Hero:(Hero*)mainCharacter {
    
    int fireDamage = [elementMap[@"FIRE"] intValue];
    int lightningDamage = [elementMap[@"LIGHTNING"] intValue];
    int coldDamage = [elementMap[@"COLD"] intValue];
    int poisonDamage = [elementMap[@"POISON"] intValue];
    int arcaneDamage = [elementMap[@"ARCANE"] intValue];
    int physicalDamage = [elementMap[@"PHYSICAL"] intValue];
    
    /** HANDLE LINGERING SPELLS/ABILITIES **/
    // Rend Dot
    Buff *rendDot = (Buff*)mainCharacter.debuffLibrary[@"rendDot"];
    if (rendDot != nil) {
        int rendDamage = rendDot.value;
        
        /* Remove */
        if (rendDot.duration == 0) {
            [mainCharacter.debuffLibrary removeObjectForKey:@"rendDot"];
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
    Buff *fireDot = (Buff*)mainCharacter.debuffLibrary[@"fireDot"];
    if (fireDot != nil) {
        int fireDotDamage = fireDot.value;
        
        /* Remove */
        if (fireDot.duration == 0) {
            [mainCharacter.debuffLibrary removeObjectForKey:@"fireDot"];
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
-(int)heroDamageReduction:(Hero*)mainCharacter EnemyDamageMap:(NSMutableDictionary*)enemyDamageMap
               HeroDamage:(int) heroDamage Enemy:(Enemy *)e {
    
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
    Buff *frozen = (Buff*)e.enemyDebuffLibrary[@"frozen"];
    if (frozen != nil) {
        
        /* Remove */
        if (frozen.duration == 0) {
            [e.enemyDebuffLibrary removeObjectForKey:@"frozen"];
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


-(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage
                      Hero:(Hero*)mainCharacter {
    
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
    Buff *frozen = (Buff*)mainCharacter.debuffLibrary[@"frozen"];
    if (frozen != nil) {
        
        /* Remove */
        if (frozen.duration == 0) {
            [mainCharacter.debuffLibrary removeObjectForKey:@"frozen"];
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
            // Enemy TAKES NO DAMAGE
            intFinalDamageReduce = 0;
        }
    }
    
    if (intFinalDamageReduce < 0) {
        intFinalDamageReduce = 0;
    }
    
    return intFinalDamageReduce;
}



-(void)critChance:(int)extraChance Hero:(Hero*)mainCharacter {
    int critChance = arc4random_uniform(100);
    if (critChance < ([mainCharacter getCritical]+extraChance)) {
        
        
        NSLog(@"\n%@\n", [NSThread currentThread]);
        
        /* Critical Strike Button Thread */
        NSThread* critThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(threadMainMethod)
                                                       object:nil];
        [critThread setName:@"critThread"];
        [critThread start];  // Actually create the thread
        
        /* Sleep Main Thread While Crit button is flashing */
        [NSThread sleepForTimeInterval:1.1];
        
        

        
    }
}

-(void)threadMainMethod {

    NSLog(@"\n%@\n", [NSThread currentThread]);
    
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0.0];
    self.timer = [[NSTimer alloc] initWithFireDate:fireDate
                                          interval:1.0
                                            target:self
                                          selector:@selector(timeFired:)
                                          userInfo:nil
                                           repeats:YES];
    self.critTimerCount = 0;
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [runLoop run];
    
    printf("\n DOES MAKE IT HERE? thread fired \n");
}


- (void)timeFired:(NSTimer *)timer {
    
    /* Increment Time Counter */
    self.critTimerCount++;
    
     printf("\n DOES MAKE IT HERE? timer fired \n");
    
    // Show crit button
    self.critButton.hidden = false;
    self.SkillOne.hidden = true;
    self.SkillTwo.hidden = true;
    self.SkillThree.hidden = true;
    self.SkillFour.hidden = true;
    

    
    if (self.critTimerCount == 2) {
        /* Invalidate Counter */
        [self.timer invalidate];
        self.timer = nil;
        
        self.critButton.hidden = true;
        self.SkillOne.hidden = false;
        self.SkillTwo.hidden = false;
        self.SkillThree.hidden = false;
        self.SkillFour.hidden = false;
    }
}

- (IBAction)critButton:(id)sender {
printf("\n~~~~~~~~~~~~CRITICAL HIT~~~~~~~~~~~~\n");
    
    /* MAKE CRIT STTRING RED */
    NSString *critStringTmp = @"~~CRITICAL HIT!~~\n";
    NSMutableAttributedString *critString = [[NSMutableAttributedString alloc] initWithString:critStringTmp];
    [critString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]
                       range:NSMakeRange(0, critString.length)];
    [self.combatSetText appendAttributedString:critString];
    self.CombatText.attributedText = self.combatSetText;
    
    
    /* Crit Boolean */
    self.critHit = true;
    printf("\n\nVALUE IS : %d\n\n", self.critHit);
    
}


-(void)LabelLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {

    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        
        self.moveView = [[UITextView alloc] initWithFrame:CGRectMake(point.x,
                                                                     point.y, 150, 175)];
        self.moveView.tintColor = [UIColor blackColor];
        self.moveView.tag = 123;
        self.moveView.text = self.e.printStats;
        self.moveView.layer.borderWidth = 2.0f;
        self.moveView.layer.borderColor = [[UIColor redColor] CGColor];
        [self.view addSubview:self.moveView];
    }
    
    if (gestureRecognizer.state == 2) {
        [[self.view viewWithTag:123]removeFromSuperview];
        
        CGPoint newPoint = [gestureRecognizer locationInView:self.view];
        self.moveView = [[UITextView alloc] initWithFrame:CGRectMake(newPoint.x,
                                                                     newPoint.y, 150, 175)];
        self.moveView.tintColor = [UIColor blackColor];
        self.moveView.tag = 123;
        self.moveView.text = self.e.printStats;
        self.moveView.layer.borderWidth = 2.0f;
        self.moveView.layer.borderColor = [[UIColor redColor] CGColor];
        [self.view addSubview:self.moveView];
        
//        printf("X: %f | ", newPoint.x);
//        printf("Y: %f\n",newPoint.y);
//        printf("MOVING BOXES");
    }
    
    if (gestureRecognizer.state == 3) {
        [[self.view viewWithTag:123]removeFromSuperview];
        self.moveView = nil;
    }
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
