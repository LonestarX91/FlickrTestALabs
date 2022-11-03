//
//  ViewController.m
//  Flickrtest
//
//  Created by Daniel on 01.11.2022.
//

#import "ViewController.h"

@interface ViewController () {
    NSInteger currentPage;
    NSDate *lastLoad;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FlickrCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:self.photosArray[indexPath.row][@"URL"]];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)text {
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    currentPage = 0;
    if (text == nil || [text  isEqual: @""]) {
        [self.view endEditing:true];
        [[self collectionView] reloadData];
    } else {
        [self loadSearch:text forPage:currentPage];
    }
}

- (void)loadSearch:(NSString *)text forPage:(NSInteger)page {
    [NetworkManager.sharedInstance getPhotosForText:text onPage:page withResult:^(NSArray<UIImage *> *result) {
        if (result) {
            self.photosArray = result.mutableCopy;
            [self.collectionView reloadData];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    BOOL end = self.collectionView.contentOffset.y >= (self.collectionView.contentSize.height - self.collectionView.frame.size.height);
    if (end) {
        if ([[NSDate date] timeIntervalSinceDate:lastLoad] < 2) //this is so when you scroll fast it doesn't load multiple pages, just 1 by 1 so we don't add useless data
            return;
        lastLoad = NSDate.now;
        currentPage++;
        [NetworkManager.sharedInstance getPhotosForText:self.searchBar.text onPage:currentPage withResult:^(NSArray<UIImage *> *result) {
            if (result) {
                [self.photosArray addObjectsFromArray:result.mutableCopy];
                [self.collectionView reloadData];
            }
        }];
    }
}


@end
