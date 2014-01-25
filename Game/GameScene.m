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
}

-(instancetype)initWithSize:(CGSize)size
{
    if(( self = [super initWithSize:size] )){
<<<<<<< HEAD
        [self initRoomBound];
        [self initButtons];
=======
        [[SimplePhysic sharedPhysic] setRootNode:self];
        
        lastTime = 0;
        
        _backWall = [SKCropNode new];
        [self addChild:_backWall];
        
        [self initBackground];
        [self initRoomBound];
        [self initButtons];
      //  [self initEnemy];
        [self initTvEnemy];
        [self initBox];
        [self initGirl];
      //  self.position = CGPointMake(512, self.position.y);
        
        [[SimplePhysic sharedPhysic] refreshNodeList];
>>>>>>> f13aeffbcf580d1386c449556944c943d2892c41
    }
    return self;
}

<<<<<<< HEAD
-(void)initButtons{
    _leftButton = [SKSpriteNode spriteNodeWithImageNamed:leftButtonFilename];
=======

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
    Enemy* tvEnemy = [[Enemy alloc] init:@"tv" health:100 damage:5];
    [self addChild:tvEnemy];
    tvEnemy.position = CGPointMake(CGRectGetMidX(self.frame)+200,50);
    [tvEnemy move];
}

-(void) initBox {
    GameObject* box = [[GameObject alloc] initWithImageNamed:@"left_button.png"];
    box.position = CGPointMake(800, 40);
    box.size = CGSizeMake(50, 50);
    box.dynamic = NO;
    box.contactBitMask = kContactRoom;
    [self addChild:box];
}

-(void)initButtons{
    _leftButton = [Button spriteNodeWithImageNamed:leftButtonFilename];
    [self addChild:_leftButton];
>>>>>>> f13aeffbcf580d1386c449556944c943d2892c41
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
<<<<<<< HEAD
     SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(self.size.width, 1)];
    floor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    floor.physicsBody.dynamic = NO;
    floor.position = CGPointMake(self.size.width/2, 0);
    [self addChild:floor];
    
    SKSpriteNode *ceiling = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(self.size.width, 1)];
    ceiling.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    ceiling.physicsBody.dynamic = NO;
    ceiling.position = CGPointMake(self.size.width/2, self.size.height);
=======
    GameObject *floor = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(background.backgroundSize.width, 100)];
    floor.dynamic = NO;
    floor.position = CGPointMake(background.backgroundSize.width/2, 4-floor.size.height/2);
    floor.categoryBitMask = kColisionRoom;
    floor.collisionBitMask = kColisionRoom;
    floor.contactBitMask = kContactRoom;
    [self addChild:floor];
    
    GameObject *ceiling = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(background.backgroundSize.width, 4)];
    ceiling.dynamic = NO;
    ceiling.position = CGPointMake(background.backgroundSize.width/2, background.backgroundSize.height);
    ceiling.categoryBitMask = kColisionRoom;
    ceiling.collisionBitMask = kColisionRoom;
    ceiling.contactBitMask = kContactRoom;
>>>>>>> f13aeffbcf580d1386c449556944c943d2892c41
    [self addChild:ceiling];
    
    SKSpriteNode *leftWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(1, self.size.height)];
    leftWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    leftWall.physicsBody.dynamic = NO;
    leftWall.position = CGPointMake(0,self.size.height/2);
<<<<<<< HEAD
=======
    leftWall.categoryBitMask = kColisionRoom;
    leftWall.collisionBitMask = kColisionRoom;
    leftWall.contactBitMask = kContactRoom;
>>>>>>> f13aeffbcf580d1386c449556944c943d2892c41
    [self addChild:leftWall];
    
    SKSpriteNode *rightWall = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:10] size:CGSizeMake(1, self.size.height)];
    rightWall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:floor.size];
    rightWall.physicsBody.dynamic = NO;
    rightWall.position = CGPointMake(self.size.width,self.size.height/2);
<<<<<<< HEAD
    [self addChild:rightWall];
}
=======
    rightWall.categoryBitMask = kColisionRoom;
    rightWall.collisionBitMask = kColisionRoom;
    rightWall.contactBitMask = kContactRoom;
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
    float dt = (lastTime == 0)?0: currentTime - lastTime;
    lastTime =  currentTime;
    
    [_girl update:dt];
    [[SimplePhysic sharedPhysic] update:dt];
    /* Called before each frame is rendered */
}

-(void)contact:(GameObject *)gameObjectA gameObjectB:(GameObject *)gameObjectB{
    
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


>>>>>>> f13aeffbcf580d1386c449556944c943d2892c41
@end
