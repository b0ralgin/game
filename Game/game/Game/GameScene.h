//
//  GameScene.h
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Girl.h"
#import "Button.h"
#import "Mask.h"
#import "SceneBackground.h"
#import "SimplePhysic.h"
#import "Heart.h"

@interface GameScene : SKScene<GirlMovedDelegate, SimplePhysicContactDelegate> {
    SceneBackground *background;
    SKCropNode* darkSideNode;
}

- (void)loadLevel;
- (void)initRoomBound:(float)width;

@end
