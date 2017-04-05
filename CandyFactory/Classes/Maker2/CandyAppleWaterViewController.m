//
//  CandyAppleWaterViewController.m
//  CandyFactory
//
//  Created by Ana-Maria Stoica on 12/6/12.
//  Copyright (c) 2012 Ana-Maria Stoica. All rights reserved.
//

#import "CandyAppleWaterViewController.h"
#import "CandyAppleSugarViewController.h"
#import "AppDelegate.h"
#import "CandyApplesViewController.h"

@implementation CandyAppleWaterViewController

@synthesize timer;
@synthesize timerPour;
@synthesize waterBottle;
@synthesize waterPouring;
@synthesize liquid;
@synthesize nextButton;
@synthesize overlay;
@synthesize bubbleBig1;
@synthesize bubbleBig2;
@synthesize bubbleSmall1;
@synthesize bubbleSmall2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _isPouring = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval  = 1.0/10.0; // Update at 10Hz
    if(motionManager.accelerometerAvailable)
    {
        NSLog(@"Accelerometer avaliable");
        queue = [NSOperationQueue currentQueue];
        [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             CMAcceleration acceleration = accelerometerData.acceleration;
             _currentX = acceleration.x;
         }];
    }
    else
    {
        NSLog(@"Accelerometer not avaliable");
    }
    
    _textureMask = [CALayer layer];
    _textureMask.frame = CGRectMake(0, self.liquid.frame.size.height, self.liquid.frame.size.width, self.liquid.frame.size.height);
    _textureMask.contents = (__bridge id)[[UIImage imageNamed:@"waterFilledPotTest.png"] CGImage];
    self.liquid.layer.mask = _textureMask;
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.bubbleBig1.alpha = 0;
    timerT = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(playBubbles) userInfo:nil repeats:YES];
    self.waterBottle.alpha = 1.0;
    nextButton.enabled = NO;
    self.waterBottle.hidden = NO;
    _isPouring = NO;
    self.waterPouring.hidden = YES;
    _textureMask  = nil;
    _textureMask = [CALayer layer];
    _textureMask.frame = CGRectMake(0, self.liquid.frame.size.height, self.liquid.frame.size.width, self.liquid.frame.size.height);
    _textureMask.contents = (__bridge id)[[UIImage imageNamed:@"waterFilledPotTest.png"] CGImage];
    self.liquid.layer.mask = _textureMask;
    _sugar = 0;
    _currentRotation = _currentX;
    
    if ([timer isValid])
        [timer invalidate];
    if ([timerPour isValid])
        [timerPour invalidate];

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.f/60.f target:self selector:@selector(rotate:) userInfo:nil repeats: YES];
    self.timerPour = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(pour:) userInfo:nil repeats: YES];
}


- (void)playBubbles
{
    [UIView beginAnimations:@"sparkle" context:nil];
    [UIView setAnimationDuration:0.3];
    if (bubbleBig1.alpha < 1)
    {
        bubbleBig1.alpha = 1;
        bubbleBig2.alpha = 0;
        bubbleSmall1.alpha = 1;
        bubbleSmall2.alpha = 1;
    }
    else if (bubbleBig2.alpha < 1) {
        bubbleBig1.alpha = 1;
        bubbleBig2.alpha = 1;
        bubbleSmall1.alpha = 0;
        bubbleSmall2.alpha = 1;
    }
    
    else if (bubbleSmall1.alpha < 1) {
        bubbleBig1.alpha = 1;
        bubbleBig2.alpha = 1;
        bubbleSmall1.alpha = 1;
        bubbleSmall2.alpha = 0;
    }
    else if (bubbleSmall2.alpha < 1) {
        bubbleBig1.alpha = 0;
        bubbleBig2.alpha = 1;
        bubbleSmall1.alpha = 1;
        bubbleSmall2.alpha = 1;
    }
    [UIView commitAnimations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void) rotate:(NSTimer *) theTimer {
    double rotation = _currentX*2.2;
    if (rotation > 0) rotation = 0;
    
    rotation -= .15;
    
    double difference = rotation - _currentRotation;
    _currentRotation += difference *.05;
    
    if (_currentRotation <= -1.3) {
        _currentRotation = -1.3;
        
        _isPouring = YES;
        self.waterPouring.hidden = NO;
        
    } else {
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] stopSoundEffect:4];
        _isPouring = NO;
        self.waterPouring.hidden = YES;
        
    }
    
    self.waterBottle.transform = CGAffineTransformMakeRotation(_currentRotation);
}

- (void) pour:(NSTimer *) theTimer {
    
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
         
         if (_isPouring && ++_sugar <7) {
           
               [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:4];
             CABasicAnimation* anim = [[CABasicAnimation alloc] init];
             anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(_textureMask.position.x, _textureMask.position.y)];
             anim.keyPath = @"position";
             anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
             anim.duration = 0.5;
             _textureMask.position = CGPointMake(_textureMask.position.x, _textureMask.position.y - (_textureMask.frame.size.height/7));
             [_textureMask addAnimation:anim forKey:nil];
          
         }
         if (_sugar >= 7) {
               [(AppDelegate *)[[UIApplication sharedApplication] delegate] stopSoundEffect:4];
             [self.timer invalidate];
             [self.timerPour invalidate];
             _currentRotation = 0;
             _isPouring = NO;
             self.waterPouring.hidden = YES;

             [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
              {
                  self.waterBottle.alpha = 0;
                        
                  
              } completion:^(BOOL finished) {
                  self.waterBottle.hidden = YES;
                   [self performSelector:@selector(NextPage:) withObject:nil afterDelay:0.3];
                  
              }];
             
         }

     }
    else
    {
        if (_isPouring && ++_sugar <8) {
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:4];
            
            CABasicAnimation* anim = [[CABasicAnimation alloc] init];
            anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(_textureMask.position.x, _textureMask.position.y)];
            anim.keyPath = @"position";
            anim.timingFunction = [CAMediaTimingFunction functionWithName:@"linear"];
            anim.duration = 0.5;
            _textureMask.position = CGPointMake(_textureMask.position.x, _textureMask.position.y - (_textureMask.frame.size.height/7));
            [_textureMask addAnimation:anim forKey:nil];
            
        }
        if (_sugar >= 8) {
              [(AppDelegate *)[[UIApplication sharedApplication] delegate] stopSoundEffect:4];
            [self.timer invalidate];
            [self.timerPour invalidate];
            _currentRotation = 0;
            _isPouring = NO;
            self.waterPouring.hidden = YES;
            
            [UIView animateWithDuration:.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
             {
                 self.waterBottle.alpha = 0;
                 //self.liquid.alpha = 0;
                 self.overlay.alpha = 1;
                 
                 
             } completion:^(BOOL finished) {
                 self.waterBottle.hidden = YES;
                [self performSelector:@selector(NextPage:) withObject:nil afterDelay:0.3];
                 
             }];
            
        }

    }
}

-(IBAction)BackButtonPressed:(id)sender
{
    if([timer isValid])
        [timer invalidate];
    if ([timerPour isValid])
        [timerPour invalidate];
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ResetButtonPreseed:(id)sender
{
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    if([timerT isValid])
        [timerT invalidate];
    
    [self viewWillAppear:YES];
}


-(IBAction)NextPage:(id)sender
{
   
    CandyAppleSugarViewController * flavour;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        flavour = [[CandyAppleSugarViewController alloc]initWithNibName:@"CandyAppleSugarViewController-iPad" bundle:nil];
    }
    else
    {
        flavour = [[CandyAppleSugarViewController alloc]initWithNibName:@"CandyAppleSugarViewController" bundle:nil];
    }
    [self.navigationController pushViewController:flavour animated:NO];
}

@end
