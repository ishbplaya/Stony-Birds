//
//  MyScene.m
//  Stony Birds
//
//  Created by Jimmy on 9/22/13.
//  Copyright (c) 2013 Jimmy Bouker. All rights reserved.
//

#import "MyScene.h"

#define PI              3.14159265359


#define BALL_CATEGORY   (0x00000001)
#define PIG_CATEGORY    ((0x00000001)<<1)
#define BLOCK_CATEGORY  ((0x00000001)<<2)

#define SCALE           4.0

@implementation MyScene {
    NSMutableDictionary *particles;
}
@synthesize objectType, gameStarted;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        particles = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [SKColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        pigTextures = [[NSMutableArray alloc] init];
        for(int i=1; i<3; i++)
            [pigTextures addObject:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"pig%d",i]]];
        
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        
        NSLog(@"Ball %d\nPig %d\nBlock %d\n\n", BALL_CATEGORY, PIG_CATEGORY, BLOCK_CATEGORY);
    }
    return self;
}

-(void)dealloc {
    [pigTextures release];
    [super dealloc];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        switch (objectType) {
            case ball:      [self launchBall:location];                 break;
            case square:    [self addBlock:location];                   break;
            case vRect:     [self addRectangle:location Vertical:YES];  break;
            case hRect:     [self addRectangle:location Vertical:NO];   break;
            case pig:       [self addPig:location];                     break;
        }
    }
}

-(void)launchBall:(CGPoint)position {
    static int count = 0;
    SKEmitterNode *fire = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"BallFlame" ofType:@"sks"]];
    
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    
    sprite.position = CGPointMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    fire.position = sprite.position;
    [self addChild:fire];
    
    sprite.name = [NSString stringWithFormat:@"%d", count++];
    [particles setObject:fire forKey:sprite.name];
    
    [self addChild:sprite];
    
    [sprite.physicsBody applyForce:CGVectorMake(position.x*2, position.y*2)];
    sprite.physicsBody.categoryBitMask = BALL_CATEGORY;
}

-(void)addBlock:(CGPoint)position {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"square"];
    sprite.position = position;
    
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    sprite.physicsBody.categoryBitMask = BLOCK_CATEGORY;
    
    
    [self addChild:sprite];
}

-(void)addRectangle:(CGPoint)position Vertical:(BOOL)vertical {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"rectangle"];
    sprite.position = position;
    
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    if(vertical) {
        sprite.zRotation = PI/2.0;
    }
    
    sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    sprite.physicsBody.categoryBitMask = BLOCK_CATEGORY;

    [self addChild:sprite];
}

-(void)addPig:(CGPoint)position {
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"pig0"];
    sprite.position = position;
    
    SKAction *animAction = [SKAction animateWithTextures:pigTextures timePerFrame:0.5 resize:NO restore:YES];
    [sprite runAction:[[SKAction repeatActionForever:animAction] retain]];
    sprite.size = CGSizeMake(sprite.size.width/SCALE, sprite.size.height/SCALE);
    
    
    sprite.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    sprite.physicsBody.categoryBitMask = PIG_CATEGORY;
    sprite.physicsBody.contactTestBitMask = PIG_CATEGORY | BLOCK_CATEGORY | BALL_CATEGORY;
    
    [self addChild:sprite];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (gameStarted == NO)
        return;
    if(contact.bodyB == self.physicsBody || contact.bodyA == self.physicsBody)
        return;
    int test = PIG_CATEGORY | BLOCK_CATEGORY | BALL_CATEGORY;
    
    
    if(contact.bodyA.categoryBitMask == PIG_CATEGORY && (contact.bodyB.categoryBitMask & test) > 0) {
        [contact.bodyA.node removeFromParent];
        SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"]];
        emitter.position = contact.contactPoint;
        [self addChild:emitter];
    }
    else if(contact.bodyB.categoryBitMask == PIG_CATEGORY && (contact.bodyA.categoryBitMask & test)>0) {
        [contact.bodyB.node removeFromParent];
        SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"]];
        emitter.position = contact.contactPoint;
        [self addChild:emitter];
    }
    
}

-(void)didSimulatePhysics {
    for(SKNode *node in self.children) {
        if(node.physicsBody.categoryBitMask == BALL_CATEGORY) {
            SKEmitterNode *flame = [particles objectForKey:node.name];
            flame.position = node.position;
        }
    }
}

@end
