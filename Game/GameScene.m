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
    SKCropNode* _backWall;
    Girl* _girl;
    
    Button *_leftButton;
    Button *_rightButton;
    Button *_jumpButton;
    
    Button *_pressedButton;
    
    BOOL _isLightOn;
    
    BedroomBackground *background;
}

-(instancetype)initWithSize:(CGSize)size
{
    if(( self = [super initWithSize:size] )){
        
        self.physicsWorld.gravity = CGVectorMake(0, -5);
        
        _backWall = [SKCropNode new];
        [self addChild:_backWall];
        
        [self initBackground];
        [self initRoomBound];
        [self initButtons];
      //  [self initEnemy];
        [self initTvEnemy];
        [self initBox];
        [self initGirl];
        self.physicsWorld.contactDelegate = self;
      //  self.position = CGPointMake(512, self.position.y);
    }
    return self;
}


-(void)initBackground{
    background = [BedroomBackground node];
    [self addChild:background];
    background.zPosition = -1;
}

-(void)initGirl
{
    _girl = [[Girl alloc] init];
    _girl.position = CGPointMake(100, 400);
    
    _girl.zPosition = 1000;
    _girl.girlMovedDelegate = self;
    [_girl setParent:_backWall];
}

-(void) initEnemy{
   /* Enemy *enemy = [[Enemy alloc] init:@"enemy" health:1 damage:1];
    [self addChild:enemy];
    enemy.position = CGPointMake(CGRectGetMidX(self.frame) + 200,10);
    [enemy move];*/
}
-(void) initTvEnemy {
    Enemy* tvEnemy = [[Enemy alloc] init:@"tvStand" health:100 damage:5];
    [self addChild:tvEnemy];
    tvEnemy.position = CGPointMake(CGRectGetMidX(self.frame)+200,50);
    [tvEnemy stand];
    
}
-(void) initBox {
    SKSpriteNode* box = [[SKSpriteNode alloc] initWithImageNamed:@"left_button.png"];
    box.position = CGPointMake(800, 40);
    box.size = CGSizeMake(50, 50);
    box.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:box.size];
    box.physicsBody.dynamic = NO;
    box.physicsBody.contactTestBitMask = kContactRoom;
    [self addChild:box];
    
}

-(void)initButtons{
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
    
     SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(background.backgroundSize.width, 4)];
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.position = CGPointMake(background.backgroundSize.width/2, 0);
    [self addChild:floor];
    
    SKSpriteNode *ceiling = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(background.backgroundSize.width, 4)];
    ceiling.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ceiling.size];
    ceiling.physicsBody.dynamic = NO;
    ceiling.position = CGPointMake(background.backgroundSize.width/2, background.backgroundSize.height);
    [self addChild:ceiling];
    
    SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(4, background.backgroundSize.height)];
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:leftWall.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.position = CGPointMake(0,background.backgroundSize.height/2);
    [self addChild:leftWall];
    
    SKSpriteNode *rightWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(4, background.backgroundSize.height)];
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rightWall.size];
    rightWall.physicsBody.dynamic = NO;
    rightWall.position = CGPointMake(background.backgroundSize.width,background.backgroundSize.height/2);
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

-(void)girlMoveByX:(float)offsetX{
    if(fabs(offsetX) > 0){
        ;
    }
    //[self runAction:[SKAction moveByX:-offsetX y:0 duration:0]];
    
    //[_leftButton runAction:[SKAction moveByX:offsetX y:0 duration:0]];
   // [_rightButton runAction:[SKAction moveByX:offsetX y:0 duration:0]];
   // [_jumpButton runAction:[SKAction moveByX:offsetX y:0 duration:0]];
    background.position = CGPointMake(background.position.x - offsetX, background.position.y);
    [_girl runAction:[SKAction moveByX:offsetX y:0 duration:0]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    NSLog(@"%d",(contact.bodyA.contactTestBitMask & contact.bodyB.contactTestBitMask));
    if ((contact.bodyA.contactTestBitMask & contact.bodyB.contactTestBitMask)== 0b00001) {
        NSLog(@"damage");
    }
    
    Enemy* node;
    if ((contact.bodyA.contactTestBitMask & contact.bodyB.contactTestBitMask) ==0b10001) {
        if (contact.bodyA.contactTestBitMask == 17) {
            node = (Enemy*)contact.bodyA.node;
        } else {
            node = (Enemy*)contact.bodyB.node;
        }
    [node move];
    }
}


@end
