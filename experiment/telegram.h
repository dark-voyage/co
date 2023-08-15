#import <Foundation/Foundation.h>

@interface Telegram : NSObject

- (instancetype)init:(NSString *)token;
- (void)startPolling;
- (void)sendMessage:(NSString *)chatId text:(NSString *)text;

@end