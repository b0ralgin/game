//
//  SimplePhysic.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "SimplePhysic.h"

static SimplePhysic* instance = nil;

static float const gravity = -1500;

@implementation SimplePhysic
{
    SKNode* rootNode;
    NSMutableArray* nodeList;
}
@synthesize contactDelegate = _contactDelegate;

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
        nodeList = [NSMutableArray new];
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
        
        flag = (prevLength > position);
        position = prevLength;
    }
    
    for (uint i = 0; i < nodeList.count; i++) {
        id element = nodeList[i];
        if (![[element class] isSubclassOfClass:[GameObject class]] && [element class] != [GameObject class]) {
            [nodeList removeObjectAtIndex:i];
            i--;
        }
    }
}

- (void)update:(NSTimeInterval)dt {
    if (dt > 0.04) {
        dt = 0.04;
    }
    
    for (uint i = 0; i < nodeList.count; i++) {
        GameObject* objI = nodeList[i];
        
        if (objI.dynamic) {
            objI.velocity = CGVectorMake(objI.velocity.dx, objI.velocity.dy + dt * gravity);
            objI.position = CGPointMake(objI.position.x + dt * objI.velocity.dx, objI.position.y + dt * objI.velocity.dy);
            objI.velocity = CGVectorMake(0.5*objI.velocity.dx, 0.8*objI.velocity.dy);
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
            obj1Rect.origin.x = obj1Rect.origin.x / [[UIScreen mainScreen] scale] - 0.5*obj1Rect.size.width;
            obj1Rect.origin.y = obj1Rect.origin.y / [[UIScreen mainScreen] scale] - 0.5*obj1Rect.size.height;
            
            obj2Rect.origin = [objJ convertPoint:objJ.position toNode:rootNode];
            obj2Rect.size = objJ.size;
            obj2Rect.origin = CGPointMake(obj2Rect.origin.x / [[UIScreen mainScreen] scale], obj2Rect.origin.y / [[UIScreen mainScreen] scale]);
            NSLog(@"%f %f %f %f", obj2Rect.origin.x, obj2Rect.origin.y, obj2Rect.size.width, obj2Rect.size.height);
            
            CGRect intersection = CGRectIntersection(obj1Rect, obj2Rect);
            if (CGRectIsEmpty(intersection)) {
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
                objOffset.dx = (obj1Rect.origin.x < obj2Rect.origin.x ? obj1Rect.origin.x + obj1Rect.size.width - obj2Rect.origin.x : obj1Rect.origin.x - obj2Rect.size.width - obj2Rect.origin.x);
                objOffset.dy = (obj1Rect.origin.y < obj2Rect.origin.y ? obj1Rect.origin.y + obj1Rect.size.height - obj2Rect.origin.y : obj1Rect.origin.y - obj2Rect.size.height - obj2Rect.origin.y);
                
                if (intersection.size.width >= MIN(obj1Rect.size.width, obj2Rect.size.width)) {
                    objOffset.dx = 0;
                }
                
                if (intersection.size.height >= MIN(obj1Rect.size.height, obj2Rect.size.height)) {
                    objOffset.dy = 0;
                }
                
                [self moveObj:objI WithOffset:CGVectorMake( objOffset.dx / dynObj,  objOffset.dy / dynObj)];
                [self moveObj:objJ WithOffset:CGVectorMake(-objOffset.dx / dynObj, -objOffset.dy / dynObj)];
            }
        }
    }
}

- (void)contactMessage:(GameObject*)obj1 And:(GameObject*)obj2 {
    [_contactDelegate contact:obj1 gameObjectB:obj2];
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
