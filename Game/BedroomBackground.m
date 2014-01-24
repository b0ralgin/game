//
//  BedroomBackground.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "BedroomBackground.h"
static NSString *const tilesFilename = @"bedroom";
@implementation BedroomBackground{
    int _tileAmount;
}
-(instancetype)init
{
    if((self = [super init] )){
        _tileAmount = 4;
        for(uint i = 0; i<_tileAmount; i++){
            NSString *filename = [NSString stringWithFormat:@"bedroom%d.png",i];
            SKSpriteNode *tile = [SKSpriteNode spriteNodeWithImageNamed:filename];
            [self addChild:tile];
            tile.position = CGPointMake((i+1/2)*tile.size.width/2, tile.size.height/2);
        }
    }
    return self;
}
@end
