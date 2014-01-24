//
//  Enemy.m
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Enemy.h"

@implementation Enemy
{
    int _health,_damage,int _speed;
    NSMutableArray* _frames;
    NSArray* _enemyFrames;
}
- (id)init:(NSString *)type health:(int)health damage:(int)damage {
    self = [super init];
    if (self) {
    _frames = [NSMutableArray array];
    _enemyFrames = [NSMutableArray array];
    SKTextureAtlas* enemyAnimatedAtlas = [SKTextureAtlas atlasNamed:@"enemyImages"];
    for (int i=1; i< 5; i++) {
        NSLog(@"%@%d",type,i);
        NSString* textureName = [NSString stringWithFormat:@"%@%d",type,i];
        SKTexture *enemy = [enemyAnimatedAtlas textureNamed:textureName];
        [_frames addObject:enemy];
    }
        _enemyFrames = _frames;
    SKTexture* firstFrame = _enemyFrames[0];
    self.texture = firstFrame;
    }
    return self;
    
}
-(void) damage:(int)hit {
    
}
@end
