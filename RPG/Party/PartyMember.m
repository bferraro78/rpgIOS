//
//  PartyMember.m
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PartyMember.h"

@implementation PartyMember

-(id)initWith:(NSString*)aName {
    _name = aName;
    _readyCheck = false;
    return self;
}


@end
