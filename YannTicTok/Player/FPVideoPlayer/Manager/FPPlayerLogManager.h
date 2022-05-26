//
//  FPPlayerLogManager.h
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/1.
//

#import <Foundation/Foundation.h>

#define FPPlayerLog(format,...)  [FPPlayerLogManager logWithFunction:__FUNCTION__ lineNumber:__LINE__ formatString:[NSString stringWithFormat:format, ##__VA_ARGS__]]

NS_ASSUME_NONNULL_BEGIN

@interface FPPlayerLogManager : NSObject

+ (void)setLogEnable:(BOOL)enable;

+ (BOOL)getLogEnable;

+ (void)logWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString;

@end

NS_ASSUME_NONNULL_END
