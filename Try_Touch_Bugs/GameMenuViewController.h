//
//  GameOverViewController.h
//  Easy_Dodge
//
//  Created by irons on 2015/7/3.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScene.h"

@protocol gameDelegate;

@interface GameMenuViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *touchMultiImage;
@property (strong, nonatomic) IBOutlet UIImageView *zoneImage;
@property (strong, nonatomic) IBOutlet UIImageView *BladeImage;
@property (strong, nonatomic) IBOutlet UIButton *touchBtn;
@property (strong, nonatomic) IBOutlet UIButton *touchMultiBtn;
@property (strong, nonatomic) IBOutlet UIButton *zoneBtn;
@property (strong, nonatomic) IBOutlet UIButton *bladeBtn;
@property (strong, nonatomic) IBOutlet UILabel *gameTimeLabel;

- (IBAction)changeToTouchClick:(id)sender;
- (IBAction)changeToTouchMultiClick:(id)sender;
- (IBAction)changeToZoneClick:(id)sender;
- (IBAction)changeToBladeClick:(id)sender;
- (IBAction)backClick:(id)sender;

@property (weak) id<gameDelegate> gameDelegate;
@property int gameType;
@property int64_t gameScore;
@property (weak) MyScene* scene;

@end
