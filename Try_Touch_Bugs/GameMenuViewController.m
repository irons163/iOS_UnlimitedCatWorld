//
//  GameOverViewController.m
//  Easy_Dodge
//
//  Created by irons on 2015/7/3.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameMenuViewController.h"
//#import "CommonUtil.h"
#import "ViewController.h"

extern int UNLOCK_TOUCH_MULTI_CLEAR;
extern int UNLOCK_ZONE_CLEAR;
extern int UNLOCK_BLADE_CLEAR;

@interface GameMenuViewController ()

@end

@implementation GameMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.gameTimeLabel.text = [CommonUtil timeFormatted:self.gameTime];
//    [self.touchBtn.titleLabel setText:NSLocalizedString(@"touchMode", "")]; // not work
    [self.touchBtn setTitle:NSLocalizedString(@"touchMode", "")forState:UIControlStateNormal];
    self.touchBtn.titleLabel.numberOfLines = 0;
    self.touchBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.touchBtn.titleLabel sizeToFit];
    
    if(self.gameScore < UNLOCK_TOUCH_MULTI_CLEAR){
        self.touchMultiImage.image = [UIImage imageNamed:@"question_mark_horizental_btn"];
//        self.touchMultiBtn.titleLabel.text = @"500";
        [self.touchMultiBtn setTitle:[NSString stringWithFormat:@"%d %@",UNLOCK_TOUCH_MULTI_CLEAR, NSLocalizedString(@"modeUnlock", "")] forState:UIControlStateNormal];
        self.touchMultiBtn.titleLabel.numberOfLines = 0;
        self.touchMultiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.touchMultiBtn.titleLabel sizeToFit];
    }else{
        self.touchMultiImage.image = [UIImage imageNamed:@"touch_multi_btn"];
//        self.touchMultiBtn.titleLabel.text = @"500";
        [self.touchMultiBtn setTitle:NSLocalizedString(@"touchMultiMode", "")  forState:UIControlStateNormal];
        self.touchMultiBtn.titleLabel.numberOfLines = 0;
        self.touchMultiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.touchMultiBtn.titleLabel sizeToFit];
    }
    
    if(self.gameScore < UNLOCK_ZONE_CLEAR){
        self.zoneImage.image = [UIImage imageNamed:@"question_mark_horizental_btn"];
//        self.zoneBtn.titleLabel.text = NSLocalizedString(@"5000 Unlocked", "");
         [self.zoneBtn setTitle:[NSString stringWithFormat:@"%d %@",UNLOCK_ZONE_CLEAR, NSLocalizedString(@"modeUnlock", "")] forState:UIControlStateNormal];
        self.zoneBtn.titleLabel.numberOfLines = 0;
        self.zoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.zoneBtn.titleLabel sizeToFit];
    }else{
        self.zoneImage.image = [UIImage imageNamed:@"zone_btn"];
//        self.zoneBtn.titleLabel.text = NSLocalizedString(@"5000 Unlocked", "");
         [self.zoneBtn setTitle:NSLocalizedString(@"zoneMode", "") forState:UIControlStateNormal];
        self.zoneBtn.titleLabel.numberOfLines = 0;
        self.zoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.zoneBtn.titleLabel sizeToFit];
    }
    
    if(self.gameScore < UNLOCK_BLADE_CLEAR){
        self.BladeImage.image = [UIImage imageNamed:@"question_mark_horizental_btn"];
//        self.bladeBtn.titleLabel.text = NSLocalizedString(@"5000 Unlocked", "");
         [self.bladeBtn setTitle:[NSString stringWithFormat:@"%d %@",UNLOCK_BLADE_CLEAR, NSLocalizedString(@"modeUnlock", "")] forState:UIControlStateNormal];
        self.bladeBtn.titleLabel.numberOfLines = 0;
        self.bladeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.bladeBtn.titleLabel sizeToFit];
    }else{
        self.BladeImage.image = [UIImage imageNamed:@"blade_btn"];
//        self.bladeBtn.titleLabel.text = NSLocalizedString(@"5000 Unlocked", "");
         [self.bladeBtn setTitle:NSLocalizedString(@"bladeMode", "") forState:UIControlStateNormal];
        self.bladeBtn.titleLabel.numberOfLines = 0;
        self.bladeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bladeBtn.titleLabel sizeToFit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)restartClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
        [self.gameDelegate restartGame];
    }];
}

-(void)changeToTouchClick:(id)sender{
    [self.scene setClearType:0];
    [self backClick:nil];
}

-(void)changeToZoneClick:(id)sender{
    if(self.gameScore < UNLOCK_ZONE_CLEAR)
        return;
    [self.scene setClearType:1];
    [self backClick:nil];
}

-(void)changeToBladeClick:(id)sender{
    if(self.gameScore < UNLOCK_BLADE_CLEAR)
        return;
    [self.scene setClearType:2];
    [self backClick:nil];
}

-(void)changeToTouchMultiClick:(id)sender{
    if(self.gameScore < UNLOCK_TOUCH_MULTI_CLEAR)
        return;
    [self.scene setClearType:3];
    [self backClick:nil];
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:^{
     
    }];
}

@end
