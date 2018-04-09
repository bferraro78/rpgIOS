//
//  PartyMember.h
//  RPG
//
//  Created by james schuler on 4/9/18.
//  Copyright © 2018 Ben Ferraro. All rights reserved.
//

#ifndef PartyMember_h
#define PartyMember_h

@interface PartyMember : NSObject

@property NSString *name;
@property BOOL readyCheck;


-(id)initWith:(NSString*)aName;

@end
#endif /* PartyMember_h */
