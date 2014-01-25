//
//  Enemy.m
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Enemy.h"
#import "Mask.h"

const int kAnimationFrames = 6;

@implementation Enemy
{
    int _health,_damage, _speed;
    NSMutableArray* walkFrames;
    NSMutableArray* standFrames;
    NSMutableArray* actionFrames;
    SKTexture* deadFrame;
    SKTexture* ligthFrame;
    NSArray* enemyFrames;
}

-(void) loadTextures:(NSString*) name array:(NSMutableArray*) arrayOfTextures {
       NSMutableArray* frames = [NSMutableArray array];
    SKTextureAtlas* enemyAnimatedAtlas = [SKTextureAtlas atlasNamed:[[NSString alloc] initWithFormat:@"%@Images",name]];
    for (int i=1; i<=enemyAnimatedAtlas.textureNames.count; i++) {
        NSLog(@"type %@ %d",name,i);
        NSString* textureName = [NSString stringWithFormat:@"%@%d",name,i];
        SKTexture *enemy = [enemyAnimatedAtlas textureNamed:textureName];
        [arrayOfTextures addObject:enemy];
    }
}

- (id)init:(NSString *)type health:(int)health damage:(int)damage {
    self = [super initWithTexture:standFrames[0]];
    
    if (self != nil) {
        actionFrames = [[NSMutableArray alloc] init];
        standFrames = [[NSMutableArray alloc] init];
        walkFrames = [[NSMutableArray alloc] init];
        
        [self loadTextures:[[NSString alloc] initWithFormat:@"%@Stand",type] array:standFrames];
        [self loadTextures:[[NSString alloc] initWithFormat:@"%@Walk",type]  array:walkFrames];
        /*for (int i=0; i<=kAnimationFrames-3; i++) {
         [actionFrames addObject:frames[i]];
         }
         deadFrame = frames[kAnimationFrames-2];
         ligthFrame = frames[kAnimationFrames-1];
         SKTexture* firstFrame = frames[0];*/
        
        self.dynamic = YES;
        self.contactBitMask = kContactEnemy;
        self.collisionBitMask = kColisionEnemy;
        self.categoryBitMask = kColisionEnemy;
        
        _moveRigth = true;
    }
    
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
    [self removeAllActions];
   [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:standFrames timePerFrame:0.5 resize:NO restore:YES]] withKey:@"walkingEnemy" ];
}

-(void) move {
    _moveRigth =!_moveRigth;
    NSLog(@"moveR %d",_moveRigth);
    [self removeAllActions];
    [self runAction:[SKAction repeatActionForever:[SKAction moveByX:(_moveRigth?1:-1)*5 y:0 duration:0.1]]];
    [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:walkFrames timePerFrame:0.1 resize:NO restore:YES]] withKey:@"walkingEnemy" ];
}

-(void) lightOn {
    [self removeAllActions];
    self.texture = ligthFrame;
}
@end
