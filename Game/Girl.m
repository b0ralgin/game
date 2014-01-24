//
//  Girl.m
//  Game
//
//  Created by Alexander Semenov on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Girl.h"

static NSString* const girlDarkStand[] = {@"Girl dark stand 1.png"};
static NSString* const girlDarkMove[] = {@"Girl dark move 1.png"};
static NSString* const girlLightStand[] = {@"Girl light stand 1.png"};
static NSString* const girlLightMove[] = {@"Girl light move 1.png"};

static NSTimeInterval const animationDelay = 0.05;

@implementation Girl {
    NSMutableArray* darkStand;
    NSMutableArray* darkMove;
    NSMutableArray* lightStand;
    NSMutableArray* lightMove;
    
    SKSpriteNode* lightGirl;
}

- (instancetype)init {
    self = [super initWithImageNamed:girlDarkStand[0]];
    
    if (self != nil) {
        lightGirl = [SKSpriteNode spriteNodeWithImageNamed:girlLightStand[0]];
        
        [self initTextures];
        
        SKTexture* tex = [darkStand firstObject];
        SKPhysicsBody* girlBody = [SKPhysicsBody bodyWithRectangleOfSize:tex.size];
        self.physicsBody = girlBody;
        girlBody.allowsRotation = NO;
        girlBody.dynamic = YES;
        
        [self stopMoving];
    }
    
    return self;
}

- (void)initTextures {
    darkStand = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [darkStand addObject:[SKTexture textureWithImageNamed:girlDarkStand[i]]];
    }
    
    darkMove = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [darkMove addObject:[SKTexture textureWithImageNamed:girlDarkMove[i]]];
    }
    
    lightStand = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [lightStand addObject:[SKTexture textureWithImageNamed:girlLightStand[i]]];
    }
    
    lightMove = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [lightMove addObject:[SKTexture textureWithImageNamed:girlLightMove[i]]];
    }
}

- (void)moveLeft {
    self.xScale = -1;
    
    [self startAnimation:darkMove AndLight:lightMove];
}

- (void)moveRight {
    self.xScale = 1;
    
    [self startAnimation:darkMove AndLight:lightMove];
}

- (void)stopMoving {
    [self startAnimation:darkStand AndLight:lightStand];
}

- (void)startAnimation:(NSArray*)darkTextureList AndLight:(NSArray*)lightTextureList {
    SKAction* darkAnimation = [SKAction animateWithTextures:darkTextureList timePerFrame:animationDelay];
    SKAction* lightAnimation = [SKAction animateWithTextures:lightTextureList timePerFrame:animationDelay];
    
    darkAnimation = [SKAction repeatActionForever:darkAnimation];
    lightAnimation = [SKAction repeatActionForever:lightAnimation];
    
    [self removeAllActions];
    [self runAction:darkAnimation];
    
    [lightGirl removeAllActions];
    [lightGirl runAction:lightAnimation];
}

- (void)update:(NSTimeInterval)dt {
    
    lightGirl.position = self.position;
}

- (void)jump {
    
}

- (void)setAdditionalSpriteParent:(SKNode*)parentNode {
    [lightGirl removeFromParent];
    [parentNode addChild:lightGirl];
}

- (void)startOpenDoorAnimation {
    
}

@end
