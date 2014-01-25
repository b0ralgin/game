//
//  ViewController.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController{
    NSMutableArray *gameLevelList;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
        // Create and configure the scene.
        CGSize size = CGSizeMake(1024, 768);
        CGSize sizeView =skView.bounds.size;
        SKScene * scene = [BedroomScene sceneWithSize:size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        // Present the scene.
        [skView presentScene:scene];
        
    }
}


-(void)initGameLevels{
    gameLevelList = [NSMutableArray new];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
-(void)runLevel:(int)levelNumber{
    SKView * skView = (SKView *)self.view;
    GameScene *nextLevel = gameLevelList[levelNumber];
    [skView presentScene:nextLevel];
}
@end
