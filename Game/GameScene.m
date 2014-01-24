//
//  GameScene.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameScene.h"
static NSString *const leftButtonFilename = @"left_button.png";
static NSString *const rightButtonFilename = @"right_button.png";
static NSString *const jumpButtonFilename = @"jump_button.png";
@implementation GameScene{
    Girl *_girl;
    
    SKSpriteNode *_leftButton;
    SKSpriteNode *_rightButton;
    SKSpriteNode *_jumpButton;
    
    SKSpriteNode *_pressedButton;
}

-(instancetype)initWithSize:(CGSize)size
{
    if(( self = [super initWithSize:size] )){
        [self initRoomBound];
        [self initButtons];
    }
    return self;
}

-(void)initButtons{
    _leftButton = [SKSpriteNode spriteNodeWithImageNamed:leftButtonFilename];
    _leftButton.position = CGPointMake(100, 100);
    [self addChild:_leftButton];
    
    _rightButton = [SKSpriteNode spriteNodeWithImageNamed:rightButtonFilename];
    _rightButton.position = CGPointMake(200, 100);
    [self addChild:_rightButton];
    
    _jumpButton = [SKSpriteNode spriteNodeWithImageNamed:jumpButtonFilename];
    _jumpButton.position = CGPointMake(1800, 100);
    [self addChild:_jumpButton];
}

-(void)initRoomBound{
     SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(self.size.width, 1)];
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.position = CGPointMake(self.size.width/2, 0);
    [self addChild:floor];
    
    SKSpriteNode *ceiling = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(self.size.width, 1)];
    ceiling.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    ceiling.physicsBody.dynamic = NO;
    ceiling.position = CGPointMake(self.size.width/2, self.size.height);
    [self addChild:ceiling];
    
    SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(1, self.size.height)];
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.position = CGPointMake(0,self.size.height/2);
    [self addChild:leftWall];
    
    SKSpriteNode *rightWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(1, self.size.height)];
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    rightWall.physicsBody.dynamic = NO;
    rightWall.position = CGPointMake(self.size.width,self.size.height/2);
    [self addChild:rightWall];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
