//
//;  MyCollectionViewCell.m
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/6.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import <UIKit/UIKit.h>
#import "CurrencyFinal_1.34_charts-Bridging-Header.h"


@interface MyCollectionViewCell()<ChartViewDelegate>


@property(nonatomic) UIView *legend;
@property(nonatomic) UIImageView *backgroundGradientView;
@property(nonatomic) LineChartView *lineChartView;
@property(nonatomic) LineChartData *lineChartData;


@property(nonatomic) BOOL isOpen;
@property(nonatomic) NSArray *optionItem;

@property(nonatomic) CGRect tableFrame;

@end

@implementation MyCollectionViewCell


-(void)awakeFromNib{
    [super awakeFromNib];
    //舊的建立pnchart圖表
//     self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(self.frame.origin.x+10,self.frame.origin.y+25, self.frame.size.width-20, self.frame.size.height-40)];
    
    //創建漸層色背景
    [self creatBackgroundGradientImageView];

    self.flagForLabel = [[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 35, 35)];
    self.countryName_label = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 100, 40)];
    
    [self addSubview:self.countryName_label];
    [self addSubview:self.flagForLabel];
    
    //創建歷史數據圖
    [self creatLineChartView];
    //設定天數按鈕
    [self setOptionTableViewSet];

}


#pragma mark creatLineChartView

-(void)creatLineChartView{
    
    float ratio = (float)4/5;
    
    _lineChartView =[[LineChartView alloc] initWithFrame:CGRectMake(_backgroundGradientView.frame.origin.x, _backgroundGradientView.frame.origin.y+_backgroundGradientView.frame.size.height*(1-ratio), _backgroundGradientView.frame.size.width, _backgroundGradientView.frame.size.height*ratio)];
    
    _lineChartView.delegate = self;
    _lineChartView.noDataText = @"無網際網路,請確認網路連線";
    _lineChartView.noDataTextColor = [UIColor whiteColor];
    _lineChartView.legend.enabled = NO;
    
    //取消y軸縮放
    _lineChartView.scaleYEnabled = NO;
    //取消雙擊縮放
    _lineChartView.doubleTapToZoomEnabled = NO;
    //啟用拖曳圖標
    _lineChartView.dragEnabled = YES;
    _lineChartView.chartDescription.enabled = NO;
    
    //x軸樣式設定
    ChartXAxis *xAxis = _lineChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    //不畫x軸的網格線
    xAxis.drawGridLinesEnabled = NO;
    //取消右邊外框軸
    _lineChartView.rightAxis.enabled = NO;
    xAxis.labelCount = 5;
    xAxis.avoidFirstLastClippingEnabled = YES ;
    xAxis.forceLabelsEnabled = YES;
    xAxis.axisLineColor = [UIColor whiteColor];
    xAxis.labelTextColor = [UIColor whiteColor];
    
    //y軸樣式設定
    ChartYAxis *yAxis = _lineChartView.leftAxis;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    numberFormatter.roundingMode = NSNumberFormatterRoundFloor;
    numberFormatter.maximumFractionDigits = 4 ;
    yAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numberFormatter];
    yAxis.axisMinimum = 0;
    yAxis.drawGridLinesEnabled = NO;
    yAxis.axisLineColor = [UIColor whiteColor];
    yAxis.labelTextColor = [UIColor whiteColor];
    
    LineChartData *data = [self setData];
    
    _lineChartView.data = data ;
    
    
    [_lineChartView animateWithYAxisDuration:0.5f];
    [self addSubview:_lineChartView];
    [self insertSubview:_optionTableView aboveSubview:_lineChartView];
}


#pragma mark LineChartData Set
-(LineChartData *)setData{
    //設定x軸資料
    int xVals_count = 5;
    NSMutableArray *xVals = [NSMutableArray new];

    for (int i = 0; i < xVals_count; i++) {
        
        [xVals addObject:[NSString stringWithFormat:@"0%d/19",i+1]];
    }

    _lineChartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xVals];
    
    //設定y軸資料
    NSMutableArray *yVals = [NSMutableArray new];
    NSArray *tempYvals = @[@"0.3012",@"0.3123",@"0.3234",@"0.3456",@"0.2667"];
    //    NSArray *tempYvals = @[@0.3012,@0.3123,@0.3234,@0.33456,@0.3567];

    for (int i = 0; i < 5; i++) {
        double val = [tempYvals[i] doubleValue];
        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
        [yVals addObject:entry];
    }
    
    
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:yVals label:@""];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    numberFormatter.roundingMode = NSNumberFormatterRoundFloor;
    numberFormatter.maximumFractionDigits = 3 ;
    set1.valueFormatter = [[ChartDefaultValueFormatter alloc] initWithFormatter:numberFormatter];
    
    set1.drawCircleHoleEnabled = NO;
    set1.circleRadius = 3.0;
    set1.circleColors = @[[UIColor whiteColor]];
    
    //y軸線的漸層效果
//    set1.isDrawLineWithGradientEnabled = true;
//    set1.gradientPositions = @[@0.30,@0.31,@0.32,@0.33];
    
    //y軸資料的line顏色
    [set1 setColor:[UIColor whiteColor]];
    
    //資料line的下方區塊遮照
    set1.drawFilledEnabled = YES;
    
    //每個y點之間線的顏色,無漸層效果
//    set1.colors = @ [[UIColor whiteColor] ,[UIColor redColor],[UIColor greenColor],[UIColor blueColor]];
    
    NSArray *gradientColors = @[(id)[ChartColorTemplates colorFromString:@"#FFFFFFFF"].CGColor,

                                (id)[ChartColorTemplates colorFromString:@"#C4F3FF"].CGColor];

    CGGradientRef gradientRef = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);

    set1.fillAlpha = 0.3f;//透明度

    set1.fill = [ChartFill fillWithLinearGradient:gradientRef angle:90.0f];//赋值填充颜色对象

    CGGradientRelease(gradientRef);//释放gradientRef
    
    
    NSMutableArray *dataSets = [NSMutableArray new];
    [dataSets addObject:set1];
    
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    
    return data;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self.superview.superview endEditing:true];
    
}


#pragma mark setTableView's properties
-(void)setOptionTableViewSet{
        _optioneTableViewController = [OptionTableViewController new];

        _optionTableView.delegate = _optioneTableViewController;
        _optionTableView.dataSource = _optioneTableViewController;

        _optionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _optionTableView.backgroundView.alpha = 0.1f;
        _optionTableView.layer.borderWidth = 1.2;
        _optionTableView.layer.borderColor = [UIColor whiteColor].CGColor;
        _optionTableView.layer.cornerRadius = 9;
        _optionTableView.backgroundColor= [UIColor clearColor];
        _optionTableView.estimatedRowHeight = 0;

        _optioneTableViewController.tableFrame = _optionTableView.frame;

}


#pragma mark creatBackgroundImageView
-(void)creatBackgroundGradientImageView {
    
    //使用RGB顏色模型
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    //漸層中所包含的關鍵顏色 RGBA
    CGFloat components[] = {0.96, 0.31, 0.0, 0.55,
        0.96, 0.31, 0.0, 0.7,
        0.96, 0.31, 0.0, 0.85,
        0.96, 0.31, 0.0, 1.0};
    //關鍵顏色所出現的位置
    CGFloat locations[] = {0.0, 0.33, 0.55, 1.0};
    //關鍵顏色的個數
    size_t count = 4;
    //製作漸層顏色模型
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, components, locations, count);
    CGColorSpaceRelease(rgb);
    //製作ImageView
    _backgroundGradientView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.origin.x+(self.frame.size.width*1/20) , self.frame.origin.y,self.frame.size.width*9/10, self.frame.size.height*17/18)];
    //開始繪圖
    UIGraphicsBeginImageContext(_backgroundGradientView.frame.size);
    //指定畫布
    CGContextRef context = UIGraphicsGetCurrentContext();
    //繪製漸層線條並儲存畫布
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(0.0, self.frame.size.height), 0);
    CGContextSaveGState(context);
    //將畫布指定給ImageView
    _backgroundGradientView.image = UIGraphicsGetImageFromCurrentImageContext();
    //結束繪圖
    UIGraphicsEndImageContext();
    //設定圓角
    _backgroundGradientView.layer.masksToBounds = YES ;
    _backgroundGradientView.layer.cornerRadius = 10;
    //將ImageView顯示於畫面
    [self addSubview:_backgroundGradientView];
}

/*



#pragma mark load Yahoo historical rate
//取得今天的時間
-(NSString *)getTodayDate{
    NSDate *dateSYS = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:dateSYS];
    return dateStr;
}

//取得今天開始往前數(int)day天的日期
-(NSString *)getPriousorLaterDateFromDateWithDay:(int)day{
    
    NSDate *dateSYS = [NSDate date];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:day];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *beforeDate = [calender dateByAddingComponents:comps toDate:dateSYS options:0];
    
    NSString *dateStr = [dateFormatter stringFromDate:beforeDate];
    return dateStr;
    
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

*/


@end
