//
//  SimplePhysicContactDelegate.h
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
@protocol SimplePhysicContactDelegate <NSObject>
@required
-(void)contact:(GameObject *) gameObjectA gameObjectB: (GameObject *) gameObjectB;
@end
