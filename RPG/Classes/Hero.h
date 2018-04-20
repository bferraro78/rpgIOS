//
//  Hero.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//


#define Hero_h
#import <UIKit/UIKit.h>
#import "Being.h"

#import "Armor.h"
#import "Weapon.h"
#import "Space.h"
#import "Item.h"
#import "Constants.h"

@interface Hero : Being


@property int classID;
@property int Exp;
@property int purse;

@property NSMutableDictionary *resistanceDefenseMap; //<Element, Integer>;
@property NSMutableDictionary *resistanceOffenseMap; //<Element, Integer>;


@property NSMutableArray *skillSet; // All Skills to Hero
@property NSMutableArray *inventory;
@property NSMutableArray *activeItems;

// Holds more permanant, pre/post combat enconters buffs/debuffs
// ex: major buff from a skill or potion, disease which effects some stat...
@property NSMutableDictionary *buffLibrary; //<String, Buff>;
@property NSMutableDictionary *debuffLibrary;

// Things that should not carry to or from a combat encounter (heals, dots etc)
@property NSMutableDictionary *combatBuffLibrary;
@property NSMutableDictionary *combatDebuffLibrary;

// Holds damage hero has taken during a combat phase
@property NSMutableDictionary *combatActionMap;

@property Weapon *mainHand;
@property Weapon *offHand;
@property Armor *helm;
@property Armor *shoulders;
@property Armor *bracers;
@property Armor *gloves;
@property Armor *torso;
@property Armor *legs;
@property Armor *boots;


/* Methods */
-(id)initNewCharacterName:(NSString *)aName vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext;

-(void)addSkillIfNotAlreadyKnown:(NSString*)ability; // add skill to skill array if not already available

-(NSString*)getClassName;

-(int)getPrimaryStat;
-(int)getCritical;
-(void)resetActiveItems;
-(void)resetCombatLibraries;
-(void)resetCombatHealth;
-(void)setHealth;
-(void)takeDamage:(int)healthReductionOrIncrease;

-(void)increaseStrn:(int)strn;
-(void)increaseInti:(int)inti;
-(void)increaseDext:(int)dext;
-(void)increaseVit:(int)vit;
-(void)increaseResistance:(NSString*)element  increaseBy:(int)resistance;

-(void)decreaseStrn:(int)strn;
-(void)decreaseInti:(int)inti;
-(void)decreaseDext:(int)dext;
-(void)decreaseVit:(int)vit;
-(void)decreaseResistance:(NSString*)element  decreaseBy:(int)resistance;

-(void)increaseLevel;
-(void)increaseExp:(int)xp;
-(int)getLevelExp;

-(void)setElementSpec;

-(void)loadSkills; 
-(int)getResource;
-(int)getCombatResource;
-(NSString*)getResourceName;
-(void)increaseResource:(int)resourceIncrease;
-(void)regenCombatResource:(int)resourceGain;
-(void)useCombatResource:(int)resourceUsed;
-(void)resetCombatResource;
-(void)setResource;
-(void)setMaxCombatResource;

-(void)resetResourceAndHealth;
-(void)resetCombatActionMap;

-(int)getTotalArmor;
-(float)getArmorRating;


-(Weapon*)getMH;
-(Weapon*)getOH;
-(Armor*)getTorso;
-(Armor*)getShoulders;
-(Armor*)getHelm;
-(Armor*)getBoots;
-(Armor*)getLegs;
-(Armor*)getGloves;
-(Armor*)getBracers;

-(NSMutableString*)printBody;
-(NSMutableString*)printStats;
/** Print Resistance Maps **/
-(NSMutableString*)printOffenseResMap;
-(NSMutableString*)printDefenseResMap;
/* Active Items */
-(NSMutableString*)printActiveItems;






@end/* Hero_h */
