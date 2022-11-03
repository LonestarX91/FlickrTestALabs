//
//  ViewController.h
//  Flickrtest
//
//  Created by Daniel on 01.11.2022.
//

#import <UIKit/UIKit.h>
#import "NetworkManager.h"
#import "FlickrCollectionViewCell.h"
#import <SDWebImage/SDWebImage.h>

@interface ViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSMutableArray *photosArray;

@end

