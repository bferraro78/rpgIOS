//
//  InventoryViewController.m
//  RPG
//
//  Created by Ben Ferraro on 5/23/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import "InventoryViewController.h"

@interface InventoryViewController ()

@end

@implementation InventoryViewController

NSMutableString *textBox;

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(id)init {
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UITabBarItem *bitem = [[UITabBarItem alloc] init];
    bitem.title = @"Inventory";
    self.tabBarItem = bitem;
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mainCharacter.inventory count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [InventoryManager removeFromInventory:[mainCharacter.inventory objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    [cell addGestureRecognizer:lpgr];
   
    if ([[mainCharacter.inventory objectAtIndex:indexPath.row] isKindOfClass:[Armor class]]) {
        cell.textLabel.text = [[mainCharacter.inventory objectAtIndex:indexPath.row] getName];
    } else if ([[mainCharacter.inventory objectAtIndex:indexPath.row] isKindOfClass:[Weapon class]]) {
        cell.textLabel.text = [[mainCharacter.inventory objectAtIndex:indexPath.row] getName];
    } else { // ITEM
        cell.textLabel.text = [[mainCharacter.inventory objectAtIndex:indexPath.row] toString];
    }
  
    return cell;
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    /* Strins to make equipment stats */
    
    NSMutableString *str = [[NSMutableString alloc] init];
    
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    
    if (indexPath == nil) {
        printf("long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {

        // CLEAR TEXT BOX FOR NEW INVENTORY ITEM
        self.textBox = [[NSMutableString alloc] init];
        
        // POP OUT BOX
        /* EQUIPPED ITEM*/
        if ([[mainCharacter.inventory objectAtIndex:indexPath.row] isKindOfClass:[Armor class]]) {
            
            Armor *a = (Armor*)[mainCharacter.inventory objectAtIndex:indexPath.row];
            
            if ([a.armorType isEqualToString:@"Helmet"]) {
                if ([mainCharacter getHelm].armor != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getHelm] toString]];
                }
            } else if ([a.armorType isEqualToString:@"Torso"]) {
                if ([mainCharacter getTorso].armor != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getTorso] toString]];
                }
            } else if ([a.armorType isEqualToString:@"Shoulders"]) {
                if ([mainCharacter getShoulders].armor != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getShoulders] toString]];
                }
            } else if ([a.armorType isEqualToString:@"Bracers"]) {
                if ([mainCharacter getBracers].armor != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getBracers] toString]];
                }
            } else if ([a.armorType isEqualToString:@"Gloves"]) {
                if ([mainCharacter getGloves].armor != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getGloves] toString]];
                }
            } else if ([a.armorType isEqualToString:@"Legs"]) {
                if ([mainCharacter getLegs].armor != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getLegs] toString]];
                }
            } else if ([a.armorType isEqualToString:@"Boots"]) {
                if ([mainCharacter getBoots].armor != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getBoots] toString]];
                }
            }
        } else if ([[mainCharacter.inventory objectAtIndex:indexPath.row] isKindOfClass:[Weapon class]]) { // Weapon
            
            Weapon *tmp = (Weapon*)[mainCharacter.inventory objectAtIndex:indexPath.row];
            if (tmp.isMainHand) {
                if ([mainCharacter getMH].attack != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getMH] toString]];
                }
            } else { // OH
                if ([mainCharacter getOH].attack != 0) {
                    [str appendFormat:@"Equipped:\n%@\n", [[mainCharacter getOH] toString]];
                }
            }
        }
        
        
        /* Inventory Item */
        self.textBox = [[mainCharacter.inventory objectAtIndex:indexPath.row] toString];
        
        // Append only if str in not empty
        if (![str isEqualToString:@""]) {
            [self.textBox appendFormat:@"\n\n%s",[str UTF8String]];
        }
        
        /* POP UP BOX */
        self.moveView = [[UITextView alloc] initWithFrame:CGRectMake(p.x-245, p.y, 200, 0)];
        self.moveView.tintColor = [UIColor blackColor];
        
        self.moveView.tag = 123;
        self.moveView.text = self.textBox;
        

        CGFloat fixedWidth = self.moveView.frame.size.width;
        CGSize newSize = [self.moveView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = self.moveView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        self.moveView.frame = newFrame;
        
        self.moveView.layer.borderWidth = 2.0f;
        self.moveView.layer.borderColor = [[UIColor greenColor] CGColor];
        [self.view addSubview:self.moveView];
        
    }
    
    if (gestureRecognizer.state == 2) { // MOVEMENT
        
        /* New Touch Point, Remove View to make new view */
        CGPoint newPoint = [gestureRecognizer locationInView:self.tableView];
        [[self.view viewWithTag:123]removeFromSuperview];
        
        self.moveView = [[UITextView alloc] initWithFrame:CGRectMake(newPoint.x-245, newPoint.y, 200, 0)];
        self.moveView.tintColor = [UIColor blackColor];
        self.moveView.tag = 123;
        self.moveView.text = self.textBox;
        
        CGFloat fixedWidth = self.moveView.frame.size.width;
        CGSize newSize = [self.moveView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
        CGRect newFrame = self.moveView.frame;
        newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
        self.moveView.frame = newFrame;
        
        self.moveView.layer.borderWidth = 2.0f;
        self.moveView.layer.borderColor = [[UIColor greenColor] CGColor];
        [self.view addSubview:self.moveView];
    }
    
    if (gestureRecognizer.state == 3) { // LET GO
        [[self.view viewWithTag:123]removeFromSuperview];
        self.moveView = nil;
    }
    
}


/** Equip/Unequip/Item Activate **/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger index = indexPath.row;
    [InventoryManager equipOrActivateItemArmorWeapon:[mainCharacter.inventory objectAtIndex:index]];
    
    /*Reload View*/
    [tableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
