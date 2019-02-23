//
//  YahooCurrencyRateLoader.h
//  Currency
//
//  Created by Shane on 2017/8/19.
//  Copyright © 2017年 Shane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YahooCurrencyRateLoader : NSObject

-(void)loadYahooCurrency;
-(void)loadYahooHistoricalDataNew:(NSArray*)countryNameArr keyInCountry:(NSString*)userKeyInCountry;

@end
