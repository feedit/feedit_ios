//
//  showArticle.h
//  feedit_ios
//
//  Created by xdf on 12/5/14.
//  Copyright (c) 2014 xdf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwapData.h"

@interface ShowArticle : UIViewController<UIWebViewDelegate> {
}
@property (retain,nonatomic) SwapData *swapData;
@end