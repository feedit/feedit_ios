//
//  swapData.h
//  feedit_ios
//
//  Created by xdf on 12/5/14.
//  Copyright (c) 2014 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwapData : NSObject {
    NSString *targetUrl;
    NSString *targetTitle;
}
@property(nonatomic,retain) NSString *targetUrl;
@property(nonatomic,retain) NSString *targetTitle;
@end