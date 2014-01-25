//
//  GameObject.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameObject.h"

static NSTimeInterval const animationDelay = 0.05;

@implementation GameObject
{
    NSMutableDictionary* animationDictionary;
    CGRect bodyRect;
}

- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    
    if (self != nil) {
        lightCopy = [SKSpriteNode spriteNodeWithImageNamed:name];
        animationDictionary = [NSMutableDictionary new];
        
        self.velocity = CGVectorMake(0, 0);
        bodyRect = CGRectNull;
    }
    
    return self;
}

- (instancetype)initWithTexture:(SKTexture *)texture {
    self = [super initWithTexture:texture];
    
    if (self != nil) {
        lightCopy = [SKSpriteNode spriteNodeWithTexture:texture];
        animationDictionary = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)removeFromParent {
    [lightCopy removeFromParent];
    [super removeFromParent];
}

- (void)addAnimation:(NSArray*)animationList ByName:(NSString*)animationName {
    [animationDictionary setObject:animationList forKey:animationName];
}

- (void)startAnimation:(NSString*)animationName {
    NSArray* animationList = [animationDictionary objectForKey:animationName];
    if (animationList == nil) {
        return;
    }
    
    SKAction* animation = [SKAction repeatActionForever:[SKAction animateWithTextures:animationList timePerFrame:animationDelay]];
    [self removeAllActions];
    [self runAction:animation];
}

- (void)startLightAnimation:(NSString*)animationName {
    NSArray* animationList = [animationDictionary objectForKey:animationName];
    if (animationList == nil) {
        return;
    }
    
    SKAction* animation = [SKAction repeatActionForever:[SKAction animateWithTextures:animationList timePerFrame:animationDelay]];
    [lightCopy removeAllActions];
    [lightCopy runAction:animation];
}

- (void)setParent:(SKNode *)parent {
    [parent addChild:self];
    //[[parent scene] addChild:lightCopy];
}

- (void)setLightTexture:(SKTexture *)texture {
    [lightCopy removeAllActions];
    lightCopy.texture = texture;
}

- (void)setPosition:(CGPoint)position {
    lightCopy.position = position;
    [super setPosition:position];
}

- (void)setCustomBodyRect:(CGRect)rect {
    bodyRect = rect;
}

- (void)setFall {
    
}

- (void)setGround {
    
}

- (CGRect)getRectOnNode:(SKNode *)node {
    float prevScale = self.xScale;
    self.xScale = 1;
    
    CGRect result;
    
    result.origin = [self convertPoint:self.position toNode:node];
    result.size = self.size;
    result.origin.x = result.origin.x / 2 - 0.5*result.size.width;
    result.origin.y = result.origin.y / 2 - 0.5*result.size.height;
    
    self.xScale = prevScale;
    
    if (CGRectIsEmpty(bodyRect)) {
        return result;
    }
    
    result.size = bodyRect.size;
    result.origin.x += bodyRect.origin.x;
    result.origin.y += bodyRect.origin.y;
    
    return result;
}

@end
