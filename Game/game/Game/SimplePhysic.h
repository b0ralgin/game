//
//  SimplePhysic.h
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameObject.h"
#import "SimplePhysicContactDelegate.h"
@interface SimplePhysic : NSObject

+ (instancetype)sharedPhysic;
@property (weak, nonatomic) id <SimplePhysicContactDelegate> contactDelegate;

- (void)setRootNode:(SKNode*)root;
- (void)refreshNodeList;

- (void)update:(NSTimeInterval)dt;

@end
