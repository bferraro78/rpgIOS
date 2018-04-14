//
//  HealthBar.h
//  RPG
//
//  Created by james schuler on 4/2/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef HealthBar_h
#define HealthBar_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HealthBar  : UIView

@property float currentHealth;
@property float fullHealth;

-(void)setHealthBar:(int)currentHealth;
-(id)initWithFrame:(CGRect)frame;
@end

#endif /* HealthBar_h */
