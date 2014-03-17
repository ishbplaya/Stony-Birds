//
//  ViewController.m
//  Stony Birds
//
//  Created by Jimmy on 9/22/13.
//  Copyright (c) 2013 Jimmy Bouker. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

-(IBAction)gravityButtonHit:(id)sender {
    SKView * skView = (SKView *)self.view;
    skView.scene.physicsWorld.gravity = CGVectorMake(0, skView.scene.physicsWorld.gravity.dy*-1);
}

-(IBAction)squareButtonHit:(id)sender {
    SKView * skView = (SKView *)self.view;
    MyScene * scene = (MyScene*)skView.scene;
    scene.objectType = square;
}

-(IBAction)hRectButtonHit:(id)sender {
    SKView * skView = (SKView *)self.view;
    MyScene * scene = (MyScene*)skView.scene;
    scene.objectType = hRect;
}

-(IBAction)vRectButtonHit:(id)sender {
    SKView * skView = (SKView *)self.view;
    MyScene * scene = (MyScene*)skView.scene;
    scene.objectType = vRect;
}

-(IBAction)pigButtonHit:(id)sender {
    SKView * skView = (SKView *)self.view;
    MyScene * scene = (MyScene*)skView.scene;
    scene.objectType = pig;
}

-(IBAction)launchBallButtonHit:(id)sender {
    SKView * skView = (SKView *)self.view;
    MyScene * scene = (MyScene*)skView.scene;
    scene.objectType = ball;
    
    scene.gameStarted = YES;
}

@end
