//
//  Girl.m
//  Game
//
//  Created by Alexander Semenov on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Girl.h"
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

static NSString* const activeWeapon[] = {@"Active weapon.png"};

static CGVector const weaponOffset;

static NSTimeInterval const animationDelay = 0.05;
static float const moveSpeed = 15000;
static float const maxSpeed = 150;
static float const jumpPower = 7500;

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
    
    SKSpriteNode* weapon;
    
    GirlJumpStateType jumpState;
    GirlMoveStateType moveState;
    GirlAttackStateType attackState;
    
    uint32_t weaponCategoryMask;
    
    AVAudioRecorder *recorder;
    BOOL allowAttack;
    
    NSTimeInterval lastTime;
}

- (instancetype)init {
    self = [super initWithImageNamed:girlDarkStand[0]];
    
    if (self != nil) {
        self.size = CGSizeMake(100, 100);
        jumpState = GROUND_STATE;
        moveState = STAND_STATE;
        attackState = PASSIVE_STATE;
        
        recorder = nil;
        lastTime = 0;
        
        [self initTextures];
        //[self initWeapon];
        
        SKPhysicsBody* girlBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody = girlBody;
        girlBody.allowsRotation = NO;
        girlBody.dynamic = YES;
        girlBody.friction = 1.0;
        girlBody.restitution = 0.0;
        girlBody.mass = 30;
        
        [self startAnimation];
        [self startAudioRec];
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

- (void)initWeapon {
    weapon = [SKSpriteNode spriteNodeWithImageNamed:activeWeapon[0]];
    weapon.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:weapon.size];
    weapon.physicsBody.dynamic = NO;
    
    [self addChild:weapon];
    
    NSMutableArray* weaponAnimationList = [NSMutableArray new];
    for (ushort i = 0; i < 1; i++) {
        [weaponAnimationList addObject:[SKTexture textureWithImageNamed:activeWeapon[i]]];
    }
    
    SKAction* weaponAnimation = [SKAction animateWithTextures:weaponAnimationList timePerFrame:animationDelay];
    weaponAnimation = [SKAction repeatActionForever:weaponAnimation];
    [weapon runAction:weaponAnimation];
    
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
    
    if (darkTexList == nil || lightTexList == nil) {
        return;
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
        
        //double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
        //float lowPassResults = peakPowerForChannel;
        
        double avaragePowerForChannel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
        
        if (avaragePowerForChannel > 0.1) {
            [self beginAttack];
        }
        else {
            [self endAttack];
        }
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
    weaponCategoryMask = mask;
}

- (void)setWeaponCollisionBitMask:(uint32_t)mask {
    weapon.physicsBody.collisionBitMask = mask;
}

- (void)beginAttack {
    if (attackState == ATTACK_STATE && allowAttack) {
        return;
    }
    
    attackState = ATTACK_STATE;
    
    weapon.physicsBody.categoryBitMask = weaponCategoryMask;
    weapon.hidden = NO;
    
    [self startAnimation];
}

- (void)endAttack {
    if (attackState == PASSIVE_STATE) {
        return;
    }
    
    attackState = PASSIVE_STATE;
    
    weapon.physicsBody.categoryBitMask = 0;
    weapon.hidden = YES;
    
    [self startAnimation];
}

-(void)startAudioRec {
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

- (void)setXScale:(CGFloat)xScale {
    lightGirl.xScale = xScale;
    weapon.xScale = xScale;
    [super setXScale:xScale];
}

- (void)setPosition:(CGPoint)position {
    lightGirl.position = position;
    weapon.position = CGPointMake(self.position.x + self.xScale * weaponOffset.dx, self.position.y + weaponOffset.dy);
    [super setPosition:position];
}

@end
