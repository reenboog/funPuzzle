//
//  Game.h
//  theGame
//
//  Created by Alexander on 20.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameField.h"


#define kFieldMiniSize 3
#define kFieldBigSize 4

@interface Game : NSObject
{
	GameField *field;
    
	BOOL gameIsEnded;
    
    NSInteger fieldSize;
}

@property (nonatomic, readonly) GameField *field;
@property (nonatomic, readonly) BOOL gameIsEnded;

+ (Game *) instanceWithFuckingSize: (NSInteger) fSize;
+ (void) releaseInstance;
- (id) initWithCountOfCells: (NSInteger) fSize;
- (CGPoint) moveX:(int) x Y:(int) y;
- (void) newGame;

- (CGPoint) moveValue:(int) value;

@end
