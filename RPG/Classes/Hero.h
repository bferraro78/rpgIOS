//
//  Hero.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//


#define Hero_h
#import <UIKit/UIKit.h>
#import "Armor.h"
#import "Weapon.h"
#import "Space.h"
#import "Item.h"
#import "Constants.h"

@interface Hero : NSObject

@property NSString *name;
@property int classID;
@property int level;
@property int health; // HEALTH IS HEROES TOTAL HEALTH
@property int combatHealth; // COMBAT HEALTH IS USED TO DETERMINE HEALTH IN ONE INSTANCE OF COMBAT
@property int strn;
@property int inti;
@property int dext;
@property int vit;
@property int Exp;
@property int purse;
@property NSString *elementSpec;
@property NSMutableDictionary *resistanceDefenseMap; //<Element, Integer>;
@property NSMutableDictionary *resistanceOffenseMap; //<Element, Integer>;


@property NSMutableArray *skillSet; // All Skills to Hero
@property NSMutableArray *activeSkillSet; // The 4 active Skills Possible
@property NSMutableArray *inventory;
@property NSMutableArray *activeItems;

@property NSMutableDictionary *buffLibrary; //<String, Buff>;
@property NSMutableDictionary *debuffLibrary;
@property NSMutableArray *stepsTaken;


@property NSMutableArray *poisonPassiveDots;


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

-(NSMutableDictionary*)heroPartyMemberToDictionary;
-(id)loadPartyMemberHero:(NSDictionary*)partyHeroStats;

-(void)addSkillIfNotAlreadyKnown:(NSString*)ability; // add skill to skill array if not already available
-(void)setActiveSkills;

-(NSString*)getClassName;

-(int)getPrimaryStat;
-(int)getCritical;
-(void)resetActiveItems;
-(void)resetLibraries;
-(void)resetHealth;
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
