//
//  MainMenuLayer.h
//  funMouseGame
//
//  Created by Mac on 17.09.12.
//  Copyright 2012 alex.gievsky@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MainMenuLayer : CCLayer 
{
    CCSprite *back;
    CCSprite *mainLogo;
    
    CCMenuItemImage *playBtn;
    CCMenuItemImage *moreBtn;
    
    CCLayerColor *subMenuLayer;
    
    CCSprite *chooseFieldSprite;
    
    CCMenuItemImage *threeBtn;
    CCMenuItemImage *fourBtn;
    
    NSInteger screenHeightCenter;
    NSInteger screenWidth;
}

+ (CCScene *) scene;

@end
