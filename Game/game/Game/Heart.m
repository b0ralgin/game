//
//  Heart.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "Heart.h"
static NSString *const emptyHeartFilename = @"emptyHeart.png";
static NSString *const halfHeartFilename = @"halfHeart.png";
static NSString *const fullHearttFilename = @"fullHeart.png";
static const int START_HP = 2;
@implementation Heart{
    int hp;
}
-(instancetype)init{
    if(( self = [super initWithImageNamed:fullHearttFilename]))
    {
        hp = START_HP;
    }
    return self;
}
-(int)damage:(int)damage{
    if(hp<1)
    {
        return damage;
    }
    else{
        int restDamage = damage - hp;
        hp-=damage;
        [self showAnimation];
        return restDamage;
    }
    
}
-(void)showAnimation{
    if(hp == 1)
    {
        SKTexture *halfHeartTexture = [SKTexture textureWithImageNamed:halfHeartFilename];
        self.texture = halfHeartTexture;
    }
    else if(hp < 1)
    {
        SKTexture *fullHeartTexture = [SKTexture textureWithImageNamed:emptyHeartFilename];
        self.texture = fullHeartTexture;
    }
}
@end
