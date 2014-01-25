//
//  BedroomBackground.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "SceneBackground.h"
#import "GameObject.h"

static NSString *const tilesFilename = @"bedroom";
static const float nearRatio = 0.1;
static const float farRatio = 0.25;

@implementation SceneBackground {
    NSMutableArray* tileSpriteList;
    
    NSMutableArray *nearParalaxList;
    NSMutableArray *farParalaxList;
    
    float backgroundWidth, xPos;
}

-(instancetype)init
{
    if ((self = [super init] )) {
        tileSpriteList = [NSMutableArray new];
        backgroundWidth = 0;
        xPos = 0;
    }
    
    return self;
}

- (void)setTileList:(NSArray *)tileList LightVersion:(NSArray *)tileLightList {
    for (SKNode* node in tileSpriteList) {
        [node removeFromParent];
    }
    
    [tileSpriteList removeAllObjects];
    
    NSMutableDictionary* tempAtlas = [NSMutableDictionary new];
    backgroundWidth = 0;
    xPos = 0;
    
    for (ushort i = 0; i < tileList.count; i++) {
        NSString* tileName = tileList[i];
        NSString* lightName = (tileLightList.count > i ? tileLightList[i] : tileName);
        
        SKTexture* tileTexture = [tempAtlas objectForKey:tileName];
        if (tileTexture == nil) {
            tileTexture = [SKTexture textureWithImageNamed:tileName];
            [tempAtlas setObject:tileTexture forKey:tileName];
        }
        
        SKTexture* tileLightTexture = [tempAtlas objectForKey:lightName];
        if (tileLightTexture == nil) {
            tileLightTexture = [SKTexture textureWithImageNamed:lightName];
            [tempAtlas setObject:tileLightTexture forKey:lightName];
        }
        
        GameObject* tileSprite = [GameObject spriteNodeWithTexture:tileTexture];
        [tileSprite setLightTexture:tileLightTexture];
        [tileSpriteList addObject:tileSprite];
        [self addChild:tileSprite];
        tileSprite.position = CGPointMake(backgroundWidth + 0.5*tileSprite.size.width, 0.5*tileSprite.size.height);
        
        backgroundWidth += tileSprite.size.width;
    }
}

- (float)backgroundWidth {
    return (1-nearRatio)*backgroundWidth;
}

- (void)moveBackground:(float)xPosition {
    float offset = xPosition - xPos;
    xPos = xPosition;
    
    for (SKNode* node in tileSpriteList) {
        node.position = CGPointMake(node.position.x - nearRatio*offset, node.position.y);
    }
}

@end
