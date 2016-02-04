//
//  ViewController.m
//  Powerballer-ObjC
//
//  Created by Kevin Kong on 1/28/16.
//  Copyright © 2016 Kevin Kong. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ViewController.h"
#import "NumberCell.h"
#import "Drawing.h"


@interface ViewController ()

@end

@implementation ViewController

- (NSDateFormatter *)dateFormatter {
    NSDateFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return formatter;
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Font
    self.font = @"GothamRounded-Medium";
    self.fontBold = @"GothamRounded-Bold";
    
    
    // Title
    UIFont *boldFont = [UIFont fontWithName:self.fontBold size:14];
    UIColor *whiteColor = [UIColor whiteColor];
    UIImage *emptyImage = [[UIImage alloc] init];
    UIImage *menuImage = [[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    self.navigationBar.translucent = YES;
    self.navigationBar.tintColor = whiteColor;
    self.navigationBar.shadowImage = emptyImage;
    self.navigationBar.titleTextAttributes = @{
                                               NSFontAttributeName: boldFont,
                                               NSForegroundColorAttributeName: whiteColor
                                               };
    [self.navigationBar setBackgroundImage:emptyImage forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:menuImage style:UIBarButtonItemStylePlain target:self action:@selector(showPreviousWinningNumbers)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.title = @"POWERBALLER";
    self.navigationBar.items = [NSArray arrayWithObject:self.navigationItem];
    
    
    
    // Init background
    self.backgroundColor = [self randomColor];
    self.view.backgroundColor = self.backgroundColor;
    
    
    
    // Intro Label
    CGFloat padding = 10;
    
    
    self.introLabel = [[UILabel alloc] init];
    self.introLabel.font = [UIFont fontWithName:self.font size:25];
    self.introLabel.textAlignment = NSTextAlignmentCenter;
    self.introLabel.adjustsFontSizeToFitWidth = YES;
    self.introLabel.textColor = whiteColor;
    self.introLabel.frame = CGRectMake(0, 0, self.view.frame.size.width - padding * 2, 60);
    self.introLabel.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
    self.introLabel.alpha = 1;
    
    
    [self generateIntroText];
    self.introLabelTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(generateIntroText) userInfo:nil repeats:YES];
    
    
    
    
    
    
    
    
    //
    // MAIN VIEW
    //
    
    
    // Screen Size - dynamic formatting
    CGSize size = [UIScreen mainScreen].bounds.size;
    BOOL currentDeviceIsSmall = size.height < 568;
    
    
    CGFloat iconOriginY = currentDeviceIsSmall ? 100 : 150;
    CGFloat descriptionLabelOriginY = currentDeviceIsSmall ? 60 : 90;
    CGFloat infoLabelOriginY = currentDeviceIsSmall ? 15 : 25;
    
    
    
    
    // Icon
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = CGRectMake(0, 0, 60, 60);
    self.imageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2 - iconOriginY);
    self.imageView.alpha = 0;
    
    
    
    
    
    
    //
    // Number generation view
    //
    CGFloat circleSize = 0.16 * self.view.frame.size.width;
    
    
    // Numbers
    self.numbersLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding * 2, self.view.frame.size.height / 2 - 30, self.view.frame.size.width - circleSize - padding * 6, 60)];
    self.numbersLabel.textAlignment = NSTextAlignmentCenter;
    self.numbersLabel.textColor = whiteColor;
    self.numbersLabel.font = [UIFont fontWithName:self.fontBold size:25];
    self.numbersLabel.alpha = 0;
    self.numbersLabel.adjustsFontSizeToFitWidth = YES;
    
    
    // Powerball Label
    self.powerballLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numbersLabel.frame) + padding * 1.5, self.view.frame.size.height / 2 - circleSize / 2, circleSize, circleSize)];
    self.powerballLabel.font = [UIFont fontWithName:self.fontBold size: 25];
    self.powerballLabel.textColor = whiteColor;
    self.powerballLabel.textAlignment = NSTextAlignmentCenter;
    self.powerballLabel.layer.cornerRadius = self.powerballLabel.frame.size.height / 2;
    self.powerballLabel.layer.masksToBounds = YES;
    self.powerballLabel.backgroundColor = [whiteColor colorWithAlphaComponent:0.2];
    self.powerballLabel.alpha = 0;
    
    
    
    
    
    
    // Jackpot &
    // Your chances:
    UILabel *currentJackpotLabel = [[UILabel alloc] init];
    UILabel *yourChancesLabel = [[UILabel alloc] init];
    UILabel *cashValueLabel = [[UILabel alloc] init];
    
    NSArray *labels = [NSArray arrayWithObjects:currentJackpotLabel, yourChancesLabel, cashValueLabel, nil];
    
    for (UILabel *label in labels) {
        
        NSUInteger index = [labels indexOfObject:label];
        
        NSString *string = (index == 0) ? @"your chances:" : @"current jackpot:";
        CGFloat centerX = (index == 0) ? (self.view.frame.size.width * 3/4) : (self.view.frame.size.width / 4);
        
        label.text = [string uppercaseString];
        label.font = [UIFont fontWithName:self.fontBold size:12];
        label.textColor = [whiteColor colorWithAlphaComponent:0.5];
        label.textAlignment = NSTextAlignmentCenter;
        [label sizeToFit];
        label.center = CGPointMake(centerX, self.view.frame.size.height / 2 + descriptionLabelOriginY);
        label.alpha = 0;
        
    }
    
    cashValueLabel.text = @"";
    cashValueLabel.textColor = [whiteColor colorWithAlphaComponent:0.3];
    cashValueLabel.font = [UIFont fontWithName:self.font size:10];
    cashValueLabel.center = CGPointMake((self.view.frame.size.width / 4), CGRectGetMaxY(yourChancesLabel.frame) + infoLabelOriginY * 2);
    
    
    
    
    UILabel *probabilityLabel = [[UILabel alloc] init];
    self.jackpotLabel = [[UILabel alloc] init];
    
    NSArray *bigLabels = [NSArray arrayWithObjects:self.jackpotLabel, probabilityLabel, nil];
    
    for (UILabel *label in bigLabels) {
        
        NSUInteger index = [bigLabels indexOfObject:label];
        
        NSString *text = (index == 0) ? @"$$$" : @"1 in 292,201,338";
        CGFloat centerX = (index == 0) ? (self.view.frame.size.width / 4) : (self.view.frame.size.width * 3/4);
        
        
        label.text = text;
        label.font = [UIFont fontWithName:self.fontBold size:18];
        label.textColor = [whiteColor colorWithAlphaComponent:0.7];
        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.frame = CGRectMake(0, 0, self.view.frame.size.width / 2 - 20, 20);
        label.center = CGPointMake(centerX, CGRectGetMaxY(yourChancesLabel.frame) + infoLabelOriginY);
        label.alpha = 0;
        
    }
    
    
    
    // Update Current Jackpot
    [self fetchJackpotWinnings:^(NSString *jackpot, NSString *cashValue) {
        
        self.jackpotLabel.text = jackpot;
        cashValueLabel.text = [NSString stringWithFormat:@"%@ CV", cashValue];
        
    }];
    
    
    
    
    
    // Buttons
    
    self.generateNumbersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.generateNumbersButton setTitle:@"START" forState:UIControlStateNormal];
    [self.generateNumbersButton setTitleColor:whiteColor forState:UIControlStateNormal];
    [self.generateNumbersButton setTitleColor:[whiteColor colorWithAlphaComponent:0.4] forState:UIControlStateHighlighted];
    self.generateNumbersButton.titleLabel.font = [UIFont fontWithName:self.fontBold size:16];
    self.generateNumbersButton.frame = CGRectMake(0, self.view.frame.size.height - 80, self.view.frame.size.width, 80);
    [self.generateNumbersButton addTarget:self action:@selector(startGenerating) forControlEvents:UIControlEventTouchUpInside];
    self.generateNumbersButton.backgroundColor = [whiteColor colorWithAlphaComponent:0.3];
    
    
    // SAVE button
    self.saveNumbersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveNumbersButton setTitle:@"SAVE" forState:UIControlStateNormal];
    [self.saveNumbersButton setTitleColor:[whiteColor colorWithAlphaComponent:0.4] forState: UIControlStateNormal];
    [self.saveNumbersButton setTitleColor:[whiteColor colorWithAlphaComponent:0.1] forState:UIControlStateNormal];
    self.saveNumbersButton.titleLabel.font = [UIFont fontWithName:self.fontBold size:18];
    self.saveNumbersButton.frame = CGRectMake(0, 0, 250, 20);
    self.saveNumbersButton.center = CGPointMake(self.view.frame.size.width / 2, CGRectGetMinY(self.generateNumbersButton.frame) - 25);
    self.saveNumbersButton.alpha = 0;
    [self.saveNumbersButton addTarget:self action:@selector(saveCurrentNumbers) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    
    // Elements to be added in after tapping START button
    self.generateNumbersElements = [NSArray arrayWithObjects:self.numbersLabel, self.powerballLabel, self.saveNumbersButton, currentJackpotLabel, self.jackpotLabel, cashValueLabel, yourChancesLabel, probabilityLabel, nil];
    
    
    
    
    // Add to view
    NSArray *viewsToAdd = [NSArray arrayWithObjects:self.navigationBar, self.imageView, self.introLabel, self.numbersLabel, self.powerballLabel, self.generateNumbersButton, self.saveNumbersButton, currentJackpotLabel, self.jackpotLabel, cashValueLabel, yourChancesLabel, probabilityLabel, nil];
    
    for (UIView *item in viewsToAdd) {
        [self.view addSubview:item];
    }
    
    
    
    
    
    
    
    
    
    // Previous Winning Numbers
    
    
    // Create black blur
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    self.blurView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.blurView.alpha = 0;
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navBar.tintColor = whiteColor;
    navBar.shadowImage = emptyImage;
    navBar.translucent = YES;
    [navBar setBackgroundImage:emptyImage forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"x-mark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(closeView)];
    UINavigationItem *leftItem = [[UINavigationItem alloc] init];
    leftItem.leftBarButtonItem = closeButton;
    
    navBar.items = [NSArray arrayWithObject:leftItem];
    
    [self.blurView addSubview:navBar];
    
    
    
    // Segmented Control
    NSArray *items = [NSArray arrayWithObjects:@"PREVIOUS WINNERS", @"MY NUMBERS", nil];
    
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    self.segmentedControl.tintColor = whiteColor;
    self.segmentedControl.frame = CGRectMake(padding, navBar.frame.size.height + 5, self.view.frame.size.width - padding * 2, 25);
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: whiteColor, NSFontAttributeName: [UIFont fontWithName:self.font size:12]} forState: UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: self.backgroundColor} forState: UIControlStateSelected];
    [self.segmentedControl addTarget:self action:@selector(indexChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    // TableView
    self.previousWinnersTableView = [[UITableView alloc] init];
    self.myNumbersTableView = [[UITableView alloc] init];
    
    NSArray *tables = [NSArray arrayWithObjects:self.previousWinnersTableView, self.myNumbersTableView, nil];
    
    for (UITableView *table in tables) {
        
        NSUInteger index = [tables indexOfObject:table];
        BOOL allowsSelection = (index == 1);           // myNumbers enables selection
        
        table.delegate = self;
        table.dataSource = self;
        
        table.frame = CGRectMake(0, navBar.frame.size.height + 44, self.view.frame.size.width, self.view.frame.size.height / 2);
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.allowsSelection = allowsSelection;
        table.backgroundColor = [whiteColor colorWithAlphaComponent:0.05];
        table.tag = index;
        [table registerClass:NumberCell.self forCellReuseIdentifier:@"NumberCell"];
        
    }
    
    
    
    // data source
    self.dataSourceLabel = [[UILabel alloc] init];
    self.dataSourceLabel.text = @"DATA SOURCE: NYC GOV";
    self.dataSourceLabel.textAlignment = NSTextAlignmentCenter;
    self.dataSourceLabel.textColor = [whiteColor colorWithAlphaComponent:0.2];
    self.dataSourceLabel.font = [UIFont fontWithName:self.font size:10];
    self.dataSourceLabel.frame = CGRectMake(0, CGRectGetMaxY(self.previousWinnersTableView.frame) + 10, self.view.frame.size.width, 12);
    
    
    
    // Share button
    self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(padding, CGRectGetMaxY(self.dataSourceLabel.frame) + 25, self.view.frame.size.width - padding * 2, 50);
    self.shareButton.backgroundColor = [UIColor clearColor];
    self.shareButton.layer.borderWidth = 1.5;
    self.shareButton.layer.borderColor = [whiteColor CGColor];
    self.shareButton.layer.cornerRadius = 3.0;
    self.shareButton.layer.masksToBounds = YES;
    self.shareButton.titleLabel.font = [UIFont fontWithName:self.fontBold size:18];
    [self.shareButton setTitle:@"SHARE" forState:UIControlStateNormal];
    [self.shareButton setTitleColor:whiteColor forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(showShareView) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    // Signature
    
    UILabel *signature = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 28, self.view.frame.size.width, 28)];
    signature.text = @"2016 © Kevin Kong";
    signature.textColor = whiteColor;
    signature.textAlignment = NSTextAlignmentCenter;
    signature.font = [UIFont fontWithName:self.font size:14];
    
    
    
    
    
    // My Numbers
    
    
    for (UIView *item in [NSArray arrayWithObjects:self.segmentedControl, self.previousWinnersTableView, self.dataSourceLabel, self.shareButton, signature, nil]) {
        [self.blurView addSubview:item];
    }
    
    
    
    
    [self fetchSavedNumbers];
    
    
    
    
    // Formatter
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}









#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return [self.previousNumbers count];
    } else {
        return MAX(1, [self.myNumbers count]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1 && [self.myNumbers count] == 0) {
        
        @autoreleasepool {
            
            // Empty cell
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.textLabel.text = @"No numbers saved!\nTap to test your luck.";
            
            // Tap gesture
            SEL generateFromBlurView = NSSelectorFromString(@"generateTappedFromBlurView");
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:generateFromBlurView];
            [cell addGestureRecognizer:tapGesture];
            
            return cell;
            
        }
        
        
    } else {
        
        NumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NumberCell"];
        
        if (cell == nil) {
            cell = [[NumberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NumberCell"];
        }
        
        if (tableView.tag == 0) {
            
            // Split off the last Powerball num
            NSArray *numberArray = [[self.previousNumbers[indexPath.row] valueForKey:@"numbers"] componentsSeparatedByString:@" "];
            
            // Join the string again with a larger space
            NSString *numbersString = [[numberArray subarrayWithRange:NSMakeRange(0, 5)] componentsJoinedByString:@"   "];
            
            cell.numbersLabel.text = numbersString;
            cell.powerballLabel.text = numberArray[5];
            
            
            
            // Formatted date
            cell.datesLabel.text = [self.dateFormatter stringFromDate: [self.previousNumbers[indexPath.row] valueForKey:@"date"]];
            
            
        } else {
            
            NSManagedObject *numbers = [self.myNumbers objectAtIndex:indexPath.row];
            
            
            // Split off the last Powerball num
            NSArray *numberArray = [[numbers valueForKey:@"numbers"] componentsSeparatedByString:@" "];
            
            // Join the string again with a larger space
            NSString *numbersString = [[numberArray subarrayWithRange:NSMakeRange(0, 5)] componentsJoinedByString:@"   "];
            
            
            cell.numbersLabel.text = numbersString;
            cell.powerballLabel.text = numberArray[5];
            cell.datesLabel.text = [self.dateFormatter stringFromDate:[numbers valueForKey:@"date"]];
            
        }
        
        return cell;
        
    }
}


// Edits


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        return !([self.myNumbers count] == 0);
    } else {
        return NO;
    }
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1) {
        
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            
            // remove the deleted item from the model
            [self.managedObjectContext deleteObject:self.myNumbers[indexPath.row]];
            [self.myNumbers removeObjectAtIndex:indexPath.row];
            
            
            NSError *error;
            
            if (![self.managedObjectContext save:&error]) {
                
                UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error while saving" message:@"We could not save your changes. Please try again later!" preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:errorAlert animated:YES completion:nil];
                
            }
            
            
            
            
            // remove the deleted item from the `UITableView`
            if ([self.myNumbers count] == 0) {
                
                // Show the "No numbers" notification
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                
                [self fadeOut:cell duration:0.3 delay:0 completion:^(bool completed) {
                    [self.myNumbersTableView reloadData];
                }];
                
            } else {
                NSArray *rows = [NSArray arrayWithObject:indexPath];
                [self.myNumbersTableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }
        
    }
    
}




#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:self.fontBold size:15];
    [cell.textLabel sizeToFit];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    cell.textLabel.numberOfLines = 0;
    
    
    // If not empty
    if ([self.myNumbers count] != 0) {
        
        UIView *selectedBgView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1];
        cell.selectedBackgroundView = selectedBgView;
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


BOOL myNumberIsSelected = NO;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    myNumberIsSelected = YES;
    
    NSManagedObject *myNumbers = self.myNumbers[indexPath.row];
    
    
    //Edit Share Text
    
    if ([myNumbers valueForKey:@"numbers"] != nil) {
        NSString *numbers = [myNumbers valueForKey:@"numbers"];
        self.textToShare = [NSString stringWithFormat:@"Wish me luck with these numbers! %@ #PowerBaller", numbers];
    }
    
    [self toggleShareButton];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    myNumberIsSelected = NO;
    
    // Edit Share Text
    self.textToShare = @"Wanna try your luck? Become a #PowerBaller";
    
    // Toggle Share Button
    [self toggleShareButton];
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.selected == YES) {
        // Deselect manually
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [tableView.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        return UITableViewCellEditingStyleDelete;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}





#pragma mark - METHODS - General / Launch

- (void)closeView {
    [self fadeOut:self.blurView duration:0.3 delay:0 completion:^(bool completed) {
        [self.blurView removeFromSuperview];
    }];
}


BOOL startedGeneratingNumbers = NO;

- (void) generateTappedFromBlurView {
    
    [self closeView];
    
    if (self.startedGeneratingNumbers == NO) {
        [self startGenerating];
    } else {
        [self showNextSetOfNumbers];
    }
    
}

- (void)startGenerating {
    
    startedGeneratingNumbers = YES;
    
    [self fadeIn:self.introLabel duration:0.5 delay:0 completion:^(bool completed) {
        
        // Stop the timer
        [self.introLabelTimer invalidate];
        
        // Fade out the intro
        [self.introLabel removeFromSuperview];
        
        // Fade in the labels
        for (UIView *view in self.generateNumbersElements) {
            [self fadeIn:view];
        }
        
        
        // Format button
        
        SEL startGenerating = NSSelectorFromString(@"startGenerating");
        SEL showNextSetOfNumbers = NSSelectorFromString(@"showNextSetOfNumbers");
        SEL animateImage = NSSelectorFromString(@"animateImage");
        
        [self.generateNumbersButton setTitle:[@"Generate" uppercaseString] forState: UIControlStateNormal];
        [self.generateNumbersButton removeTarget:self action:startGenerating forControlEvents:UIControlEventTouchUpInside];
        [self.generateNumbersButton addTarget:self action:showNextSetOfNumbers forControlEvents:UIControlEventTouchUpInside];
        
        // Start animating image
        [self animateImage];
        [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:animateImage userInfo:nil repeats:YES];
        
        
    }];
    
    
    [self showNextSetOfNumbers];
    
}


- (void)showNextSetOfNumbers {
    
    
    // Morph color
    [UIView animateWithDuration:0.6 animations:^{
        self.backgroundColor = [self randomColor];
        self.view.backgroundColor = self.backgroundColor;
    }];
    
    
    // Fade out current Numbers
    [UIView animateWithDuration:0.3 animations:^{
        
        self.numbersLabel.alpha = 0;
        self.powerballLabel.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        // Change numbers
        self.currentNumbers = [self generateNumbers];
        
        // Remove last item
        self.powerballLabel.text = self.currentNumbers[5];
        self.numbersLabel.text = [[self.currentNumbers subarrayWithRange:NSMakeRange(0, 5)] componentsJoinedByString:@"   "];
        
        // Fade back in
        [self fadeIn:self.numbersLabel];
        [self fadeIn:self.powerballLabel];
        
        // Format save button
        if (self.saveNumbersButton.enabled == NO) {
            [self resetSaveNumbersButton];
            self.saveNumbersButton.enabled = YES;
            self.saveNumbersButton.alpha = 1.0;
        }
        
    }];
}



#pragma mark - METHODS - NSURLSession


// Previous winning numbers

- (void)fetchPreviousWinners:(void (^)(NSArray *drawings))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://data.ny.gov/api/views/d6yy-54nr/rows.json?accessType=DOWNLOAD"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ([data length] > 0 && error == nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *drawings = [[json objectForKey:@"data"] subarrayWithRange:NSMakeRange(0, 15)];
            
            
            // Only the 25 most recent drawings
            NSMutableArray *drawingsToDisplay = [[NSMutableArray alloc] init];
            
            for (NSArray *drawing in drawings) {
                
                NSString *dateString = drawing[8];
                NSString *numbers = drawing[9];
                
                // Formatted date
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
                NSDate *dateToAdd = [formatter dateFromString:dateString];
                
                Drawing *drawingObj = [[Drawing alloc] initWithData:dateToAdd numbers:numbers];
                
                [drawingsToDisplay addObject:drawingObj];
                
                
                
            }
            
            completion(drawingsToDisplay);
            
        } else {
            
            completion(nil);
            
        }
        
    }];
    
    [task resume];
    
    
    
}


// Jackpot/CV info

- (void)fetchJackpotWinnings:(void (^)(NSString *jackpot, NSString *cashValue))completion {
    
    NSURL *url = [NSURL URLWithString:@"https://www.kimonolabs.com/api/5lh3spt2?apikey=koirKBAW9m8Myrg1xwSEao40UOWy22Lt"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ([data length] > 0 && error == nil) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSString *jackpotString = json[@"results"][@"collection1"][0][@"jackpot"];
            NSString *cashValueString = json[@"results"][@"collection1"][0][@"cashValue"];
            
            
            completion(jackpotString, cashValueString);
            
        } else {
            
            completion(nil, nil);
            
        }
    }];
    
    [task resume];
    
}





#pragma mark - METHODS - Random Numbers
// Return array of 6 numbers. last is powerball.

- (NSArray *)generateNumbers {
    
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    
    
    // First FIVE numbers
    for (NSUInteger i = 0; i < 5; i++) {
        
        uint32_t randomNumber = arc4random_uniform(69) + 1;
        NSString *randomNumberString = [NSString stringWithFormat:@"%u", randomNumber];
        
        // Keep making until no repeats
        while ([numbers containsObject:randomNumberString]) {
            randomNumber = arc4random_uniform(69) + 1;
            randomNumberString = [NSString stringWithFormat:@"%u", randomNumber];
        }
        
        [numbers addObject:randomNumberString];
        
    }
    
    
    // Powerball Number
    uint32_t pbNumber = arc4random_uniform(26) + 1;
    NSString *pbString = [NSString stringWithFormat:@"%u", pbNumber];
    [numbers addObject:pbString];
    
    return numbers;
    
}





#pragma mark - METHODS - Random Color

- (CGFloat)randomCGFloat {
    return (float)rand() / RAND_MAX;
}

- (UIColor *)randomColor {
    
    CGFloat r = [self randomCGFloat];
    CGFloat g = [self randomCGFloat];
    CGFloat b = [self randomCGFloat];
    
    CGFloat red = MAX(r - 0.2, 0.0);
    CGFloat green = MAX(g - 0.2, 0.0);
    CGFloat blue = MAX(b - 0.2, 0.0);
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
}






#pragma mark - METHODS - Random Text

// Random Text

- (void)generateIntroText {
    self.introLabel.text = [self generateString];
    
    [self fadeIn:self.introLabel duration:0.2 delay:0 completion:^(bool completed) {
        if (completed) {
            [self fadeOut:self.introLabel duration:0.2 delay:3.6 completion:nil];
        }
    }];
}



NSUInteger stringIndex = 0;

- (NSString *)generateString {
    
    NSArray *quotes = @[@"Fortune favors the Bold",
                        @"Try your luck",
                        @"Time is money",
                        @"What's to lose?",
                        @"Live your dream",
                        @"A dollar and a dream",
                        @"You never know",
                        @"Live on the wild side"
                        ];
    
    NSString *quote = quotes[stringIndex];
    
    if (stringIndex < ([quotes count] - 1)) {
        stringIndex++;
    } else if (stringIndex == ([quotes count] - 1)) {
        stringIndex = 0;
    }
    
    return quote;
    
}





#pragma mark - METHODS - Random Image

// Random Image

- (void)animateImage {
    [self generateImage];
    
    [self fadeIn:self.imageView duration:0.2 delay:0 completion:^(bool completed) {
        [self fadeOut:self.imageView duration:0.2 delay:3.6 completion:nil];
    }];
}

NSUInteger imageIndex = 0;

- (void)generateImage {
    
    NSArray *images = @[@"Bill",
                        @"Bills",
                        @"Dice",
                        @"Dollar",
                        @"Money-Bag",
                        @"Piggy-Bank",
                        ];
    
    NSString *imageName = images[imageIndex];
    
    if (imageIndex < ([images count] - 1)) {
        imageIndex++;
    } else if (imageIndex == ([images count] - 1)) {
        imageIndex = 0;
    }
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = [UIImage imageNamed:imageName];
    
}




#pragma mark - METHODS - UI Fade In/Out


- (void)fadeIn:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(bool completed))completion {
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.alpha = 1.0;
    } completion: completion];
    
}

- (void)fadeOut:(UIView *)view duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay completion:(void (^)(bool completed))completion {
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.alpha = 0.0;
    } completion: completion];
    
}

- (void)fadeIn:(UIView *)view {
    [self fadeIn:view duration:0.3 delay:0 completion:nil];
}

- (void)fadeOut:(UIView *)view {
    [self fadeOut:view duration:0.3 delay:0 completion:nil];
}





#pragma mark - METHODS - Core Data


// Save numbers to CoreData

- (void)saveCurrentNumbers {
    
    if ([self.currentNumbers count] != 0) {
        
        NSString *numbersToSave = [self.currentNumbers componentsJoinedByString:@" "];
        
        
        
        
        // Create a new managed object
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Numbers" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *newNumbersObject = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:self.managedObjectContext];
        
        NSDate *currentDate = [NSDate date];
        
        if (![self.myNumbers containsObject:newNumbersObject]) {
            
            [newNumbersObject setValuesForKeysWithDictionary:@{
                                                               @"date": currentDate,
                                                               @"numbers": numbersToSave
                                                               }];
            
            NSError *error = nil;
            if (![self.managedObjectContext save:&error]) {
                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
            }
            
            [self.myNumbers addObject:newNumbersObject];
            [self.myNumbersTableView reloadData];
            
            
            // Hide button
            self.saveNumbersButton.alpha = 0.5;
            self.saveNumbersButton.enabled = NO;
            
            
            
            // Success!
            [self.saveNumbersButton setTitle:[@"Success!" uppercaseString] forState: UIControlStateNormal];
            
            
        }
        
    }
    
}


// Fetch saved numbers

- (void)fetchSavedNumbers {
    
    
    // Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Numbers"];
    
    NSError *error = nil;
    NSMutableArray *result = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if (error) {
        
        // Error notification
        [self.saveNumbersButton setTitle:@"ERROR!" forState:UIControlStateNormal];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(resetSaveNumbersButton) userInfo:nil repeats:NO];
        
    } else {
        
        // Update Table
        self.myNumbers = result;
        [self.myNumbersTableView reloadData];
        
    }
    
}


- (void)resetSaveNumbersButton {
    [self.saveNumbersButton setTitle:@"SAVE" forState:UIControlStateNormal];
}









#pragma mark - METHODS - Segues


- (void)showPreviousWinningNumbers {
    
    if ([self.previousNumbers count] == 0) {
        
        [self fetchPreviousWinners:^(NSArray *drawings) {
            if ([drawings count] > 0) {
                self.previousNumbers = drawings;
                
                [self.previousWinnersTableView reloadData];
            }
        }];
        /*
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
        });
        */
    }
    
    
    // Dynamically change font color
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: self.backgroundColor} forState:UIControlStateSelected];
    
    // Add Views
    [self.view addSubview:self.blurView];
    [self fadeIn:self.blurView duration:0.3 delay:0 completion:nil];
    
    
}

- (IBAction)indexChanged:(id)sender {
    UISegmentedControl *s = (UISegmentedControl *)sender;
    
    
    
    // Dynamically change font color
    [s setTitleTextAttributes:@{NSForegroundColorAttributeName: self.backgroundColor} forState:UIControlStateSelected];
    
    
    switch ([s selectedSegmentIndex]) {
        case 0:
        {
            [self fadeOut:self.myNumbersTableView duration:0.2 delay:0 completion:^(bool completed) {
                // Remove Numbers Table
                [self.myNumbersTableView removeFromSuperview];
                
                // Add Previous Numbers Table
                [self.blurView addSubview:self.previousWinnersTableView];
                [self fadeIn:self.previousWinnersTableView];
                
                // Data Source label
                [self.blurView addSubview:self.dataSourceLabel];
                [self fadeIn:self.dataSourceLabel];
                
            }];
            
            
            break;
        }
            
        case 1:
        {
            // Data Source label
            [self fadeOut:self.dataSourceLabel];
            
            // Table
            [self fadeOut:self.previousWinnersTableView duration:0.2 delay:0 completion:^(bool completed) {
                
                // Remove numbers table
                [self.previousWinnersTableView removeFromSuperview];
                
                // Add Previous Numbers Table
                [self.blurView addSubview:self.myNumbersTableView];
                [self fadeIn:self.myNumbersTableView];
                
            }];
            
            break;
        }
            
        default:
            break;
    }
    
}



#pragma mark - METHODS - Sharing

// Share Button

- (void)toggleShareButton {
    UIColor *bgColor = myNumberIsSelected ? [[UIColor whiteColor] colorWithAlphaComponent:0.8] : [UIColor clearColor];
    NSString *title = myNumberIsSelected ? @"SHARE THESE NUMBERS" : @"SHARE THE FUN";
    UIColor *titleColor = myNumberIsSelected ? self.backgroundColor : [UIColor whiteColor];
    UIColor *titleColorHighlighted = myNumberIsSelected ? [self.backgroundColor colorWithAlphaComponent:0.2] : [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    
    self.shareButton.backgroundColor = bgColor;
    [self.shareButton setTitleColor:titleColor forState:UIControlStateNormal];
    [self.shareButton setTitleColor:titleColorHighlighted forState:UIControlStateHighlighted];
    [self.shareButton setTitle:title forState:UIControlStateNormal];
}

- (void)showShareView {
    
    NSArray *excludedActivityItems = @[
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList
                                       ];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.textToShare] applicationActivities:nil];
    activityVC.excludedActivityTypes = excludedActivityItems;
    [self presentViewController:activityVC animated:YES completion:nil];
    
}





@end



