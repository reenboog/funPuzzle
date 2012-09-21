
#import "MenuLayer.h"
#import "MainMenuLayer.h"
#import "GameConfig.h"
#import "Game.h"
#import "SimpleAudioEngine.h"

@implementation MenuLayer

@synthesize gameLayerDelegate;

- (id) init
{
    if((self = [super init])) 
    {
        shadow = [CCLayerColor layerWithColor: ccc4(0, 0, 0, 255)];
        screenHeightCenter = (IsIPad ? 1024 / 2 : 480 / 2);
        screenWidth = (IsIPad ? 768 : 320);
        [shadow setOpacity: 0];

        [self addChild: shadow];
        
        NSString *isIPadPostfix = (IsIPad ? @"HD" : @"");
        NSString *btnName = @"pauseBtn";
        
        pauseBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"%@%@.png", btnName, isIPadPostfix]
                                                           selectedImage: [NSString stringWithFormat: @"%@%@.png", btnName, isIPadPostfix]
                                                                  target: self
                                                                selector: @selector(pause)
                                    ];
        pauseBtn.position = ccp((screenWidth / 2.0f) * 0.79, (screenHeightCenter) * 0.85);
        
        pauseBtn.scale = 0.8;
        
        btnName = @"resetBtn";
        
        resetBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"%@%@.png", btnName, isIPadPostfix]
                                                           selectedImage: [NSString stringWithFormat: @"%@On%@.png", btnName, isIPadPostfix]
                                                                  target: self
                                                                selector: @selector(reset)
                                   ];
        resetBtn.position = ccp((GameWidth / 2.0f) * kResetBtnRelativeX, (GameHeight / 2.0f) * (-3));
        
        resetBtn.scale = 0.8;

        btnName = @"infoBtn";
        
        infoBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"%@%@.png", btnName, isIPadPostfix]
                                                           selectedImage: [NSString stringWithFormat: @"%@On%@.png", btnName, isIPadPostfix]
                                                                  target: self
                                                                selector: @selector(showInfo)
                                   ];
        infoBtn.position = ccp((GameWidth / 2.0f) * kInfoBtnRelativeX, (GameHeight / 2.0f) * (-3));
        
        infoBtn.scale = 0.8;
        
        btnName = @"helpBtn";
        
        helpBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"%@%@.png", btnName, isIPadPostfix]
                                                           selectedImage: [NSString stringWithFormat: @"%@On%@.png", btnName, isIPadPostfix]
                                                                  target: self
                                                                selector: @selector(help)
                                   ];
        helpBtn.position = ccp((GameWidth / 2.0f) * kHelpBtnRelativeX, (GameHeight / 2.0f) * (-3));
        
        helpBtn.scale = 0.8;
        
        btnName = @"exit";
        
        exitBtn = [CCMenuItemImage itemFromNormalImage: [NSString stringWithFormat: @"%@%@.png", btnName, isIPadPostfix]
                                         selectedImage: [NSString stringWithFormat: @"%@On%@.png", btnName, isIPadPostfix]
                                                target: self
                                              selector: @selector(backInMainMenu:)
                   ];
        exitBtn.position = ccp((GameWidth / 2.0f) * kExitBtnRelativeX, (GameHeight / 2.0f) * (-3));
        
        exitBtn.scale = 0.8;
        
        //help sprite
        
        help = [CCSprite spriteWithFile: [NSString stringWithFormat: @"help%@.png", isIPadPostfix]];
        help.position = ccp(screenWidth / 2, screenHeightCenter * 4);
        
        [self addChild: help];

        menu = [CCMenu menuWithItems: pauseBtn, infoBtn, helpBtn, resetBtn, exitBtn, nil];
        
        [self addChild: menu];
    }
    
    return self;
}

- (void) pause
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"btnTap.mp3"];
    
    [self.gameLayerDelegate pause];
    
    [shadow runAction:
                    [CCSequence actions:
                                        [CCFadeTo actionWithDuration: 0.3 opacity: 200],
                                        nil
                    ]
    ];
    
    //place buttons
    
    [resetBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kResetBtnRelativeX, (GameHeight / 2.0f) * kResetBtnRelativeY)]                
    ];
    
    [helpBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kHelpBtnRelativeX, (GameHeight / 2.0f) * kHelpBtnRelativeY)]                
    ];
    
    [infoBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kInfoBtnRelativeX, (GameHeight / 2.0f) * kInfoBtnRelativeY)]                
    ];
    
    [exitBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kExitBtnRelativeX, (GameHeight / 2.0f) * kExitBtnRelativeY)]                
    ];
    
    [pauseBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * 1.2, (screenHeightCenter) * 0.85)]
    ];
    
    //enable showing chartboost
    
    CanDisplayChartBoost = YES;
}

- (void) backInMainMenu: (id) sender
{
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration: 1.0 scene: [MainMenuLayer scene]]];
    
    [Game releaseInstance];
    //[[Game instanceWithFuckingSize: 3] gameIsEnded];
}

- (void) showInfo
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"btnTap.mp3"];
    //request more apps
    [[NSNotificationCenter defaultCenter] postNotificationName: kRequestMoreAppsNotificationKey object: nil];
}

- (void) reset
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"btnTap.mp3"];
    
    [shadow runAction:
                    [CCSequence actions:
                                        [CCFadeOut actionWithDuration: 0.1f],
                                        [CCCallFunc actionWithTarget: self.gameLayerDelegate selector: @selector(unpause)],
                                        nil
                    ]
    ];
    
    [resetBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kResetBtnRelativeX, (GameHeight / 2.0f) * (-3))]                
    ];
    
    [helpBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kHelpBtnRelativeX, (GameHeight / 2.0f) * (-3))]                
    ];
    
    [infoBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kInfoBtnRelativeX, (GameHeight / 2.0f) * (-3))]                
    ];
    
    [exitBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * kExitBtnRelativeX, (GameHeight / 2.0f) * (-3))]                
    ];

    [pauseBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((screenWidth / 2.0f) * 0.80, (screenHeightCenter) * 0.85)]
    ];
    
    [help runAction:
                    [CCMoveTo actionWithDuration: 0.2f position: ccp(screenWidth / 2.0f, screenHeightCenter * 4.0f)]
    ];
    
    //disable showing chartboost
    CanDisplayChartBoost = NO;
}

- (void) help
{
    [[SimpleAudioEngine sharedEngine] playEffect: @"btnTap.mp3"];
    
    [help runAction:
                    [CCMoveTo actionWithDuration: 0.2f position: ccp(screenWidth / 2, screenHeightCenter)]
    ];
    
    [resetBtn runAction:
                        [CCSequence actions:
                                            [CCMoveTo actionWithDuration: 0.4f position: ccp(-GameWidth, 0)],
                                            [CCPlace actionWithPosition: ccp(GameWidth * 2, GameHeight * (-0.37))],
                                            [CCMoveTo actionWithDuration: 0.5f position: ccp(screenWidth * 0.3, (screenHeightCenter * 2) * (-0.37))],
                                            nil
                        ]
    ];
    
    [helpBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((GameWidth / 2.0f) * kHelpBtnRelativeX, (GameHeight / 2.0f) * (-3))]                
    ];
    
    [infoBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((GameWidth / 2.0f) * kInfoBtnRelativeX, (GameHeight / 2.0f) * (-3))]                
    ];
    
    [exitBtn runAction:
                        [CCMoveTo actionWithDuration: 0.2f position: ccp((GameWidth / 2.0f) * kExitBtnRelativeX, (GameHeight / 2.0f) * (-3))]                
    ];
}

@end
