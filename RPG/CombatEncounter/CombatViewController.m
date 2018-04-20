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

-(void)viewWillAppear:(BOOL)animated {
    [self.tabBarController setTitle:@"Combat"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setEnemyPartyAndCombatOrder:)
                                                 name:@"loadCombatOrderAndEnemyPartyNotification"
                                               object:nil];
    
    self.navigationItem.hidesBackButton = YES; // set to NO at the end of battle
    
    
    // Scroll Views 
    _heroScrollView.bounces = false;
    _enemyScrollView.bounces = false;
    
    // Init turn number
    _turnNumber = 1;
    
    // Init combat text log
    _combatTextTmpString = [[NSAttributedString alloc] init];
    _fullCombatTextString = [[NSMutableAttributedString alloc] init];
    _CombatText.editable = false;
    
    
    Skill *skill;
    NSString *skillString;
    NSString *buttonTitle;
   
    /* Set Up Current Hero Move String - Holds Currently Tapped Hero's Skill Name */
    _heroMoveName = [[NSString alloc] init];
    
    /* ELEMENT SPECS helpers set */
    self.lightningSpecAdditionalTurn = false;
    
    /***
     
     COMBAT INIT PHASES
     
     If you are the party leader, your phone is in charge of determing
     1. EnemyParty Generation
     2. Combat order initiative
     3. Send both to others, recieved by setEnemyPartyAndCombatOrder: function
     4. Combat Buff/Debuff libaries, combat resource, Damage Element maps are RESET
     
     ***/
    
    [self generateEnemyPartyAndCombatOrder];
    
}


-(void)generateEnemyPartyAndCombatOrder {
    
    _combatQueue = [[CombatQueue alloc] init];
    
    /** Reset player BUFFS/DEBUFFS/Damage element maps **/
    [mainCharacter resetCombatLibraries]; // resets combat buff/debuff libraries
    [mainCharacter resetCombatResource]; // resets combat resource to full
    [mainCharacter resetCombatActionMap]; // stores all damage and buffs taken during a comabt turn
    
    Party *heroParty = [Party getPartyArray];
    
    if ([mainCharacter.name isEqualToString:[heroParty getPartyLeader].partyMember.name]) {
        
        // Generate EnemyParty
        [CombatManager generateEnemyParty:heroParty];
        
        // Set Combat order queue
        NSMutableArray *combatQueueArray= [CombatManager createCombatOrder:heroParty enemyParty:[EnemyParty getEnemyPartyArray]];
        _combatQueue = [[CombatQueue alloc] initWithCombatQueue:combatQueueArray];

        // Send to all peers
        [self sendEnemyPartyAndCombatOrder];
        
        [self initialCombatText];
    }
}

/* Send hero data / ready check over */
-(void)sendEnemyPartyAndCombatOrder {
    NSMutableDictionary *dictionaryToSend = [[EnemyParty getEnemyPartyArray] enemyPartyToDictionary];
    dictionaryToSend[@"combatOrder"] = [_combatQueue combatOrderToDictionary];
    dictionaryToSend[@"action"] = @"loadCombatOrderAndEnemyParty";
    [[SendDataMCManager getSender] sendDictionaryOfInfo:dictionaryToSend];
}
 
/* Sent from the party leaders phone - combat order/enemy party */
-(void)setEnemyPartyAndCombatOrder:(NSNotification*)notification {
    NSDictionary *enemyPartyAndCombatOrder = [[notification userInfo] objectForKey:@"receivedData"];
    
    // Set EnemyParty
    [[EnemyParty getEnemyPartyArray] loadPartyEnemiesFromDictionary:enemyPartyAndCombatOrder];
    
    // Set Combat Order Queue
    _combatQueue = [[CombatQueue alloc] initCombatQueue];
    [_combatQueue loadCombatOrderFromDictionary:enemyPartyAndCombatOrder];
    
    // Set start combat text
    [self initialCombatText];
}

-(void)initialCombatText {
    dispatch_async(dispatch_get_main_queue(), ^{
        // INITAL START FIGHT TEXT
        self->_combatTextTmpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"-----Combat!-----\n\n"]];
        [self.fullCombatTextString appendAttributedString:self->_combatTextTmpString];
        self.CombatText.attributedText = self->_combatTextTmpString;
        
        // Load ScrollView UIs
        [self setUpUIScrollViews];
        
        [self startCombatTurn];
    });
}

-(void)setUpUIScrollViews {
    
    Party *hp = [Party getPartyArray];
    EnemyParty *ep = [EnemyParty getEnemyPartyArray];

    CGFloat width = _heroScrollView.frame.size.width;
    
    int heroSumY = 5.0;
    int enemySumY = 5.0;
    
    for (int i = 0; i < [hp partyCount]; i++) {
        HeroPartyMember *pm = [hp partyMemberAtIndex:i];
        HeroPartyMemberView *HeroView = [[HeroPartyMemberView alloc] initWithFrame:CGRectMake(5.0, heroSumY, width-10.0, 50.0)];
        [HeroView setUpSubviews:(Hero*)pm.partyMember];
        
        
        
        [_heroScrollView addSubview:HeroView];
        
        heroSumY += 90.0;
    }

    enemySumY = 5.0;
    for (int i = 0; i < [ep enemyPartyCount]; i++) {
        EnemyPartyMember *em = [ep enemyPartyMemberAtIndex:i];
        EnemyPartyMemberView *EnemyView = [[EnemyPartyMemberView alloc] initWithFrame:CGRectMake(5.0, enemySumY, width-10.0, 50.0)];
        [EnemyView setUpSubviews:(Enemy*)em.partyMember];
        
        /* Enemy Stats and Buffs/Debuffs */
        UILongPressGestureRecognizer *enemyStatus = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(EnemyStatus:)];
        enemyStatus.minimumPressDuration = 0.3;
        [EnemyView addGestureRecognizer:enemyStatus];

        /* Enemy Stats and Buffs/Debuffs */
        UITapGestureRecognizer *selectEnemy = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self action:@selector(SelectEnemy:)];
        [EnemyView addGestureRecognizer:selectEnemy];
        
        
        
        [_enemyScrollView addSubview:EnemyView];
        
        enemySumY += 60.0;
    }
    
 
    // Set content size based on how mnay Hero/Enemy UI Views
    [_heroScrollView setContentSize:CGSizeMake(width, heroSumY)];
    [_enemyScrollView setContentSize:CGSizeMake(width, enemySumY)];
}


/***
 
 COMBAT TURN PHASES
 
 
 1. Pop person off the queue
 1b. Put that same name back on the end of the queue
 2. If it is an enemy, the party leader's phone carries out enemy turn
 3. Choose action and targets
 
 3b. The action is going to fill up a CombatActionMap (dictionary of damage type/buff/debuff/heal ==> value)
 
 4. Send the to targets only, or carry out action on target enemies
 5. User or enemy that recieved action takes action and SENDS SELF TO ALL PEERS
 6. Person who turn it is sends self TO ALL PEERS
 7. Send the end turn notification, which will call this function below --> startCombatTurn
 
 ***/

/* Init combat turn, allowing the player/enemy to take a turn */
-(void)startCombatTurn {
    
    // Pop off queue, add self to the end of the queue
    PartyMember *PartyMembersTurn = [_combatQueue dequeuePartyMember];
    [_combatQueue enqueuePartyMember:PartyMembersTurn];
    
    // Set Turn Color
    // TODO ^^
    
    // If Enemy, party leaders phone carrys out turn
    if ([NSStringFromClass([PartyMembersTurn class]) isEqualToString:ENEMYPARTYMEMBER]) {
        if ([mainCharacter.name isEqualToString:[[Party getPartyArray] getPartyLeader].partyMember.name]) {
            // Carry out enemy turn
            
        }
    } else {
        // If you are the person who was popped off turn, then it is your turn!
        
        // Reveal use item button
        // allow UI Views to be tappable --- property saying keeping track of whos turn it is?
        
        
    }

}

/*******************************************************************************************************************/



/* Ability move buttons. Check if there is available resources to cast move */
// TODO -- pick target by tapping view of hero or enemy, then determine if the move is valid...
//
//-(void)checkValidAttack:(NSString*) abilityName {
//    self.heroMoveName = [[NSString alloc] init];
//    self.heroMoveName = abilityName;
//    /* INIT COMBAT TURN */
//    [self initCombat];
//
//}
//
///* INIT COMBAT TURN */
//-(void)initCombat {
//
//    /* Load elemental maps */
//    if (!_lightningSpecAdditionalTurn) {
//        /* Load damages to 0 */
////        _heroElementMap[FIRE] = [NSNumber numberWithInt:0];
////        _heroElementMap[COLD] = [NSNumber numberWithInt:0];
////        _heroElementMap[ARCANE] = [NSNumber numberWithInt:0];
////        _heroElementMap[POISON] = [NSNumber numberWithInt:0];
////        _heroElementMap[LIGHTNING] = [NSNumber numberWithInt:0];
////        _heroElementMap[PHYSICAL] = [NSNumber numberWithInt:0];
////
////        _enemyElementMap[FIRE] = [NSNumber numberWithInt:0];
////        _enemyElementMap[COLD] = [NSNumber numberWithInt:0];
////        _enemyElementMap[ARCANE] = [NSNumber numberWithInt:0];
////        _enemyElementMap[POISON] = [NSNumber numberWithInt:0];
////        _enemyElementMap[LIGHTNING] = [NSNumber numberWithInt:0];
////        _enemyElementMap[PHYSICAL] = [NSNumber numberWithInt:0];
//    } else {
//        _lightningSpecAdditionalTurn = false;
//    }
//
//    /*** Damage Gathering Stage -- Contains all abilities that deal damage ***/
//
//    /* Generate Damage will load hero and enemey
//     1. Resource Check, vaid move checked
//     2. elementMaps - hold the damage for that turn for each element and physical damage.
//     3. Buffs libraries will be loaded.
//     4. Combat Resource is used
//
//     */
//
//    /* Set up Enemy Move */
//    NSString *enemyMoveName = [self.e selectAttack]; // generates random attack from a specific enemy's skill set array
////    BOOL validAbilityCast = [SkillDictionary generateDamage:self.e heroMoveName:self.heroMoveName enemyMoveName:enemyMoveName heroElementMap:_heroElementMap enemeyElementMap:_enemyElementMap];
//
//    if (true) { // validAbilityCast
//
//        // DEBUGGGINNNNN
//        printf("ENEMY HEALTH %u\n", self.e.enemyHealth);
//        printf("HERO HEALTH %u\n", mainCharacter.health);
//
//        // Lightning Spec, get another turn -- TODO -- determine a chance for this to happen
//        // Don't let the chance of another turn happen every time? maybe decrease by half every time
//        if ([mainCharacter.elementSpec isEqualToString:LIGHTNING]) {
//            _lightningSpecAdditionalTurn = true;
//            // TODO -- UPDATE UI telling users, this guy is taking another turn
//        } else {
//            // Print attacks to UI
//            [self updateUIWithAttacks:enemyMoveName];
//
//            /** Manage Buff/Debuff/Armor/Resistances Stage **/
////            [self manageBuffDebuffStage:mainCharacter heroElementMap:_heroElementMap enemyElementMap:_enemyElementMap];
//
//            /** Damage Reduction Stage/ Take Damage Stage -- Contains all abilities that reduce damage **/
////            [self reductionStage:mainCharacter heroElementMap:_heroElementMap enemyElementMap:_enemyElementMap];
//
//            /** Reduce Buff Stage **/
//            [self reduceBuffStage];
//
//            /** Death Check Stage **/
//            [self deathStage];
//
//
//        }
//    } else {
//        [self updateUIWithInvalidMove];
//    }
//}
//
//-(void)updateUIWithInvalidMove {
//    NSMutableString *invalidMoveString = [[NSMutableString alloc] initWithFormat:@"Not enough %s\n", [[mainCharacter getResourceName] UTF8String]];
//    _combatTextTmpString = [[NSAttributedString alloc] initWithString:invalidMoveString];
//    [self.combatSetText appendAttributedString:_combatTextTmpString];
//    self.CombatText.attributedText = self.combatSetText;
//}
//
//-(void)updateUIWithAttacks:(NSString*)enemyMoveName {
//    NSMutableString *attackString = [[NSMutableString alloc] initWithFormat:@"Hero Attack: %s\nEnemy Attack: %s\n", [self.heroMoveName UTF8String], [enemyMoveName UTF8String]];
//    _combatTextTmpString = [[NSAttributedString alloc] initWithString:attackString];
//    [self.combatSetText appendAttributedString:_combatTextTmpString];
//    self.CombatText.attributedText = self.combatSetText;
//}
//
//-(void)manageBuffDebuffStage:mainCharacter heroElementMap:(NSMutableDictionary*)heroElementMap
//             enemyElementMap:(NSMutableDictionary*)enemyElementMap {
//
//    /** Apply damage/buffs/debuffs for both hero and enemy **/
//    [self heroManageBuffs:heroElementMap Enemy:(Enemy*)self.e];
//    [self enemyManageBuffs:self.e ElementMap:enemyElementMap];
//
//    // DEBUG
//    printf("\nHero after manageBUFF DAMGE\n");
//    for (NSString* dam in heroElementMap) {
//        NSInteger value = [[heroElementMap objectForKey:dam] integerValue];
//        printf("%s ", [dam UTF8String]);
//        printf("%ld\n", (long)value);
//    }
//
//    printf("\nEnemy after manageBUFF DAMGE\n");
//    for (NSString* dam in heroElementMap) {
//        NSInteger value = [[enemyElementMap objectForKey:dam] integerValue];
//        printf("%s ", [dam UTF8String]);
//        printf("%ld\n", (long)value);
//    }
//
//}
//
///*** Apply damage/buffs/debuffs/armor/resistances ***/
///** HERO DAMAGE/BUFFS **/
//-(void)heroManageBuffs:(NSMutableDictionary*)elementMap Enemy:(Enemy*)e {
//
//    int fireDamage = [elementMap[FIRE] intValue];
//    int lightningDamage = [elementMap[LIGHTNING] intValue];
//    int coldDamage = [elementMap[COLD] intValue];
//    int poisonDamage = [elementMap[POISON] intValue];
//    int arcaneDamage = [elementMap[ARCANE] intValue];
//    int physicalDamage = [elementMap[PHYSICAL] intValue];
//
//    /* Take into account extra crit Chance */
//    Buff *critExtraChance = (Buff*)mainCharacter.combatBuffLibrary[EXTRACRITICALCHANCE];
//    int critExtra;
//    if (critExtraChance != nil) {
//        critExtra = critExtraChance.value;
//        [mainCharacter.combatBuffLibrary removeObjectForKey:EXTRACRITICALCHANCE]; // Remove
//    } else {
//        critExtra = 100;
//    }
//
//    /* Check if hit is CRIT */
//    self.critHit = false;
//    [self critChance:critExtra];
//    printf("\n\nVALUE IS : %d\n\n", self.critHit);
//
//
//    // TODO -- Multicombat , put the poisonDotArray on the enmy so they know to take the poison damage every turn
//
//
//    /** Elemental Spec - POISON POISON DOT PASSIVE **/
//    if ([mainCharacter.elementSpec isEqualToString:POISON]) {
//        /** DOT IS 25% of what the damage is over two turns **/
//
//        //        /* Handle Damage from Buff Library */
//        //        for(NSString* currentKey in mainCharacter.buffLibrary) {
//        //            Buff* b = (Buff*)[e.enemyDebuffLibrary objectForKey:currentKey];
//        //            int poisonDotDamage = (float)b.value*0.25;
//        //            printf("%i", poisonDotDamage);
//        //            if (poisonDotDamage > 0 && [currentKey rangeOfString:@"Dot"].location != NSNotFound) {
//        //                // Then this is a damage that is not a DOT and Not already A Poison Passive Dot
//        //                [mainCharacter.poisonPassiveDots addObject:[[Buff alloc] initvalue:poisonDotDamage duration:2]];
//        //            }
//        //        }
//
//        /** Turn Damage from elements/physical into a dot **/
////        int damageFromTurn =  fireDamage + lightningDamage + coldDamage + poisonDamage + arcaneDamage + physicalDamage;
////        if (damageFromTurn > 0) {
////            int tmp = (float)damageFromTurn*0.25;
////            [mainCharacter.poisonPassiveDots addObject:[[Buff alloc] initvalue:tmp duration:2]];
////        }
////
////        /* Carry Out Damage from Poison Passive Dots */
////        for (int i = 0; i < [mainCharacter.poisonPassiveDots count]; i++) {
////            Buff *passiveDot = [mainCharacter.poisonPassiveDots objectAtIndex:i];
////            printf("%s", [[BuffDictionary getDescription:@"poisonPassiveDot"] UTF8String]);
////            printf("%u", (int)passiveDot.value);
////            poisonDamage += passiveDot.value;
////        }
//    }
//
//    /** HANDLE BUFFS / DEBUFFS **/
//    // Rend Dot
//    Buff *rendDot = (Buff*)e.enemyDebuffLibrary[RENDDOT];
//    if (rendDot != nil) {
//        int rendDamage = rendDot.value;
//
//        /* Deal Rend DOT Damage */
//        if ([mainCharacter.getMH.weaponElement isEqualToString:FIRE]) {
//            fireDamage += rendDamage;
//        } else if ([mainCharacter.getMH.weaponElement isEqualToString:COLD]) {
//            coldDamage += rendDamage;
//        } else if ([mainCharacter.getMH.weaponElement isEqualToString:ARCANE]) {
//            arcaneDamage += rendDamage;
//        } else if ([mainCharacter.getMH.weaponElement isEqualToString:POISON]) {
//            poisonDamage += rendDamage;
//        } else if ([mainCharacter.getMH.weaponElement isEqualToString:LIGHTNING]) {
//            lightningDamage += rendDamage;
//        } else { // NO ELEMENT
//            physicalDamage += rendDamage;
//        }
//
//    }
//
//    // Fireball Dot
//    Buff *fireDot = (Buff*)e.enemyDebuffLibrary[FIREDOT];
//    if (fireDot != nil) {
//        int fireDotDamage = fireDot.value;
//        /* Take FIREDOT Damage */
//        fireDamage += fireDotDamage;
//    }
//
//    // Heal Dot
//    Buff *healDot = (Buff*)mainCharacter.combatBuffLibrary[HEALDOT];
//    if (healDot != nil) {
//        int healDamage = healDot.value;
//        /* Heal Player*/
//        if (self.critHit) {
//            [mainCharacter takeDamage:(healDamage*2)];
//        } else {
//            [mainCharacter takeDamage:healDamage];
//        }
//    }
//
//    /* Resistance damage bonus, this this from resistanceOffenseMap. Use those elemental numbers to increase that elements damage by percentage */
//    fireDamage = (fireDamage+(int)(([mainCharacter.resistanceOffenseMap[FIRE] floatValue]/(float)100.00)*(float)fireDamage));
//    lightningDamage = (lightningDamage+(int)(([mainCharacter.resistanceOffenseMap[LIGHTNING] floatValue]/(float)100.00)*(float)lightningDamage));
//    coldDamage = (coldDamage+(int)(([mainCharacter.resistanceOffenseMap[COLD] floatValue]/(float)100.00)*(float)coldDamage));
//    poisonDamage = (poisonDamage+(int)(([mainCharacter.resistanceOffenseMap[POISON] floatValue]/(float)100.00)*(float)poisonDamage));
//    arcaneDamage = (arcaneDamage+(int)(([mainCharacter.resistanceOffenseMap[ARCANE] floatValue]/(float)100.00)*(float)arcaneDamage));
//
//    /* Applys crits */
//    printf("\n\nCrit Chance: %d\n\n", self.critHit);
//    if (self.critHit) {
//        fireDamage = fireDamage*2;
//        lightningDamage = lightningDamage*2;
//        coldDamage = coldDamage*2;
//        poisonDamage = poisonDamage*2;
//        arcaneDamage = arcaneDamage*2;
//        physicalDamage = physicalDamage*2;
//    }
//
//    /* Put elemental damage into hashmap */
//    elementMap[FIRE] = [NSNumber numberWithInt: fireDamage];
//    elementMap[LIGHTNING] = [NSNumber numberWithInt:lightningDamage];
//    elementMap[COLD] = [NSNumber numberWithInt:coldDamage];
//    elementMap[POISON] = [NSNumber numberWithInt:poisonDamage];
//    elementMap[ARCANE] =[NSNumber numberWithInt: arcaneDamage];
//    elementMap[PHYSICAL] = [NSNumber numberWithInt:physicalDamage];
//
//    /** Resource Regain **/
//    [self regainResources];
//
//}
//
//-(void)regainResources {
//    /* INCREASE RESOURCES ONLY IF IT IS BELOW THEIR MAX RESOURCE */
//    int regen = 0;
//
//    if ([[mainCharacter getResourceName] isEqualToString:MANA]) {
//        regen = mainCharacter.inti/3;
//    } else if ([[mainCharacter getResourceName] isEqualToString:ENERGY]) {
//        regen = 15;
//    }
//
//    if (([mainCharacter getCombatResource]+regen)  <= [mainCharacter getResource]) {
//        [mainCharacter regenCombatResource:regen];
//    } else {
//        /* Set Resource to Max */
//        [mainCharacter resetCombatResource];
//    }
//
//}
//
///*** Apply damage/buffs/debuffs/armor/resistances ***/
///** enemy DAMAGE/BUFFS **/
//-(void)enemyManageBuffs:(Enemy*)e ElementMap:(NSMutableDictionary*)elementMap {
//
//    int fireDamage = [elementMap[FIRE] intValue];
//    int lightningDamage = [elementMap[LIGHTNING] intValue];
//    int coldDamage = [elementMap[COLD] intValue];
//    int poisonDamage = [elementMap[POISON] intValue];
//    int arcaneDamage = [elementMap[ARCANE] intValue];
//    int physicalDamage = [elementMap[PHYSICAL] intValue];
//
//    /** HANDLE LINGERING SPELLS/ABILITIES **/
//    // Rend Dot
//    Buff *rendDot = (Buff*)mainCharacter.combatDebuffLibrary[RENDDOT];
//    if (rendDot != nil) {
//        int rendDamage = rendDot.value;
//
//        if ([e.enemyElement  isEqualToString:FIRE]) {
//            fireDamage += rendDamage;
//        } else if ([e.enemyElement  isEqualToString:COLD]) {
//            coldDamage += rendDamage;
//        } else if ([e.enemyElement  isEqualToString:ARCANE]) {
//            arcaneDamage += rendDamage;
//        } else if ([e.enemyElement  isEqualToString:POISON]) {
//            poisonDamage += rendDamage;
//        } else if ([e.enemyElement  isEqualToString:LIGHTNING]) {
//            lightningDamage += rendDamage;
//        } else { // NO ELEMENT
//            physicalDamage += rendDamage;
//        }
//    }
//
//    // Fireball Dot
//    Buff *fireDot = (Buff*)mainCharacter.combatDebuffLibrary[FIREDOT];
//    if (fireDot != nil) {
//        int fireDotDamage = fireDot.value;
//        /* Take FIREDOT Damage */
//        fireDamage += fireDotDamage;
//    }
//
//    // Heal Dot
//    Buff *healDot = (Buff*)e.enemyBuffLibrary[HEALDOT];
//    if (healDot != nil) {
//        int healDamage = healDot.value;
//        /* Heal Enemy */
//        [e takeDamage:healDamage];
//    }
//
//    /* Put elemental damage into hashmap */
//    elementMap[FIRE] = [NSNumber numberWithInt:fireDamage];
//    elementMap[LIGHTNING] = [NSNumber numberWithInt:lightningDamage];
//    elementMap[COLD] = [NSNumber numberWithInt:coldDamage];
//    elementMap[POISON] = [NSNumber numberWithInt:poisonDamage];
//    elementMap[ARCANE] =[NSNumber numberWithInt: arcaneDamage];
//    elementMap[PHYSICAL] = [NSNumber numberWithInt:physicalDamage];
//}
//
///** Determine Damage Reduction **/
//-(void)reductionStage:(Hero*)mainCharacter heroElementMap:(NSMutableDictionary*)heroElementMap
//      enemyElementMap:(NSMutableDictionary*)enemyElementMap {
//    /* Quickly total hero/enemy damage for certain buffs in reduction stage  (Like Vanish) */
//    int heroDamage = 0;
//    for (NSString* dam in heroElementMap) {
//        int value = [[heroElementMap objectForKey:dam] intValue];
//        heroDamage += (int)value;
//    }
//
//    int enemyDamage = 0;
//    for (NSString* dam in enemyElementMap) {
//        int value = [[enemyElementMap objectForKey:dam] intValue];
//        enemyDamage += (int)value;
//    }
//
//    printf("Hero Dam before reduction %u\n", heroDamage);
//    printf("Enemy Dam before reduction %u\n", enemyDamage);
//
//    /** This will reduce damage based on armor/resistances, then return a total damage **/
//    /* Hero */
//    int totalHeroDamageTaken = [self heroDamageReduction:enemyElementMap HeroDamage:heroDamage Enemy:self.e];
//
//    /* Enemy */
//    int totalEnemyDamageTaken =[self enemyDamageReduction:self.e HeroDamageMap:heroElementMap EnemyDamage:enemyDamage];
//
//
//    /** Damage Reduction Stage -- Contains all abilities that reduce damage **/
//    [self damageStage:mainCharacter totalHeroDamageTaken:totalHeroDamageTaken totalEnemyDamageTaken:totalEnemyDamageTaken];
//
//
//}
//
//-(int)heroDamageReduction:(NSMutableDictionary*)enemyDamageMap
//               HeroDamage:(int) heroDamage Enemy:(Enemy *)e {
//
//    int fireDamage = [enemyDamageMap[FIRE] intValue];
//    int lightningDamage = [enemyDamageMap[LIGHTNING] intValue];
//    int coldDamage = [enemyDamageMap[COLD] intValue];
//    int poisonDamage = [enemyDamageMap[POISON] intValue];
//    int arcaneDamage = [enemyDamageMap[ARCANE] intValue];
//    int physicalDamage = [enemyDamageMap[PHYSICAL] intValue];
//
//    printf("\n\nDAMAGES IN HERO DAM REDUCTiON\n");
//    printf("Fire: %u\n", fireDamage);
//    printf("%u\n", lightningDamage);
//    printf("%u\n", coldDamage);
//    printf("%u\n", poisonDamage);
//    printf("%u\n", arcaneDamage);
//    printf("%u\n", physicalDamage);
//
//
//    /* Armor Reduction */
//    float floatFinalDamage = (float)physicalDamage * (float)([mainCharacter getArmorRating]/100.0);
//    int intFinalDamageReduce = (int)(physicalDamage - floatFinalDamage);
//
//    /* Resistance damage reduction, this this from resistanceDefenseMap. Use those elemental numbers to decrease that elements damage by percentage */
//
//    fireDamage = (fireDamage-(int)(([mainCharacter.resistanceDefenseMap[FIRE] floatValue]/(float)100.00)*(float)fireDamage));
//    lightningDamage = (lightningDamage-(int)(([mainCharacter.resistanceDefenseMap[LIGHTNING] floatValue]/(float)100.00)*(float)lightningDamage));
//    coldDamage = (coldDamage-(int)(([mainCharacter.resistanceDefenseMap[COLD] floatValue]/(float)100.00)*(float)coldDamage));
//    poisonDamage = (poisonDamage-(int)(([mainCharacter.resistanceDefenseMap[POISON] floatValue]/(float)100.00)*(float)poisonDamage));
//    arcaneDamage = (arcaneDamage-(int)(([mainCharacter.resistanceDefenseMap[ARCANE] floatValue]/(float)100.00)*(float)arcaneDamage));
//
//
//    printf("\n%i\n", fireDamage);
//    printf("%i\n", lightningDamage);
//    printf("%i\n", coldDamage);
//    printf("%i\n", poisonDamage);
//    printf("%i\n", arcaneDamage);
//    printf("%i\n\n", physicalDamage);
//
//    /* Total damage reduction */
//    intFinalDamageReduce += (fireDamage + lightningDamage + coldDamage + poisonDamage + arcaneDamage);
//
//    /* Freeze Cone Reduction, enemy is frozen */
//    Buff *frozen = (Buff*)e.enemyDebuffLibrary[FROZEN];
//    if (frozen != nil) {
//        intFinalDamageReduce -= (int)((float)intFinalDamageReduce*(float).25);
//    }
//
//    // Vanish Buff, take no damage for 2 turns
//    Buff *vanish = (Buff*)mainCharacter.combatBuffLibrary[VANISH];
//    if (vanish != nil) {
//        /* Remove b/c hero did damage */
//        if (heroDamage != 0) {
//            [e.enemyBuffLibrary removeObjectForKey:VANISH];
//        } else {
//            // HERO TAKES NO DAMAGE
//            intFinalDamageReduce = 0;
//        }
//
//    }
//
//    if (intFinalDamageReduce < 0) {
//        intFinalDamageReduce = 0;
//    }
//
//    return intFinalDamageReduce;
//}
//
//
//-(int)enemyDamageReduction:(Enemy*)e HeroDamageMap:(NSMutableDictionary*)heroDamageMap EnemyDamage:(int)enemyDamage {
//
//    int fireDamage = [heroDamageMap[FIRE] intValue];
//    int lightningDamage = [heroDamageMap[LIGHTNING] intValue];
//    int coldDamage = [heroDamageMap[COLD] intValue];
//    int poisonDamage = [heroDamageMap[POISON] intValue];
//    int arcaneDamage = [heroDamageMap[ARCANE] intValue];
//    int physicalDamage = [heroDamageMap[PHYSICAL] intValue];
//
//
//    /* Armor Reduction */
//    float floatFinalDamage = (float)physicalDamage * (float)([e getArmorRating]/100.0);
//    int intFinalDamageReduce = (int)(physicalDamage - floatFinalDamage);
//
//    /* Total damage reduction */
//    intFinalDamageReduce += (fireDamage + lightningDamage + coldDamage + poisonDamage + arcaneDamage);
//
//    /* Freeze Cone Reduction */
//    Buff *frozen = (Buff*)mainCharacter.combatDebuffLibrary[FROZEN];
//    if (frozen != nil) {
//        intFinalDamageReduce -= (int)((float)intFinalDamageReduce*(float).25);
//    }
//
//    // Vanish Buff, take no damage for 2 turns
//    Buff *vanish = (Buff*)e.enemyBuffLibrary[VANISH];
//    if (vanish != nil) {
//        /* Remove if enemy did damage */
//        if (enemyDamage != 0) {
//            [e.enemyBuffLibrary removeObjectForKey:VANISH];
//        } else {
//            // Enemy TAKES NO DAMAGE
//            intFinalDamageReduce = 0;
//        }
//    }
//
//    if (intFinalDamageReduce < 0) {
//        intFinalDamageReduce = 0;
//    }
//
//    return intFinalDamageReduce;
//}
//
///** Damage Stage **/
//-(void)damageStage:(Hero*)mainCharacter totalHeroDamageTaken:(int)totalHeroDamageTaken totalEnemyDamageTaken:(int)totalEnemyDamageTaken {
//    /* Enemy takes damage */
//    printf("Damage Done: %i\n", totalEnemyDamageTaken);
//    [self.e takeDamage:totalEnemyDamageTaken];
//
//    /* Hero takes damage */
//    printf("Damage Taken: %i\n", totalHeroDamageTaken);
//    [mainCharacter takeDamage:totalHeroDamageTaken];
//
//    /* Print Damage to UI */
//    [self updateUIWithDamage:totalHeroDamageTaken totalEnemyDamageTaken:totalEnemyDamageTaken];
//}
//
//
//-(void)updateUIWithDamage:(int)totalHeroDamageTaken totalEnemyDamageTaken:(int)totalEnemyDamageTaken {
//    // PRINT DAMAGE
//    NSMutableString *damageString = [[NSMutableString alloc] initWithFormat:@"Damage Done: %i\nDamage Taken: %i\n", totalEnemyDamageTaken, totalHeroDamageTaken];
//    _combatTextTmpString = [[NSAttributedString alloc] initWithString:damageString];
//    [self.combatSetText appendAttributedString:_combatTextTmpString];
//    self.CombatText.attributedText = self.combatSetText;
//}
//
//
///** Reduce Buff Stage **/
//-(void)reduceBuffStage {
//
//    /** Reduce Durations && Remove Buffs/Debuffs from libraries **/
//
//    NSMutableString *HeroBuffs = [[NSMutableString alloc] init];
//    NSMutableString *EnemyBuffs = [[NSMutableString alloc] init];
//
//    /* Hero */
//    for(NSString* currentKey in mainCharacter.combatBuffLibrary) {
//        Buff *heroBuff = [mainCharacter.combatBuffLibrary objectForKey:currentKey];
//
//        printf("Hero BUFF duration: %i", heroBuff.duration);
//        [HeroBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:currentKey], heroBuff.value];
//
//        [heroBuff decreaseDuration];
//        if (heroBuff.duration == 0) {
//            [mainCharacter.combatBuffLibrary removeObjectForKey:currentKey];
//        }
//    }
//
//    for(NSString* currentKey in mainCharacter.combatDebuffLibrary) {
//        Buff *heroDebuff = [mainCharacter.combatDebuffLibrary objectForKey:currentKey];
//
//        [HeroBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:currentKey], heroDebuff.value];
//
//        [heroDebuff decreaseDuration];
//        if (heroDebuff.duration == 0) {
//            [mainCharacter.combatDebuffLibrary removeObjectForKey:currentKey];
//        }
//    }
//
//    /* Enemy */
//    for(NSString* currentKey in self.e.enemyBuffLibrary) {
//        Buff *enemyBuff = [self.e.enemyBuffLibrary objectForKey:currentKey];
//
//        [EnemyBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:currentKey], enemyBuff.value];
//
//        [enemyBuff decreaseDuration];
//        if (enemyBuff.duration == 0) {
//            [self.e.enemyBuffLibrary removeObjectForKey:currentKey];
//        }
//    }
//
//    for(NSString* currentKey in self.e.enemyDebuffLibrary) {
//        Buff *enemyDebuff = [self.e.enemyDebuffLibrary objectForKey:currentKey];
//
//        [EnemyBuffs appendFormat:@"%@ - %i\n", [BuffDictionary getName:currentKey], enemyDebuff.value];
//
//        [enemyDebuff decreaseDuration];
//        if (enemyDebuff.duration == 0) {
//            [self.e.enemyDebuffLibrary removeObjectForKey:currentKey];
//        }
//
//    }
//
////    /* POISION SPEC BUFF HANDLE */
////    for (int i = 0; i < [mainCharacter.poisonPassiveDots count]; i++) {
////        Buff *passiveDot = [mainCharacter.poisonPassiveDots objectAtIndex:i];
////        [passiveDot decreaseDuration];
////        if (passiveDot. duration == 0) {
////            [mainCharacter.poisonPassiveDots removeObjectAtIndex:i];
////        }
////    }
//
//    // Set UI Text
//    // TODO - this will now be handled in the movie view
//}
//
//
///** Death Stage **/
//-(void)deathStage {
//    BOOL death =  false;
//    if (self.e.enemyCombatHealth <= 0) {
//        printf("Enemy Has Died!!!");
//
//        /* Defeated */
//        _combatTextTmpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%s defeated!\n", [_e.enemyName UTF8String]]];
//        [self.combatSetText appendAttributedString:_combatTextTmpString];
//
//        /* Print EXP Gain*/
//        int expGain = [self.e getExp];
//        _combatTextTmpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\nXp: %i\n", expGain]];
//        [self.combatSetText appendAttributedString:_combatTextTmpString];
//
//        /* Generate / Print loot */
//        _combatTextTmpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n------- Loot dropped:"]];
//        [self.combatSetText appendAttributedString:_combatTextTmpString];
//        NSMutableArray *loot = [LootManager generateLoot];
//
//        for (int i = 0; i < [loot count]; i++) {
//            _combatTextTmpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", [[loot objectAtIndex:i] toString]]];
//            [self.combatSetText appendAttributedString:_combatTextTmpString];
//        }
//
//        /* Improve Hero */
//        [InventoryManager receiveLoot:loot]; // recieve loot, add to inventory
//        [mainCharacter increaseExp:expGain]; // INCRESE HERO EXP
//        [InventoryManager changePurse:[self.e goldDrop]]; // increase gold amount
//
//        self.CombatText.attributedText = self.combatSetText; // set combat text view
//
//        death = true;
//        [[self navigationController] setNavigationBarHidden:NO animated:YES];
//
//    } else if (mainCharacter.combatHealth <= 0)  {
//        /* Hero dies, reset active Items */
//
//        printf("Hero Has Died :(");
//
//        /* Hero death text */
//        _combatTextTmpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%s has died\n", [mainCharacter.name UTF8String]]];
//        [self.combatSetText appendAttributedString:_combatTextTmpString];
//        self.CombatText.attributedText = self.combatSetText;
//
//        /* Carry out hero death */
//        [mainCharacter resetActiveItems];
//
//        death = true;
//        [[self navigationController] setNavigationBarHidden:NO animated:YES];
//
//    }
//
//    /* AUTO ROLL DOWN */
//    NSRange range = NSMakeRange(self.CombatText.text.length - 1, 1);
//    [self.CombatText scrollRangeToVisible:range];
//
//    /* Reset Health / Resource Bar */
//
//
//    printf("\nHealths: %i --- %i\n", mainCharacter.combatHealth, _e.enemyCombatHealth);
//
//
//    // PRINTING -- NEW TURN --
//    if (!death) {
//        _turnNumber++;
//        _combatTextTmpString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n\n---Turn %i---\n", _turnNumber]];
//        [self.combatSetText appendAttributedString:_combatTextTmpString];
//        self.CombatText.attributedText = self.combatSetText;
//    }
//
//}


/** Crit Chance **/
-(void)critChance:(int)extraChance {
    int critChance = arc4random_uniform(100);
    if (critChance < ([mainCharacter getCritical]+extraChance)) {
        self.critHit = true;
    }
}


/** GESTURES **/
-(void)SelectEnemy:(id)sender {
    EnemyPartyMemberView *pv = (EnemyPartyMemberView*) [sender view];
    
    if (pv.backgroundColor == [UIColor lightGrayColor]) {
        [pv setBackgroundColor:[UIColor whiteColor]];
    } else {
        [pv setBackgroundColor:[UIColor lightGrayColor]];
    }
    
}

-(void)EnemyStatus:(UILongPressGestureRecognizer *)gestureRecognizer {

    EnemyPartyMemberView *pv = (EnemyPartyMemberView*) [gestureRecognizer view];
    Enemy *e = pv.Enemy;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.view];

        self.moveView = [[UITextView alloc] initWithFrame:CGRectMake(point.x-200, point.y, 150, 175)];
        self.moveView.tintColor = [UIColor blackColor];
        self.moveView.tag = 123;
        self.moveView.text = e.printStats; // TODO - change this to buffs and debuffs
        self.moveView.layer.borderWidth = 2.0f;
        self.moveView.layer.borderColor = [[UIColor redColor] CGColor];
        [self.view addSubview:self.moveView];
    }

    if (gestureRecognizer.state == 2) {
        [[self.view viewWithTag:123]removeFromSuperview];

        CGPoint newPoint = [gestureRecognizer locationInView:self.view];
        self.moveView = [[UITextView alloc] initWithFrame:CGRectMake(newPoint.x-200, newPoint.y, 150, 175)];
        self.moveView.tintColor = [UIColor blackColor];
        self.moveView.tag = 123;
        self.moveView.text = e.printStats;
        self.moveView.layer.borderWidth = 2.0f;
        self.moveView.layer.borderColor = [[UIColor redColor] CGColor];
        [self.view addSubview:self.moveView];

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
