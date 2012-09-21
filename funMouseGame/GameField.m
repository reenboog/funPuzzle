//
//  GameField.m
//  theGame
//
//  Created by Alexander on 20.11.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameField.h"
#import "GameConfig.h"


@implementation GameField

- (id) initWithSize:(int) _size {
	if (![super init]) {
		return nil;
	}
	
    
	data = [[NSMutableArray alloc] initWithCapacity:(_size*_size)];
	size = _size;
	
    //fieldSize = (IsLittleField ? kTotalChipsMini : kTotalChipsBig);
    fieldSize = size * size;
    NSLog(@"FIELDSIZE: %i", fieldSize);
    
	for (int i = 0; i < size * size; i++) {
		NSNumber *n = [NSNumber numberWithInt:i];
		[data addObject:n];
	}
	
	return self;
}

- (void) dealloc {
	[data release];
	[super dealloc];
}

@synthesize size;

- (BOOL) isCorrectX:(int) x Y:(int) y {
	if ((x > -1) && (y > -1) && (x < size) && (y < size)) {
		return YES;
	}
	
	return NO;
}

- (int) getX:(int) x Y:(int) y {
	if (![self isCorrectX:x Y:y]) {
		return -1;
	}
	
	int index = x*size + y;
	
	return [(NSNumber *)[data objectAtIndex:index] intValue];
}

- (BOOL) setX:(int) x Y:(int) y byValue:(int) value 
{
	if (![self isCorrectX:x Y:y]) {
		return NO;
	}
	
	int index = x*size + y;
	
	[data replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:value]];
	
	return YES;
}

- (void) fill {
    
    
    
	for (int i = 0; i < size*size; i++) {
		[data replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:0]];
	}
	
	for (int i = 1; i < size * size; i++) {
		while (true) {
			int index = arc4random() % fieldSize; //f
			
			
			
			if ([[data objectAtIndex:index] intValue] == 0) {
				[data replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:i]];
				
				break;
			}
		}
	}
	
	int chaos = 0;
	int curr;
	
	for (int i = 0; i < size*size; i++) {
		curr = [[data objectAtIndex:i] intValue];
		
		for (int j = i; j < size*size; j++) {
			if (curr > [[data objectAtIndex:j] intValue]) {
				chaos++;
			}
		}
	}
	
	if (chaos%2 == 1) {
		NSNumber *n = [data objectAtIndex:(size*size-3)];
		[data replaceObjectAtIndex:(size*size-3) withObject:[data objectAtIndex:(size*size-2)]];
		[data replaceObjectAtIndex:(size*size-2) withObject:n];
	}
}


- (int) getByIndex:(int) index {
	if ((index > -1) && (index < size*size)) {
		return [[data objectAtIndex:index] intValue];
	}
	
	return -1;
}

@end
