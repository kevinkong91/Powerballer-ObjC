//
//  ViewController.h
//  Powerballer-ObjC
//
//  Created by Kevin Kong on 1/28/16.
//  Copyright © 2016 Kevin Kong. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


// Data


@property (strong, nonatomic) NSArray *previousNumbers; // [Drawing]
@property (strong, nonatomic) NSMutableArray *myNumbers; // [NSManagedObject]

@property (strong, nonatomic) NSString *textToShare;


// Basic UI

@property (strong, nonatomic) UINavigationBar *navigationBar;

@property (strong, nonatomic) UIColor *backgroundColor;
@property (strong, atomic) NSString *font;
@property (strong, atomic) NSString *fontBold;

@property (strong, nonatomic) NSTimer *introLabelTimer; // lazy
@property (strong, nonatomic) UILabel *introLabel;

@property (strong, nonatomic) UIImageView *imageView;


// Generating numbers

@property (strong, atomic) NSArray *currentNumbers; // [NSString]

@property (strong, nonatomic) NSArray *generateNumbersElements; // [UIView]
@property (strong, atomic) UILabel *numbersLabel; //
@property (strong, nonatomic) UILabel *powerballLabel;//

@property (strong, nonatomic) UIButton *saveNumbersButton;
@property (strong, nonatomic) UILabel *jackpotLabel;

@property (strong, nonatomic) UIButton *generateNumbersButton;



// Menu / other views
@property (strong, nonatomic) UIVisualEffectView *blurView; //
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UITableView *previousWinnersTableView;
@property (strong, nonatomic) UITableView *myNumbersTableView;
@property (strong, nonatomic) UILabel *dataSourceLabel;
@property (strong, nonatomic) UIButton *shareButton;

@property BOOL myNumberIsSelected;
@property BOOL startedGeneratingNumbers;

@property NSUInteger stringIndex;
@property NSUInteger imageIndex;

//
// METHODS
//

- (void)closeView;

- (void)generateTappedFromBlurView;
- (void)startGenerating;
- (void)showNextSetOfNumbers;
- (void)generateIntroText;

- (NSArray *)generateNumbers;

- (void)toggleShareButton;



@end

