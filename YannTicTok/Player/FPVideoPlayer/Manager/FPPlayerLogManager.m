//
//  FPPlayerLogManager.m
//  YannIjkPlayer
//
//  Created by YannChee on 2021/11/1.
//

#import "FPPlayerLogManager.h"

static BOOL kLogEnable = NO;

@implementation FPPlayerLogManager

+ (void)setLogEnable:(BOOL)enable {
    kLogEnable = enable;
}

+ (BOOL)getLogEnable {
    return kLogEnable;
}


+ (void)logWithFunction:(const char *)function lineNumber:(int)lineNumber formatString:(NSString *)formatString {
    if ([self getLogEnable]) {
        NSLog(@"FPPlayer******%s[%d]%@", function, lineNumber, formatString);
    }
}

@end
