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
NSString *elementSpec = @"PHYSICAL";

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
    
    _skillSet = [[NSMutableArray alloc] init];
    _inventory = [[NSMutableArray alloc] init];
    activeItems = [[NSMutableArray alloc] init];
    stepsTaken = [[NSMutableArray alloc] init];
    _poisonPassiveDots = [[NSMutableArray alloc] init];
    
    _resistanceDefenseMap = [[NSMutableDictionary alloc] init];
    _resistanceOffenseMap = [[NSMutableDictionary alloc] init];
    
    _resistanceDefenseMap[@"FIRE"] = [NSNumber numberWithInt:0];
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


/* Active Items */
//    public void printActiveItems() {
//        System.out.println("Active Items: ");
//        int count = 1;
//        for (Item i : getActiveItems()) {
//            System.out.println(count + ". " + i.toString());
//            count++;
//        }
//        System.out.println();
//    }

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

-(void)equipArmor:(Armor*)a {
    if ([a.armorType isEqualToString:@"Helmet"]) {
        self.helm = a;
    } else if ([a.armorType isEqualToString:@"Torso"]) {
        self.torso = a;
    } else if ([a.armorType isEqualToString:@"Shoulders"]) {
        self.shoulders = a;
    } else if ([a.armorType isEqualToString:@"Bracers"]) {
        self.bracers = a;
    } else if ([a.armorType isEqualToString:@"Gloves"]) {
        self.gloves = a;
    } else if ([a.armorType isEqualToString:@"Legs"]) {
        self.legs = a;
    } else if ([a.armorType isEqualToString:@"Boots"]) {
        self.boots = a;
    } else {
        //     System.out.println("GEAR DOESN'T EXIST");
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

/**** TODO unequip Enters the Equip/unquip screen for inventory / on Hero selection ****/
//    -(void)unequip {
////        Scanner s = new Scanner(System.in);
//
////        System.out.println();
////        System.out.println("\nSuit up");
////        System.out.println("Type in the name of the slot you wish to unequip.\nOr Type in the number of an inventory slot to equip.\n");
//
//        boolean mode = true;
//        while (mode) {
//
//            [self printBody]; // Show Equipment
//            [self revealInventory]; // Show Inventory
//
////           String selection = s.next();
//
//            if (selection.equals("Helmet")) {
//                if (getHelm().getArmor() != 0) {
//                    unequipHelm();
//                }
//            } else if (selection.equals("Torso")) {
//                if (getTorso().getArmor() != 0) {
//                    unequipTorso();
//                }
//            } else if (selection.equals("Shoulders")) {
//                if (getShoulders().getArmor() != 0) {
//                    unequipShoulders();
//                }
//            } else if (selection.equals("Gloves")) {
//                if (getGloves().getArmor() != 0) {
//                    unequipGloves();
//                }
//            } else if (selection.equals("Bracers")) {
//                if (getBracers().getArmor() != 0) {
//                    unequipBracers();
//                }
//            } else if (selection.equals("Legs")) {
//                if (getLegs().getArmor() != 0) {
//                    unequipLegs();
//                }
//            } else if (selection.equals("Boots")) {
//                if (getBoots().getArmor() != 0) {
//                    unequipBoots();
//                }
//            } else if (selection.equals("MH")) {
//                if (getMH().getAttack() != 0) {
//                    unequipMH();
//                }
//            } else if (selection.equals("OH")) {
//                if (getOH().getAttack() != 0) {
//                    unequipOH();
//                }
//            } else if (selection.equals("quit") || selection.equals("q")) {
//                break;
//            } else { // I am equiping from inventory
//                try {
//                    int invSelection = Integer.parseInt(selection);
//                    if (getInventory().get(invSelection) != nil) {
//                        if (getInventory().get(invSelection).getClass().equals(getHelm().getClass())) { // Armor
//                            Armor tmp = (Armor) getInventory().get(invSelection);
//                            String type = tmp.getType();
//                            // 1. get the type
//                            // 2. use the getMethod to see if the slot is full
//                            // 3. if it is, unequip, then equip the guy from the inventory
//                            // 3.5. if the slot is empty, just equip jawn
//                            if (type.equals("Helmet")) {
//                                if (getHelm().getArmor() != 0) { // SLOT IS FULL
//                                    unequipHelm(); // unequip
//                                }
//                                equipArmor(tmp); // Equip
//                            } else if (type.equals("Torso")) {
//                                if (getTorso().getArmor() != 0) {
//                                    unequipTorso();
//                                }
//                                equipArmor(tmp);
//                            } else if (type.equals("Shoulders")) {
//                                if (getShoulders().getArmor() != 0) {
//                                    unequipShoulders();
//                                }
//                                equipArmor(tmp);
//                            } else if (type.equals("Gloves")) {
//                                if (getGloves().getArmor() != 0) {
//                                    unequipGloves();
//                                }
//                                equipArmor(tmp);
//                            } else if (type.equals("Bracers")) {
//                                if (getBracers().getArmor() != 0) {
//                                    unequipBracers();
//                                }
//                                equipArmor(tmp);
//                            } else if (type.equals("Legs")) {
//                                if (getLegs().getArmor() != 0) {
//                                    unequipLegs();
//                                }
//                                equipArmor(tmp);
//                            } else if (type.equals("Boots")) {
//                                if (getBoots().getArmor() != 0) {
//                                    unequipBoots();
//                                }
//                                equipArmor(tmp);
//                            }
//                        } else if (getInventory().get(invSelection).getClass().equals(getMH().getClass())) { // Weapon
//                            Weapon tmp = (Weapon) getInventory().get(invSelection);
//                            String type = tmp.getType();
//                            if (type.equals("MH")) { // MH
//                                if (getMH().getAttack() != 0) {
//                                    unequipMH();
//                                }
//                                equipWeapon(tmp);
//                            } else { // OH
//                                if (getOH().getAttack() != 0) {
//                                    unequipOH();
//                                }
//                                equipWeapon(tmp);
//                            }
//                        } else { // ITEMS
//                            Item tmp = (Item) getInventory().get(invSelection);
//
//                            /* Add active Item Buff to Hero's ActiveItem Array and Activate Buff */
//                            if (tmp.getType().contains("stone")) { // Resistance stone
//                                increaseResistance(tmp.getElement(), tmp.getPotency());
//                            }
//
//                            /* Add to Active Item Buffs Array */
//                            getActiveItems().add(tmp);
//                            /* Remove from Inventory */
//                            removeFromInventory(tmp);
//
//                            if (getActiveItems().size() > 4) {
//                                /* CAN ONLY HAVE 4 BUFFS ACTIVE AT ONCE */
//                                /* remove Resistance stone, decrease resistance */
//                                System.out.println("Can Only Have 4 Active items...");
//                                System.out.println("Pick one to eliminate:");
//                                printActiveItems();
//                                while (true) {
//                                    try {
//                                        int elim = s.nextInt();
//                                        if (elim <= getActiveItems().size()) {
//                                            decreaseResistance(getActiveItems().get(elim-1).getElement(), getActiveItems().get(elim-1).getPotency());
//                                            getActiveItems().remove(elim-1);
//                                            break;
//                                        }
//                                    } catch (Exception e) {
//                                        String tmpStr = s.next();
//                                    }
//                                }
//                            }
//                        }
//                    }
//                } catch (Exception e) {
//                    System.out.println("Enter an Eqiupment OR a Inventory Number");
//                }
//            }
//        } // End while
//
//        resetVariables();
//    }

/** INENTORY **/
-(void)revealInventory {
    for (int i = 0; i < [self.inventory count]; i++) {
        if ([[self.inventory  objectAtIndex:i] isKindOfClass:[Armor class]]) { // Armor
            Armor *tmp = (Armor *) [self.inventory objectAtIndex:i];
            
        } else if ([[self.inventory  objectAtIndex:i] isKindOfClass:[Weapon class]]) { // Wep
            Weapon *tmp = (Weapon *) [self.inventory objectAtIndex:i];
            
        } else {
            Item *tmp = (Item *) [self.inventory objectAtIndex:i];
            
        }
    }
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
    [self.inventory removeObject:o];
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
    if (torso == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.torso;
    }
}

-(Armor*)getShoulders {
    if (shoulders == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.shoulders;
    }
}

-(Armor*)getHelm {
    if (helm == nil) {
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
    if (legs == nil) {
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
    if (bracers == nil) {
        return [[Armor alloc] initarmorID:0 armorName:@"" armorType:@""];
    } else {
        return self.bracers;
    }
}

/** Show Eqiupment/Weapons **/
//    public void printBody() {
//        System.out.println("-----------------------------EQUIPED-----------------------------");
//        if (getMH() != null) {
//            System.out.println("Main Hand: " + getMH().toString());
//        } else {
//            System.out.println("Main Hand: " );
//        }
//
//        if (getOH() != null) {
//            System.out.println("Off Hand: " + getOH().toString());
//        } else {
//            System.out.println("Off Hand: " );
//        }
//
//        if (getHelm() != null) {
//            System.out.println("Helmet: " + getHelm().toString());
//        } else {
//            System.out.println("Helmet: ");
//        }
//
//        if (getShoulders() != null) {
//            System.out.println("Shoulders: " + getShoulders().toString());
//        } else {
//            System.out.println("Shoulders: ");
//        }
//
//
//        if (getTorso() != null) {
//            System.out.println("Torso: " + getTorso().toString());
//        } else {
//            System.out.println("Torso: ");
//        }
//
//        if (getGloves() != null) {
//            System.out.println("Gloves: " + getGloves().toString());
//        } else {
//            System.out.println("Gloves: ");
//        }
//
//        if (getBracers() != null) {
//            System.out.println("Bracers: " + getBracers().toString());
//        } else {
//            System.out.println("Bracers: ");
//        }
//
//        if (getLegs() != null) {
//            System.out.println("Legs: " + getLegs().toString());
//        } else {
//            System.out.println("Legs: ");
//        }
//
//        if (getBoots() != null) {
//            System.out.println("Boots: " + getBoots().toString());
//        } else {
//            System.out.println("Boots: ");
//        }
//        System.out.println("-----------------------------------------------------------------\n");
//    }

/** Print Resistance Maps **/
//    public void printOffenseResMap() {
//        System.out.println("Elemental Damage Boost (%): ");
//        for (Element res : getResistanceOffenseMap().keySet()) {
//            System.out.print(res + ": " + getResistanceOffenseMap().get(res) + " ");
//        }
//        System.out.println("\n");
//    }
//    public void printDefenseResMap() {
//        System.out.println("Elemental Damage Reduction (%): ");
//        for (Element res : getResistanceOffenseMap().keySet()) {
//            System.out.print(res + ": " + getResistanceDefenseMap().get(res) + " ");
//        }
//        System.out.println();
//    }
@end