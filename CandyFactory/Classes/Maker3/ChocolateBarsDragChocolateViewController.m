//
//  ChocolateBarsDragChocolateViewController.m
//  CandyFactory
//
//  Created by Ana-Maria Stoica on 12/10/12.
//  Copyright (c) 2012 Ana-Maria Stoica. All rights reserved.
//

#import "ChocolateBarsDragChocolateViewController.h"
#import "ChocolateBarMilkViewController.h"


@implementation ChocolateBarsDragChocolateViewController

@synthesize chocolateBar;
@synthesize nextButton;
@synthesize bottomView;
@synthesize chocolateNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
      
}
-(void)viewWillAppear:(BOOL)animated
{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         
         self.bottomView.frame = CGRectMake(0, self.bottomView.frame.origin.y, 320, self.bottomView.frame.size.height);
         
         
     } completion:^(BOOL finished) {
       
         
     }];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

-(IBAction)BackButtonPressed:(id)sender
{
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         
         self.bottomView.frame = CGRectMake(640, self.bottomView.frame.origin.y, 320, self.bottomView.frame.size.height);
         
         
     } completion:^(BOOL finished) {
       
          [self.navigationController popViewControllerAnimated:NO];
         
     }];
   
}
-(IBAction)Next:(id)sender
{
    ChocolateBarMilkViewController * milk;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        milk = [[ChocolateBarMilkViewController alloc]initWithNibName:@"ChocolateBarMilkViewController-iPad" bundle:nil];
    }
    else{
         milk = [[ChocolateBarMilkViewController alloc]initWithNibName:@"ChocolateBarMilkViewController" bundle:nil];
    }
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         
         self.bottomView.frame = CGRectMake(-320, self.bottomView.frame.origin.y, 320, self.bottomView.frame.size.height);
        
         
     } completion:^(BOOL finished) {

         milk.chocolate = self.chocolateBar.image;
         milk.offSet = self.chocolateBar.center;
   
         [self.navigationController pushViewController:milk animated:NO];
         
       
     }];

    
}
- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
   UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == self.chocolateBar)
    {
       
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  
}
- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([touch view] == self.chocolateBar)
    {
      CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
      self.chocolateBar.center = touchPoint;
        if ([self checkIfIsInPot:self.chocolateBar.center]) {
            nextButton.enabled = YES;
        }
        else
        {
            nextButton.enabled = NO;
        }
    }
}

-(BOOL)checkIfIsInPot:(CGPoint)point
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (point.x > 81 && point.x <247)
        {
            if (point.y >305 && point.y <353) {
                return YES;
            }
            return NO;
        }
    }
    return NO;
}

@end
