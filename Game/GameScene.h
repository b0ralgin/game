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
#import "BedroomBackground.h"
#import "SimplePhysic.h"

@interface GameScene : SKScene<GirlMovedDelegate,SimplePhysicContactDelegate>{
    
}

@end
