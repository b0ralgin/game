//
//  GameObject.h
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameObject : SKSpriteNode
{
    SKSpriteNode* lightCopy;
}

- (void)setCustomBodyRect:(CGRect)rect;
- (void)setParent:(SKNode*)parent;
- (void)setLightTexture:(SKTexture*)texture;
- (void)addAnimation:(NSArray*)animationList ByName:(NSString*)animationName;
- (void)startAnimation:(NSString*)animationName;
- (void)startLightAnimation:(NSString*)animationName;
- (void)setFall;
- (void)setGround;
- (CGRect)getRectOnNode:(SKNode*)node;

@property (assign, nonatomic) uint32_t contactBitMask;
@property (assign, nonatomic) uint32_t collisionBitMask;
@property (assign, nonatomic) uint32_t categoryBitMask;
@property (assign, nonatomic) BOOL dynamic;
@property (assign, nonatomic) CGVector velocity;

@end
