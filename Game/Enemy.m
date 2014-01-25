//
//  Enemy.m
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Enemy.h"
#import "Mask.h"
const int kAnimationFrames=6;
@implementation Enemy
{
    int _health,_damage, _speed;
    NSMutableArray* frames;
    NSMutableArray* actionFrames;
    NSMutableArray* standFrames;
    SKTexture* deadFrame;
    SKTexture* ligthFrame;
    NSArray* enemyFrames;
}
- (id)init:(NSString *)type health:(int)health damage:(int)damage {
    frames = [NSMutableArray array];
    actionFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas* enemyAnimatedAtlas = [SKTextureAtlas atlasNamed:[[NSString alloc] initWithFormat:@"%@Images",type]];
    for (int i=1; i<=enemyAnimatedAtlas.textureNames.count; i++) {
        NSLog(@"%@%d",type,i);
        NSString* textureName = [NSString stringWithFormat:@"%@%d",type,i];
        SKTexture *enemy = [enemyAnimatedAtlas textureNamed:textureName];
        [frames addObject:enemy];
    }
    /*for (int i=0; i<=kAnimationFrames-3; i++) {
        [actionFrames addObject:frames[i]];
    }
    deadFrame = frames[kAnimationFrames-2];
    ligthFrame = frames[kAnimationFrames-1];
    SKTexture* firstFrame = frames[0];*/
    standFrames = frames;
    self = [super initWithTexture:frames[0]];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.restitution =0;
    self.physicsBody.friction =NO;
    self.physicsBody.contactTestBitMask = kContactEnemy;
    self.physicsBody.collisionBitMask = kColisionEnemy;
    self.physicsBody.categoryBitMask = kColisionEnemy;
    
    self.physicsBody.usesPreciseCollisionDetection = YES;

    _moveRigth = true;
    return self;
}
-(void) damage:(int)hit {
    if (_health - _speed <=0) {
        _health = 0;
        [self removeAllActions];
        self.texture = deadFrame;
    }
}
-(void) stand {
   [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:standFrames timePerFrame:0.5 resize:NO restore:YES]] withKey:@"walkingEnemy" ];
}
-(void) move {
    _moveRigth =!_moveRigth;
    NSLog(@"moveR %d",_moveRigth);
    [self removeAllActions];
    //[self.physicsBody applyImpulse:CGVectorMake(,0)];
    [self runAction:[SKAction repeatActionForever:[SKAction moveByX:(_moveRigth?1:-1)*5 y:0 duration:0.1]]];
    [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:actionFrames timePerFrame:0.5 resize:NO restore:YES]] withKey:@"walkingEnemy" ];
}
-(void) lightOn {
    [self removeAllActions];
    self.texture = ligthFrame;
}
@end
