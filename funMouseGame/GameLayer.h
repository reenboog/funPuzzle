
#import "cocos2d.h"
#import "Common.h"

// HelloWorldLayer
@interface GameLayer: CCLayer <GameLayerDelegate>
{
    CCSprite *back;
    
    CCLabelBMFont *scores;
    CCLabelBMFont *bestResult;
    CCMenuItemImage *playAgainBtn;
    
    CCMenu *field;
    
    NSInteger currentScore;
    
    float chipImageSize;
    float chipsCount;
    
    NSInteger fSize;
    
    BOOL ready;
    BOOL inGame;
    
    NSInteger screenHeightCenter;
    NSInteger screenWidth;
} 

// returns a CCScene that contains the HelloWorldLayer as the only child
- (id) initWithFieldSize: (NSInteger) size;
+ (CCScene *) sceneWithFieldSize: (NSInteger) size;
- (void) gameEnded;
- (NSString *) scoreInFormat:(NSInteger) score;
- (void) increaseScore;
- (void) playAgain;

- (void) pause;
- (void) unpause;

@end
