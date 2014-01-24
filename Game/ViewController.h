//
//  ViewController.h
//  Game
//

//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameScene.h"
#import "SceneDirector.h"
#import "MenuScene.h"
@interface ViewController : UIViewController
-(void)runLevel:(int)levelNumber;
@end
