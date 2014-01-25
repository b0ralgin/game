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

@implementation GameScene {
    Girl* _girl;

    BOOL _isLightOn;

    float lastTime;
    
    int _health;
    NSMutableArray *_heartList;
}

-(instancetype)initWithSize:(CGSize)size
{
    if (( self = [super initWithSize:size] )){
        [[SimplePhysic sharedPhysic] setRootNode:self];
        lastTime = 0;
        self.physicsWorld.gravity = CGVectorMake(0, -5);
        
        darkSideNode = [SKCropNode new];
        darkSideNode.zPosition = 100;
        [self addChild:darkSideNode];
        
        [self loadLevel];
        [self initGirl];
        [self initHealth];
      
        [[SimplePhysic sharedPhysic] refreshNodeList];
    }
    return self;
}

- (void)loadLevel {
    
}

-(void)damage:(int)damage{
    
    for(int i = _heartList.count-1; i>=0; i--)
    {
        Heart *heart = _heartList[i];
        damage = [heart damage:damage];
        if(damage<=0)
        {
            break;
        }
    }
    
    if(damage > 0){
        //DEFEAT
    }
        
}

-(void)initHealth{
    _health = 6;
    _heartList = [NSMutableArray new];

    
    for(uint i=0; i<3; i++){
        Heart *heart = [Heart node];
        [self addChild:heart];
        [_heartList addObject:heart];
        heart.position = CGPointMake((i+1)*70, 680);
    }
    [self damage:3];
}

-(void)initGirl
{
    _girl = [[Girl alloc] init];
    _girl.position = CGPointMake(100, 400);
    _girl.zPosition = 1000;
    _girl.delegate = self;
    [_girl setParent:darkSideNode];
}

-(void) initBox {
    GameObject* box = [[GameObject alloc] initWithImageNamed:@"left_button.png"];
    box.position = CGPointMake(800, 40);
    box.size = CGSizeMake(50, 50);
    box.dynamic = NO;
    box.contactBitMask = kContactRoom;
    box.categoryBitMask = kColisionRoom;
    box.collisionBitMask = kColisionRoom;
    [self addChild:box];
}

-(void)initRoomBound:(float)width {
    GameObject *floor = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(width, 100)];
    floor.dynamic = NO;
    floor.position = CGPointMake(width/2, -0.5*floor.size.height);
    floor.categoryBitMask = kColisionRoom;
    floor.collisionBitMask = kColisionRoom;
    floor.contactBitMask = kContactRoom;
    [self addChild:floor];
    
    GameObject *ceiling = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(width, 100)];
    ceiling.dynamic = NO;
    ceiling.position = CGPointMake(width/2, self.size.height + 0.5*floor.size.height);
    ceiling.categoryBitMask = kColisionRoom;
    ceiling.collisionBitMask = kColisionRoom;
    ceiling.contactBitMask = kContactRoom;
    [self addChild:ceiling];
    
    GameObject *leftWall = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(100, self.size.height)];
    leftWall.dynamic = NO;
    leftWall.position = CGPointMake(-0.5*leftWall.size.width, self.size.height/2);
    leftWall.categoryBitMask = kColisionRoom;
    leftWall.collisionBitMask = kColisionRoom;
    leftWall.contactBitMask = kContactRoom;
    [self addChild:leftWall];
    
    GameObject *rightWall = [GameObject spriteNodeWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] size:CGSizeMake(100, self.size.height)];
    rightWall.dynamic = NO;
    rightWall.position = CGPointMake(width + 0.5*rightWall.size.width, self.size.height/2);
    rightWall.categoryBitMask = kColisionRoom;
    rightWall.collisionBitMask = kColisionRoom;
    rightWall.contactBitMask = kContactRoom;
    [self addChild:rightWall];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    CGRect leftRect = CGRectMake(0, 0, 512, 384);
    CGRect rightRect = CGRectMake(512, 0, 512, 384);
    CGRect jumpRect = CGRectMake(0, 384, 1024, 384);
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (CGRectContainsPoint(leftRect, location)) {
            [_girl moveLeft];
        }
        if (CGRectContainsPoint(rightRect, location)) {
            [_girl moveRight];
        }
        if (CGRectContainsPoint(jumpRect, location)) {
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
            [_girl stopMoving];
    }
}

-(void)moveGirlTo:(CGPoint)position {
    //NSLog(@"%f", self.position.x);
    for(Heart *heart in _heartList){
        heart.position = CGPointMake(position.x - 400, heart.position.y);
    }
    
    [background moveBackground:position.x];
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


@end
