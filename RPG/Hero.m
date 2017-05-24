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

int MOVELISTMAX = 20; // static?
int INVENTORYMAX = 50; // static?

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
NSMutableArray *inventory;
NSMutableArray *activeItems;

/* Tempory libraries */
NSMutableDictionary *buffLibrary; //<String, Buff>;
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
-(id)initname:(NSString *)aName classID:(int)aClassID vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext startX:(int)aStartX startY:(int)aStartY dungeonLvl:(int)aDungeonLvl {
    _name = aName;
    _classID = aClassID;
    _vit = aVit;
    _strn = aStrn;
    _inti = aInti;
    _dext = aDext;
    _Exp = 0;
    _level = 20;
    _startX  = aStartX;
    _startY = aStartY;
    _dungeonLvl = aDungeonLvl;
    _purse = 0;
    _elementSpec= @"PHYSICAL";
    
    _skillSet = [[NSMutableArray alloc] init];
    _inventory = [[NSMutableArray alloc] init];
    _activeItems = [[NSMutableArray alloc] init];
    _stepsTaken = [[NSMutableArray alloc] init];
    _poisonPassiveDots = [[NSMutableArray alloc] init];
    
    _buffLibrary = [[NSMutableDictionary alloc] init];
    _resistanceDefenseMap = [[NSMutableDictionary alloc] init];
    _resistanceOffenseMap = [[NSMutableDictionary alloc] init];
    
    _resistanceDefenseMap[@"FIRE"] = [NSNumber numberWithInt:50];
    _resistanceDefenseMap[@"COlD"] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[@"ARCANE"] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[@"POISON"] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[@"LIGHTNING"] = [NSNumber numberWithInt:0];
    _resistanceDefenseMap[@"PHYSICAL"] = [NSNumber numberWithInt:0];
    
    _resistanceOffenseMap[@"FIRE"] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[@"COlD"] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[@"ARCANE"] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[@"POISON"] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[@"LIGHTNING"] = [NSNumber numberWithInt:0];
    _resistanceOffenseMap[@"PHYSICAL"] = [NSNumber numberWithInt:0];
    
    /* Set Heatlh Based On Vit */
    [self resetVariables]; // method call
    
    return self;
}


/*** Dungeon Info ***/
/* Increase dungeon level by one, resets steps taken/active Items */
-(void)increaseDungeonLevel {
    self.dungeonLvl += 1;
    [self.stepsTaken removeAllObjects]; // remove all objects
    [self resetActiveItems];
}

/** MAP SPACES **/
-(void)addStepSpace:(Space*)s {
    [self.stepsTaken addObject:s];
}

-(BOOL)containsSpace:(Space*)s {
    NSUInteger count = [self.stepsTaken count];
    for (int i = 0; i < count; i++) {
        Space *tmp  = (Space*)[self.stepsTaken objectAtIndex:i];
        if (tmp.x == s.x &&
            tmp.y == s.y) {
            return true;
        }
    }
    return false;
}


/** ATTACKS and ABILITIES**/

-(void)addSkill:(NSString*)ability {
    int count = 0;
    for (NSString *s in self.skillSet) {
        if ([s isEqualToString:ability]) {
            count++;
        }
    }
    if (count == 0) { [self.skillSet addObject:ability]; }
}

//    public void toStringSkills() {
//        for (int i = 0; i < skillSet.size(); i++) {
//            int combatCost = SkillLibrary.findSkill(skillSet.get(i)).getCombatResourceCost(getResource());
//            if (skillSet.get(i).equals("BasicAttack")) {
//                if (getClassName().equals("Barb")) {
//                    System.out.println(i + ". " + "Swing | " + 0);
//                } else if (getClassName().equals("Wizard")) {
//                    System.out.println(i + ". " + "Shoot | " + combatCost);
//                } else { // Rogue
//                    System.out.println(i + ". " + "Shank | " + combatCost);
//                }
//            } else {
//                System.out.println(i + ". " + SkillLibrary.findSkill(getSkillSet().get(i)).toString() + " | Cost: " + combatCost);
//            }
//        }
//    }


/** Get Classes name based on ClassID **/
-(NSString*)getClassName {
    if (self.classID == 1) {
        return @"Barb";
    } else if (self.classID == 2) {
        return @"Wizard";
    } else {
        return @"Rogue";
    }
}

/** Gold Functions **/
-(void)changePurse:(int)gold { self.purse = (self.purse+gold); }

/* Get Stats */
-(int)getPrimaryStat {
    if ([self.getClassName isEqualToString:@"Barb"]) {
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
    [self.poisonPassiveDots removeAllObjects];
}

/* Set Health */
-(void)resetHealth { self.combatHealth = self.health; }

-(void)setHealth {
    if ([self.getClassName isEqualToString:@"Barb"]) { // Barb gets 2 health : 1 Vit
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
    if ([self.getClassName isEqualToString:@"Barb"]) {
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
        /* Set health/resource/Skill Cost after stat changes */
        [self resetVariables];
        /* Calls Specific Classes loadSkills to update list of skills
         * (Some skills are gathered at a certain level) */
        [self loadSkills];
        /* SET ELEMENTAL SPEC */
        if (self.level == 20) {
            [self setElementSpec];
        }
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


/** Set Armor/Weapons **/
/* Will unequip armor if slot is not empty */
-(void)equipArmor:(Armor*)a {
    if ([a.armorType isEqualToString:@"Helmet"]) {
        if (self.getHelm.armor != 0) {
            [self unequipHelm];
        }
        self.helm = a;
    } else if ([a.armorType isEqualToString:@"Torso"]) {
        if (self.getTorso.armor != 0) {
            [self unequipTorso];
        }
        self.torso = a;
    } else if ([a.armorType isEqualToString:@"Shoulders"]) {
        if (self.getShoulders.armor != 0) {
            [self unequipShoulders];
        }
        self.shoulders = a;
    } else if ([a.armorType isEqualToString:@"Bracers"]) {
        if (self.getBracers.armor != 0) {
            [self unequipBracers];
        }
        self.bracers = a;
    } else if ([a.armorType isEqualToString:@"Gloves"]) {
        if (self.getGloves.armor != 0) {
            [self unequipGloves];
        }
        self.gloves = a;
    } else if ([a.armorType isEqualToString:@"Legs"]) {
        if (self.getLegs.armor != 0) {
            [self unequipLegs];
        }
        self.legs = a;
    } else if ([a.armorType isEqualToString:@"Boots"]) {
        if (self.getBoots.armor != 0) {
            [self unequipBoots];
        }
        self.boots = a;
    } else {
    
    }
    /* Increase stats */
    [self increaseStrn:a.armorStrn];
    [self increaseInti:a.armorInti];
    [self increaseDext:a.armorDext];
    [self increaseVit:a.armorVit];
    [self increaseResistance:a.armorElement increaseBy:a.armorResistance];
    /* Remove and reset values */
    [self removeFromInventory:a];
    [self resetVariables];
}

-(void)equipWeapon:(Weapon*)w {
    if (w.isMainHand) {
        if ([self canUseWeapon:w]) {
            if (w.twoHand) {
                // Unquip OffHand
                [self unequipOH];
                self.mainHand = w;
            } else {
                self.mainHand = w;
            }
        } else {
            printf("Class can't use weapon");
        }
    } else { // OH
        if ([self canUseWeapon:w]) {
            self.offHand = w;
        } else {
            printf("Class can't use weapon");
        }
    }
    
    [self removeFromInventory:w];
}

-(BOOL)canUseWeapon:(Weapon*)w {
    if ([[self getClassName] isEqualToString:@"Barb"]) {
        if (![w.weaponType isEqualToString:@"Wand"]) {
            return true;
        }
    } else if ([[self getClassName] isEqualToString:@"Wizard"]) {
        /* WIZARDS CAN'T DUAL WIELD */
        if (w.isMainHand) { // MH
            if ([w.weaponType isEqualToString:@"Wand"] || [w.weaponType isEqualToString:@"Staff"] ||
                [w.weaponType isEqualToString:@"Sword"] || [w.weaponType isEqualToString:@"Dagger"] ||
                [w.weaponType isEqualToString:@"Shield"]) {
                return true;
            }
        } else { // OH
            if ([w.weaponType isEqualToString:@"Shield"]) {
                return true;
            } else {
                printf("Class Can't Dual Wield");
            }
        }
    } else { // Rogue
        if ([w.weaponType isEqualToString:@"Blunt"] || [w.weaponType isEqualToString:@"Axe"] ||
            [w.weaponType isEqualToString:@"Sword"] || [w.weaponType isEqualToString:@"Dagger"]) {
            return true;
        }
    }

    return false;

}

/** Unequip Items **/
-(void)unequipHelm {
    [self decreaseStrn:self.helm.armorStrn];
    [self decreaseInti:self.helm.armorInti];
    [self decreaseDext:self.helm.armorDext];
    [self decreaseVit:self.helm.armorVit];
    [self decreaseResistance:self.helm.armorElement decreaseBy:self.helm.armorResistance];
    [self addToInventory:self.helm];
    self.helm = nil;
}

-(void)unequipShoulders {
    [self decreaseStrn:self.shoulders.armorStrn];
    [self decreaseInti:self.shoulders.armorInti];
    [self decreaseDext:self.shoulders.armorDext];
    [self decreaseVit:self.shoulders.armorVit];
    [self decreaseResistance:self.shoulders.armorElement decreaseBy:self.shoulders.armorResistance];
    [self addToInventory:self.shoulders];
    self.shoulders = nil;
}

-(void)unequipBracers {
    [self decreaseStrn:self.bracers.armorStrn];
    [self decreaseInti:self.bracers.armorInti];
    [self decreaseDext:self.bracers.armorDext];
    [self decreaseVit:self.bracers.armorVit];
    [self decreaseResistance:self.bracers.armorElement decreaseBy:self.bracers.armorResistance];
    [self addToInventory:self.bracers];
    self.bracers = nil;
}

-(void)unequipGloves {
    [self decreaseStrn:self.gloves.armorStrn];
    [self decreaseInti:self.gloves.armorInti];
    [self decreaseDext:self.gloves.armorDext];
    [self decreaseVit:self.gloves.armorVit];
    [self decreaseResistance:self.gloves.armorElement decreaseBy:self.gloves.armorResistance];
    [self addToInventory:self.gloves];
    self.gloves = nil;
}

-(void)unequipTorso {
    [self decreaseStrn:self.torso.armorStrn];
    [self decreaseInti:self.torso.armorInti];
    [self decreaseDext:self.torso.armorDext];
    [self decreaseVit:self.torso.armorVit];
    [self decreaseResistance:self.torso.armorElement decreaseBy:self.torso.armorResistance];
    [self addToInventory:self.torso];
    self.torso = nil;
}

-(void)unequipLegs {
    [self decreaseStrn:self.legs.armorStrn];
    [self decreaseInti:self.legs.armorInti];
    [self decreaseDext:self.legs.armorDext];
    [self decreaseVit:self.legs.armorVit];
    [self decreaseResistance:self.legs.armorElement decreaseBy:self.legs.armorResistance];
    [self addToInventory:self.legs];
    self.legs = nil;
}

-(void)unequipBoots {
    [self decreaseStrn:self.boots.armorStrn];
    [self decreaseInti:self.boots.armorInti];
    [self decreaseDext:self.boots.armorDext];
    [self decreaseVit:self.boots.armorVit];
    [self decreaseResistance:self.boots.armorElement decreaseBy:self.boots.armorResistance];
    [self addToInventory:self.boots];
    self.boots = nil;
}


-(void)unequipMH { [self addToInventory:self.mainHand]; self.mainHand = nil; }
-(void)unequipOH { [self addToInventory:self.offHand]; self.offHand = nil; }

/**** inventoryManagement Enters the Equip/unquip screen for inventory / on Hero selection ****/
-(void)inventoryManagement:(NSObject*)invItem {
    
    if ([invItem isKindOfClass:[Armor class]]) { // Armor
        Armor *tmp = (Armor *) invItem;
        
        [self equipArmor:tmp];
        
        printf("%s",[[tmp toString] UTF8String]);
        
    } else if ([invItem isKindOfClass:[Weapon class]]) { // Wep
        Weapon *tmp = (Weapon *) invItem;
        
        [self equipWeapon:tmp];
        
        printf("%s",[[tmp toString] UTF8String]);
        
    } else {
        Item *tmp = (Item *) invItem;
        printf("%s",[[tmp toString] UTF8String]);
        
        /* Activate Item */
        [self activateItem:tmp];
    }



}

/** ITEM HANDLING **/
-(void)activateItem:(Item*)item {
    /* Add active Item Buff to Hero's ActiveItem Array and Activate Buff */
    if([[item getType] rangeOfString:@"stone"].location != NSNotFound) {
        [self increaseResistance:[item getElement] increaseBy:[item getPotency]];
        /* Add to Active Item Buffs Array */
        [self.activeItems addObject:item];
        
    } else if ([[item getType]isEqualToString:@"XPBoost"]) {
        /* Add to Active Item Buffs Array */
        [self.activeItems addObject:item];
        
    } else if ([[item getType]isEqualToString:@"ElementScroll"]) {
        /* Select a random skill from that element (that is level approriate)
         * Add it to mainCharcters skillSet */
        if ([self.elementSpec isEqualToString:@"FIRE"]) {
            
        } else if ([self.elementSpec isEqualToString:@"COLD"]) {
            
        } else if ([self.elementSpec isEqualToString:@"POISON"]) {
            
        } else if ([self.elementSpec isEqualToString:@"LIGHTNING"]) {
            
        } else if ([self.elementSpec isEqualToString:@"ARCANE"]) {
            
        }
    }
    
    /* Remove from Inventory */
    [self removeFromInventory:item];
    
}

-(void)deactivateItem:(Item*)item {
    /* Remove active Item Buff to Hero's ActiveItem Array and Activate Buff */
    if([[item getType] rangeOfString:@"stone"].location != NSNotFound) {
        [self decreaseResistance:[item getElement] decreaseBy:[item getPotency]];
        /* Add to Active Item Buffs Array */
        [self.activeItems removeObject:item];
        
    } else if ([[item getType]isEqualToString:@"XPBoost"]) {
        /* Add to Active Item Buffs Array */
        [self.activeItems removeObject:item];
    }
    
    
    
}

/** INENTORY **/
-(NSMutableString*)revealInventory {
    NSMutableString *printInventory = [[NSMutableString alloc] init];
    [printInventory appendString:@"INVENTORY\n\n"];
    for (int i = 0; i < [self.inventory count]; i++) {
        if ([[self.inventory  objectAtIndex:i] isKindOfClass:[Armor class]]) { // Armor
            Armor *tmp = (Armor *) [self.inventory objectAtIndex:i];
            [printInventory appendFormat:@"%u. %s\n", i, [[tmp toString] UTF8String]];
            
        } else if ([[self.inventory  objectAtIndex:i] isKindOfClass:[Weapon class]]) { // Wep
            Weapon *tmp = (Weapon *) [self.inventory objectAtIndex:i];
            [printInventory appendFormat:@"%u. %s\n", i, [[tmp toString] UTF8String]];
        } else {
            Item *tmp = (Item *) [self.inventory objectAtIndex:i];
            [printInventory appendFormat:@"%u. %s\n", i, [[tmp toString] UTF8String]];
        }
    }
    return printInventory;
}

-(void)addToInventory:(id)o {
    if ([self.inventory count] > 25) {
        //                Scanner s = new Scanner(System.in);
        //                System.out.println("Can only hold 25 Items, choose one to drop.");
        [self.inventory removeLastObject]; // Remove
        [self.inventory addObject:o]; // Then add
    } else {
        
        [self.inventory addObject:o];
    }
}

-(void)removeFromInventory:(id)o {

    if ([self.inventory indexOfObject:o] != NSNotFound) {
        [self.inventory removeObjectAtIndex:[self.inventory indexOfObject:o]];
    }
}

-(void)receiveLoot:(NSMutableArray*)loot {
    for (int i = 0; i < [loot count]; i++) {
        id tmp = [loot objectAtIndex:i];
        [self addToInventory:tmp];
    }
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
        NSString *chosenElement = @"PHYSICAL";
        BOOL correctSlection = false;
        if (ele == 1) { // fire
            chosenElement = @"FIRE";
            correctSlection = true;
        } else if (ele == 2) { // cold
            chosenElement = @"COLD";
            correctSlection = true;
        } else if (ele == 3) { // lightning
            chosenElement = @"LIGHTNING";
            correctSlection = true;
        } else if (ele == 4) { // poison
            chosenElement = @"POISON";
            correctSlection = true;
        } else if (ele == 5) { // arcane
            chosenElement = @"ARCANE";
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



/* Skill Set */
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
-(void)resetVariables {
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
    if (boots == nil) {
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
        [body appendString:@"EQUIPED\n"];
        if ([self getMH].attack != 0) {
            [body appendFormat:@"Main Hand: %s\n", [[[self getMH] toString] UTF8String]];
        } else {
            [body appendFormat:@"Main Hand: %s\n", ""];
        }

        if ([self getOH].attack != 0) {
            [body appendFormat:@"Off Hand: %s\n", [[[self getOH] toString] UTF8String]];
        } else {
            [body appendFormat:@"Off Hand: %s\n", ""];
        }

        if ([self getHelm ].armor != 0) {
            [body appendFormat:@"Helmet: %s\n", [[[self getHelm] toString] UTF8String]];
        } else {
            [body appendFormat:@"Helmet: %s\n", ""];
        }

        if ([self getShoulders].armor != 0) {
            [body appendFormat:@"Shoulders: %s\n", [[[self getShoulders] toString]UTF8String]];
        } else {
            [body appendFormat:@"Shoulders: %s\n", ""];
        }

        if ([self getTorso].armor != 0) {
            [body appendFormat:@"Torso: %s\n", [[[self getTorso] toString] UTF8String]];
        } else {
            [body appendFormat:@"Torso: %s\n", ""];
        }

        if ([self getGloves].armor != 0) {
            [body appendFormat:@"Gloves: %s\n", [[[self getGloves] toString] UTF8String]];
        } else {
            [body appendFormat:@"Gloves: %s\n", ""];
        }

        if ([self getBracers].armor != 0) {
            [body appendFormat:@"Bracers: %s\n", [[[self getBracers] toString] UTF8String]];
        } else {
            [body appendFormat:@"Bracers: %s\n", ""];
        }

        if ([self getLegs].armor != 0) {
            [body appendFormat:@"Legs: %s\n", [[[self getLegs] toString]UTF8String]];
        } else {
            [body appendFormat:@"Legs: %s\n", ""];
        }

        if ([self getBoots].armor != 0) {
            [body appendFormat:@"Boots: %s\n", [[[self getBoots] toString] UTF8String]];
        } else {
            [body appendFormat:@"Boots: %s\n", ""];
        }
        return body;
    }

-(NSMutableString*)printStats {
    NSMutableString *stats = [[NSMutableString alloc] init];
    
    [stats appendString:@"      Hero's Stats: \n"];

    [stats appendFormat:@"Class: %s\n" , [[self getClassName] UTF8String]];
    [stats appendFormat:@"Name: %s\n" , [self.name UTF8String]];
    [stats appendFormat:@"Dungeon Level: %u\n" , self.dungeonLvl];
    [stats appendFormat:@"Element Spec: %s\n" , [self.elementSpec UTF8String]];

    [stats appendFormat:@"\nLevel: %u\n" , self.level];
    [stats appendFormat:@"XP to Next Level: %u\n" , [self getLevelExp]];
    [stats appendFormat:@"XP: %u\n" , self.Exp];
    [stats appendFormat:@"Gold: %u\n" , self.purse];

    [stats appendFormat:@"\n    STATS:%s\n" , ""];
    
    [stats appendFormat:@"Health: %u\n" , self.health];
    [stats appendFormat:@"Armor: %u\n" , [self getTotalArmor]];
    [stats appendFormat:@"Vitality: %u\n" , self.vit];
    [stats appendFormat:@"Strength: %u\n" , self.strn];
    [stats appendFormat:@"Initeligence: %u\n" , self.inti];
    [stats appendFormat:@"Dexterity: %u\n" , self.dext];
    [stats appendFormat:@"Critical Hit Chance: %u\n" , [self getCritical]];
    
    [stats appendString:@"\n    Resistances\n"];
    [stats appendString:[self printOffenseResMap]];
    [stats appendString:@"\n"];
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
        [resMap appendFormat:@"%s: %ld\n", [dam UTF8String], (long)value];
    }
    
    return resMap;
}

-(NSMutableString*)printDefenseResMap {
    NSMutableString *resMap = [[NSMutableString alloc] init];
    
    for (NSString* dam in self.resistanceDefenseMap) {
        NSInteger value = [[self.resistanceDefenseMap objectForKey:dam] integerValue];
        [resMap appendFormat:@"%s: %ld\n", [dam UTF8String], (long)value];
    }
    
    return resMap;
}

/* Active Items */
-(NSMutableString*)printActiveItems {
    NSMutableString *resMap = [[NSMutableString alloc] init];
    for (Item *item in self.activeItems) {
        [resMap appendFormat:@"%s ", [[item toString] UTF8String]];
    }
    return resMap;
}

@end