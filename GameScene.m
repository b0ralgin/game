//
//  GameScene.m
//  Game
//
//  Created by Akira Yamaoka on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene{

}
-(instancetype)initWithSize:(CGSize)size
{
    if(( self = [super initWithSize:size] )){
        [self initRoomBound];
    }
    return self;
}
-(void)initRoomBound{
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0] size:CGSizeMake(self.size.width, 2)];
}
@end
