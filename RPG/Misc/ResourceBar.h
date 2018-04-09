//
//  ResourceBar.h
//  RPG
//
//  Created by james schuler on 4/4/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef ResourceBar_h
#define ResourceBar_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ResourceBar : UIView

@property float currentResource;
@property float fullResource;

-(void)setResourceBar:(int)currentResource;

@end

#endif /* ResourceBar_h */
