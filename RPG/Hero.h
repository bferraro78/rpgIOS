//
//  Hero.h
//  RPG
//
//  Created by Ben Ferraro on 5/14/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//


#define Hero_h
#import "Armor.h"
#import "Weapon.h"
#import "Space.h"
#import "Item.h"
@interface Hero : NSObject

@property int MOVELISTMAX;// static?
@property int INVENTORYMAX; // static?

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

@property NSMutableArray *skillSet;
@property NSMutableArray *inventory;
@property NSMutableArray *activeItems;

@property NSMutableDictionary *buffLibrary; //<String, Buff>;
@property NSMutableArray *stepsTaken;


@property NSMutableArray *poisonPassiveDots;

@property NSMutableDictionary *resistanceDefenseMap; //<Element, Integer>;
@property NSMutableDictionary *resistanceOffenseMap; //<Element, Integer>;


@property Weapon *mainHand;
@property Weapon *offHand;
@property Armor *helm;
@property Armor *shoulders;
@property Armor *bracers;
@property Armor *gloves;
@property Armor *torso;
@property Armor *legs;
@property Armor *boots;

@property int dungeonLvl;
@property int startX;
@property int startY;


/* Methods */
-(id)initname:(NSString *)aName classID:(int)aClassID vit:(int)aVit strn:(int)aStrn inti:(int)aInti dext:(int)aDext startX:(int)aStartX startY:(int)aStartY dungeonLvl:(int)aDungeonLvl;

-(void)increaseDungeonLevel;
-(void)addStepSpace:(Space*)s;
-(BOOL)containsSpace:(Space*)s;

-(void)addSkill:(NSString*)ability;

-(NSString*)getClassName;

-(void)changePurse:(int)gold;

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

-(void)equipArmor:(Armor*)a;
-(void)equipWeapon:(Weapon*)w;
-(BOOL)canUseWeapon:(Weapon*)w;

-(void)unequipHelm;
-(void)unequipShoulders;
-(void)unequipBracers;
-(void)unequipGloves;
-(void)unequipTorso;
-(void)unequipLegs;
-(void)unequipBoots;
-(void)unequipMH;
-(void)unequipOH;

-(void)revealInventory;
-(void)addToInventory:(id)o;
-(void)removeFromInventory:(id)o;
-(void)receiveLoot:(NSMutableArray*)loot;
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

-(void)resetVariables;

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








@end/* Hero_h */
