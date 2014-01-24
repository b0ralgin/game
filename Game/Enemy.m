//
//  Enemy.m
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Enemy.h"
const int kAnimationFrames=6;
@implementation Enemy
{
    int _health,_damage, _speed;
    NSMutableArray* frames;
    NSMutableArray* actionFrames;
    SKTexture* deadFrame;
    SKTexture* ligthFrame;
    NSArray* enemyFrames;
}
- (id)init:(NSString *)type health:(int)health damage:(int)damage {
    frames = [NSMutableArray array];
    actionFrames = [[NSMutableArray alloc] init];
    SKTextureAtlas* enemyAnimatedAtlas = [SKTextureAtlas atlasNamed:@"enemyImages"];
    for (int i=1; i<=kAnimationFrames; i++) {
        NSLog(@"%@%d",type,i);
        NSString* textureName = [NSString stringWithFormat:@"%@%d",type,i];
        SKTexture *enemy = [enemyAnimatedAtlas textureNamed:textureName];
        [frames addObject:enemy];
    }
    for (int i=0; i<kAnimationFrames-3; i++) {
        [actionFrames addObject:frames[i]];
    }
    deadFrame = frames[kAnimationFrames-2];
    ligthFrame = frames[kAnimationFrames-1];
    SKTexture* firstFrame = frames[0];
    self = [super initWithTexture:firstFrame];
    return self;
}
-(void) damage:(int)hit {
    if (_health - _speed <=0) {
        _health = 0;
        [self removeAllActions];
        self.texture = deadFrame;
    }
}
-(void) move {
    [self runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:0.1 resize:NO restore:YES]] withKey:@"walkingEnemy" ];
}
-(void) lightOn {
    [self removeAllActions];
    self.texture = ligthFrame;
}
@end
