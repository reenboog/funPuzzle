//
//  GameConfig.h
//  funMouseGame
//
//  Created by Alex Gievsky on 10.11.11.
//  Copyright alex.gievsky@gmail.com 2011. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//

// 3rd generation and newer devices: Rotate using UIViewController. Rotation should be supported on iPad apps.
// TIP:
// To improve the performance, you should set this value to "kGameAutorotationNone" or "kGameAutorotationCCDirector"
#if defined(__ARM_NEON__) || TARGET_IPHONE_SIMULATOR
#define GAME_AUTOROTATION kGameAutorotationUIViewController

// ARMv6 (1st and 2nd generation devices): Don't rotate. It is very expensive
#elif __arm__
#define GAME_AUTOROTATION kGameAutorotationCCDirector

// Ignore this value on Mac
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)

#else
#error(unknown architecture)
#endif

//constants
#define kTotalMice 2
#define kMaxScoreKey @"maxScoreKey"

#define kScreenHeight       480
#define kScreenWidth        320

#define kScreenHeightHD     1024
#define kScreenWidthHD      768
#define kMouseTag           679

#define zBestResult         10

#define kInfoBtnRelativeX (0.45)
#define kInfoBtnRelativeY 0  

#define kHelpBtnRelativeX 0
#define kHelpBtnRelativeY 0 

#define kResetBtnRelativeX (-0.45)
#define kResetBtnRelativeY 0 

#define kRequestMoreAppsNotificationKey @"requestMoreApps"
#define kRequestMoreInterstitialKey     @"requestMoreInterstitial"

extern float GameWidth;
extern float GameHeight;
extern float GameCenterX;
extern float GameCenterY;
extern CGPoint GameCenterPos;
extern BOOL IsIPad;
extern BOOL CanDisplayChartBoost;

extern CGPoint fieldPosition;


// Chips
#define kChipImageName @"chip%@%i.png"

#define kChipImageSize 100.0f
#define kChipImageSizeHD 248.0f

#define kTotalChips 9

#endif // __GAME_CONFIG_H

