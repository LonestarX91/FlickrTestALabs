//
//  NetworkManager.m
//  Flickrtest
//
//  Created by Daniel on 01.11.2022.
//

#import "NetworkManager.h"

@implementation NetworkManager

static NSString * const APIKEY = INSERT_API_KEY_HERE;

+ (instancetype)sharedInstance {
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NetworkManager alloc] init];
    });
    return sharedInstance;
}

- (void)getPhotosForText:(NSString *)text onPage:(NSInteger)page withResult:(void (^)(NSArray<UIImage *>*))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&format=json&nojsoncallback=1&text=%@&page=%ld", APIKEY, text, (long)page]];
    
    NSLog(@"URL: %@", url.absoluteString);

    NSURLSessionDataTask *dataTask = [NSURLSession.sharedSession dataTaskWithURL:url
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                if (error && data) {
                                                    NSLog(@"Error fetching image from URL: %@", error);
                                                    return;
                                                } else {
                                                     NSDictionary<NSString *, id> *resultDictionary  = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                                                    NSLog(@"%@", resultDictionary);
                                                    if (resultDictionary[@"photos"] && resultDictionary[@"photos"][@"photo"]) {
                                                        NSMutableArray *photosArray = NSMutableArray.new;
                                                        for (NSMutableDictionary *photo in resultDictionary[@"photos"][@"photo"]) {
                                                            NSMutableDictionary *item = photo.mutableCopy;
                                                            item[@"URL"] = [NSString stringWithFormat:@"https://live.staticflickr.com/%@/%@_%@.jpg", photo[@"server"], photo[@"id"], photo[@"secret"]];
                                                            [photosArray addObject:item];
                                                            }
//                                                        NSLog(@"PHOTOS:%@", photosArray);
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            completion(photosArray);
                                                        });
                                                        }
                                                    else completion(nil);
                                                    }
                                            }];
    [dataTask resume];

    
}

@end
