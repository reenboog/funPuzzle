//
//  MainMenuLayer.m
//  funMouseGame
//
//  Created by Mac on 17.09.12.
//  Copyright 2012 alex.gievsky@gmail.com. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameLayer.h"
#import "Game.h"
#import "GameConfig.h"
#import "Apsalar.h"

#import "SimpleAudioEngine.h"


@implementation MainMenuLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainMenuLayer *layer = [MainMenuLayer node];
    
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) init
{
    if (self = [super init] )
    {
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic: @"back.mp3" loop: YES];
        
        NSString *isIPadPostfix = (IsIPad ? @"HD" : @"");
        screenHeightCenter = (IsIPad ? 1024 / 2 : 480 / 2);
        screenWidth = (IsIPad ? 768 : 320);
        
        //load background
        back = [CCSprite spriteWithFile: [NSString stringWithFormat: @"back%@.png", isIPadPostfix]];
        back.position = ccp(screenWidth / 2, screenHeightCenter);
        [self addChild: back];
        
        // Logo
        mainLogo = [CCSprite spriteWithFile: [NSString stringWithFormat: @"mainLogo%@.png", isIPadPostfix]];
        mainLogo.position = ccp(screenWidth / 2, screenHeightCenter * 1.7);
        [self addChild: mainLogo];
        
        playBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"playMenuBtn%@.png", isIPadPostfix] 
                                         selectedImage: [NSString stringWithFormat: @"playMenuBtnOn%@.png", isIPadPostfix]
                                                target: self 
                                              selector: @selector(chooseField)];
        
        moreBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"moreBtn%@.png", isIPadPostfix] 
                                         selectedImage: [NSString stringWithFormat: @"moreBtnOn%@.png", isIPadPostfix]
                                                target: self 
                                              selector: @selector(showMoreGames)
                   ];
        
        playBtn.position = ccp(screenWidth / 2, screenHeightCenter * 1.15);
        moreBtn.position = ccp(screenWidth / 2, screenHeightCenter * 0.75);
        
        CCMenu *mainMenu = [CCMenu menuWithItems: playBtn, moreBtn, nil];
        mainMenu.position = ccp(0,0);
        [self addChild: mainMenu];
        
        // submeenu layer
        
        subMenuLayer = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 0)];
        subMenuLayer.position = ccp(0,0);
        [self addChild: subMenuLayer];
        
        chooseFieldSprite = [CCSprite spriteWithFile: [NSString stringWithFormat: @"chooseField%@.png", isIPadPostfix]];
        chooseFieldSprite.position = ccp(screenWidth / 2, screenHeightCenter * 1.55);
        [chooseFieldSprite setOpacity: 0];
        [subMenuLayer addChild: chooseFieldSprite];
        
        threeBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"threeBtn%@.png", isIPadPostfix] 
                                          selectedImage: [NSString stringWithFormat: @"threeBtnOn%@.png", isIPadPostfix]
                                                 target: self 
                                               //selector: @selector(playThreeGame:)
                                             selector: @selector(onFieldSizeSelected:)
                    ];
        //tag используется для хранения размера, метод onFieldSizeSelected: позже будет работать с этим тегом
        threeBtn.tag = 3;
        
        fourBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"fourBtn%@.png", isIPadPostfix] 
                                         selectedImage: [NSString stringWithFormat: @"fourBtnOn%@.png", isIPadPostfix]
                                                target: self 
                                              //selector: @selector(playFourGame:)
                                              selector: @selector(onFieldSizeSelected:)
                    ];
                                            
        
        //tag используется для хранения размера, метод onFieldSizeSelected: позже будет работать с этим тегом
        fourBtn.tag = 4;

        
        threeBtn.position = ccp((screenWidth / 2) + screenWidth, screenHeightCenter * 1.15);
        fourBtn.position = ccp((screenWidth / 2) + screenWidth, screenHeightCenter * 0.75);
        
        CCMenu *changeDifficultyMenu = [CCMenu menuWithItems: threeBtn, fourBtn, nil];
        changeDifficultyMenu.position = ccp(0,0);
        [subMenuLayer addChild: changeDifficultyMenu];
    }

    return self;
}

- (void) chooseField
{
    [subMenuLayer setOpacity: 220];
    [chooseFieldSprite setOpacity: 255];
    
    CCAction *moveBtnThree = [CCMoveTo actionWithDuration: 0.2 position: ccp(screenWidth / 2, screenHeightCenter * 1.15)];
    CCAction *moveBtnFour = [CCMoveTo actionWithDuration: 0.2 position: ccp(screenWidth / 2, screenHeightCenter * 0.75)];
    
    [threeBtn runAction: moveBtnThree];
    [fourBtn runAction: moveBtnFour];
}

//вместо этиз двух нижних методов:
- (void) onFieldSizeSelected: (CCMenuItemImage *) sender
{
  NSInteger fieldSize = sender.tag;
    
  [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [GameLayer sceneWithFieldSize: fieldSize]]];
}

-(void)showMoreGames
{
    [[NSNotificationCenter defaultCenter] postNotificationName: kRequestMoreAppsNotificationKey object: nil];
    [Apsalar event: @"funSlideShowMoreGames"];

}

//    - (void) playThreeGame: (id) sender
//    {
//        IsLittleField = YES;
//        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [GameLayer scene]]];
//
//    }
//
//    - (void) playFourGame: (id) sender
//    {
//        IsLittleField = NO;
//        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [GameLayer scene]]];
//
//    }

@end
