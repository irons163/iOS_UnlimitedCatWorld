//
//  ViewController.m
//  Try_Touch_Bugs
//
//  Created by irons on 2015/5/21.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "GameCenterUtil.h"
#import "GameMenuViewController.h"
//#import "IClearGestureUtil.h"
//#import "MyTest.h"
//#import "MyTest2.h"

@implementation ViewController{
    ADBannerView * adBannerView;
//    GADInterstitial *interstitial;
    MyScene * scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self something];
    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 200, 30)];
    adBannerView.delegate = self;
    adBannerView.alpha = 1.0f;
    [self.view addSubview:adBannerView];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
//    skView.showsFPS = YES;
//    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    // Present the scene.
    [skView presentScene:scene];
    
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
//    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

-(void) showRankView{
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
//    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    //    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil showGameCenter:self];
    [gameCenterUtil submitAllSavedScores];
}

-(void)showGameMenu{
    GameMenuViewController* gameMenuDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameMenuViewController"];
    gameMenuDialogViewController.gameDelegate = self;
    gameMenuDialogViewController.scene = scene;
    gameMenuDialogViewController.gameType = [scene getClearType];
    gameMenuDialogViewController.gameScore = [scene getGameScore];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    
    [gameMenuDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:gameMenuDialogViewController animated:YES completion:^{
        //        [reset];
    }];
}

//-(void)something{
//    //    [self.delegate BviewcontrollerDidTapBackToMenuButton];
//    //
//    //    [Mytest1 new];
//    
//    IClearGestureUtil *a = [MyTest new];
//    IClearGestureUtil *b = [MyTest2 new];
//    
//    NSArray *array = @[a,b];
//    
//    for (IClearGestureUtil *bview in array) {
//        [bview BviewcontrollerDidTapBackToMenuButton];
//    }
//    
//}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self layoutAnimated:true];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [self layoutAnimated:true];
}

- (void)layoutAnimated:(BOOL)animated
{
    CGRect contentFrame = self.view.bounds;
    CGRect bannerFrame = adBannerView.frame;
    if (adBannerView.bannerLoaded)
    {
        //        contentFrame.size.height -= adBannerView.frame.size.height;
        contentFrame.size.height = 0;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        adBannerView.frame = contentFrame;
        [adBannerView layoutIfNeeded];
        adBannerView.frame = bannerFrame;
    }];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
