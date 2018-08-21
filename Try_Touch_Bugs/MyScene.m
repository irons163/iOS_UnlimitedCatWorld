//
//  MyScene.m
//  Try_Touch_Bugs
//
//  Created by irons on 2015/5/21.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "MyScene.h"
#import "TextureHelper.h"
#import "SKBlade.h"
#import "GameMenuViewController.h"
#import "MyUtils.h"
#import "MyADView.h"

const int TOUCH_CLEAR = 0;
const int ZONE_CLEAR = 1;
const int BLADE_CLEAR = 2;
const int TOUCH_MULTI_CLEAR = 3;

const int UNLOCK_TOUCH_MULTI_CLEAR = 1000;
const int UNLOCK_ZONE_CLEAR = 100000;
const int UNLOCK_BLADE_CLEAR = 10000;

@implementation MyScene{
    MyADView * myAdView;
    int gameLevel;
    bool isTouchAble;
    int gamePointX;
    int64_t gameScore;
    bool isRandomCatTexturesRepeat;
    int clearType;
    
    SKSpriteNode * backgroundNode;
    NSArray * currentCatTextures;
    
    NSMutableArray * bugs;
    NSMutableArray * explodePool;
    
    NSArray * explodeTextures;
    
    SKSpriteNode * zone;
    SKSpriteNode * rankBtn;
    SKSpriteNode * musicBtn;
    SKSpriteNode * menuBtn;
    
    SKSpriteNode * gamePointSingleNode, *gamePointTenNode,
        *gamePointHunNode, *gamePointTHUNode, *gamePoint10THUNode,
        *gamePoint100THUNode, *gamePoint1MNode, *gamePoint10MNode,
        *gamePoint100MNode, *gamePoint1BNode, *gamePoint10BNode;
    
    SKBlade *blade;
    CGPoint _delta;
    
    NSMutableArray * musicBtnTextures;
}

const static int EXPLODE_ZPOSITION = 2;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        [TextureHelper initTextures];
        [TextureHelper initCatTextures];
        
        musicBtnTextures = [NSMutableArray array];
        [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music-hd"]];
        [musicBtnTextures addObject:[SKTexture textureWithImageNamed:@"btn_Music_Select-hd"]];
        
        bugs = [NSMutableArray array];
        explodePool = [NSMutableArray array];
        
        [self checkIsRandomCatTexturesRepeat];
        [self randomCurrentCatTextures];
        
        isTouchAble = true;
        
        [self initKillZone];
        
        gameScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"gameScore"];
//        gameScore=9999999;
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
        
        int r = arc4random_uniform(15);
        
        self.backgroundNode = [SKSpriteNode spriteNodeWithTexture:[TextureHelper bgTextures][r]];
        CGSize backgroundSize = CGSizeMake(self.frame.size.width, self.frame.size.height                                                                                                                                                                                                                                                                                                                         );
        
        self.backgroundNode.size = backgroundSize;
        
        self.backgroundNode.anchorPoint = CGPointMake(0, 0);
        
        self.backgroundNode.position = CGPointMake(0, 0);
        
//        self.backgroundNode.zPosition = backgroundLayerZPosition;
        
        [self addChild:self.backgroundNode];
        
        int gamePointNodeWH = 30;
        
        gamePointX = self.frame.size.width - gamePointNodeWH;
        int gamePointY = self.frame.size.height*6/8.0;
        //        int gamePointY = self.frame.size.height - 50;
        
        gamePointSingleNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:gameScore%10]];
        gamePointSingleNode.anchorPoint = CGPointMake(0, 0);
        gamePointSingleNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePointSingleNode.position = CGPointMake(gamePointX, gamePointY);
        //        gamePointSingleNode.zPosition = backgroundLayerZPosition;
        
        gamePointTenNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/10%10]];
        gamePointTenNode.anchorPoint = CGPointMake(0, 0);
        gamePointTenNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePointTenNode.position = CGPointMake(gamePointX - gamePointNodeWH, gamePointY);
        //        gamePointTenNode.zPosition = backgroundLayerZPosition;
        
        
        gamePointHunNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/100%10]];
        gamePointHunNode.anchorPoint = CGPointMake(0, 0);
        gamePointHunNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePointHunNode.position = CGPointMake(gamePointX - gamePointNodeWH*2, gamePointY);
        
        gamePointTHUNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/1000%10]];
        gamePointTHUNode.anchorPoint = CGPointMake(0, 0);
        gamePointTHUNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePointTHUNode.position = CGPointMake(gamePointX - gamePointNodeWH*3, gamePointY);
        
        gamePoint10THUNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/10000%10]];
        gamePoint10THUNode.anchorPoint = CGPointMake(0, 0);
        gamePoint10THUNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePoint10THUNode.position = CGPointMake(gamePointX - gamePointNodeWH*4, gamePointY);
        
        gamePoint100THUNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/100000%10]];
        gamePoint100THUNode.anchorPoint = CGPointMake(0, 0);
        gamePoint100THUNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePoint100THUNode.position = CGPointMake(gamePointX - gamePointNodeWH*5, gamePointY);
        
        gamePoint1MNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/1000000%10]];
        gamePoint1MNode.anchorPoint = CGPointMake(0, 0);
        gamePoint1MNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePoint1MNode.position = CGPointMake(gamePointX - gamePointNodeWH*6, gamePointY);
        
        gamePoint10MNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/10000000%10]];
        gamePoint10MNode.anchorPoint = CGPointMake(0, 0);
        gamePoint10MNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePoint10MNode.position = CGPointMake(gamePointX - gamePointNodeWH*7, gamePointY);
        
        gamePoint100MNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/100000000%10]];
        gamePoint100MNode.anchorPoint = CGPointMake(0, 0);
        gamePoint100MNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePoint100MNode.position = CGPointMake(gamePointX - gamePointNodeWH*8, gamePointY);
        
        gamePoint1BNode = [SKSpriteNode spriteNodeWithTexture:[self getTimeTexture:(gameScore)/1000000000%10]];
        gamePoint1BNode.anchorPoint = CGPointMake(0, 0);
        gamePoint1BNode.size = CGSizeMake(gamePointNodeWH, gamePointNodeWH);
        gamePoint1BNode.position = CGPointMake(gamePointX - gamePointNodeWH*9, gamePointY);
        
        [self addChild:gamePointSingleNode];
        [self addChild:gamePointTenNode];
        [self addChild:gamePointHunNode];
        [self addChild:gamePointTHUNode];
        [self addChild:gamePoint10THUNode];
        [self addChild:gamePoint100THUNode];
        [self addChild:gamePoint1MNode];
        [self addChild:gamePoint10MNode];
        [self addChild:gamePoint100MNode];
        [self addChild:gamePoint1BNode];
        
        rankBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btnL_GameCenter-hd"];
        rankBtn.size = CGSizeMake(42,42);
        rankBtn.anchorPoint = CGPointMake(0, 0);
        rankBtn.position = CGPointMake(self.frame.size.width - rankBtn.size.width, self.frame.size.height/2);
//        rankBtn.zPosition = backgroundLayerZPosition;
        [self addChild:rankBtn];
        
        [self autoCreateBugs];
        
//        [self setBgByGameLevel];
        
        [self initExplodeTextures];
        
        musicBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Music-hd"];
        musicBtn.size = CGSizeMake(42,42);
        musicBtn.anchorPoint = CGPointMake(0, 0);
        musicBtn.position = CGPointMake(self.frame.size.width - musicBtn.size.width, self.frame.size.height/2 - 42);
        //        rankBtn.zPosition = backgroundLayerZPosition;
        [self addChild:musicBtn];
        
        menuBtn = [SKSpriteNode spriteNodeWithImageNamed:@"btn_Menu-hd"];
        menuBtn.size = CGSizeMake(42,42);
        menuBtn.anchorPoint = CGPointMake(0, 0);
        menuBtn.position = CGPointMake(self.frame.size.width - menuBtn.size.width, self.frame.size.height/2 - 42*2);
        //        rankBtn.zPosition = backgroundLayerZPosition;
        [self addChild:menuBtn];
        
        clearType = [[NSUserDefaults standardUserDefaults] integerForKey:@"clearType"];
        
        
        NSArray* musics = [NSArray arrayWithObjects:@"am_white.mp3", @"biai.mp3", @"cafe.mp3", @"deformation.mp3", nil];
        
        int index = arc4random_uniform(4);
        [MyUtils preparePlayBackgroundMusic:musics[index]];
        
        id isPlayMusicObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"isPlayMusic"];
        BOOL isPlayMusic = true;
        if(isPlayMusicObject==nil){
            isPlayMusicObject = false;
        }else{
            isPlayMusic = [isPlayMusicObject boolValue];
        }
        if(isPlayMusic){
            [MyUtils backgroundMusicPlayerPlay];
            musicBtn.texture = musicBtnTextures[0];
        }else{
            [MyUtils backgroundMusicPlayerPause];
            musicBtn.texture = musicBtnTextures[1];
        }
        
        myAdView = [MyADView spriteNodeWithTexture:nil];
        myAdView.size = CGSizeMake(self.frame.size.width, self.frame.size.width/5.0f);
//        myAdView.position = CGPointMake(self.frame.size.width/2, self.frame.size.height - 35);
        myAdView.position = CGPointMake(self.frame.size.width/2, 0);
        [myAdView startAd];
        myAdView.zPosition = 1;
        myAdView.anchorPoint = CGPointMake(0.5, 0);
        [self addChild:myAdView];
        
    }
    return self;
}

-(void)initExplodeTextures{
    explodeTextures = [TextureHelper getTexturesWithSpriteSheetNamed:@"explode" withinNode:nil sourceRect:CGRectMake(0, 0, 500, 500) andRowNumberOfSprites:1 andColNumberOfSprites:5];
}

-(void)skill{
    
}

-(void)initKillZone{
    zone = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(120, 120)];
    zone.alpha = 0.5;
    zone.position = CGPointMake(-500, -500);
    zone.zPosition = 1;
    [self addChild:zone];
}

-(void)hideKillZone{
    zone.position = CGPointMake(-500, -500);
}

-(void)killZone{
    for (int i = 0; i < bugs.count ; i++) {
        if (CGRectContainsRect([bugs[i] calculateAccumulatedFrame], zone.calculateAccumulatedFrame)) {
            [self doKill:bugs[i]];
            i--;
        }
    }
}

-(void) checkIsRandomCatTexturesRepeat{
    int r = arc4random_uniform(2);
    if (r == 0) {
        isRandomCatTexturesRepeat = false;
    }else{
        isRandomCatTexturesRepeat = true;
    }
}

-(void) randomCurrentCatTextures{
    int r = arc4random_uniform(5);
    
    switch (r) { 
        case 0:
            currentCatTextures = [TextureHelper cat1Textures];
            break;
        case 1:
            currentCatTextures = [TextureHelper cat2Textures];
            break;
        case 2:
            currentCatTextures = [TextureHelper cat3Textures];
            break;
        case 3:
            currentCatTextures = [TextureHelper cat4Textures];
            break;
        case 4:
            currentCatTextures = [TextureHelper cat5Textures];
            break;
        default:
            break;
    }
}

-(void)autoCreateBugs{
    SKAction * createTimer;
    createTimer = [SKAction runBlock:^{
        if(bugs.count < 50){
            [self createBugs];
            [self createBugs];
        }else if(bugs.count < 100){
            [self createBugs];
        }
//        [self createBugs];
        
        if (gameScore>=TOUCH_MULTI_CLEAR) {
            [self createBugs];
        }
        if(gameScore>=BLADE_CLEAR){
            [self createBugs];
        }
        if(gameScore>=ZONE_CLEAR){
            [self createBugs];
        }
    }];
    SKAction * wait;
    wait = [SKAction waitForDuration:0.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[createTimer, wait]]]];
}

-(void)createBugs{
    if(isRandomCatTexturesRepeat){
        [self randomCurrentCatTextures];
    }
    SKSpriteNode * bug = [SKSpriteNode spriteNodeWithTexture:currentCatTextures[0]];
    bug.size = CGSizeMake(60, 60);
    bug.position = CGPointMake(arc4random_uniform(self.size.width - bug.size.width)+bug.size.width/2, arc4random_uniform(self.size.height - bug.size.height) + bug.size.height/2);
    [self addChild:bug];
    [bugs addObject:bug];
    [self move:bug];
    [self runMovementAction:bug];
}

#define ARC4RANDOM_MAX 0x100000000

-(void)move:(SKSpriteNode*)bug{
    float radians = ((float)arc4random() / ARC4RANDOM_MAX) * (M_PI*2-0) + 0;
    float r = 40;
    CGFloat dx = r * cos (radians);
    CGFloat dy = r * sin (radians);
    
    if((bug.position.x - bug.size.width/2.0f) + dx < 0){
        dx = -dx;
    }else if((bug.position.x + bug.size.width/2.0f) + dx > self.size.width){
        dx = -dx;
    }
    
    if((bug.position.y - bug.size.height/2.0f) + dy < 0){
        dy = -dy;
    }else if((bug.position.y + bug.size.height/2.0f) + dy > self.size.height){
        dy = -dy;
    }
    
    SKAction * action;
    action = [SKAction moveByX:dx y:dy duration:1.0];
    SKAction * wait;
    wait = [SKAction waitForDuration:2.0];
    SKAction * end;
    end = [SKAction runBlock:^{
        [self move:bug];
    }];
    
    [bug runAction:[SKAction sequence:@[action, wait, end]]];
}

-(void)runMovementAction:(SKSpriteNode*)bug{
    SKAction * movementAction = [SKAction animateWithTextures:@[currentCatTextures[0],currentCatTextures[1]] timePerFrame:0.2];
    [bug runAction:[SKAction repeatActionForever:movementAction]];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [myAdView touchesBegan:touches withEvent:event];
    
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    bool isTouch = false;
    
    if(clearType == BLADE_CLEAR){
        
        [self presentBladeAtPosition:location];
        
    }else if(clearType == ZONE_CLEAR){
        zone.position = location;
        for (int i = bugs.count-1; i >= 0 ; i--) {
            if (CGRectContainsPoint([zone calculateAccumulatedFrame], [bugs[i] position])) {
                //            isTouchAble = false;
                isTouch = true;
                
                [self doKill:bugs[i]];
                i--;
                //                break;
            }
        }
    }else if(clearType == TOUCH_MULTI_CLEAR){
        for (int i = bugs.count-1; i >= 0 ; i--) {
            if (CGRectContainsPoint([bugs[i] calculateAccumulatedFrame], location)) {
                //            isTouchAble = false;
                isTouch = true;
                
                [self doKill:bugs[i]];
                i--;
            }
        }
    }
    else{
        for (int i = bugs.count-1; i >= 0 ; i--) {
            if (CGRectContainsPoint([bugs[i] calculateAccumulatedFrame], location)) {
                //            isTouchAble = false;
                isTouch = true;
                
                [self doKill:bugs[i]];
                i--;
                break;
            }
        }
    }
    
    if(CGRectContainsPoint(rankBtn.calculateAccumulatedFrame, location)&&!isTouch){
        //        rankBtn.texture = storeBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
        
        [self.gameDelegate showRankView];
    }else if(CGRectContainsPoint(musicBtn.calculateAccumulatedFrame, location)){
        if([MyUtils isBackgroundMusicPlayerPlaying]){
            [MyUtils backgroundMusicPlayerPause];
            musicBtn.texture = musicBtnTextures[1];
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"isPlayMusic"];
        }else{
            [MyUtils backgroundMusicPlayerPlay];
            musicBtn.texture = musicBtnTextures[0];
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"isPlayMusic"];
        }
    }else if(CGRectContainsPoint(menuBtn.calculateAccumulatedFrame, location)&&!isTouch){
        //        rankBtn.texture = storeBtnClickTextureArray[PRESSED_TEXTURE_INDEX];
//        clearType = ZONE_CLEAR;
        [self.gameDelegate showGameMenu];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch * touch = [touches anyObject];
//    CGPoint _currentPoint = [touch locationInNode:self];
    CGPoint _currentPoint = [[touches anyObject] locationInNode:self];
    CGPoint _previousPoint = [[touches anyObject] previousLocationInNode:self];
    _delta = CGPointMake(_currentPoint.x - _previousPoint.x, _currentPoint.y - _previousPoint.y);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self removeBlade];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self removeBlade];
}

-(void)runHitAction:(SKSpriteNode*)bug{
    [bug removeAllActions];
    [bugs removeObject:bug];
    bug.texture = currentCatTextures[3];
    SKAction * wait = [SKAction waitForDuration:0.5];
    SKAction * end = [SKAction runBlock:^{
        [bug removeFromParent];
    }];
    
    [bug runAction:[SKAction sequence:@[wait, end]]];
}

-(SKSpriteNode*)checkPool{
    SKSpriteNode * availidExplodeNode = nil;
    
    for(int i = 0; i < explodePool.count; i++){
        SKSpriteNode * explode = explodePool[i];
        if (explode.isHidden) {
            explode.hidden = false;
            availidExplodeNode = explode;
            break;
        }
    }
    
    return availidExplodeNode;
}

-(void)runExplodeAction:(SKSpriteNode*)explode{
    
    SKAction * explodeAction = [SKAction animateWithTextures:explodeTextures timePerFrame:0.2];
    SKAction * end = [SKAction runBlock:^{
        explode.hidden = true;
        isTouchAble = true;
    }];
    
    [explode runAction:[SKAction sequence:@[explodeAction, end]]];
}

-(void)changeGamePoint{
    gameScore++;
    
    [[NSUserDefaults standardUserDefaults] setInteger:gameScore forKey:@"gameScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    gamePointSingleNode.texture = [self getTimeTexture:gameScore%10];
    gamePointTenNode.texture = [self getTimeTexture:(gameScore)/10%10];
    gamePointHunNode.texture = [self getTimeTexture:(gameScore)/100%10];
    gamePointTHUNode.texture = [self getTimeTexture:(gameScore)/1000%10];
//    gamePointTHUNode.texture = [self getTimeTexture:(gameScore)/10000%10];
    gamePoint10THUNode.texture = [self getTimeTexture:(gameScore)/10000%10];
    gamePoint100THUNode.texture = [self getTimeTexture:(gameScore)/100000%10];
//    gamePoint100THUNode.texture = [self getTimeTexture:(gameScore)/10000000%10];
    gamePoint1MNode.texture = [self getTimeTexture:(gameScore)/1000000%10];
    gamePoint10MNode.texture = [self getTimeTexture:(gameScore)/10000000%10];
    gamePoint100MNode.texture = [self getTimeTexture:(gameScore)/100000000%10];gamePoint1BNode.texture = [self getTimeTexture:(gameScore)/1000000000%10];
}

#pragma mark - SKBlade Functions

- (void)presentBladeAtPosition:(CGPoint)position {
    blade = [[SKBlade alloc] initWithPosition:position TargetNode:self Color:[UIColor redColor]];
    [self addChild:blade];
}

- (void)removeBlade {
    _delta = CGPointZero;
    [blade removeFromParent];
    blade = nil;
}
-(SKTexture*)getTimeTexture:(int)time{
    SKTexture* texture;
    switch (time) {
        case 0:
            texture = [TextureHelper timeTextures][0];
            break;
        case 1:
            texture = [TextureHelper timeTextures][1];
            break;
        case 2:
            texture = [TextureHelper timeTextures][2];
            break;
        case 3:
            texture = [TextureHelper timeTextures][3];
            break;
        case 4:
            texture = [TextureHelper timeTextures][4];
            break;
        case 5:
            texture = [TextureHelper timeTextures][5];
            break;
        case 6:
            texture = [TextureHelper timeTextures][6];
            break;
        case 7:
            texture = [TextureHelper timeTextures][7];
            break;
        case 8:
            texture = [TextureHelper timeTextures][8];
            break;
        case 9:
            texture = [TextureHelper timeTextures][9];
            break;
            //        default:
            //            texture = [self getTimeTexture:time/10];
            //            break;
    }
    return texture;
}

-(void)doKill:(SKSpriteNode*)targetBug{
    SKSpriteNode * bug = targetBug;
    [self runHitAction:bug];
    
    SKSpriteNode * explodeNode = [self checkPool];
    if(explodeNode==nil){
        explodeNode = [SKSpriteNode spriteNodeWithTexture:nil];
        explodeNode.zPosition = EXPLODE_ZPOSITION;
        explodeNode.size = bug.size;
        explodeNode.position = CGPointMake(bug.position.x, bug.position.y+bug.size.height);
        explodeNode.anchorPoint = CGPointMake(0.5, 1);
        
        [self addChild:explodeNode];
        [explodePool addObject:explodeNode];
    }else{
        explodeNode.position = CGPointMake(bug.position.x, bug.position.y+bug.size.height);
    }
    
    [self runExplodeAction:explodeNode];
    
    [self changeGamePoint];
    
    //            [hamer runAction:hamerHitCat];
    //            [self enemyBeHit];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    // Here you add our _delta value to our blade position
    
    if(zone!=nil){
        [self killZone];
    }
    {
    
    blade.position = CGPointMake(blade.position.x + _delta.x, blade.position.y + _delta.y);
    
//    if(isTouchAble){
        for (int i = 0; i < bugs.count ; i++) {
            if (CGRectContainsPoint([bugs[i] calculateAccumulatedFrame], blade.position)) {
    //            isTouchAble = false;
    //            isTouch = true;
                [self doKill:bugs[i]];
                i--;
                break;
            }
        }
    }
//    }

    
    // it's important to reset _delta at this point,
    // you are telling our blade to only update his position when touchesMoved is called
    _delta = CGPointZero;
}

-(void)setClearType:(int)_clearType{
    clearType = _clearType;
    if(clearType!=ZONE_CLEAR){
        [self hideKillZone];
    }
    [[NSUserDefaults standardUserDefaults] setInteger:clearType forKey:@"clearType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(int)getClearType{
    return clearType;
}

-(int64_t)getGameScore{
    return gameScore;
}

-(void)circle{
    
}

@end
