
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
    
    BOOL ready;
    BOOL inGame;
} 

// returns a CCScene that contains the HelloWorldLayer as the only child
+ (CCScene *) scene;
- (void) gameEnded;
- (NSString *) scoreInFormat:(NSInteger) score;
- (void) increaseScore;
- (void) playAgain;

- (void) pause;
- (void) unpause;

@end
