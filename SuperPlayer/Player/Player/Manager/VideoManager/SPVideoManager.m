//
//  SPVideoManager.m
//  Player
//
//  Created by hz on 2021/11/12.
//

#import "SPVideoManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
@implementation SPVideoManager

static SPVideoManager *_mgr = nil;

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_mgr) {
            _mgr = [[SPVideoManager alloc] init];
        }
    });
    return _mgr;
}

- (void)getThumbnailImage:(NSString *)videoPath completion:(MyImageBlock)handler {

    NSURL *fileURL = [NSURL fileURLWithPath:videoPath];
        
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
        AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
        NSError *error = nil;
        CMTime actualTime;
        CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
        UIImage *thumb = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(thumb);
        });
    });
}

@end
