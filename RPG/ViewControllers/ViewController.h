//
//  ViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/13/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MainCharacter.h"
#import "Dungeon.h"
#import "Space.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *printHero;
@property (strong, nonatomic) IBOutlet UITextView *MainTextField;
@property (strong, nonatomic) IBOutlet UITextView *MapTextField;
@property (strong, nonatomic) IBOutlet UIButton *HeroStats;
@property (strong, nonatomic) IBOutlet UIView *up;
@property (strong, nonatomic) IBOutlet UIView *down;
@property (strong, nonatomic) IBOutlet UIView *left;
@property (strong, nonatomic) IBOutlet UIView *right;
@property (strong, nonatomic) IBOutlet UIButton *inventory;
@property (strong, nonatomic) IBOutlet UIButton *SkillButton;

@property NSMutableString *mainText;

@property Dungeon *currMap;


@end

