//
//  SceneDirector.m
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "SceneDirector.h"
#import "ViewController.h"

@implementation SceneDirector{
    ViewController *_viewController;
}
static SceneDirector *instance = nil;

+(SceneDirector *) shared{
    if(instance == nil){
        instance = [[SceneDirector alloc] init];
    }
    return instance;
}


-(void)setViewController: (ViewController *) viewController{
    _viewController=viewController;
}

@end
