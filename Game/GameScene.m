//
//  GameScene.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameScene.h"
#import "Enemy.h"
static NSString *const leftButtonFilename = @"left_button.png";
static NSString *const rightButtonFilename = @"right_button.png";
static NSString *const jumpButtonFilename = @"jump_button.png";



@implementation GameScene{
    Girl *_girl;
    
    Button *_leftButton;
    Button *_rightButton;
    Button *_jumpButton;
    
    Button *_pressedButton;
    
    
    BOOL _isTurnLampOn;
}

-(instancetype)initWithSize:(CGSize)size
{
    if(( self = [super initWithSize:size] )){
        
        self.physicsWorld.gravity = CGVectorMake(0, -3);
        
        [self initRoomBound];
        [self initButtons];
        [self initEnemy];
        [self initGirl];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"Hello, World!";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        [self addChild:myLabel];
    }
    return self;
}

-(void)initGirl
{
    _girl = [[Girl alloc] init];
    _girl.position = CGPointMake(CGRectGetMidX(self.frame),
                                 CGRectGetMidY(self.frame));
    [self addChild:_girl];
}

-(void) initEnemy{
    Enemy *enemy = [[Enemy alloc] init:@"enemy" health:1 damage:1];
    [self addChild:enemy];
    enemy.position = CGPointMake(500,500);
}

-(void)initButtons{
    NSLog(@"gdsfgf");
    _leftButton = [Button spriteNodeWithImageNamed:leftButtonFilename];
      [self addChild:_leftButton];
    _leftButton.position = CGPointMake(100, 100);
 
    _leftButton.tag = 1;
    
    _rightButton = [Button spriteNodeWithImageNamed:rightButtonFilename];
    _rightButton.position = CGPointMake(220, 100);
    [self addChild:_rightButton];
    _rightButton.tag = 2;
    
    _jumpButton = [Button spriteNodeWithImageNamed:jumpButtonFilename];
    _jumpButton.position = CGPointMake(900, 100);
    [self addChild:_jumpButton];
     _rightButton.tag = 3;
}

-(void)initRoomBound{
     SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(self.size.width, 4)];
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.position = CGPointMake(self.size.width/2, 0);
    [self addChild:floor];
    
    SKSpriteNode *ceiling = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(self.size.width, 4)];
    ceiling.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    ceiling.physicsBody.dynamic = NO;
    ceiling.position = CGPointMake(self.size.width/2, self.size.height);
    [self addChild:ceiling];
    
    SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(4, self.size.height)];
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.position = CGPointMake(0,self.size.height/2);
    [self addChild:leftWall];
    
    SKSpriteNode *rightWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(4, self.size.height)];
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    rightWall.physicsBody.dynamic = NO;
    rightWall.position = CGPointMake(self.size.width,self.size.height/2);
    [self addChild:rightWall];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([[self nodesAtPoint:location] containsObject:_leftButton]) {
            [_girl moveLeft];
        }
        
        if ([[self nodesAtPoint:location] containsObject:_rightButton]) {
            [_girl moveRight];
        }
        
        if ([[self nodesAtPoint:location] containsObject:_jumpButton]) {
            [_girl jump];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    [_girl stopMoving];
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if ([[self nodesAtPoint:location] containsObject:_leftButton]) {
            [_girl stopMoving];
        }
        
        if ([[self nodesAtPoint:location] containsObject:_rightButton]) {
            [_girl stopMoving];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [_girl update:currentTime];
    /* Called before each frame is rendered */
}

@end
