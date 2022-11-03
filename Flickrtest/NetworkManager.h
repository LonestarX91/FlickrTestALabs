//
//  NetworkManager.h
//  Flickrtest
//
//  Created by Daniel on 01.11.2022.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject
+sharedInstance;
- (void)getPhotosForText:(NSString *)text onPage:(NSInteger)page withResult:(void (^)(NSArray<UIImage *>*))completion;

@end

NS_ASSUME_NONNULL_END
