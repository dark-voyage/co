#import "telegram.h"

static NSString *const kTelegramApiBaseUrl = @"https://api.telegram.org/bot";

@implementation Telegram {
    NSString *_botToken;
    NSInteger _lastUpdateId;
    NSURLSession *_session;
}

- (instancetype)init:(NSString *)token {
    self = [super init];
    if (self) {
        _botToken = token;
        _lastUpdateId = 0;
        _session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)startPolling {
  [self getUpdates];
}

- (void)getUpdates {
  NSString *urlString = [NSString stringWithFormat:@"%@%@/getUpdates?offset=%ld", kTelegramApiBaseUrl, _botToken,
                                                   _lastUpdateId + 1];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSessionDataTask *task = [_session dataTaskWithURL:url completionHandler:^(NSData *_Nullable data,
                                                                                 NSURLResponse *_Nullable response,
                                                                                 NSError *_Nullable error) {
    if (!data) {
      return;
    }

    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *updates = json[@"result"];
    for (NSDictionary *update in updates) {
        self->_lastUpdateId = [update[@"update_id"] integerValue];
      NSDictionary *message = update[@"message"];
      NSString *chatID = [NSString stringWithFormat:@"%@", message[@"chat"][@"id"]];
      NSString *text = message[@"text"];
      [self sendMessage:chatID text:text];
    }

    [self getUpdates];
  }];
  [task resume];
}

- (void)sendMessage:(NSString *)chatId text:(NSString *)text {
    NSString *urlString = [NSString stringWithFormat:@"%@%@/sendMessage", kTelegramApiBaseUrl, _botToken];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSDictionary *params = @{@"chat_id": chatId, @"text": text};
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    request.HTTPBody = bodyData;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error sending message: %@", error);
            return;
        }

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (![json[@"ok"] boolValue]) {
            NSLog(@"Failed to send message: %@", json[@"description"]);
        }
    }];
    [task resume];
}

@end
