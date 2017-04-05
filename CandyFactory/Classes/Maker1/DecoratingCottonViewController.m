//
//  DecoratingCottonViewController.m
//  CandyFactory
//
//  Created by Ana-Maria Stoica on 1/16/13.
//  Copyright (c) 2013 Ana-Maria Stoica. All rights reserved.
//

#import "DecoratingCottonViewController.h"
#import "CottonCandyEatingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "SpiningVatViewController.h"
#import "ExtrasMenuViewController.h"

@implementation DecoratingCottonViewController
@synthesize allView;
@synthesize vat1;
@synthesize vat2;
@synthesize vat3;
@synthesize vat4;
@synthesize rgbs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
       
    {
         nextPressed = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    self.vat1.image = [UIImage imageNamed:@"cottonClump1Collecting~ipad.png"];
    
    self.vat1.image = [self imageWithImage:self.vat1.image rotatedByHue:[rgbs objectForKey:@"0"]];
    self.vat2.image = [self imageWithImage:self.vat2.image rotatedByHue:[rgbs objectForKey:@"1"]];
    self.vat3.image = [self imageWithImage:self.vat3.image rotatedByHue:[rgbs objectForKey:@"2"]];
    self.vat4.image = [self imageWithImage:self.vat4.image rotatedByHue:[rgbs objectForKey:@"3"]];
    lastClickedDecoration = 0;  
    movingStopped = YES;
    lastTag = 1;
    //    previousX = -100;
    //    previousY = -100;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BackgroundChaged:) name:@"BackgroundChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DrawOnSelected:) name:@"DrawOnSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ExtrasSelected:) name:@"ExtrasSelected" object:nil];
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] cottonCandyPurchased] || [(AppDelegate *)[[UIApplication sharedApplication] delegate] everythingPurchased] ) {
        
    }
    else{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showPopupAd];
    }
  
    self.stick.image = [UIImage imageNamed:self.stickName];
    self.allView.transform = CGAffineTransformRotate(self.allView.transform, M_PI/6);
    
}

- (UIImage*)imageWithImage:(UIImage*)source rotatedByHue:(NSMutableDictionary*)rgb
{
    
    UIColor * color = [UIColor colorWithRed:[[rgb objectForKey:@"red"] floatValue]/255.0 green:[[rgb objectForKey:@"green"] floatValue]/255.0 blue:[[rgb objectForKey:@"blue"] floatValue]/255.0 alpha:1.0f];
    UIGraphicsBeginImageContext(source.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, source.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
    CGContextDrawImage(context, rect, source.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, source.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create a Core Image version of the image.
    //    CIImage *sourceCore = [CIImage imageWithCGImage:[source CGImage]];
    //
    //    // Apply a CIHueAdjust filter
    //    CIFilter *hueAdjust = [CIFilter filterWithName:@"CIColorMonochrome"];
    //    [hueAdjust setDefaults];
    //    [hueAdjust setValue:[NSNumber numberWithFloat:0.7] forKey:@"inputIntensity"];
    //
    //    [hueAdjust setValue: sourceCore forKey: @"inputImage"];
    //    [hueAdjust setValue: [[CIColor alloc]initWithColor:[UIColor colorWithRed:[[rgb objectForKey:@"red"] floatValue]/255.0 green:[[rgb objectForKey:@"green"] floatValue]/255.0 blue:[[rgb objectForKey:@"blue"] floatValue]/255.0 alpha:1.0f]] forKey: @"inputColor"];
    //    CIImage *resultCore = [hueAdjust valueForKey: @"outputImage"];
    //
    //    CIContext *context = [CIContext contextWithOptions:nil];
    //    CGImageRef resultRef = [context createCGImage:resultCore fromRect:[resultCore extent]];
    //    UIImage *result = [UIImage imageWithCGImage:resultRef];
    //CGImageRelease(resultRef);
    
    return coloredImg;
}


- (void)viewWillAppear:(BOOL)animated
{
    
    
    if (nextPressed) {
        if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] cottonCandyPurchased] || [(AppDelegate *)[[UIApplication sharedApplication] delegate] everythingPurchased] ) {
            
        }
        else{
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] showPopupAd];
        }

        nextPressed = NO;
    }
    stupidCandyCoat.image = coatImage;
    
    self.stick.image = [UIImage imageNamed:self.stickName];
    self.apple.image = [UIImage imageNamed:self.appleName];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         self.backgroundButton.frame = CGRectMake(self.backgroundButton.frame.origin.x, 0, self.backgroundButton.frame.size.width, self.backgroundButton.frame.size.height);
     } completion:^ (BOOL completed)
     {
         [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
          {
              self.drawOnButton.frame = CGRectMake(self.drawOnButton.frame.origin.x, 0, self.drawOnButton.frame.size.width, self.drawOnButton.frame.size.height);
          } completion:^ (BOOL completed)
          {
              [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^
               {
                   self.extrasButton.frame = CGRectMake(self.extrasButton.frame.origin.x, 0, self.extrasButton.frame.size.width, self.extrasButton.frame.size.height);
               } completion:^ (BOOL completed)
               {
                   
                   
               }];
              
          }];
         
     }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back:(id)sender
{
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    NSArray *viewControllers = self.navigationController.viewControllers;
    SpiningVatViewController *previousView = [viewControllers objectAtIndex:[viewControllers count] - 2];
    previousView.backPressed = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)Next:(id)sender
{
    nextPressed = YES;
    
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.bigView.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.bigView.frame.size);
	[self.bigView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
     UIGraphicsEndImageContext();
    CottonCandyEatingViewController *eating;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        eating = [[CottonCandyEatingViewController alloc] initWithNibName:@"CottonCandyEatingViewController-iPad" bundle:nil];
    else
        eating = [[CottonCandyEatingViewController alloc] initWithNibName:@"CottonCandyEatingViewController" bundle:nil];
    eating.stickName = self.stickName;
    eating.backImage  = viewImage;
    
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.bigView.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.bigView.frame.size);
    self.background.hidden = YES;
	[self.bigView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
	UIImage *viewImage3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    eating.transparetImage = viewImage3;
    self.background.hidden = NO;

    UIImageView *newImage = [[UIImageView alloc] initWithFrame:self.background.frame];
    newImage.image = self.background.image;
    UIImageView *stickImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.stick.frame.origin.x , self.stick.frame.origin.y , self.stick.frame.size.width, self.stick.frame.size.height)];
    stickImage.image = self.stick.image;
    [newImage addSubview:stickImage];
    
    if([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(newImage.frame.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(newImage.frame.size);
    
    [newImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage2 = UIGraphicsGetImageFromCurrentImageContext();
    eating.backgroundName = viewImage2;

    [self.navigationController pushViewController:eating animated:YES];
}

- (IBAction)resetClick:(id)sender
{
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    for(UIView *view in [self.bigView subviews])
    {
        if(view != self.background && view != self.allView && view != self.stick)
            [view removeFromSuperview];
    }
}
- (IBAction)ChangeBackground:(id)sender
{
    lastClickedDecoration = 1;
    movingStopped = YES;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    
    ExtrasMenuViewController * extras;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        extras = [[ExtrasMenuViewController alloc]initWithNibName:@"ExtrasMenuViewController-iPad" bundle:nil];
    else
        extras = [[ExtrasMenuViewController alloc]initWithNibName:@"ExtrasMenuViewController" bundle:nil];
    
    extras.choice = 1;
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] cottonCandyPurchased] || [(AppDelegate *)[[UIApplication sharedApplication] delegate] everythingPurchased]) {
         extras._isBought = YES;
    }
   
    [UIView
     transitionWithView:self.navigationController.view
     duration:1.0
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^{
         [self.navigationController
          pushViewController:extras
          animated:NO];
     }
     completion:NULL];
}

- (IBAction)DrawOns:(id)sender
{
    lastClickedDecoration = 2;
    movingStopped = YES;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    
    ExtrasMenuViewController * extras;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        extras = [[ExtrasMenuViewController alloc] initWithNibName:@"ExtrasMenuViewController-iPad" bundle:nil];
    else
        extras = [[ExtrasMenuViewController alloc] initWithNibName:@"ExtrasMenuViewController" bundle:nil];
    
    extras.choice = 2;
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] cottonCandyPurchased] || [(AppDelegate *)[[UIApplication sharedApplication] delegate] everythingPurchased]) {
        extras._isBought = YES;
    }

    
    [UIView
     transitionWithView:self.navigationController.view
     duration:1.0
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^{
         [self.navigationController
          pushViewController:extras
          animated:NO];
     }
     completion:NULL];
}

- (IBAction)Extras:(id)sender
{
    lastClickedDecoration = 3;
    movingStopped = YES;
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] playSoundEffect:0];
    
    ExtrasMenuViewController *extras;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        extras = [[ExtrasMenuViewController alloc]initWithNibName:@"ExtrasMenuViewController-iPad" bundle:nil];
    else
        extras = [[ExtrasMenuViewController alloc]initWithNibName:@"ExtrasMenuViewController" bundle:nil];
    
    extras.choice = 3;
    if ([(AppDelegate *)[[UIApplication sharedApplication] delegate] cottonCandyPurchased] || [(AppDelegate *)[[UIApplication sharedApplication] delegate] everythingPurchased]) {
        extras._isBought = YES;
    }

    [UIView
     transitionWithView:self.navigationController.view
     duration:1.0
     options:UIViewAnimationOptionTransitionCurlDown
     animations:^{
         [self.navigationController
          pushViewController:extras
          animated:NO];
     }
     completion:NULL];
}



@end
