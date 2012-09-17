//
//  Game.h
//  theGame
//
//  Created by Alexander on 20.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameField.h"


#define kFieldSize 3

@interface Game : NSObject
{
	GameField *field;
	
	BOOL gameIsEnded;
}

@property (nonatomic, readonly) GameField *field;
@property (nonatomic, readonly) BOOL gameIsEnded;

+ (Game *) instance;
+ (void) releaseInstance;

- (CGPoint) moveX:(int) x Y:(int) y;
- (void) newGame;

- (CGPoint) moveValue:(int) value;

@end
