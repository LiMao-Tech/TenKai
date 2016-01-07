//
//  LMCollectionViewController.m
//  Swapp
//
//  Created by Yumen Cao on 7/26/15.
//  Copyright (c) 2015 Limao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ProfilePicsCollectionViewController.h"
#import "ProfilePicsCollectionViewCell.h"


@interface ProfilePicsCollectionViewController()

@end

@implementation ProfilePicsCollectionViewController

enum CELLSIZE {
    STDSIZE = 1,
    LSIZE = 2
};

static NSString *ProfilePicsCellIdentifier = @"ppCell";
static NSString *ProfilePicsCellXibName = @"ProfilePicsCollectionViewCell";
static NSString *hostName = @"http://www.limao-tech.com/Ten/";
static NSString *cloudAddrYumen = @"http://www.code-desire.com.tw/LiMao/TenImages";

- (id) initWithHeight:(CGFloat) height Width: (CGFloat)width ToolbarHeight: (CGFloat) toolbarHeight {
    self = [super init];
    if (self) {
        SCREEN_WIDTH = width;
        SCREEN_HEIGHT = height;
        TOOL_BAR_HEIGHT = toolbarHeight;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"相簿";
    
    // afnetoworking
    
    self.afHttpManager = [[AFHTTPSessionManager alloc] init];
    self.afHttpManager.requestSerializer = [[AFJSONRequestSerializer alloc] init];
    self.afHttpManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
    
    // init the layout data
    self.numberOfPics = 10;
    self.BLOCK_DIM = SCREEN_WIDTH / 4;
    [self dataInit];
    
    // init the layout
    LMCollectionViewLayout * layout = [[LMCollectionViewLayout alloc] init];
    layout.delegate = self;
    layout.blockPixels = CGSizeMake(self.BLOCK_DIM, self.BLOCK_DIM);
    
    // init the view
    self.lmCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOOL_BAR_HEIGHT) collectionViewLayout:layout];
    self.lmCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.lmCollectionView.backgroundColor = [UIColor darkGrayColor];
    self.lmCollectionView.bounces = YES;
    self.lmCollectionView.alwaysBounceVertical = YES;
    self.lmCollectionView.delegate = self;
    self.lmCollectionView.dataSource = (id)self;
    
    // create toolbar
    UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0,SCREEN_HEIGHT-TOOL_BAR_HEIGHT, SCREEN_WIDTH, TOOL_BAR_HEIGHT)];
    toolbar.backgroundColor = [UIColor darkGrayColor];
    
    UIBarButtonItem * optionItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"btn_tabBarIcon_option"] style: UIBarButtonItemStylePlain target:self action: @selector(toolBarOption)];
    UIBarButtonItem * unlockItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"btn_tabBarIcon_unlock"] style: UIBarButtonItemStylePlain target:self action: @selector(toolBarUnlock)];
    UIBarButtonItem * lockItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"btn_tabBarIcon_lock"] style: UIBarButtonItemStylePlain target:self action: @selector(toolBarLock)];
    UIBarButtonItem * deleteItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed: @"btn_tabBarIcon_delete"] style: UIBarButtonItemStylePlain target:self action: @selector(toolBarDelete)];

    // adjust insets
    UIEdgeInsets insets = UIEdgeInsetsMake(3, 0, 3, 0);
    optionItem.imageInsets = insets;
    optionItem.width = 15;
    unlockItem.imageInsets = insets;
    unlockItem.width = 5;
    lockItem.imageInsets = insets;
    lockItem.width = 5;
    deleteItem.imageInsets = insets;
    deleteItem.width = 5;
    
    // insert paddings between items
    UIBarButtonItem * padding = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    padding.width = (SCREEN_WIDTH - 4*optionItem.width)/3;

    NSMutableArray * itemArr = [[NSMutableArray alloc] init] ;
    [itemArr addObject:optionItem];
    [itemArr addObject:padding];
    [itemArr addObject:unlockItem];
    [itemArr addObject:padding];
    [itemArr addObject:lockItem];
    [itemArr addObject:padding];
    [itemArr addObject:deleteItem];
    toolbar.items = itemArr;
    
    // Register Xib
    UINib * ppCell = [UINib nibWithNibName:ProfilePicsCellXibName bundle:nil];
    [self.lmCollectionView registerNib: ppCell forCellWithReuseIdentifier:ProfilePicsCellIdentifier];
    
    // Add to view
    [self.view addSubview: self.lmCollectionView];
    [self.view addSubview: toolbar];
    [self.lmCollectionView reloadData];
}


- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) toolBarOption {
    
}

- (void) toolBarUnlock {
    
}

- (void) toolBarLock {
    
}

- (void) toolBarDelete {
    
}

- (void) addImage {
    
}

// SharedUser.StandardUser().UserIndex
- (void) postImage:(NSData *) imageData toUrl: (NSString *) targetUrl {
    
    NSDictionary * params = @{@"id" : @1};
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString * fileDate = [formatter stringFromDate:[[NSDate alloc] init]];
    NSString * fileName = [fileDate stringByAppendingString:@".png"];

    [self.afHttpManager POST:targetUrl parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"upload"
                                fileName:fileName
                                mimeType:@"image/png"];
    } progress: ^(NSProgress * uploadProgress) {
        
    } success: ^(NSURLSessionDataTask * task , id responseObject) {
         
     } failure:^(NSURLSessionDataTask * task , NSError * error ) {
         
     }];
    

}

- (void)dataInit {
    self.num = 0;
    self.numbers = [@[] mutableCopy];
    self.numberWidths = @[].mutableCopy;
    self.numberHeights = @[].mutableCopy;
    
    for(; self.num < self.numberOfPics; self.num++) {
        [self.numbers addObject:@(self.num)];
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
    NSIndexPath *toAdd = [visibleIndexPaths firstObject];[visibleIndexPaths objectAtIndex:middle];
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
    
    // Configure the cell
    NSString *cellImageUrlStr = [NSString stringWithFormat:@"%@%ld.png", cloudAddrYumen,(long)indexPath.row];
    NSURL * cellImageUrl = [NSURL URLWithString : cellImageUrlStr];
        
        
    [self downloadImageWithURL:cellImageUrl completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            // change the image in the cell
            [cell.cellImage setImage: image];
            
            // cache the image for use later (when scrolling up)
        }
        else {
            NSLog(@"Waiting for image.");
        }
    }];
    
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
        [self.numbers insertObject:@(++self.num) atIndex:index];
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
        
        // [self.numbers removeObjectAtIndex:index];
        [self.numberWidths removeObjectAtIndex:index];
        [self.numberHeights removeObjectAtIndex:index];
        
        [self.lmCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        
        //  [self.numbers insertObject:@(++num) atIndex:index];
        [self.numberWidths insertObject:@(LSIZE) atIndex:index];
        [self.numberHeights insertObject:@(LSIZE) atIndex:index];
        
        [self.lmCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
        /*
         NSUInteger width = self.numberWidths[index];
         NSUInteger height = self.numberHeights[index];
         
         [self.numberWidths replaceObjectAtIndex:index withObject:@(width*2)];
         [self.numberHeights replaceObjectAtIndex:index withObject:@(height*2)];
         */
    } completion:^(BOOL done) {
        isAnimating = NO;
    }];
}

#pragma mark helpers

- (NSUInteger)randomLength
{
    return 1;
}

- (void) downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}

@end
