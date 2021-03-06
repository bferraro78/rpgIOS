//
//  Hero.m
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hero.h"

@implementation Hero

NSString *name;
int classID;
int level;
int health; // HEALTH IS HEROES TOTAL HEALTH
int combatHealth; // COMBAT HEALTH IS USED TO DETERMINE HEALTH IN ONE INSTANCE OF COMBAT
int strn;
int inti;
int dext;
int vit;
int Exp;
int purse;
NSString *elementSpec;

/* Definite Libraries */
NSMutableArray *skillSet;
NSMutableArray *activeSkillSet;
NSMutableArray *inventory;
NSMutableArray *activeItems;

/* Tempory libraries */
NSMutableDictionary *buffLibrary; //<String, Buff>;
NSMutableDictionary *debuffLibrary;
NSMutableArray *stepsTaken;


/* Element Passive Libraries */
NSMutableArray *poisonPassiveDots; //<Buff>

/* Resisatnces: Fire, Lightning, Cold, Poison, Arcane  */
NSMutableDictionary *resistanceDefenseMap; //<String, Integer>;
NSMutableDictionary *resistanceOffenseMap; //<String, Integer>;

/* Armor/Weapons */
Weapon *mainHand;
Weapon *offHand;
Armor *helm;
Armor *shoulders;
Armor *bracers;
Armor *gloves;
Armor *torso;
Armor *legs;
Armor *boots;

/* Dungeon Info */
int dungeonLvl;
int startX;
int startY;

/** START OF CLASS METHODS **/
-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext {
    _name = aName;
    _vit = aVit;
    _strn = aStrn;
    _inti = aInti;
    _dext = aDext;
    _Exp = 0;
    _level = 20;
    _purse = 0;
    _elementSpec= @"PHYSICAL";
    
    _skillSet = [[NSMutableArray alloc] init];
    _activeSkillSet = [[NSMutableArray alloc] initWithCapacity:4];
    _inventory = [[NSMutableArray alloc] init];
    _activeItems = [[NSMutableArray alloc] init];
    _stepsTaken = [[NSMutableArray alloc] init];
    _poisonPassiveDots = [[NSMutableArray alloc] init];
    
    _buffLibrary = [[NSMutableDictionary alloc] init];
    _debuffLibrary = [[NSMutableDictionary alloc] init];
    _resistanceDefenseMap = [[NSMutableDictionary alloc] init];
    _resistanceOffenseMap = [[NSMutableDictionary alloc] init];
    
    _resistanceDefenseMap[FIRE] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[COLD] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[ARCANE] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[POISON] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[LIGHTNING] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[PHYSICAL] = [NSNumber numberWithInt:0];
    
    _resistanceOffenseMap[FIRE] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[COLD] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[ARCANE] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[POISON] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[LIGHTNING] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[PHYSICAL] = [NSNumber numberWithInt:0];
    
    /* Set Heatlh Based On Vit */
    [self resetResourceAndHealth]; // method call
    
    return self;
}

-(id)loadPartyMemberHero:(NSDictionary*)partyHeroStats {
    _name = partyHeroStats[@"name"];
    _level = [partyHeroStats[@"level"] intValue];
    _health = [partyHeroStats[@"health"] intValue];
    _combatHealth = [partyHeroStats[@"combatHealth"] intValue];
    _strn = [partyHeroStats[@"strn"] intValue];
    _dext = [partyHeroStats[@"dext"] intValue];
    _inti = [partyHeroStats[@"inti"] intValue];
    _vit = [partyHeroStats[@"vit"] intValue];
    _elementSpec = partyHeroStats[@"elementSpec"];
    _resistanceOffenseMap = partyHeroStats[@"resistanceOffenseMap"];
    _resistanceDefenseMap = partyHeroStats[@"resistanceDefenseMap"];
    return self;
}

/* Load mainCharacter up into dictionary to send to other players.
   These are the ony stats a mainCharacter needs from his party for
   dungeon/combat purposes */
-(NSMutableDictionary*)heroPartyMemberToDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    jsonable[@"name"] = _name;
    jsonable[@"class"] = [self getClassName];
    jsonable[@"level"] = [NSString stringWithFormat:@"%i", _level];
    jsonable[@"health"] = [NSString stringWithFormat:@"%i", _health];
    jsonable[@"combatHealth"] = [NSString stringWithFormat:@"%i", _combatHealth];
    jsonable[@"strn"] = [NSString stringWithFormat:@"%i", _strn];
    jsonable[@"inti"] = [NSString stringWithFormat:@"%i", _inti];
    jsonable[@"dext"] = [NSString stringWithFormat:@"%i", _dext];
    jsonable[@"vit"] =  [NSString stringWithFormat:@"%i", _vit];
    jsonable[@"elementSpec"] = _elementSpec;
    jsonable[@"resistanceOffenseMap"] = _resistanceOffenseMap;
    jsonable[@"resistanceDefenseMap"] = _resistanceDefenseMap;
    return jsonable;
}

/*** Dungeon Info ***/
/* Increase dungeon level by one, resets steps taken/active Items */
//-(void)increaseDungeonLevel {
//    self.dungeonLvl += 1;
//    [self.stepsTaken removeAllObjects]; // remove all objects
//    [self resetActiveItems];
//}
//
///** MAP SPACES **/
//-(void)addStepSpace:(Space*)s {
//    [self.stepsTaken addObject:s];
//}
//
//-(BOOL)containsSpace:(Space*)s {
//    NSUInteger count = [self.stepsTaken count];
//    for (int i = 0; i < count; i++) {
//        Space *tmp  = (Space*)[self.stepsTaken objectAtIndex:i];
//        if (tmp.x == s.x &&
//            tmp.y == s.y) {
//            return true;
//        }
//    }
//    return false;
//}


/** ATTACKS and ABILITIES**/
/* Add Skill to skillSet if not alread a skill */
-(void)addSkillIfNotAlreadyKnown:(NSString*)ability {
    int count = 0;
    for (NSString *s in self.skillSet) {
        if ([s isEqualToString:ability]) {
            count++;
        }
    }
    if (count == 0) { [self.skillSet addObject:ability]; }
}

/* Load Up Active Skill Set With First Four Skills in skillSet */
-(void)setActiveSkills {
    [self.activeSkillSet removeAllObjects];
    
    for (int i = 0; i < [self.skillSet count]; i++) {
        [self.activeSkillSet addObject:[self.skillSet objectAtIndex:i]];
        if (i == 4) {
            break;
        }
    }
}


/** Get Classes name based on ClassID **/
-(NSString*)getClassName {
    if (self.classID == 1) {
        return @"Barbarian";
    } else if (self.classID == 2) {
        return @"Wizard";
    } else {
        return @"Rogue";
    }
}

/* Get Stats */
-(int)getPrimaryStat {
    if ([self.getClassName isEqualToString:@"Barbarian"]) {
        return self.strn;
    } else if ([self.getClassName isEqualToString:@"Wizard"]) {
        return self.inti;
    } else { // Rogue
        return self.dext;
    }
}


-(int)getCritical { return  (int)(((float)self.getPrimaryStat/(float)((self.strn+self.dext+self.inti)*2))*(100.00)); } // TODO -- REWORK

/** Active Items **/

// This is done when a hero dies or a dungeon is completed */
-(void)resetActiveItems {
    for (Item *item in self.activeItems) {
        if ([[item getType] rangeOfString:@"stone"].location != NSNotFound) { // Does it contain stone? if so reduce it's reistance
            [self decreaseResistance:[item getElement] decreaseBy:[item getPotency]];
        }
    }
    
    [self.activeItems removeAllObjects]; // remove all objects
}

/* Buff Library */
-(void)resetLibraries {
    [self.buffLibrary removeAllObjects];
    [self.debuffLibrary removeAllObjects];
    [self.poisonPassiveDots removeAllObjects];
}

/* Set Health and Combat Health */
-(void)resetHealth { self.combatHealth = self.health; }

-(void)setHealth {
    if ([self.getClassName isEqualToString:@"Barbarian"]) { // Barb gets 2 health : 1 Vit
        self.health = (self.vit*2);
    } else if ([self.getClassName isEqualToString:@"Wizard"]) {
        self.health = (int)((float)self.vit*(float)(0.5)); // Wizard gets .5 health : 1 Vit
    } else { // Rogue
        self.health = (int)((float)self.vit*(float)(0.75)); // Rogue gets .75 health : 1 Vit
    }
    /* Set Combat Health */
    self.combatHealth = self.health;
}

-(void)takeDamage:(int)healthReductionOrIncrease {
    int oldCombatHealth = self.combatHealth;
    self.combatHealth = (oldCombatHealth-healthReductionOrIncrease);
    if (self.combatHealth > self.health) {
        self.combatHealth = self.health;
    }
}

/* Set Stats */
// Increase
-(void)increaseStrn:(int)strn { self.strn = self.strn + strn; }
-(void)increaseInti:(int)inti { self.inti = self.inti + inti; }
-(void)increaseDext:(int)dext { self.dext = self.dext + dext; }
-(void)increaseVit:(int)vit { self.vit = self.vit + vit; }
-(void)increaseResistance:(NSString*)element  increaseBy:(int)resistance {
    /* Increase both Offense and Defense Resistance */
    if (![element isEqualToString:@"PHYSICAL"]) {
        /* Increase that elemental resistance */
        NSNumber *oldOffenseResistance  = [self.resistanceOffenseMap objectForKey:element];
        NSNumber *oldDefenseResistance = [self.resistanceDefenseMap objectForKey:element];
        NSNumber *newOffenseResistance = [NSNumber numberWithInt:[oldOffenseResistance intValue] + (resistance)];
        NSNumber *newDefenseResisatnce = [NSNumber numberWithInt:[oldDefenseResistance intValue] + (resistance)];
        
        self.resistanceOffenseMap[element] = newOffenseResistance;
        self.resistanceDefenseMap[element] = newDefenseResisatnce;
    }
}

// Decrease
-(void)decreaseStrn:(int)strn { self.strn = self.strn - strn; }
-(void)decreaseInti:(int)inti { self.inti = self.inti - inti; }
-(void)decreaseDext:(int)dext { self.dext = self.dext - dext; }
-(void)decreaseVit:(int)vit { self.vit = self.vit - vit; };
-(void)decreaseResistance:(NSString*)element  decreaseBy:(int)resistance {
    /* Decrease both Offense and Defense Resistance */
    if (![element isEqualToString:@"PHYSICAL"]) {
        NSNumber *oldOffenseResistance  = [self.resistanceOffenseMap objectForKey:element];
        NSNumber *oldDefenseResistance = [self.resistanceDefenseMap objectForKey:element];
        NSNumber *newOffenseResistance = [NSNumber numberWithInt:[oldOffenseResistance intValue] - (resistance)];
        NSNumber *newDefenseResisatnce = [NSNumber numberWithInt:[oldDefenseResistance intValue] - (resistance)];
        
        self.resistanceOffenseMap[element] = newOffenseResistance;
        self.resistanceDefenseMap[element] = newDefenseResisatnce;
    }
}

/* TODO - DETERMINES WHAT HAPPEN WHEN WE LEVEL
 * 1. Increase Stats
 * 2. Lootbox?
 * 3. Skills? */
-(void)increaseLevel {
    if ([self.getClassName isEqualToString:@"Barbarian"]) {
        [self increaseStrn:10];
        [self increaseInti:5];
        [self increaseDext:5];
        [self increaseVit:10];
    } else if ([self.getClassName isEqualToString:@"Wizard"]) {
        [self increaseStrn:5];
        [self increaseInti:10];
        [self increaseDext:5];
        [self increaseVit:10];
    } else { // Dext
        [self increaseStrn:5];
        [self increaseInti:5];
        [self increaseDext:10];
        [self increaseVit:10];
    }
    self.level += 1;
    
    /* Set health/resource/Skill Cost after stat changes */
    [self resetResourceAndHealth];
    
    /* Calls Specific Classes loadSkills to update list of skills
     * (Some skills are gathered at a certain level) */
    [self loadSkills];
    /* SET ELEMENTAL SPEC */
    if (self.level == 20) {
        [self setElementSpec];
    }
    
}

/* Increases XP by paramater.
 * If level is grown, increase by 1 and carry over Exp */
-(void)increaseExp:(int)xp {
    self.Exp += xp;
    int lvlEXP = self.getLevelExp;
    while (self.Exp >= lvlEXP) { // Increase level
        int difference = (self.Exp-lvlEXP);
        self.Exp = difference;
        [self increaseLevel];
    }
}

-(int)getLevelExp {
    int y = self.level;
    int xp;
    if (y < 50)  {
        xp = (int)(-.4*(y*y*y) + 40.4*y*y + 396*y);
    } else {
        xp = (int)((65*y*y - 165*y - 6750) * .82);
    }
    return xp;
}





/** ELEMENT SPEC **/
-(void)setElementSpec {
    //        System.out.println("\nThe time has come to advance your element. Choose Wisly...");
    //        System.out.println("You will get an immediate boot into Damage Increase and Reduction to your chosen element, ");
    //        System.out.println("as well as next elemental specific abilities\n");
    //        System.out.println("1. Fire: (Extra Damage, Heavy Dots Spells)");
    //        System.out.println("2. Cold: (Damage Reduction)");
    //        System.out.println("3. Lightning: Harnese the power of the sky as you fry your opponents into dust (Stuns, chance to attack again)");
    //        System.out.println("4. Poison: Melt your opponents from the inside (Everything that does damage also becomes a DOT)");
    //        System.out.println("5. Arcane: Utilize holy power to negate the elements (Heavy Elemental Resistances)");
    
    //        Scanner s = new Scanner(System.in);
    while (true) {
        int ele = 0;
        NSString *chosenElement = PHYSICAL;
        BOOL correctSlection = false;
        if (ele == 1) { // fire
            chosenElement = FIRE;
            correctSlection = true;
        } else if (ele == 2) { // cold
            chosenElement = COLD;
            correctSlection = true;
        } else if (ele == 3) { // lightning
            chosenElement = LIGHTNING;
            correctSlection = true;
        } else if (ele == 4) { // poison
            chosenElement = POISON;
            correctSlection = true;
        } else if (ele == 5) { // arcane
            chosenElement = ARCANE;
            correctSlection = true;
        }
        if (correctSlection) {
            self.elementSpec = chosenElement;
            [self increaseResistance:self.elementSpec increaseBy:25];
            break;
        } else {
            
        }
    }
}



/* Loads Skill Set, inserting skills not already known.
   Class specific function. Skills are added based on elemental spec and level */
-(void)loadSkills { }

/* RESOURCES-- OVERIDE BY SUBCLASSES */
-(int)getResource { return 0; }
-(int)getCombatResource { return 0; }
-(NSString*)getResourceName { return @""; }
-(void)increaseResource:(int)resourceIncrease { }
-(void)regenCombatResource:(int)resourceGain { }
-(void)useCombatResource:(int)resourceUsed { }
-(void)resetCombatResource { }
-(void)setResource { }
-(void)setMaxCombatResource { }  // RAGE RESOURCE SPECIFIC

/** RESET variables that are based on other variables
 * (Ex. Health, Resources, skill costs, Resistances)
 * Do self when you, 1. grow a level, 2. equip new armor/wep */
-(void)resetResourceAndHealth {
    [self setResource]; // located in specific classes
    [self setHealth]; // based on Vitality
}

/** Determine Total Armor and Armor Rating **/
-(int)getTotalArmor {
    int armor = 0;
    int count = 0; // Hidden armor rating
    if (self.torso.armorID != 0) { armor += self.torso.armor; count++; }
    if (self.shoulders.armorID != 0) { armor += self.shoulders.armor; count++; }
    if (self.helm.armorID != 0) { armor += self.helm.armor; count++; }
    if (self.boots.armorID != 0) { armor += self.boots.armor; count++; }
    if (self.legs.armorID != 0) { armor += self.legs.armor; count++; }
    if (self.gloves.armorID != 0) { armor += self.gloves.armor; count++; }
    if (self.bracers.armorID != 0) { armor += self.bracers.armor; count++; }
    return (armor+(count*25));
}
-(float)getArmorRating {
    return (float)[self getTotalArmor] * (float)0.12;
}

/* Get Armor/Weapons */
-(Weapon*)getMH {
    if (self.mainHand == nil) {
        return [[Weapon alloc] initweaponID:0 weaponName:@"" weaponType:@"" twoHand:false MH:false];
    } else {
        return self.mainHand;
    }
}
-(Weapon*)getOH {
    if (self.offHand == nil) {
        return [[Weapon alloc] initweaponID:0 weaponName:@"" weaponType:@"" twoHand:false MH:false];
    } else {
        return self.offHand;
    }
}

-(Armor*)getTorso {
    if (self.torso == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.torso;
    }
}

-(Armor*)getShoulders {
    if (self.shoulders == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.shoulders;
    }
}

-(Armor*)getHelm {
    if (self.helm == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.helm;
    }
}

-(Armor*)getBoots {
    if (self.boots == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.boots;
    }
}

-(Armor*)getLegs {
    if (self.legs == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.legs;
    }
}

-(Armor*)getGloves {
    if (gloves == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.gloves;
    }
}

-(Armor*)getBracers {
    if (self.bracers == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.bracers;
    }
}

/** Show Eqiupment/Weapons **/
    -(NSMutableString*)printBody {
        NSMutableString *body = [[NSMutableString alloc] init];

        if ([self getMH].attack != 0) {
            [body appendFormat:@"\nMain Hand: %s\n", [[[self getMH] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nMain Hand: %s\n", ""];
        }

        if ([self getOH].attack != 0) {
            [body appendFormat:@"\nOff Hand: %s\n", [[[self getOH] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nOff Hand: %s\n", ""];
        }

        if ([self getHelm ].armor != 0) {
            [body appendFormat:@"\nHelmet: %s\n", [[[self getHelm] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nHelmet: %s\n", ""];
        }

        if ([self getShoulders].armor != 0) {
            [body appendFormat:@"\nShoulders: %s\n", [[[self getShoulders] toString]UTF8String]];
        } else {
            [body appendFormat:@"\nShoulders: %s\n", ""];
        }

        if ([self getTorso].armor != 0) {
            [body appendFormat:@"\nTorso: %s\n", [[[self getTorso] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nTorso: %s\n", ""];
        }

        if ([self getGloves].armor != 0) {
            [body appendFormat:@"\nGloves: %s\n", [[[self getGloves] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nGloves: %s\n", ""];
        }

        if ([self getBracers].armor != 0) {
            [body appendFormat:@"\nBracers: %s\n", [[[self getBracers] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nBracers: %s\n", ""];
        }

        if ([self getLegs].armor != 0) {
            [body appendFormat:@"\nLegs: %s\n", [[[self getLegs] toString]UTF8String]];
        } else {
            [body appendFormat:@"\nLegs: %s\n", ""];
        }

        if ([self getBoots].armor != 0) {
            [body appendFormat:@"\nBoots: %s\n", [[[self getBoots] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nBoots: %s\n", ""];
        }
        return body;
    }

-(NSMutableString*)printStats {
    NSMutableString *stats = [[NSMutableString alloc] init];
    
    [stats appendString:@"Hero's Stats: \n"];

    [stats appendFormat:@"Level %u %s\n" , self.level, [[self getClassName] UTF8String]];
    [stats appendFormat:@"    Name: %s\n" , [self.name UTF8String]];
    [stats appendFormat:@"    Element Spec: %s\n" , [self.elementSpec UTF8String]];
    [stats appendFormat:@"    XP to Next Level: %u\n" , [self getLevelExp]];
    [stats appendFormat:@"    XP: %u\n" , self.Exp];
    [stats appendFormat:@"    Gold: %u\n" , self.purse];



    [stats appendFormat:@"\nSTATS:\n"];
    
    [stats appendFormat:@"    Health: %u\n" , self.health];
    [stats appendFormat:@"    %s: %u\n" , [[self getResourceName] UTF8String], [self getResource]];
    [stats appendFormat:@"    Armor: %u\n" , [self getTotalArmor]];
    [stats appendFormat:@"    Vitality: %u\n" , self.vit];
    [stats appendFormat:@"    Strength: %u\n" , self.strn];
    [stats appendFormat:@"    Initeligence: %u\n" , self.inti];
    [stats appendFormat:@"    Dexterity: %u\n" , self.dext];
    [stats appendFormat:@"    Critical Hit Chance: %u\n" , [self getCritical]];
    
    [stats appendString:@"\nResistances"];
    [stats appendString:@"\nOffense:\n"];
    [stats appendString:[self printOffenseResMap]];
    [stats appendString:@"\n\nDefense:\n"];
    [stats appendString:[self printDefenseResMap]];
    [stats appendString:@"\n"];
    [stats appendString:[self printActiveItems]];
    
    return stats;
}

/** Print Resistance Maps **/
-(NSMutableString*)printOffenseResMap {
    NSMutableString *resMap = [[NSMutableString alloc] init];
    
    for (NSString* dam in self.resistanceOffenseMap) {
        NSInteger value = [[self.resistanceOffenseMap objectForKey:dam] integerValue];
        [resMap appendFormat:@"    %s: %ld\n", [dam UTF8String], (long)value];
    }
    
    return resMap;
}

-(NSMutableString*)printDefenseResMap {
    NSMutableString *resMap = [[NSMutableString alloc] init];
    
    for (NSString* dam in self.resistanceDefenseMap) {
        NSInteger value = [[self.resistanceDefenseMap objectForKey:dam] integerValue];
        [resMap appendFormat:@"    %s: %ld\n", [dam UTF8String], (long)value];
    }
    
    return resMap;
}

/* Active Items */
-(NSMutableString*)printActiveItems {
    NSMutableString *resMap = [[NSMutableString alloc] init];
    for (Item *item in self.activeItems) {
        [resMap appendFormat:@"%s ", [[item toString] UTF8String]];
    }
    [resMap appendFormat:@"\n\n"];
    return resMap;
}

@end
