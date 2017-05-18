//
//  Buff.h
//  RPG
//
//  Created by Ben Ferraro on 5/15/17.
//  Copyright © 2017 Ben Ferraro. All rights reserved.
//

#ifndef Buff_h
#define Buff_h
@class Buff;
@interface Buff : NSObject

@property int value;
@property int duration;

-(id)initvalue:(int)aValue duration:(int)aDuration;
-(NSString*)toString;
-(void)decreaseDuration;

@end

#endif /* Buff_h */
