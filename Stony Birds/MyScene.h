//
//  MyScene.h
//  Stony Birds
//

//  Copyright (c) 2013 Jimmy Bouker. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum {
    square = 0,
    ball,
    hRect,
    vRect,
    pig
} ObectType;

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    NSMutableArray *pigTextures;
}

@property BOOL gameStarted;
@property ObectType objectType;

@end
