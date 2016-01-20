//
//  LMCollectionViewController.m
//  Swapp
//
//  Created by Yumen Cao on 7/26/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ProfilePicsCollectionViewController.h"



@interface ProfilePicsCollectionViewController()

@end

@implementation ProfilePicsCollectionViewController

enum CELLSIZE {
    STDSIZE = 1,
    LSIZE = 2
};

static NSInteger Max_Download = 5;

static NSString *ProfilePicsCellIdentifier = @"ppCell";
static NSString *ProfilePicsCellXibName = @"ProfilePicsCollectionViewCell";
static NSString *ProfilePicUrl = @"http://www.limao-tech.com/Ten/TenImage?id=";
static NSString *ProfilePicsJSONUrl = @"http://www.limao-tech.com/Ten/TenImage/GetImagesByUser?id=";


- (id) initWithHeight:(CGFloat) height Width: (CGFloat)width ToolbarHeight: (CGFloat) toolbarHeight UserId: (NSInteger) userId {
    self = [super init];
    
    if (self) {
        self.UserID = userId;
        SCREEN_WIDTH = width;
        SCREEN_HEIGHT = height;
        TOOL_BAR_HEIGHT = toolbarHeight;
    }
    
    // afnetoworking
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.afUrlManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    self.afHttpManager = [[AFHTTPSessionManager alloc] init];
    self.afHttpManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    
    
    self.afImageDowloader = [[AFImageDownloader alloc] initWithSessionManager:self.afHttpManager downloadPrioritization:AFImageDownloadPrioritizationFIFO maximumActiveDownloads:Max_Download imageCache: nil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相簿";
    
    // init the layout data
    self.NumberOfPics = 0;
    BLOCK_DIM = SCREEN_WIDTH / 4;
    
    // init the layout
    LMCollectionViewLayout * layout = [[LMCollectionViewLayout alloc] init];
    layout.delegate = self;
    layout.blockPixels = CGSizeMake(BLOCK_DIM, BLOCK_DIM);
    
    // init the view
    self.lmCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOOL_BAR_HEIGHT) collectionViewLayout:layout];
    self.lmCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.lmCollectionView.backgroundColor = [UIColor darkGrayColor];
    self.lmCollectionView.bounces = YES;
    self.lmCollectionView.alwaysBounceVertical = YES;
    self.lmCollectionView.delegate = self;
    self.lmCollectionView.dataSource = (id)self;
    
    
    // Register Xib
    UINib * ppCell = [UINib nibWithNibName:ProfilePicsCellXibName bundle:nil];
    [self.lmCollectionView registerNib: ppCell forCellWithReuseIdentifier:ProfilePicsCellIdentifier];
    
    // Add to view
    [self.view addSubview: self.lmCollectionView];
    [self.lmCollectionView reloadData];
}

- (void) viewWillAppear:(BOOL)animated {
    NSString * targetUrl = [ProfilePicsJSONUrl stringByAppendingString:[NSString stringWithFormat:@"%li", self.UserID]];
    NSURL *URL = [NSURL URLWithString: targetUrl];

    self.afHttpManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    [self.afHttpManager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        
        self.picsInfoJson = responseObject;
        self.NumberOfPics = self.picsInfoJson.count;
        
        [self dataInit];
        [self.lmCollectionView reloadData];

    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) dataInit {
    Num = 0;
    self.numbers = [@[] mutableCopy];
    self.numberWidths = @[].mutableCopy;
    self.numberHeights = @[].mutableCopy;
    
    for(; Num < self.NumberOfPics; Num++) {
        [self.numbers addObject:@(Num)];
        [self.numberWidths addObject:@([self randomLength])];
        [self.numberHeights addObject:@([self randomLength])];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [self.lmCollectionView reloadData];
}

/*
- (IBAction)remove:(id)sender {
    
    if (!self.numbers.count) {
        return;
    }

    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *toRemove = [visibleIndexPaths objectAtIndex:(arc4random() % visibleIndexPaths.count)];
    [self removeIndexPath:toRemove];
}

- (IBAction)refresh:(id)sender {
    [self datasInit];
    [self.collectionView reloadData];
}

- (IBAction)add:(id)sender {
    NSArray *visibleIndexPaths = [self.collectionView indexPathsForVisibleItems];
    if (visibleIndexPaths.count == 0) {
        [self addIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        return;
    }
    NSUInteger middle = (NSUInteger)floor(visibleIndexPaths.count / 2);
    NSIndexPath *toAdd = [visibleIndexPaths firstObject];
    [visibleIndexPaths objectAtIndex:middle];
    [self addIndexPath:toAdd];
}
 */

- (UIColor*) colorForNumber:(NSNumber*)num {
    return [UIColor colorWithHue:((19 * num.intValue) % 255)/255.f saturation:1.f brightness:1.f alpha:.8f];
}

#pragma mark - UICollectionView Delegate

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self magnifyCellAtIndexPath:indexPath];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.numbers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    ProfilePicsCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier : ProfilePicsCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [self colorForNumber:self.numbers[indexPath.row]];
        
    UILabel* label = (id)[cell viewWithTag:5];
    if(!label) label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    label.tag = 5;
    label.textColor = [UIColor blackColor];
    label.text = [NSString stringWithFormat:@"%@", self.numbers[indexPath.row]];
    label.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row < self.picsInfoJson.count) {
        NSString * targetUrl = [ProfilePicUrl stringByAppendingString:[NSString stringWithFormat:@"%@", self.picsInfoJson[indexPath.row][@"ID"]]];
        
        NSURL * url = [NSURL URLWithString:targetUrl];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        
        self.afHttpManager.responseSerializer = [[AFImageResponseSerializer alloc] init];
        [self.afImageDowloader downloadImageForURLRequest:request
                                                  success:^(NSURLRequest *request, NSHTTPURLResponse  *response, UIImage *responseObject) {
                                                      cell.cellImage.image = responseObject;
                                                      
                                                      [self.lmCollectionView reloadData];
                                                      
                                                  }
                                                  failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
                                                      NSLog(@"Error: %@", error);
                                                  }];
    }
    
    
    cell.cellImage.contentMode = UIViewContentModeScaleAspectFill;
    return cell;
}


#pragma mark – LMCollectionViewLayoutDelegate

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout blockSizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row >= self.numbers.count) {
        NSLog(@"Asking for index paths of non-existant cells!! %ld from %lu cells", (long)indexPath.row, (unsigned long)self.numbers.count);
    }
    
    CGFloat width = [[self.numberWidths objectAtIndex:indexPath.row] floatValue];
    CGFloat height = [[self.numberHeights objectAtIndex:indexPath.row] floatValue];
    return CGSizeMake(width, height);
    
    //    if (indexPath.row % 10 == 0)
    //        return CGSizeMake(3, 1);
    //    if (indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 1);
    //    else if (indexPath.row % 7 == 0)
    //        return CGSizeMake(1, 3);
    //    else if (indexPath.row % 8 == 0)
    //        return CGSizeMake(1, 2);
    //    else if(indexPath.row % 11 == 0)
    //        return CGSizeMake(2, 2);
    //    if (indexPath.row == 0) return CGSizeMake(5, 5);
    //
    //    return CGSizeMake(1, 1);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetsForItemAtIndexPath:(NSIndexPath *)indexPath {
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - Helper methods

- (void)addIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > self.numbers.count) {
        
        return;
    }
    
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.lmCollectionView performBatchUpdates:^{
        NSInteger index = indexPath.row;
        [self.numbers insertObject:@(++Num) atIndex:index];
        [self.numberWidths insertObject:@(STDSIZE) atIndex:index];
        [self.numberHeights insertObject:@(STDSIZE) atIndex:index];
        
        [self.lmCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

- (void) magnifyCellAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.numbers.count || indexPath.row > self.numbers.count) return;
    
    if(isAnimating) return;
    isAnimating = YES;
    
    [self.lmCollectionView performBatchUpdates:^{
        NSInteger index = indexPath.row;
        

        [self.numberWidths removeObjectAtIndex:index];
        [self.numberHeights removeObjectAtIndex:index];
        
        [self.lmCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];

        [self.numberWidths insertObject:@(LSIZE) atIndex:index];
        [self.numberHeights insertObject:@(LSIZE) atIndex:index];
        
        [self.lmCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        /*
         NSUInteger width = self.numberWidths[index];
         NSUInteger height = self.numberHeights[index];
         
         [self.numberWidths replaceObjectAtIndex:index withObject:@(width*2)];
         [self.numberHeights replaceObjectAtIndex:index withObject:@(height*2)];
         */
    }
    completion:^(BOOL done)
    {
        isAnimating = NO;
    }];
}

#pragma mark helpers

- (NSUInteger)randomLength
{
    return 1;
}


@end
