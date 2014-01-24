//
//  Enemy.h
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Enemy : SKSpriteNode
{
}
@property (assign,nonatomic) int damage;
-(void) lightOn;
-(id) init:(NSString*) type health:(int) health damage:(int) damage;
-(void) damage:(int) hit;

@end
