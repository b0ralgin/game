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
    int _health,_damage, _speed;
    NSMutableArray* frames;
    NSArray* enemyFrames;
}
- (id)init:(NSString *)type health:(int)health damage:(int)damage {
    self = [super init];
    if (self) {
    frames = [NSMutableArray array];
    enemyFrames = [NSArray array];
    SKTextureAtlas* enemyAnimatedAtlas = [SKTextureAtlas atlasNamed:@"enemyImages"];
    for (int i=1; i< 5; i++) {
        NSLog(@"%@%d",type,i);
        NSString* textureName = [NSString stringWithFormat:@"%@%d",type,i];
        SKTexture *enemy = [enemyAnimatedAtlas textureNamed:textureName];
        [frames addObject:enemy];
    }
    enemyFrames = frames;
    SKTexture* firstFrame = enemyFrames[0];
    self.texture = firstFrame;
    }
    return self;
    
}
-(void) damage:(int)hit {
    
}
@end
