//
//  SkillViewController.m
//  RPG
//
//  Created by Ben Ferraro on 5/26/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#import "SkillViewController.h"


/* Click and drag table view, full screen. Top 4 spots are added to main character in activeSkillSet */

@interface SkillViewController ()

@end

@implementation SkillViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    /* Long Press gesture for Table View - Drag and Drop */
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self.tableView addGestureRecognizer:longPress];

    
}

- (IBAction)longPressGestureRecognized:(id)sender {
    
    /* Clean Up View */
    [[self.view viewWithTag:123]removeFromSuperview];
    [self.tableView reloadData];
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                
                // Take a snapshot of the selected row using helper method.
                snapshot = [self customSnapshotFromView:cell];
                
                // Add the snapshot as subview, centered at cell's center...
                __block CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.tableView addSubview:snapshot];
                [UIView animateWithDuration:0.25 animations:^{
                    
                    // Offset for gesture location.
                    center.y = location.y;
                    snapshot.center = center;
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    
                    // Fade out.
                    cell.alpha = 0.0;
                    
                } completion:^(BOOL finished) {
                    
                    cell.hidden = YES;
                    
                }];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = location.y;
            snapshot.center = center;
            
            // Is destination valid and is it different from source?
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                
                // ... update data source.
                [mainCharacter.skillSet exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                
                // ... move the rows.
                [self.tableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // ... and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath;
            }
            break;
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourceIndexPath];
            cell.hidden = NO;
            cell.alpha = 0.0;
            [UIView animateWithDuration:0.25 animations:^{
                
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                
                // Undo fade out.
                cell.alpha = 1.0;
                
            } completion:^(BOOL finished) {
                
                sourceIndexPath = nil;
                [snapshot removeFromSuperview];
                snapshot = nil;
                
            }];
            break;
        }
    
    }
}

- (UIView*)customSnapshotFromView:(UIView *)inputView {
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

/* Pop Up Move Description */
- (void)handleMoveViewTap:(UITapGestureRecognizer *)recognizer {
    [[self.view viewWithTag:123]removeFromSuperview];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mainCharacter.skillSet count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; //forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
//                                          initWithTarget:self action:@selector(handleLongPress:)];
//    lpgr.minimumPressDuration = 0.5; //seconds
//    lpgr.delegate = cell;
//    [cell addGestureRecognizer:lpgr];
    
    
    cell.textLabel.text = [mainCharacter.skillSet objectAtIndex:indexPath.row];
    
    return cell;
}



/** SKill Description **/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [[self.view viewWithTag:123]removeFromSuperview];
    
    // Show Description
    NSInteger index = indexPath.row;
    NSString *skillName = [mainCharacter.skillSet objectAtIndex:index];
    
    self.moveView = [[UITextView alloc] initWithFrame:CGRectMake(10.0, cell.center.y+15.0, 200, 0)]; //(cell.center.x, cell.center.y, 200, 0)];
    self.moveView.tintColor = [UIColor blackColor];
    
    self.moveView.tag = 123;
    self.moveView.text = [SkillDictionary findSkill:skillName].moveDescription;;
    
    CGFloat fixedWidth = self.moveView.frame.size.width;
    CGSize newSize = [self.moveView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.moveView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    self.moveView.frame = newFrame;
    
    self.moveView.layer.borderWidth = 2.0f;
    self.moveView.layer.borderColor = [[UIColor yellowColor] CGColor];
    self.moveView.editable = false;
    
    /* Pop Up Box Gesture Tap Reconizer */
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleMoveViewTap:)];
    [self.moveView addGestureRecognizer:singleFingerTap];
    
    [self.view addSubview:self.moveView];
    
    printf("%s", [[SkillDictionary findSkill:skillName].moveDescription UTF8String]);
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:true];
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
