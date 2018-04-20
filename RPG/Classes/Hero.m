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


int classID;
int Exp;
int purse;

/* Definite Libraries */
NSMutableArray *skillSet;
NSMutableArray *inventory;
NSMutableArray *activeItems;

/* Tempory libraries */
NSMutableDictionary *buffLibrary; //<String, Buff>;
NSMutableDictionary *debuffLibrary;
NSMutableDictionary *combatBuffLibrary; //<String, Buff>;
NSMutableDictionary *combatDebuffLibrary;


/* Resisatnces: Fire, Lightning, Cold, Poison, Arcane  */
NSMutableDictionary *resistanceDefenseMap; //<String, Integer>;
NSMutableDictionary *resistanceOffenseMap; //<String, Integer>;

NSMutableDictionary *combatActionMap;

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


/** START OF CLASS METHODS **/
-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext {
    self.name = aName;
    self.vit = aVit;
    self.strn = aStrn;
    self.inti = aInti;
    self.dext = aDext;
    _Exp = 0;
    self.level = 20;
    _purse = 0;
    self.elementSpec= PHYSICAL;
    
    _skillSet = [[NSMutableArray alloc] init];
    _inventory = [[NSMutableArray alloc] init];
    _activeItems = [[NSMutableArray alloc] init];

    _combatActionMap = [[NSMutableDictionary alloc] init];
    _buffLibrary = [[NSMutableDictionary alloc] init];
    _debuffLibrary = [[NSMutableDictionary alloc] init];
    _combatBuffLibrary = [[NSMutableDictionary alloc] init];
    _combatDebuffLibrary = [[NSMutableDictionary alloc] init];
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
    
    /* Set Heatlh/Combat health Based On Vit */
    [self resetResourceAndHealth]; // method call
    [self resetCombatHealth];
    
    /**
        A HERO will keep there combat health untouched through the entire dungeon/campaign except by spells and potions.
        Therefore, only set the combatHealth when a character is created or loaded, before initally sending out hero data to other players
     **/
    
    return self;
}

-(id)loadBeingFromDictionary:(NSDictionary*)partyHeroStats {
    self.name = partyHeroStats[@"name"];
    self.level = [partyHeroStats[@"level"] intValue];
    self.health = [partyHeroStats[@"health"] intValue];
    self.combatHealth = [partyHeroStats[@"combatHealth"] intValue];
    self.strn = [partyHeroStats[@"strn"] intValue];
    self.dext = [partyHeroStats[@"dext"] intValue];
    self.inti = [partyHeroStats[@"inti"] intValue];
    self.vit = [partyHeroStats[@"vit"] intValue];
    self.elementSpec = partyHeroStats[@"elementSpec"];
    
    _resistanceOffenseMap = [self loadOffenseResistanceMaps:partyHeroStats[@"resistanceOffenseMap"]];
    _resistanceDefenseMap = [self loadDefenseResistanceMaps:partyHeroStats[@"resistanceDefenseMap"]];
    
    _buffLibrary = [self loadBuffLibary:partyHeroStats[@"buffLibrary"]];
    _debuffLibrary = [self loadDebuffLibary:partyHeroStats[@"debuffLibrary"]];
    
    _combatBuffLibrary = [self loadCombatBuffLibary:partyHeroStats[@"combatBuffLibrary"]];
    _combatDebuffLibrary = [self loadCombatDebuffLibary:partyHeroStats[@"combatDebuffLibrary"]];
    
    [self loadArmorFromDictionary:partyHeroStats[@"armor"]];
    [self loadWeaponsFromDictionary:partyHeroStats[@"weapons"]];
    
    return self;
}

-(NSMutableDictionary*)loadBuffLibary:(NSDictionary*)buffLibrary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString* buffName in buffLibrary) {
        dic[buffName] = buffLibrary[buffName];
    }
    return dic;
}

-(NSMutableDictionary*)loadDebuffLibary:(NSDictionary*)debuffLibrary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString* debuffName in debuffLibrary) {
        dic[debuffName] = debuffLibrary[debuffName];
    }
    return dic;
}

-(NSMutableDictionary*)loadCombatBuffLibary:(NSDictionary*)combatBuffLibrary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString* buffName in combatBuffLibrary) {
        dic[buffName] = combatBuffLibrary[buffName];
    }
    return dic;
}

-(NSMutableDictionary*)loadCombatDebuffLibary:(NSDictionary*)combatDebuffLibrary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    for (NSString* debuffName in combatDebuffLibrary) {
        dic[debuffName] = combatDebuffLibrary[debuffName];
    }
    return dic;
}

-(NSMutableDictionary*)loadOffenseResistanceMaps:(NSDictionary*)offensiveDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[FIRE] = offensiveDictionary[FIRE];
    dic[COLD] = offensiveDictionary[COLD];
    dic[ARCANE] = offensiveDictionary[ARCANE];
    dic[POISON] = offensiveDictionary[POISON];
    dic[LIGHTNING] = offensiveDictionary[LIGHTNING];
    dic[PHYSICAL] = offensiveDictionary[PHYSICAL];
    return dic;
}

-(NSMutableDictionary*)loadDefenseResistanceMaps:(NSDictionary*)defenseDictionary {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[FIRE] = defenseDictionary[FIRE];
    dic[COLD] = defenseDictionary[COLD];
    dic[ARCANE] = defenseDictionary[ARCANE];
    dic[POISON] = defenseDictionary[POISON];
    dic[LIGHTNING] = defenseDictionary[LIGHTNING];
    dic[PHYSICAL] = defenseDictionary[PHYSICAL];
    return dic;
}

/* Load mainCharacter up into dictionary to send to other players.
   These are the ony stats a mainCharacter needs from his party for
   dungeon/combat purposes */
-(NSMutableDictionary*)beingToDictionary {
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    jsonable[@"name"] = self.name;
    jsonable[@"class"] = [self getClassName];
    jsonable[@"level"] = [NSString stringWithFormat:@"%i", self.level];
    jsonable[@"health"] = [NSString stringWithFormat:@"%i", self.health];
    jsonable[@"combatHealth"] = [NSString stringWithFormat:@"%i", self.combatHealth];
    jsonable[@"strn"] = [NSString stringWithFormat:@"%i", self.strn];
    jsonable[@"inti"] = [NSString stringWithFormat:@"%i", self.inti];
    jsonable[@"dext"] = [NSString stringWithFormat:@"%i", self.dext];
    jsonable[@"vit"] =  [NSString stringWithFormat:@"%i", self.vit];
    jsonable[@"elementSpec"] = self.elementSpec;
    
    jsonable[@"resistanceOffenseMap"] = _resistanceOffenseMap;
    jsonable[@"resistanceDefenseMap"] = _resistanceDefenseMap;
    
    jsonable[@"buffLibrary"] = _buffLibrary;
    jsonable[@"debuffLibrary"] = _debuffLibrary;
    
    jsonable[@"combatBuffLibrary"] = _combatBuffLibrary;
    jsonable[@"combatDebuffLibrary"] = _combatDebuffLibrary;
    
    jsonable[@"armor"] = [self getDictionaryOfArmor];
    jsonable[@"weapons"] = [self getDictionaryOfWeapons];
    
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


/** Get Classes name based on ClassID **/
-(NSString*)getClassName {
    if (self.classID == 1) {
        return BARBARIAN;
    } else if (self.classID == 2) {
        return WIZARD;
    } else {
        return ROGUE;
    }
}

/* Get Stats */
-(int)getPrimaryStat {
    if ([self.getClassName isEqualToString:BARBARIAN]) {
        return self.strn;
    } else if ([self.getClassName isEqualToString:WIZARD]) {
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
-(void)resetCombatLibraries {
    [self.combatBuffLibrary removeAllObjects];
    [self.combatDebuffLibrary removeAllObjects];
}

-(void)resetCombatActionMap {
    _combatActionMap = [[NSMutableDictionary alloc] init];
}

/* Set Health and Combat Health */
-(void)resetCombatHealth { self.combatHealth = self.health; }

-(void)setHealth {
    if ([self.getClassName isEqualToString:BARBARIAN]) { // Barb gets 1.25 health : 1 Vit
        self.health = (int)((float)self.vit*(float)(1.25));
    } else if ([self.getClassName isEqualToString:WIZARD]) {
        self.health = (int)((float)self.vit*(float)(0.5)); // Wizard gets .5 health : 1 Vit
    } else { // Rogue
        self.health = (int)((float)self.vit*(float)(0.75)); // Rogue gets .75 health : 1 Vit
    }
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
    if (![element isEqualToString:PHYSICAL]) {
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
    if (![element isEqualToString:PHYSICAL]) {
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
    if ([self.getClassName isEqualToString:BARBARIAN]) {
        [self increaseStrn:10];
        [self increaseInti:5];
        [self increaseDext:5];
        [self increaseVit:10];
    } else if ([self.getClassName isEqualToString:WIZARD]) {
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
        return [[Weapon alloc] initForRandomStatsweaponID:0 weaponName:@"" weaponType:@"" twoHand:false MH:false];
    } else {
        return self.mainHand;
    }
}
-(Weapon*)getOH {
    if (self.offHand == nil) {
        return [[Weapon alloc] initForRandomStatsweaponID:0 weaponName:@"" weaponType:@"" twoHand:false MH:false];
    } else {
        return self.offHand;
    }
}

-(Armor*)getTorso {
    if (self.torso == nil) {
        return [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.torso;
    }
}

-(Armor*)getShoulders {
    if (self.shoulders == nil) {
        return [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.shoulders;
    }
}

-(Armor*)getHelm {
    if (self.helm == nil) {
        return [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.helm;
    }
}

-(Armor*)getBoots {
    if (self.boots == nil) {
        return [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.boots;
    }
}

-(Armor*)getLegs {
    if (self.legs == nil) {
        return [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.legs;
    }
}

-(Armor*)getGloves {
    if (gloves == nil) {
        return [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.gloves;
    }
}

-(Armor*)getBracers {
    if (self.bracers == nil) {
        return [[Armor alloc] initForRandomStatsarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.bracers;
    }
}

/** Show Eqiupment/Weapons **/
    -(NSMutableString*)printBody {
        NSMutableString *body = [[NSMutableString alloc] init];

        if ([self getMH].weaponID != 0) {
            [body appendFormat:@"\nMain Hand: %s\n", [[[self getMH] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nMain Hand: %s\n", ""];
        }

        if ([self getOH].weaponID != 0) {
            [body appendFormat:@"\nOff Hand: %s\n", [[[self getOH] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nOff Hand: %s\n", ""];
        }

        if ([self getHelm ].armorID != 0) {
            [body appendFormat:@"\nHelmet: %s\n", [[[self getHelm] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nHelmet: %s\n", ""];
        }

        if ([self getShoulders].armorID != 0) {
            [body appendFormat:@"\nShoulders: %s\n", [[[self getShoulders] toString]UTF8String]];
        } else {
            [body appendFormat:@"\nShoulders: %s\n", ""];
        }

        if ([self getTorso].armorID != 0) {
            [body appendFormat:@"\nTorso: %s\n", [[[self getTorso] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nTorso: %s\n", ""];
        }

        if ([self getGloves].armorID != 0) {
            [body appendFormat:@"\nGloves: %s\n", [[[self getGloves] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nGloves: %s\n", ""];
        }

        if ([self getBracers].armorID != 0) {
            [body appendFormat:@"\nBracers: %s\n", [[[self getBracers] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nBracers: %s\n", ""];
        }

        if ([self getLegs].armorID != 0) {
            [body appendFormat:@"\nLegs: %s\n", [[[self getLegs] toString]UTF8String]];
        } else {
            [body appendFormat:@"\nLegs: %s\n", ""];
        }

        if ([self getBoots].armorID != 0) {
            [body appendFormat:@"\nBoots: %s\n", [[[self getBoots] toString] UTF8String]];
        } else {
            [body appendFormat:@"\nBoots: %s\n", ""];
        }
        return body;
    }

-(NSMutableDictionary*)getDictionaryOfArmor {
    NSMutableDictionary *armorDictionary = [[NSMutableDictionary alloc] init];
    armorDictionary[HELMET] = [[self getHelm] armorToDictionary];
    armorDictionary[SHOULDERS] = [[self getShoulders] armorToDictionary];
    armorDictionary[TORSO] = [[self getTorso] armorToDictionary];
    armorDictionary[BRACERS] = [[self getBracers] armorToDictionary];
    armorDictionary[GLOVES] = [[self getGloves] armorToDictionary];
    armorDictionary[BOOTS] = [[self getBoots] armorToDictionary];
    armorDictionary[LEGS] = [[self getLegs] armorToDictionary];
    return armorDictionary;
}

-(NSMutableDictionary*)getDictionaryOfWeapons {
    NSMutableDictionary *weaponDictionary = [[NSMutableDictionary alloc] init];
    weaponDictionary[MAINHAND] = [[self getMH] weaponToDictionary];
    weaponDictionary[OFFHAND] = [[self getOH] weaponToDictionary];
    return weaponDictionary;
}

/* Don't use the equip function, because the stats are already in effet when
   the hero data is sent over. */
-(void)loadArmorFromDictionary:(NSMutableDictionary*)armorDictionary {
    self.helm = [Armor createArmorFromDictionary:armorDictionary[HELMET]];
    self.shoulders = [Armor createArmorFromDictionary:armorDictionary[SHOULDERS]];
    self.torso = [Armor createArmorFromDictionary:armorDictionary[TORSO]];
    self.bracers = [Armor createArmorFromDictionary:armorDictionary[BRACERS]];
    self.gloves = [Armor createArmorFromDictionary:armorDictionary[GLOVES]];
    self.boots = [Armor createArmorFromDictionary:armorDictionary[BOOTS]];
    self.legs = [Armor createArmorFromDictionary:armorDictionary[LEGS]];
}

-(void)loadWeaponsFromDictionary:(NSMutableDictionary*)weaponDictionary {
    self.mainHand = [Weapon createWeaponFromDictionary:weaponDictionary[MAINHAND]];
    self.offHand = [Weapon createWeaponFromDictionary:weaponDictionary[OFFHAND]];
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
