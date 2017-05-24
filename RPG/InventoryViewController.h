//
//  InventoryViewController.h
//  RPG
//
//  Created by Ben Ferraro on 5/23/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Barbarian.h"

@interface InventoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *InventoryTable;
@property (strong, nonatomic) IBOutlet UITextView *HeroTextField;

@property(nonatomic) Hero *mainCharacter;


@end
