//
//  FPNetworkCostTool.h
//  Funnyplanet
//
//  Created by YannChee on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const DataCounterKeyWWANSent;
static NSString *const DataCounterKeyWWANReceived;
static NSString *const DataCounterKeyWiFiSent;
static NSString *const DataCounterKeyWiFiReceived;

@interface FPNetworkCostTool : NSObject

+ (NSDictionary *)trackDataBytes;

@end

NS_ASSUME_NONNULL_END
