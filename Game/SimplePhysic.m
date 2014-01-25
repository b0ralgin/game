//
//  SimplePhysic.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "SimplePhysic.h"

static SimplePhysic* instance = nil;

static float const gravity = 0.5;

@implementation SimplePhysic
{
    SKNode* rootNode;
    NSMutableArray* nodeList;
}

+ (instancetype)sharedPhysic {
    if (instance == nil) {
        instance = [SimplePhysic new];
    }
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    
    if (self != nil) {
        rootNode = nil;
    }
    
    return self;
}

- (void)setRootNode:(SKNode *)root {
    rootNode = root;
}

- (void)refreshNodeList {
    [nodeList removeAllObjects];
    
    BOOL flag = YES;
    int position = -1;
    while (flag) {
        int prevLength = nodeList.count;
        
        if (position < 0) {
            [nodeList addObjectsFromArray:rootNode.children];
        }
        else {
            for (uint i = position; i < nodeList.count; i++) {
                [nodeList addObjectsFromArray:[nodeList[i] children]];
            }
        }
        
        for (uint i = prevLength; i < nodeList.count; i++) {
            id element = nodeList[i];
            if (![[element class] isSubclassOfClass:[GameObject class]] && [element class] != [GameObject class]) {
                [nodeList removeObjectAtIndex:i];
                i--;
            }
        }
        
        flag = (prevLength > position);
        position = prevLength;
    }
}

- (void)update:(NSTimeInterval)dt {
    for (uint i = 0; i < nodeList.count; i++) {
        GameObject* objI = nodeList[i];
        
        if (objI.dynamic) {
            objI.velocity = CGVectorMake(objI.velocity.dx, objI.velocity.dy + dt * gravity);
            objI.position = CGPointMake(objI.position.x + dt * objI.velocity.dx, objI.position.y + dt * objI.velocity.dy);
        }
        
        for (uint j = i+1; j < nodeList.count; j++) {
            GameObject* objJ = nodeList[j];
            
            if ((objI.categoryBitMask & objJ.categoryBitMask) == 0) {
                continue;
            }
            
            CGRect obj1Rect;
            CGRect obj2Rect;
            
            obj1Rect.origin = [objI convertPoint:objI.position toNode:rootNode];
            obj1Rect.size = objI.size;
            
            obj2Rect.origin = [objJ convertPoint:objJ.position toNode:rootNode];
            obj2Rect.size = objJ.size;
            
            CGRect unionRect = CGRectUnion(obj1Rect, obj2Rect);
            if (unionRect.size.width > obj1Rect.size.width + obj2Rect.size.width && unionRect.size.height > obj1Rect.size.height + obj2Rect.size.height) {
                continue;
            }
            
            if ((objI.contactBitMask & objJ.contactBitMask) != 0) {
                [self contactMessage:objI And:objJ];
            }
            
            if ((objI.collisionBitMask & objJ.collisionBitMask) != 0) {
                ushort dynObj = 0;
                dynObj += (objI.dynamic ? 1 : 0);
                dynObj += (objJ.dynamic ? 1 : 0);
                
                if (dynObj == 0) {
                    continue;
                }
                
                CGVector objOffset;
                objOffset.dx = obj1Rect.origin.x + 0.5*obj1Rect.size.width - obj2Rect.origin.x - 0.5*obj2Rect.size.width;
                objOffset.dy = obj1Rect.origin.y + 0.5*obj1Rect.size.height - obj2Rect.origin.y - 0.5*obj2Rect.size.height;
                
                [self moveObj:objI WithOffset:CGVectorMake( objOffset.dx / dynObj,  objOffset.dy / dynObj)];
                [self moveObj:objJ WithOffset:CGVectorMake(-objOffset.dx / dynObj, -objOffset.dy / dynObj)];
            }
        }
    }
}

- (void)contactMessage:(GameObject*)obj1 And:(GameObject*)obj2 {
    
}

- (void)moveObj:(GameObject*)obj WithOffset:(CGVector)offset {
    if (!obj.dynamic) {
        return;
    }
    
    obj.position = CGPointMake(obj.position.x - offset.dx, obj.position.y - offset.dy);
    if ((obj.velocity.dx > 0 && offset.dx > 0) || (obj.velocity.dx < 0 && offset.dx < 0)) {
        obj.velocity = CGVectorMake(0, obj.velocity.dy);
    }
    if ((obj.velocity.dy > 0 && offset.dy > 0) || (obj.velocity.dy < 0 && offset.dy < 0)) {
        obj.velocity = CGVectorMake(obj.velocity.dx, 0);
    }
}

@end
