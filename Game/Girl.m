//
//  Girl.m
//  Game
//
//  Created by Alexander Semenov on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Girl.h"
#import "Mask.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

static NSString* const girlDarkStand[] = {@"girl.png"};
static NSString* const girlDarkMove[] = {@"girl.png"};
static NSString* const girlDarkFly[] = {@"girl.png"};
static NSString* const girlDarkFall[] = {@"girl.png"};
static NSString* const girlLightStand[] = {@"girl.png"};
static NSString* const girlLightMove[] = {@"girl.png"};
static NSString* const girlLightFly[] = {@"girl.png"};
static NSString* const girlLightFall[] = {@"girl.png"};

static NSString* const activeWeapon[] = {@"girl.png"};

static NSString* const darkStandAnimationName = @"Dark stand";
static NSString* const darkMoveAnimationName = @"Dark stand";
static NSString* const darkFlyAnimationName = @"Dark stand";
static NSString* const darkFalLAnimationName = @"Dark stand";
static NSString* const lightStandAnimationName = @"Dark stand";
static NSString* const lightMoveAnimationName = @"Dark stand";
static NSString* const lightFlyAnimationName = @"Dark stand";
static NSString* const lightFallAnimationName = @"Dark stand";

static CGPoint const weaponOffset = {60, -40};

static NSTimeInterval const animationDelay = 0.05;
static float const moveSpeed = 15000;
static float const maxSpeed = 150;
static float const jumpPower = 7500;

typedef enum {GROUND_STATE, FLY_STATE, FALL_STATE} GirlJumpStateType;
typedef enum {STAND_STATE, MOVE_STATE} GirlMoveStateType;
typedef enum {ATTACK_STATE, PASSIVE_STATE} GirlAttackStateType;

@implementation Girl {
    GameObject* weapon;
    
    GirlJumpStateType jumpState;
    GirlMoveStateType moveState;
    GirlAttackStateType attackState;
    
    uint32_t weaponCategoryMask;
    
    AVAudioRecorder *recorder;
    BOOL allowAttack;
    
    NSTimeInterval lastTime;
    
    float lastX;
}

- (instancetype)init {
    self = [super initWithImageNamed:girlDarkStand[0]];
    
    if (self != nil) {
        self.size = CGSizeMake(150, 150);
        
        jumpState = GROUND_STATE;
        moveState = STAND_STATE;
        attackState = PASSIVE_STATE;
        
        allowAttack = YES;
        recorder = nil;
        lastTime = 0;
        
        [self initTextures];
        [self initWeapon];
        
        self.contactBitMask = kContactGirl;
        self.collisionBitMask = kColisionGirl;
        self.categoryBitMask = kColisionGirl;
        self.dynamic = YES;
        
        [self startAnimation];
        [self startAudioRec];
        
        lastX=0;
    }
    
    return self;
}

- (void)initTextures {
    NSMutableArray* animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkStand[i]]];
        [self addAnimation:animationList ByName:darkStandAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkMove[i]]];
        [self addAnimation:animationList ByName:darkMoveAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkFly[i]]];
        [self addAnimation:animationList ByName:darkFlyAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlDarkFall[i]]];
        [self addAnimation:animationList ByName:darkFalLAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightStand[i]]];
        [self addAnimation:animationList ByName:lightStandAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightMove[i]]];
        [self addAnimation:animationList ByName:lightMoveAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightFly[i]]];
        [self addAnimation:animationList ByName:lightFlyAnimationName];
    }
    
    animationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [animationList addObject:[SKTexture textureWithImageNamed:girlLightFall[i]]];
        [self addAnimation:animationList ByName:lightFallAnimationName];
    }
}

- (void)initWeapon {
    weapon = [GameObject spriteNodeWithImageNamed:activeWeapon[0]];
    weapon.size = CGSizeMake(100, 30);
    weapon.dynamic = NO;
    weapon.position = weaponOffset;
    
    [self addChild:weapon];
    
    NSMutableArray* weaponAnimationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [weaponAnimationList addObject:[SKTexture textureWithImageNamed:activeWeapon[i]]];
    }
    
    SKAction* weaponAnimation = [SKAction animateWithTextures:weaponAnimationList timePerFrame:animationDelay];
    weaponAnimation = [SKAction repeatActionForever:weaponAnimation];
    [weapon runAction:weaponAnimation];
    
    attackState = ATTACK_STATE;
    [self endAttack];
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
    switch (jumpState) {
        case STAND_STATE:
            if (moveState == STAND_STATE && attackState == PASSIVE_STATE) {
                [self startAnimation:darkStandAnimationName];
                [self startLightAnimation:lightStandAnimationName];
            }
            
            if (moveState == MOVE_STATE && attackState == PASSIVE_STATE) {
                [self startAnimation:darkMoveAnimationName];
                [self startLightAnimation:lightMoveAnimationName];
            }
            
            break;
            
        case FLY_STATE:
            if (attackState == PASSIVE_STATE) {
                [self startAnimation:darkFlyAnimationName];
                [self startLightAnimation:lightFlyAnimationName];
            }
            
            break;
            
        case FALL_STATE:
            if (attackState == PASSIVE_STATE) {
                [self startAnimation:darkFalLAnimationName];
                [self startLightAnimation:lightFallAnimationName];
            }
            
            break;
    }
}

- (void)update:(NSTimeInterval)dt {
    if (lastTime == 0) {
        lastTime = dt;
        return;
    }
    
    NSTimeInterval time = dt - lastTime;
    lastTime = dt;
    
    if (moveState == MOVE_STATE) {
        [self.physicsBody applyImpulse:CGVectorMake(self.xScale * moveSpeed * time, 0)];
    }
    
    if (self.physicsBody.velocity.dx > maxSpeed) {
        self.physicsBody.velocity = CGVectorMake(maxSpeed, self.physicsBody.velocity.dy);
       
    }
    
    if (self.physicsBody.velocity.dx < -maxSpeed) {
        self.physicsBody.velocity = CGVectorMake(-maxSpeed, self.physicsBody.velocity.dy);
        
    }
    
    switch (jumpState) {
        case FALL_STATE:
            if (self.physicsBody.velocity.dy == 0) {
                jumpState = GROUND_STATE;
                [self startAnimation];
            }
            
            if (self.physicsBody.velocity.dy > 0) {
                self.physicsBody.velocity = CGVectorMake(self.physicsBody.velocity.dx, 0);
            }
            
            break;
            
        case GROUND_STATE:
        case FLY_STATE:
            if (self.physicsBody.velocity.dy < 0) {
                jumpState = FALL_STATE;
                [self startAnimation];
            }
            
            break;
    }
    
    if (recorder != nil) {
        [recorder updateMeters];
        
        //double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
        
        double avaragePowerForChannel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
        
        if (avaragePowerForChannel > 0.045) {
            [self beginAttack];
        }
        else {
            [self endAttack];
        }
    }
    
   float currentX = self.position.x;
    [_girlMovedDelegate girlMoveByX:currentX - lastX];
    lastX = currentX;
}

- (void)jump {
    if (![self isStand]) {
        return;
    }
    
    [self.physicsBody applyImpulse:CGVectorMake(0, jumpPower)];
    jumpState = FLY_STATE;
}

- (void)startOpenDoorAnimation {
    self.xScale = 1;
    moveState = STAND_STATE;
    
    
}

- (BOOL)isStand {
    return (self.velocity.dy == 0 && jumpState == GROUND_STATE);
}

- (void)setWeaponContactBitMask:(uint32_t)mask {
    weapon.contactBitMask = mask;
}

- (void)setWeaponCategoryBitMask:(uint32_t)mask {
    weaponCategoryMask = mask;
}

- (void)setWeaponCollisionBitMask:(uint32_t)mask {
    weapon.collisionBitMask = mask;
}

- (void)beginAttack {
    if (attackState == ATTACK_STATE || !allowAttack) {
        return;
    }
    
    attackState = ATTACK_STATE;
    
    weapon.categoryBitMask = weaponCategoryMask;
    weapon.hidden = NO;
    
    [self startAnimation];
}

- (void)endAttack {
    if (attackState == PASSIVE_STATE) {
        return;
    }
    
    attackState = PASSIVE_STATE;
    
    weapon.categoryBitMask = 0;
    weapon.hidden = YES;
    
    [self startAnimation];
}

- (void)startAudioRec {
    allowAttack = YES;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
	NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
							  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
							  [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
							  [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
							  nil];
    
	NSError *error;
    
	recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
	if (recorder) {
		[recorder prepareToRecord];
		recorder.meteringEnabled = YES;
		[recorder record];
	}
    else {
        NSLog(@"audio error - %@", [error description]);
    }
}

- (void)stopAttack {
    [self endAttack];
    allowAttack = NO;
    [recorder stop];
}

- (void)resumeAttack {
    allowAttack = YES;
    [recorder record];
}

- (void)setXScale:(CGFloat)xScale {
    lightCopy.xScale = xScale;
    [super setXScale:xScale];
}

@end
