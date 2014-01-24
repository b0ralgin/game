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
static NSString* const girlDarkFly[] = {@"Girl dark fly 1.png"};
static NSString* const girlDarkFall[] = {@"Girl dark fall 1.png"};
static NSString* const girlLightStand[] = {@"Girl light stand 1.png"};
static NSString* const girlLightMove[] = {@"Girl light move 1.png"};
static NSString* const girlLightFly[] = {@"Girl light fly 1.png"};
static NSString* const girlLightFall[] = {@"Girl light fall 1.png"};

static NSTimeInterval const animationDelay = 0.05;
static float const moveSpeed = 1;
static float const jumpPower = 5;

typedef enum {GROUND_STATE, FLY_STATE, FALL_STATE} GirlJumpStateType;
typedef enum {STAND_STATE, MOVE_STATE} GirlMoveStateType;
typedef enum {ATTACK_STATE, PASSIVE_STATE} GirlAttackStateType;

@implementation Girl {
    NSMutableArray* darkStand;
    NSMutableArray* darkMove;
    NSMutableArray* darkFly;
    NSMutableArray* darkFall;
    NSMutableArray* lightStand;
    NSMutableArray* lightMove;
    NSMutableArray* lightFly;
    NSMutableArray* lightFall;
    
    SKSpriteNode* lightGirl;
    SKSpriteNode* weapon;
    
    GirlJumpStateType jumpState;
    GirlMoveStateType moveState;
    GirlAttackStateType attackState;
}

- (instancetype)init {
    self = [super initWithImageNamed:girlDarkStand[0]];
    
    if (self != nil) {
        jumpState = GROUND_STATE;
        moveState = STAND_STATE;
        attackState = PASSIVE_STATE;
        
        lightGirl = [SKSpriteNode spriteNodeWithImageNamed:girlLightStand[0]];
        
        [self initTextures];
        
        SKTexture* tex = [darkStand firstObject];
        SKPhysicsBody* girlBody = [SKPhysicsBody bodyWithRectangleOfSize:tex.size];
        self.physicsBody = girlBody;
        girlBody.allowsRotation = NO;
        girlBody.dynamic = YES;
        
        [self startAnimation];
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
    
    darkFly = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [darkFly addObject:[SKTexture textureWithImageNamed:girlDarkFly[i]]];
    }
    
    darkFall = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [darkFall addObject:[SKTexture textureWithImageNamed:girlDarkFall[i]]];
    }
    
    lightStand = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [lightStand addObject:[SKTexture textureWithImageNamed:girlLightStand[i]]];
    }
    
    lightMove = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [lightMove addObject:[SKTexture textureWithImageNamed:girlLightMove[i]]];
    }
    
    lightFly = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [lightFly addObject:[SKTexture textureWithImageNamed:girlLightFly[i]]];
    }
    
    lightFall = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [lightFall addObject:[SKTexture textureWithImageNamed:girlLightFall[i]]];
    }
}

- (void)moveLeft {
    moveState = MOVE_STATE;
    
    self.xScale = -1;
    [self startAnimation];
}

- (void)moveRight {
    moveState = MOVE_STATE;
    
    self.xScale = 1;
    [self startAnimation];
}

- (void)stopMoving {
    moveState = STAND_STATE;
    
    [self startAnimation];
}

- (void)startAnimation {
    NSArray* darkTexList = nil;
    NSArray* lightTexList = nil;
    
    switch (jumpState) {
        case STAND_STATE:
            if (moveState == STAND_STATE && attackState == PASSIVE_STATE) {
                darkTexList = darkStand;
                lightTexList = lightStand;
            }
            
            if (moveState == MOVE_STATE && attackState == PASSIVE_STATE) {
                darkTexList = darkMove;
                lightTexList = lightMove;
            }
            
            break;
            
        case FLY_STATE:
            if (attackState == PASSIVE_STATE) {
                darkTexList = darkFly;
                lightTexList = lightFly;
            }
            
            break;
            
        case FALL_STATE:
            if (attackState == PASSIVE_STATE) {
                darkTexList = darkFall;
                lightTexList = lightFall;
            }
            
            break;
    }
    
    SKAction* darkAnimation = [SKAction animateWithTextures:darkTexList timePerFrame:animationDelay];
    SKAction* lightAnimation = [SKAction animateWithTextures:lightTexList timePerFrame:animationDelay];
    
    darkAnimation = [SKAction repeatActionForever:darkAnimation];
    lightAnimation = [SKAction repeatActionForever:lightAnimation];
    
    [self removeAllActions];
    [self runAction:darkAnimation];
    
    [lightGirl removeAllActions];
    [lightGirl runAction:lightAnimation];
}

- (void)update:(NSTimeInterval)dt {
    if (moveState == MOVE_STATE) {
        [self.physicsBody applyImpulse:CGVectorMake(self.xScale * moveSpeed * dt, 0)];
    }
    
    lightGirl.position = self.position;
    
    switch (jumpState) {
        case FALL_STATE:
            if (self.physicsBody.velocity.dy == 0) {
                jumpState = GROUND_STATE;
                [self startAnimation];
            }
            break;
            
        case FLY_STATE:
            if (self.physicsBody.velocity.dy <= 0) {
                jumpState = FALL_STATE;
                [self startAnimation];
            }
            break;
            
        default:
            break;
    }
}

- (void)jump {
    if (![self isStand]) {
        return;
    }
    
    [self.physicsBody applyImpulse:CGVectorMake(0, jumpPower)];
    jumpState = FLY_STATE;
}

- (void)setAdditionalSpriteParent:(SKNode*)parentNode {
    [lightGirl removeFromParent];
    [parentNode addChild:lightGirl];
}

- (void)startOpenDoorAnimation {
    self.xScale = 1;
    moveState = STAND_STATE;
    
    
}

- (BOOL)isStand {
    return (self.physicsBody.velocity.dy == 0 && jumpState == GROUND_STATE);
}

- (void)setWeaponContactBitMask:(uint32_t)mask {
    weapon.physicsBody.contactTestBitMask = mask;
}

- (void)setWeaponCategoryBitMask:(uint32_t)mask {
    
}

- (void)setWeaponCollisionBitMask:(uint32_t)mask {
    weapon.physicsBody.collisionBitMask = mask;
}

@end
