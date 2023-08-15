//
//  main.m
//  experiment
//
//  Created by Sokhibjon Orzikulov on 15/08/23.
//

#import <Foundation/Foundation.h>
#import "telegram.h"

int main(int argc, const char *argv[]) {
  @autoreleasepool {
    const char *token = getenv("TELEGRAM_BOT");
    if (token) {
      NSString *botToken = [NSString stringWithUTF8String:token];
      Telegram *bot = [[Telegram alloc] init:botToken];
      [bot startPolling];
      [[NSRunLoop mainRunLoop] run];
    } else {
      NSLog(@"TELEGRAM_BOT environment variable is not set");
    }
  }
  return 0;
}
