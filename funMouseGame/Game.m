//
//  Game.m
//  theGame
//
//  Created by Alexander on 20.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"
#import "cocos2d.h"


@implementation Game

// Singleton part
static Game *gameInstance = nil;

+ (Game *) instance
{
	if (!gameInstance)
	{
		gameInstance = [[Game alloc] init];
	}
	
	return gameInstance;
}

+ (void) releaseInstance {
	if (gameInstance) {
		[gameInstance release];
	}
}

#pragma mark -

@synthesize field;
@synthesize gameIsEnded;

- (id) init {
	if (![super init]) {
		return nil;
	}
	
	field = [[GameField alloc] initWithSize: kFieldSize];
	
	[self newGame];
	
	return self;
}

- (void) dealloc {
	[field release];
    
	[super dealloc];
}

- (void) checkGameForEnd {
	int size = field.size;
	
	for (int i = 1; i < size*size - 1; i++) {
		if ([field getByIndex: i] < [field getByIndex: (i-1)]) {
			return;
		}
	}
	
	gameIsEnded = YES;
}

- (CGPoint) moveX:(int) x Y:(int) y {
	if (![field isCorrectX:x Y:y]) {
		return ccp(-1, -1);
	}
	
	CGPoint res = ccp(-1, -1);

	if ([field getX:x+1 Y:y] == 0) {
		[field setX:x+1 Y:y byValue:[field getX:x Y:y]];
		[field setX:x Y:y byValue:0];
		res = ccp(x+1, y);
	} else if ([field getX:x-1 Y:y] == 0) {
		[field setX:x-1 Y:y byValue:[field getX:x Y:y]];
		[field setX:x Y:y byValue:0];
		res = ccp(x-1, y);
	} else if ([field getX:x Y:y+1] == 0) {
		[field setX:x Y:y+1 byValue:[field getX:x Y:y]];
		[field setX:x Y:y byValue:0];
		res = ccp(x, y+1);
	} else if ([field getX:x Y:y-1] == 0) {
		[field setX:x Y:y-1 byValue:[field getX:x Y:y]];
		[field setX:x Y:y byValue:0];
		res = ccp(x, y-1);
	}
	
	[self checkGameForEnd];
	
	return res;
}

- (CGPoint) moveValue:(int) value {
	int size = field.size;
	for (int i = 0; i < size*size; i++) {
		int v = [field getByIndex:i];
		if (v == value) {
			int x = i/size;
			int y = i%size;
			
			return [self moveX:x Y:y];
		}
	}
	
	return ccp(0, 0);
}

- (void) newGame {
	gameIsEnded = NO;
	[field fill];
}

- (GameField *) getField {
	return field;
}

- (BOOL) gameIsEnded {
	return gameIsEnded;
}

@end
