//
//  SPPopDownMenu.m
//  
//
//  Created by zhxxxx  ondfasd 2018/12/11.
//

#import "SPPopDownMenu.h"

#define kPopDownMenuTriangleHeight    (10.f)
#define kMarginBetweenTriangleAndView (3.f)
#define kPopDownMenuPadding           (1.0f)
@interface SPPopDownMenu ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) SPBaseButton *coverBtn;
@property (nonatomic, strong) UITableView *talbeView;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, copy) NSString *selectedTitle;
// 尖角的中心位置
@property (nonatomic, assign) CGFloat triangleCenterX;
@property (nonatomic, strong) UIView *alignView;

@end

@implementation SPPopDownMenu



- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithTitles:(NSArray *)titles images:(NSArray *)images bellowView:(UIView *)view {
    self.titles = titles;
    self.images = images;
    self.alignView = view;
    if (self = [super init]) {

        self.frame = [self getFrame];
        
        [self initTableView];
    }
    return self;
}


- (CGRect)getFrame {
    CGRect frame = CGRectZero;
    CGRect relativeRect = [self convertRect:self.alignView.frame toView:[[UIApplication sharedApplication].windows lastObject]];
    CGFloat height = self.titles.count * 44 + kPopDownMenuTriangleHeight;
    CGFloat width = 0.0;
    for (NSString *title in self.titles) {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}];
        width = MAX(size.width, width);
    }
    
    frame.size.height = height;
    frame.size.width = width;
    frame.origin.x = relativeRect.origin.x - frame.size.width/2.0;
    frame.origin.y = relativeRect.origin.y + kMarginBetweenTriangleAndView;
    
    //限制边缘距离
    if (frame.origin.x <=10 ) {
        frame.origin.x = 10;
    }
    if (frame.origin.x + frame.size.width > [UIScreen mainScreen].bounds.size.width - 10) {
        frame.origin.x = [UIScreen mainScreen].bounds.size.width - 10 - frame.size.width;
    }
    
    return frame;
}

- (void)initTableView {
    CGFloat tableViewY = kPopDownMenuTriangleHeight-kPopDownMenuPadding;
    self.talbeView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, self.width, self.height-tableViewY) style:UITableViewStylePlain];
    self.talbeView.delegate = self;
    self.talbeView.dataSource = self;
    self.talbeView.scrollEnabled = NO;
    self.talbeView.separatorInset = UIEdgeInsetsMake(0, -20, 0, 0);
    [self addSubview:self.talbeView];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *popDownMenuCellId = @"popDownMenuCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:popDownMenuCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:popDownMenuCellId];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    if ([cell.textLabel.text isEqualToString:self.selectedTitle]) {
        cell.textLabel.textColor = [UIColor orangeColor];
    } else {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"333333"];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (self.images) {
        cell.imageView.image = [UIImage imageNamed:self.images[indexPath.row]];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self drawTriangleView];
}


- (void)drawTriangleView {
    CGFloat startX = 0;
    CGFloat startY = kPopDownMenuTriangleHeight + kMarginBetweenTriangleAndView;
     
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    // 开始绘制
    [path moveToPoint:CGPointMake(startX, startY)];
    [path addLineToPoint:CGPointMake(startX+self.menuView.width-self.triangleCenterX-kPopDownMenuTriangleHeight*0.5, startY)];
    [path addLineToPoint:CGPointMake(startX+self.triangleCenterX, 0)];
    [path addLineToPoint:CGPointMake(startX+self.triangleCenterX+kPopDownMenuTriangleHeight*0.5, startY)];
    [path addLineToPoint:CGPointMake(self.menuView.width, startY)];
    // 完成上面部分绘制
    [path addLineToPoint:CGPointMake(self.menuView.width, self.menuView.height)];
    [path addLineToPoint:CGPointMake(startX, self.menuView.height)];
    [path closePath];
    
    [path setLineWidth:0.5];
    [[UIColor redColor] setStroke];
    [path stroke];
    
}

- (void)tapCoverBtn {
    [self dismiss];
}

- (void)dismiss {
    [self removeFromSuperview];
}

@end
