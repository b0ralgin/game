//
//  BedroomBackground.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "BedroomBackground.h"
static NSString *const tilesFilename = @"bedroomTile";
@implementation BedroomBackground{
    int _tileAmount;
}
-(instancetype)init
{
    if((self = [super init] )){
        _tileAmount = 4;
        for(uint i = 0; i<_tileAmount; i++){
            
        }
    }
    return self;
}
@end
