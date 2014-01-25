//
//  BedroomScene.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "BedroomScene.h"

@implementation BedroomScene
{
    
}

- (void)loadLevel {
    [self initBackground];
    [self initRoomBound:background.backgroundWidth];
    [self initObjects];
}

- (void)initBackground{
    background = [SceneBackground node];
    [self addChild:background];
    background.zPosition = -1;
    
    [background setTileList:@[@"BedroomDark", @"BedroomDark", @"BedroomDark", @"BedroomDark", @"BedroomDark"] LightVersion:nil];
}

- (void)initObjects {
    GameObject* toyBox = [GameObject spriteNodeWithImageNamed:@"ToyBox"];
    toyBox.dynamic = NO;
    toyBox.categoryBitMask = kCollisionBox;
    toyBox.collisionBitMask = kCollisionBox;
    toyBox.contactBitMask = kContactRoom;
    toyBox.position = CGPointMake(200, 50);
    
    [toyBox setParent:darkSideNode];
}

@end
