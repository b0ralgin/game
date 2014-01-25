//
//  GirlMovedDelegate.h
//  Game
//
//  Created by Akira Yamaoka on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GirlMovedDelegate <NSObject>
@required
- (void)moveGirlTo:(CGPoint)position;

@end
