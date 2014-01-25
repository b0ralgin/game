//
//  Enemy.h
//  Game
//
//  Created by Enso on 24.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameObject.h"

@interface Enemy : GameObject

@property (assign,nonatomic) int damage;
@property (assign,nonatomic) int speed;
@property (assign,nonatomic) bool moveRigth;

-(void) lightOn;
-(id) init:(NSString*) type health:(int) health damage:(int) damage;
-(void) damage:(int) hit;
-(void) move;
-(void) stand;

@end
