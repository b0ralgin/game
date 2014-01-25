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
}

- (instancetype)initWithImageNamed:(NSString *)name {
    self = [super initWithImageNamed:name];
    
    if (self != nil) {
        lightCopy = [SKSpriteNode spriteNodeWithImageNamed:name];
        animationDictionary = [NSMutableDictionary new];
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

- (void)update:(NSTimeInterval)dt {
    lightCopy.position = self.position;
}

@end
