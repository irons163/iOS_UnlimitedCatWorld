//
//  MyScene.h
//  Try_Touch_Bugs
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"

@interface MyScene : SKScene

@property (nonatomic) SKSpriteNode * backgroundNode;

@property (weak) id<gameDelegate> gameDelegate;

-(void)setClearType:(int)_clearType;
-(int)getClearType;
-(int64_t)getGameScore;

@end
