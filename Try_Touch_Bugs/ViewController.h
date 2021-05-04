//
//  ViewController.h
//  Try_Touch_Bugs
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

//@import GoogleMobileAds;
@import iAd;

@protocol gameDelegate <NSObject>

-(void)showGameOver;
-(void)showRankView;
-(void)restartGame;
-(void)showGameMenu;

@end

@interface ViewController : UIViewController<ADBannerViewDelegate,gameDelegate>

@end
