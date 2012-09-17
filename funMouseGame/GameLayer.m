
#import "GameLayer.h"
#import "MenuLayer.h"
#import "GameConfig.h"
#import "SimpleAudioEngine.h"
#import "Apsalar.h"
#import "Settings.h"
#import "Game.h"

// HelloWorldLayer implementation
@implementation GameLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
    
    //add menu layer
    MenuLayer *menu = [MenuLayer node];
    menu.gameLayerDelegate = layer;
    [scene addChild: menu];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if((self=[super init])) 
    {
        NSString *isIPadPostfix = (IsIPad ? @"HD" : @"");
        
        chipImageSize = (IsIPad ? kChipImageSizeHD : kChipImageSize);
        
        //load background
        back = [CCSprite spriteWithFile: [NSString stringWithFormat: @"back%@.png", isIPadPostfix]];
        back.position = GameCenterPos;
        [self addChild: back];
        
        scores = [CCLabelBMFont labelWithString: @"score: 00:00" 
                                        fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", isIPadPostfix]];
        scores.position = ccp(GameWidth * 0.02f, GameHeight * 0.97f);
        scores.anchorPoint = ccp(0.0f, 1.0f);
        [self addChild: scores];
        
        NSString *btnName = [NSString stringWithFormat: @"playAgainBtn"];
        
        playAgainBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"%@%@.png", btnName, isIPadPostfix]
                                              selectedImage: [NSString stringWithFormat: @"%@On%@.png", btnName, isIPadPostfix]
                                                     target: self
                                                   selector: @selector(playAgain)
                       ];
        
        CCMenu *playAgainMenu = [CCMenu menuWithItems: playAgainBtn, nil];
        playAgainMenu.position = ccp(0.0f, 0.0f);
        playAgainBtn.position = ccp(-GameCenterX, GameCenterY);
        [self addChild: playAgainMenu z: 1];
        
        //best result layer
        bestResult = [CCLabelBMFont labelWithString: [NSString stringWithFormat: @"Best: %@", [self scoreInFormat: [Settings sharedSettings].maxScore]] 
                                            fntFile: [NSString stringWithFormat: @"gameFont%@.fnt", isIPadPostfix]
                     ];
        bestResult.position = ccp(GameWidth / 2.0f, -100);
        bestResult.color = ccc3(0, 0, 0);

        [self addChild: bestResult z: zBestResult];
        
        
        // Game field;
        field = [CCMenu menuWithItems: nil];
        for(int i = 0; i < kTotalChips; i++)
        {
            NSString *imageName = [NSString stringWithFormat: kChipImageName, isIPadPostfix, (i + 1)];
            CCMenuItemImage *chip = [CCMenuItemImage itemFromNormalImage: imageName
                                                           selectedImage: imageName
                                                                  target: self 
                                                                selector: @selector(clickChip:)];
            
            [field addChild: chip z: 0 tag: (i + 1)];
            
            if(chip.tag == 9)
            {
                chip.position = ccp(chipImageSize*2, 0);
            }
        }
        field.position = fieldPosition;
        [field setOpacity: 0];
        [self addChild: field];
        
        
        [self playAgain];
        
        //enable input
        self.isTouchEnabled = YES;
        
        //play background sound
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"back.mp3" loop: YES];
        [[SimpleAudioEngine sharedEngine] preloadEffect: @"btnTap.mp3"];
        
        [[SimpleAudioEngine sharedEngine] setEffectsVolume: 0.7f];
        
        
        [self schedule: @selector(update:) interval: 1.0f];
	}
	return self;
}

- (void) update: (ccTime) dt
{
    if(inGame)
    {
        [self increaseScore];
    }
}

- (void) synchronize {
	GameField *gf = [Game instance].field;
	
	for (int i = 0; i < gf.size*gf.size; i++) {
		int index = [gf getByIndex: i];
		
		if (index != 0) {
			CCNode *node = [field getChildByTag: index];
            
			if (node != nil) {
				CCMenuItemImage *chip = (CCMenuItemImage *)node;
				int x = i/gf.size;
				int y = i%gf.size;
				[chip setPosition: ccp(y*chipImageSize, 2*chipImageSize - x*chipImageSize)];
			}
		}
	}
}

- (void) hideNinthChip
{
    
    [[field getChildByTag: 9] runAction: [CCFadeOut actionWithDuration: 0.6f]];
}

- (void) showNinthChip
{
    
    [[field getChildByTag: 9] runAction: [CCFadeIn actionWithDuration: 0.6f]];
}

- (NSString *) scoreInFormat:(NSInteger) score
{
    if(score < 10)
    {
        return [NSString stringWithFormat: @"00:0%i", score];
    }
    else if(score < 60)
    {
        return [NSString stringWithFormat: @"00:%i", score];
    }
    else if(score < 600)
    {
        NSInteger n = score%60;
        if(n < 10)
        {
            return [NSString stringWithFormat: @"0%i:0%i", score/60, n];
        }
        else
        {
           return [NSString stringWithFormat: @"0%i:%i", score/60, n]; 
        }
    }
    else
    {
        NSInteger n = score%60;
        if(n < 10)
        {
            return [NSString stringWithFormat: @"%i:0%i", score/60, n];
        }
        else
        {
            return [NSString stringWithFormat: @"%i:%i", score/60, n]; 
        }
    }
}

- (void) gameEnded
{
    [playAgainBtn runAction:
                            [CCMoveTo actionWithDuration: 0.3f
                                                position: ccp(GameCenterX, GameCenterY)
                            ]
    ];
    
    NSInteger bestResultEver = [Settings sharedSettings].maxScore;
    if(currentScore < bestResultEver)
    {
        //check for a new record and save if any
        [Settings sharedSettings].maxScore = currentScore;
        [[Settings sharedSettings] save];
    }
    
    bestResult.string = [NSString stringWithFormat: @"Best: %@", [self scoreInFormat: [Settings sharedSettings].maxScore]];
    
    [bestResult runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp(GameWidth / 2.0f, GameHeight * 0.35f)]
    ];
    
    // show ninth chip
    [self showNinthChip];
    
    ready = NO;
    inGame = NO;
    //enable chartboost
    CanDisplayChartBoost = YES;
    //request more interstitial
    [[NSNotificationCenter defaultCenter] postNotificationName: kRequestMoreInterstitialKey object: nil];
}


- (void) increaseScore
{
    currentScore++;
    scores.string = [NSString stringWithFormat: @"score: %@", [self scoreInFormat: currentScore]];
}

- (void) playAgain
{
    //play btn sound
    [[SimpleAudioEngine sharedEngine] playEffect: @"btnTap.mp3"];
    
    [playAgainBtn runAction:
                            [CCMoveTo actionWithDuration: 0.2f
                                                position: ccp(-GameCenterX, GameCenterY)
                            ]
    ];
    
    [bestResult runAction:
                            [CCMoveTo actionWithDuration: 0.2f
                                                position: ccp(GameCenterX, -100)
                            ]
    ];
    
    currentScore = 0;
    
    scores.string = [NSString stringWithFormat: @"score: %@", [self scoreInFormat: currentScore]];
   
    // reinit and update game field
    static bool firstStart = true;
    
    if(firstStart)
    {
        [[Game instance] newGame];
        [field runAction: [CCSequence actions:
                           [CCCallFunc actionWithTarget: self selector: @selector(synchronize)],
                           [CCFadeIn actionWithDuration: 0.6f],
                           [CCCallFunc actionWithTarget: self selector: @selector(hideNinthChip)],
                           nil]];
        
        firstStart = false;
    }
    else
    {
        [[Game instance] newGame];
        [field runAction: [CCSequence actions:
                           [CCFadeOut actionWithDuration: 0.3f],
                           [CCCallFunc actionWithTarget: self selector: @selector(synchronize)],
                           [CCFadeIn actionWithDuration: 0.3f],
                           [CCCallFunc actionWithTarget: self selector: @selector(hideNinthChip)],
                           nil]];
    }
    
    ready = YES;
    inGame = NO;
    //disable chartboost;
    CanDisplayChartBoost = NO;
    
    //notify apsalar system about this event
    [Apsalar eventWithArgs: @"slideAgain",
                            @"lastResult", [NSNumber numberWithInt: currentScore], 
                            nil
    ];
}

#pragma mark -
#pragma mark touches

- (void) registerWithTouchDispatcher
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate: self priority: 0 swallowsTouches: YES];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void) clickChip:(id) sender
{
    if (!ready) {
		return;
	}
	
	CCMenuItemImage *item = ((CCMenuItemImage *)sender);
	
	if (item.tag == 9) {
		return;
	}
	
	CGPoint p = [[Game instance] moveValue:item.tag];
	
	if (p.x < 0) {
		return;
	}
    
    inGame = true;
    
    [[SimpleAudioEngine sharedEngine] playEffect: @"btnTap.mp3"];
	
	[item runAction: [CCSequence actions:
					 [CCMoveTo actionWithDuration: 0.2f position: ccp(p.y*chipImageSize, 2*chipImageSize - p.x*chipImageSize)],
					 [CCCallFunc actionWithTarget: self selector: @selector(synchronize)],
					 nil
					 ]];
	
	if ([[Game instance] gameIsEnded]) {
		[self gameEnded];
	}
}

- (void) pause
{
    [self onExit];
}

- (void) unpause
{
    [self onEnter];
}

@end
