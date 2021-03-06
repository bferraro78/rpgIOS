//
//  InventoryViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/23/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainCharacter.h"
#import "InventoryManager.h"

@interface InventoryViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITextView *moveView; // Pop up box Long Press
@property NSMutableString *textBox; // Holds Item Data

@end
