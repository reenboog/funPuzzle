//
//  GameField.h
//  theGame
//
//  Created by Alexander on 20.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@interface GameField : NSObject {
	NSMutableArray *data;
	int size;
    NSInteger fieldSize;
}

@property (nonatomic, readonly) int size;

- (id) initWithSize:(int) _size;

- (int) getX:(int) x Y:(int) y;
- (BOOL) setX:(int) x Y:(int) y byValue:(int) value;

- (int) getByIndex:(int) index;
- (BOOL) isCorrectX:(int) x Y:(int) y;

- (void) fill;

@end
