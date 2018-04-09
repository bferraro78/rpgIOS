//
//  SkillViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/26/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCharacter.h"
#import "Skill.h"
#import "SkillDictionary.h"

@interface SkillViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITextView *moveView; // For description show

@end
