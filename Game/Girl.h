//
//  Girl.h
//  Game
//
//  Created by Alexander Semenov on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameObject.h"
#import "GirlMovedDelegate.h"
@interface Girl : GameObject
@property id <GirlMovedDelegate> girlMovedDelegate;
- (void)moveLeft;
- (void)moveRight;
- (void)stopMoving;
- (void)jump;
- (void)startOpenDoorAnimation;
- (void)setWeaponContactBitMask:(uint32_t)mask;
- (void)setWeaponCategoryBitMask:(uint32_t)mask;
- (void)setWeaponCollisionBitMask:(uint32_t)mask;
- (void)stopAttack;
- (void)resumeAttack;
- (void)update:(NSTimeInterval)dt;

@end
