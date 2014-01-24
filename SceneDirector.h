//
//  SceneDirector.h
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViewController;

@interface SceneDirector : NSObject
+(SceneDirector *) shared;
-(void)setViewController: (ViewController *) viewController;
-(void)runNextLevel;
@end
