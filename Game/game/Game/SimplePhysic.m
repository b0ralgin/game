//
//  SimplePhysic.m
//  Game
//
//  Created by Alexander Semenov on 25.01.14.
//  Copyright (c) 2014 AppBit. All rights reserved.
//

#import "SimplePhysic.h"

static SimplePhysic* instance = nil;

static float const gravity = -5;

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
    
    for (GameObject* obj in nodeList) {
        if (obj.dynamic) {
            obj.velocity = CGVectorMake(obj.velocity.dx, obj.velocity.dy + gravity);
            obj.position = CGPointMake(obj.position.x + obj.velocity.dx, obj.position.y + obj.velocity.dy);
            obj.velocity = CGVectorMake(0.0*obj.velocity.dx, 0.0*obj.velocity.dy);
        }
    }
    
    for (uint i = 0; i < nodeList.count; i++) {
        for (uint j = i+1; j < nodeList.count; j++) {
            GameObject* objI = nodeList[i];
            GameObject* objJ = nodeList[j];
            
            if ((objI.categoryBitMask & objJ.categoryBitMask) == 0) {
                continue;
            }
            
            CGRect obj1Rect = [objI getRectOnNode:rootNode];
            CGRect obj2Rect = [objJ getRectOnNode:rootNode];
            
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
    
    if (offset.dy < 0) {
        [obj setGround];
    }
    
    if (offset.dy > 0) {
        [obj setFall];
    }
    
    obj.position = CGPointMake(obj.position.x - offset.dx, obj.position.y - offset.dy);
    if ((obj.velocity.dx > 0 && offset.dx > 0) || (obj.velocity.dx < 0 && offset.dx < 0)) {
        obj.velocity = CGVectorMake(0, obj.velocity.dy);
    }
    if ((obj.velocity.dy > 0 && offset.dy > 0) || (obj.velocity.dy < 0 && offset.dy < 0)) {
        obj.velocity = CGVectorMake(obj.velocity.dx, 0);
    }
    
    obj.position = CGPointMake(obj.position.x + obj.velocity.dx, obj.position.y + obj.velocity.dy);
    obj.velocity = CGVectorMake(0.0, 0.0);
}

@end
