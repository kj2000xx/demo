//
//  YahooCurrencyRateLoader.m
//  Currency
//
//  Created by Shane on 2017/8/19.
//  Copyright © 2017年 Shane. All rights reserved.
//

#import "YahooCurrencyRateLoader.h"
#import <UIKit/UIKit.h>
@implementation YahooCurrencyRateLoader

#pragma mark Get UserDefault
//getFavorListName_Arr 使用者的最愛清單
-(NSMutableArray*)getUserFavorListName_Arr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorListName_Arr = [NSMutableArray new];
    favorListName_Arr = [[defaults objectForKey:@"favorListName_Arr"] mutableCopy];
    
    if (favorListName_Arr) {
        NSLog(@"favorListName_Arr loading from saved is  %@",favorListName_Arr);
        
    }else{
        
        favorListName_Arr =[@[@"USD",@"TWD",@"JPY",@"HKD",@"CNY",@"AUD",@"EUR",@"KRW",@"CHF"]mutableCopy];
        NSLog(@"favorListName_Arr new created is   %@",favorListName_Arr);
        
        [defaults setObject:favorListName_Arr forKey:@"favorListName_Arr"];
        [defaults synchronize];
    }
    
    return favorListName_Arr;
}

//get UserKeyIn_Arr 紀錄使用者最後keyIn的基準幣值
-(NSArray*)getUserKeyIn_Arr{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *userKeyIn_Arr = [NSArray new];
    userKeyIn_Arr = [defaults objectForKey:@"userKeyIn_Arr"];
    
    if (userKeyIn_Arr) {
        NSLog(@"userKeyIn_Arr loading from saved is  %@",userKeyIn_Arr);
        
    }else{
        
        userKeyIn_Arr =@[@"USD",@"1"];
        [defaults setObject:userKeyIn_Arr forKey:@"userKeyIn_Arr"];
        NSLog(@"userKeyIn_Arr new created is   %@",userKeyIn_Arr);
        [defaults synchronize];
    }
    return userKeyIn_Arr;
}

//get favorListRate_Dic
-(NSMutableDictionary*)getFavoritListRate_Dic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *favorListRate_Dic = [NSMutableDictionary new];
    favorListRate_Dic = [defaults objectForKey:@"favorListRate_Dic"];
    
    return favorListRate_Dic;
    
}

#pragma mark get UserDefault historicalRate
//get historicalRate_Dic
-(NSDictionary*)getHistoricalRate_Dic{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *historicalRate_Dic =[NSDictionary new];
    historicalRate_Dic = [defaults objectForKey:@"historicalRate_Dic"];
    
    if (historicalRate_Dic) {
        NSLog(@"historicalRate_Dic loading from saved is  %@",historicalRate_Dic);
        
    }else{
        
        historicalRate_Dic =@{@"USD":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"TWD":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"JPY":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"HKD":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"CNY":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"AUD":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"EUR":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"KRW":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]],
                              @"CHF":@[@[@"4/7",@""],@[@"4/6",@""],@[@"4/5",@""],@[@"4/4",@""],@[@"4/3",@""],@[@"4/2",@""]]
                              };
        
        [defaults setObject:historicalRate_Dic forKey:@"historicalRate_Dic"];
        NSLog(@"historicalRate_Dic new created is   %@",historicalRate_Dic);
        [defaults synchronize];
    }
    return historicalRate_Dic;
}



#pragma loadYahooCurrency
//取得yahoo即時匯率
-(void)loadYahooCurrency{
    //取得使用者最後輸入的基準外幣名稱
    NSArray *userKeyIn_Arr = [NSArray new];
    userKeyIn_Arr = [self getUserKeyIn_Arr];
    
    //取得使用者的最愛外幣清單名稱
    NSMutableArray *userSymbol_arr = [NSMutableArray new];
    userSymbol_arr  = [self getUserFavorListName_Arr];
    
    //將基準外幣名稱與最愛外幣名稱混合成yahoo api所需的symbol關鍵字
    NSString *symbolToURL = [NSString new];
    for (int i = 0; i < userSymbol_arr.count; i++) {
        NSString *symbolOLD = [[NSString alloc] initWithString:symbolToURL];
        NSString *symbolWithArr = userSymbol_arr[i];
        NSString *symbolWithKeyInInfo = userKeyIn_Arr[0];
        NSString *symbolAppendKeyIN = [[NSString alloc] initWithFormat:@"%@%@=x",symbolWithKeyInInfo,symbolWithArr ];
        
        if (![symbolOLD isEqualToString:@""] ) {
            NSString *symbolAppendNew = [[NSString alloc] initWithFormat:@",%@",symbolAppendKeyIN ];
            symbolToURL = [symbolOLD stringByAppendingString:symbolAppendNew];
            
        }else{
            NSString *symbolAppendNew = [[NSString alloc] initWithFormat:@"%@",symbolAppendKeyIN ];
            symbolToURL = [symbolOLD stringByAppendingString:symbolAppendNew];
        }
    }
    
    //將完成的特殊symbol放入yahoo api的url之中
    //    NSLog(@"symbolTOURl is  %@   \n",symbolToURL);
    NSString *yahooURL = [[NSString alloc] initWithFormat:@"https://query1.finance.yahoo.com/v7/finance/quote?symbols=%@",symbolToURL];
    
    //   NSLog(@"yahooURL is   %@   \n",yahooURL);
    NSURL *url = [NSURL URLWithString:yahooURL];
    
    //利用url從yahoo fiance下載所需匯率的Jason資料
    NSError __autoreleasing *error ;
    NSData *yahooURL_data = [NSData  dataWithContentsOfURL:url];
    
    //NSLog(@"yahooURL_data's value is  %@   \n",yahooURL_data );
    
    //從Jason中取得匯率，並製作成rate陣列
    NSDictionary *rateJSData = [NSJSONSerialization JSONObjectWithData:yahooURL_data options:0 error:&error];
    if (error) {
        NSLog(@"取的匯率失敗");
    }else{
        NSDictionary *quoteResponse = [rateJSData objectForKey:@"quoteResponse"];
        NSArray *result = [quoteResponse objectForKey:@"result"];
        
    //將rate陣列中的匯率資料整理拆分成幣名與匯率，再紀錄到favorListRate辭典
        NSMutableDictionary *favorListRate_Dic = [NSMutableDictionary new];
        
    for (int i = 0; i < result.count ; i++) {
        
        NSDictionary *arrToDic =result[i];
        
        NSString *key = [arrToDic objectForKey:@"currency"];
        
        NSString *value = [arrToDic objectForKey:@"bid"] ;
        
        [favorListRate_Dic setObject:value forKey:key];
    }
    
    NSLog(@"Dic favorListRate_Dic creat suscessed   %@", favorListRate_Dic );
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:favorListRate_Dic forKey:@"favorListRate_Dic" ];
    }
}


#pragma loadYahooHistoricalRate

-(void)loadYahooHistoricalDataNew:(NSString*)countryName keyInCountry:(NSString*)userKeyInCountry{
    
    
    NSDictionary *interval_dic =[NSDictionary new];
    interval_dic = @{@"1d":@"90m",@"7d":@"1d",@"1mo":@"1d",@"6mo":@"1mo",@"1y":@"1mo"};
    
    NSString *range_str = [[NSUserDefaults standardUserDefaults] objectForKey:@"rangeForURL_str"];
    
    NSString *interval_str = [NSString new];
    interval_str = interval_dic[range_str];
    
    NSString *yahooHistorical_5daysURL = [[NSString alloc] initWithFormat:@"https://query1.finance.yahoo.com/v7/finance/chart/USD%@=X?range=%@&interval=%@&indicators=quote&includeTimestamps=true&includePrePost=false&corsDomain=finance.yahoo.com",countryName,range_str,interval_str];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    
    NSURL *url = [NSURL URLWithString:yahooHistorical_5daysURL];
    NSError __autoreleasing *error;
    NSData *yahooData =[NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
    if (error) {
        NSLog(@"取得%@歷史匯率失敗",countryName);
    }else{
        NSDictionary *jasonData = [NSJSONSerialization JSONObjectWithData:yahooData options:NSJSONReadingAllowFragments error:&error];
        
        //        拆解jason
        NSDictionary *chart = [jasonData objectForKey:@"chart"];
        NSArray *result = [chart objectForKey:@"result"];
        NSDictionary *resultTransToDic = result[0];
        
        //        timeStamp為最近五天時間，並利用epochTimeTranslate方法把epoch轉換成MM/dd格式
        NSArray *timeStamp = [resultTransToDic objectForKey:@"timestamp"];
        timeStamp = [self epochTimetranslate:timeStamp];
        NSDictionary *indicators = [resultTransToDic objectForKey:@"indicators"];
        
        //        close為最近五天時間的匯率
        NSArray *quote = [indicators objectForKey:@"quote"];
        NSArray *close = [quote[0] objectForKey:@"close"];
        //        NSLog(@"close is %@",close);
        
        //        把日期跟匯率組合成historicalRate的格式
        NSMutableArray *dayAndRate = [NSMutableArray new];
        for (int i = 0; i <= timeStamp.count-1 ; i++) {
            NSMutableArray *temp = [NSMutableArray new];
            temp[0] = timeStamp[i];
            temp[1] = close[i];
            
            dayAndRate[i] = temp;
        }
        
        NSMutableDictionary *historicalRate_Dic = [[self getHistoricalRate_Dic] mutableCopy];
        [historicalRate_Dic setObject:dayAndRate forKey:countryName];
        NSLog(@"%@",historicalRate_Dic);
        [[NSUserDefaults standardUserDefaults] setObject:historicalRate_Dic forKey:@"historicalRate_Dic"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
        
    });
}



#pragma mark epochTimeTranslate
//將輸入的epochtime轉成希望的時間格式
-(NSMutableArray*)epochTimetranslate:(NSArray*) fivedayTimesArray{
    NSMutableArray *transedFivedayTimesArray = [NSMutableArray new];
    
    for (int i = 0; i <= fivedayTimesArray.count-1; i++) {
        //顯示字串是1970年以來的秒數
        //NSString *epochTime = @"1500850800";
        
        NSString *epochTime = fivedayTimesArray[i];
        //把 NSString 轉換成 NSinterval
        NSTimeInterval seconds = [epochTime doubleValue];
        
        //步驟一 創建NSdate對象
        NSDate *epochNSDate = [[NSDate alloc] initWithTimeIntervalSince1970:seconds];
        //        NSLog(@"Epoch time \"%@\" 等於UTC \"%@\"",epochTime,epochNSDate);
        
        //步驟二 使用NSFormatter在本地時區顯示epochTime
        NSDateFormatter *dateFormatter = [NSDateFormatter new];
        //        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        [dateFormatter setDateFormat:@"MM/dd"];
        
        NSString *finalDate = [dateFormatter stringFromDate:epochNSDate];
        //        NSLog(@"最終轉換結果時間為 \"%@\"\n",finalDate);
        
        //順便顯示當地時區
        //        NSString *currentTimeZone = [[dateFormatter timeZone] abbreviation];
        //        NSLog(@"當地時區為 \"%@\"\n",currentTimeZone);
        
        transedFivedayTimesArray[i] = finalDate;
    }
    NSLog(@"transedFivedayTimesArray is %@",fivedayTimesArray);
    return transedFivedayTimesArray;
    
}


@end
