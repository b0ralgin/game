//
//  Girl.h
//  Game
//
//  Created by Alexander Semenov on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameObject.h"

@interface Girl : GameObject

- (void)moveLeft;
- (void)moveRight;
- (void)stopMoving;
- (void)update:(NSTimeInterval)dt;
- (void)jump;
- (void)startOpenDoorAnimation;
- (void)setWeaponContactBitMask:(uint32_t)mask;
- (void)setWeaponCategoryBitMask:(uint32_t)mask;
- (void)setWeaponCollisionBitMask:(uint32_t)mask;

@end
