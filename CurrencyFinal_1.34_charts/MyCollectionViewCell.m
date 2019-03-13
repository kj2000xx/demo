//
//;  MyCollectionViewCell.m
//  Currency_table&Scorw
//
//  Created by Shane on 2016/4/6.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import <UIKit/UIKit.h>

@interface MyCollectionViewCell()<ChartViewDelegate,UIGestureRecognizerDelegate>



@property(nonatomic) BOOL isOpen;
@property(nonatomic) NSArray *optionItem;

@property(nonatomic) CGRect tableFrame;
@property(nonatomic) LineChartData *dataForLineChart;

@property (weak, nonatomic) IBOutlet UIView *selectedPresntTimeAndPriceView;
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundGradientView;

@property(nonatomic) UIGestureRecognizer *gest;

@end

@implementation MyCollectionViewCell


-(void)awakeFromNib{
    [super awakeFromNib];
    
    //舊的建立pnchart圖表
//     self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(self.frame.origin.x+10,self.frame.origin.y+25, self.frame.size.width-20, self.frame.size.height-40)];
    
    //創建漸層色背景
    [self creatBackgroundGradientImageView];
    
    self.flagForLabel = [[UIImageView alloc] initWithFrame:CGRectMake(65, 15, 35, 35)];
    self.countryName_label = [[UILabel alloc] initWithFrame:CGRectMake(110, 12, 100, 40)];
    
    _selectedPresntTimeAndPriceView.layer.cornerRadius = 7.0;//點選出現的label圓角設定
    
    [self addSubview:self.countryName_label];
    [self addSubview:self.flagForLabel];
    
    //設定天數按鈕
    [self setOptionTableViewSet];
    
    //創建歷史數據view
    //改用storyboard配合autolayout
    
    //設定歷史數據view的setting
    [self setLineChartViewSetting];
    
        //點擊顯示的資訊label移到最上層
//    [self insertSubview:_selectedPresntTimeAndPriceView aboveSubview:_lineChartView];
    //添加天數按鈕上去
//    [self insertSubview:_optionTableView aboveSubview:_selectedPresntTimeAndPriceView];

    
    UILongPressGestureRecognizer *tapGest = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    tapGest.delegate = self;
    
    [self.lineChartView addGestureRecognizer:tapGest];
    
}


#pragma mark creatLineChartView

-(void)setLineChartViewSetting{
    
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
    //取消右邊外框軸
    _lineChartView.rightAxis.enabled = NO;
    
    //x軸樣式設定
    ChartXAxis *xAxis = _lineChartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    //不畫x軸的網格線
    xAxis.drawGridLinesEnabled = NO;
    
//    xAxis.labelCount = 7;
    xAxis.avoidFirstLastClippingEnabled = TRUE;
    xAxis.forceLabelsEnabled = YES;
    xAxis.axisLineColor = [UIColor whiteColor];
    xAxis.labelTextColor = [UIColor whiteColor];
    xAxis.drawLabelsEnabled = false;
    
    //y軸樣式設定
    ChartYAxis *yAxis = _lineChartView.leftAxis;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = kCFNumberFormatterDecimalStyle;
    numberFormatter.roundingMode = NSNumberFormatterRoundFloor;
    numberFormatter.maximumFractionDigits = 4 ;
    yAxis.valueFormatter = [[ChartDefaultAxisValueFormatter alloc] initWithFormatter:numberFormatter];
//    yAxis.axisMinimum = 0;
    yAxis.drawGridLinesEnabled = NO;
    yAxis.axisLineColor = [UIColor whiteColor];
    yAxis.labelTextColor = [UIColor whiteColor];
    
    //設置數據顯示動畫效果
//    [_lineChartView animateWithYAxisDuration:3.0];
    //    [_lineChartView animateWithXAxisDuration:0.8f];
    //    [_lineChartView animateWithXAxisDuration:0.5f easingOption:ChartEasingOptionEaseInQuad];
    
    //追蹤數據更動
    [self.lineChartView notifyDataSetChanged];
    [self.lineChartData notifyDataChanged];
    [self.lineChartView.data notifyDataChanged];
    
}

-(void)setLineChartData{
     _dataForLineChart = [self setData];
}


-(void)updateLineChartData{
    
    _lineChartView.data = _dataForLineChart;
    
    [_lineChartView setNeedsDisplay];
}

#pragma mark LineChartData Set
-(LineChartData *)setData{

    NSDictionary *allHistoricalRate_Dic = [NSDictionary new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    allHistoricalRate_Dic = [defaults objectForKey:@"historicalRate_Dic"];
    NSArray *oneCountryDataArr = [allHistoricalRate_Dic objectForKey:_countryNameStr];
    
    
    //設定x軸資料
    //假資料
//    int xVals_count = 5;
//    NSMutableArray *xVals = [NSMutableArray new];
//
//    for (int i = 0; i < xVals_count; i++) {
//
//        [xVals addObject:[NSString stringWithFormat:@"0%d/19",i+1]];
//    }
    
    int xValsCount =(int)oneCountryDataArr.count;
    NSMutableArray *xVals = [NSMutableArray new];
    NSMutableArray *yValsDataEntry = [NSMutableArray new];
    
    _lineChartView.xAxis.labelCount = xValsCount;
    _lineChartView.xAxis.forceLabelsEnabled = YES;
    _lineChartView.xAxis.avoidFirstLastClippingEnabled = TRUE;
    
    
    for (int i =0 ; i < xValsCount; i++) {
        [xVals addObject:oneCountryDataArr[i][0]];
        [yValsDataEntry addObject:oneCountryDataArr[i][1]];
    }
    double max = [[yValsDataEntry valueForKeyPath:@"@max.doubleValue"] doubleValue];
    _lineChartView.leftAxis.axisMaximum = max*1.012;
    _lineChartView.leftAxis.drawZeroLineEnabled = true;
    _lineChartView.leftAxis.drawTopYLabelEntryEnabled = true;
    
    _lineChartView.xAxis.valueFormatter = [[ChartIndexAxisValueFormatter alloc] initWithValues:xVals];
    
    //設定y軸資料
    //假資料範例
//    NSMutableArray *yVals = [NSMutableArray new];
//    NSArray *tempYvals = @[@"0.3012",@"0.3123",@"0.3234",@"0.3456",@"0.2667"];
//    //    NSArray *tempYvals = @[@0.3012,@0.3123,@0.3234,@0.33456,@0.3567];
//
//    for (int i = 0; i < 5; i++) {
//        double val = [tempYvals[i] doubleValue];
//        ChartDataEntry *entry = [[ChartDataEntry alloc] initWithX:i y:val];
//        [yVals addObject:entry];
//    }
    
    NSMutableArray *yVals = [NSMutableArray new];
    for (int i = 0 ; i < yValsDataEntry.count; i++) {
        double val = [yValsDataEntry[i] doubleValue];
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
    set1.drawHorizontalHighlightIndicatorEnabled = false;//不畫點擊時的水平線
//    set1.cubicIntensity = 0.15;
//    set1.mode = LineChartModeCubicBezier;//折線使用曲線模式
    set1.drawValuesEnabled = false;//不顯示每個點的y值
    set1.drawCirclesEnabled = false;
    
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
    
    //開始繪圖
//    UIImage *backgroundView = [UIImage new];
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
    _backgroundGradientView.layer.cornerRadius = 15;
    
}


#pragma mark chartValueSelectedMethod
-(void)chartValueSelected:(ChartViewBase *)chartView entry:(ChartDataEntry *)entry highlight:(ChartHighlight *)highlight{
    
    ChartIndexAxisValueFormatter *xAxisValusFormatter = (ChartIndexAxisValueFormatter *)_lineChartView.xAxis.valueFormatter;
    NSArray *xAxisValusArr = [NSArray new];
    xAxisValusArr = xAxisValusFormatter.values;
    _dateTimeLabel.text = xAxisValusArr[(int)entry.x];
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode:NSNumberFormatterRoundFloor];
    
    NSString *price = [formatter stringFromNumber:[NSNumber numberWithDouble:entry.y]];
    _priceLabel.text = price;
    if (highlight.xPx+(_selectedPresntTimeAndPriceView.frame.size.width/2) > _lineChartView.frame.size.width) {
        _selectedPresntTimeAndPriceView.center =CGPointMake(_lineChartView.frame.size.width-(_selectedPresntTimeAndPriceView.frame.size.width/2), _selectedPresntTimeAndPriceView.center.y);
    }else{
    _selectedPresntTimeAndPriceView.center =CGPointMake(highlight.xPx, _selectedPresntTimeAndPriceView.center.y);
    
    }
    _selectedPresntTimeAndPriceView.hidden = false;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:3.0];
    
    
}

-(void)chartValueNothingSelected:(ChartViewBase *)chartView{
    _selectedPresntTimeAndPriceView.hidden = true;
}


-(void)delayMethod{
    _selectedPresntTimeAndPriceView.hidden = YES;
    [_lineChartView highlightValue:nil callDelegate:YES];
    _lineChartView.lastHighlighted = nil;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"touchesBegan  ");
    CGPoint gestPoint = [[touches anyObject] locationInView:_lineChartView];
    [self.lineChartView highlightValue:[_lineChartView getHighlightByTouchPoint:gestPoint] callDelegate:YES];

}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnded  ");
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer* )gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer* )otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

-(void)longPress{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayMethod) object:nil];
}

#pragma mark prepareForReuse
-(void)prepareForReuse{
    [super prepareForReuse];
    self.selectedPresntTimeAndPriceView.hidden = true;
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    return layoutAttributes;
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
  */
@end
