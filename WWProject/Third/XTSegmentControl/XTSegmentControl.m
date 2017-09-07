//
//  SegmentControl.m
//  GT
//
//  Created by tage on 14-2-26.
//  Copyright (c) 2014年 cn.kaakoo. All rights reserved.
//

#import "XTSegmentControl.h"

#define XTSegmentControlItemFont (15)

#define XTSegmentControlHspace (12)

#define XTSegmentControlLineHeight (2)

#define XTSegmentControlAnimationTime (0.3)

#define XTSegmentControlIconWidth (50.0)

#define XTSegmentControlItemCount 4

typedef NS_ENUM(NSInteger, XTSegmentControlItemType)
{
    XTSegmentControlItemTypeTitle = 0,
    XTSegmentControlItemTypeIconUrl
};

@interface XTSegmentControlItem : UIView

@property (nonatomic , strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleIconView;
@property (nonatomic, assign) XTSegmentControlItemType type;


- (void)setSelected:(BOOL)selected;
@end

@implementation XTSegmentControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title type:(XTSegmentControlItemType)type
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _type = type;
        switch (_type) {
            case XTSegmentControlItemTypeTitle:
            default:
            {
                _titleLabel = ({
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(XTSegmentControlHspace, 0, CGRectGetWidth(self.bounds) - 2 * XTSegmentControlHspace, CGRectGetHeight(self.bounds))];
                    label.font = [UIFont systemFontOfSize:XTSegmentControlItemFont];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.text = title;
                    label.textColor = [UIColor colorWithHexString:@"0x222222"];
                    label.backgroundColor = [UIColor clearColor];
                    label;
                });
                [self addSubview:_titleLabel];
            }
                break;
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    switch (_type) {
        case XTSegmentControlItemTypeIconUrl:
        {
        }
            break;
        default:
        {
            if (_titleLabel) {
                [_titleLabel setTextColor:(selected? [UIColor colorWithHexString:@"0x3bbd79"]:[UIColor colorWithHexString:@"0x222222"])];
            }
        }
            break;
    }
}

@end

@interface XTSegmentControl ()<UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView *contentView;

@property(nonatomic,strong)UIButton *rightButton;
@property (nonatomic , strong) UIView *leftShadowView;

@property (nonatomic , strong) UIView *rightShadowView;

@property (nonatomic , strong) UIView *lineView;

@property (nonatomic , strong) NSMutableArray *itemFrames;

@property (nonatomic , strong) NSMutableArray *items;

@property (nonatomic , weak) id <XTSegmentControlDelegate> delegate;

@property (nonatomic , copy) XTSegmentControlBlock block;

@end

@implementation XTSegmentControl

- (id)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem
{
    if (self = [super initWithFrame:frame]) {
        _contentView = ({
            
            UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
            
            scrollView.width=self.bounds.size.width;
            scrollView.backgroundColor = [UIColor clearColor];
            scrollView.delegate = self;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.scrollsToTop = NO;
            [self addSubview:scrollView];
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
            [scrollView addGestureRecognizer:tapGes];
            [tapGes requireGestureRecognizerToFail:scrollView.panGestureRecognizer];
            scrollView;
        });
        
        [self initItemsWithTitleArray:titleItem];
        
    }
    return self;
}

-(void)sortButtonClick:(id)sender
{
    UIButton *rightButtom=(UIButton *)sender;
    if(self.rightButtonBlock)
    {
        self.rightButtonBlock(rightButtom.frame);
    }
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem delegate:(id<XTSegmentControlDelegate>)delegate
{
    if (self = [self initWithFrame:frame Items:titleItem]) {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame Items:(NSArray *)titleItem selectedBlock:(XTSegmentControlBlock)selectedHandle
{
    if (self = [self initWithFrame:frame Items:titleItem]) {
        self.block = selectedHandle;
    }
    return self;
}

- (void)doTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];
    
    __weak typeof(self) weakSelf = self;
    
    [_itemFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        CGRect rect = [obj CGRectValue];
        
        if (CGRectContainsPoint(rect, point)) {
            [weakSelf selectIndex:idx];
            
            [weakSelf transformAction:idx];
            
            *stop = YES;
        }
    }];
}

- (void)transformAction:(NSInteger)index
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(XTSegmentControlDelegate)] && [self.delegate respondsToSelector:@selector(segmentControl:selectedIndex:)]) {
        
        [self.delegate segmentControl:self selectedIndex:index];
        
    }else if (self.block) {
        
        self.block(index);
    }
}

- (void)initItemsWithTitleArray:(NSArray *)titleArray
{
    _itemFrames = @[].mutableCopy;
    _items = @[].mutableCopy;
    float y = 0;
    float height = CGRectGetHeight(self.bounds);
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:XTSegmentControlItemFont]};
    
    NSObject *obj = [titleArray firstObject];
    if ([obj isKindOfClass:[NSString class]]) {
        for (int i = 0; i < titleArray.count; i++) {
            NSString *title = titleArray[i];
            CGSize size = [title sizeWithAttributes:attributes];
            
            float x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
            float width = 2 * XTSegmentControlHspace + size.width;
            CGRect rect = CGRectMake(x, y, width, height);
            CGFloat minW = (kScreen_Width - XTSegmentControlHspace)/XTSegmentControlItemCount;
            if (rect.size.width < minW) {
                rect = CGRectMake(rect.origin.x, rect.origin.y, minW, rect.size.height);
            }
            [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
        }
        
        for (int i = 0; i < titleArray.count; i++) {
            CGRect rect = [_itemFrames[i] CGRectValue];
            NSString *title = titleArray[i];
            XTSegmentControlItem *item = [[XTSegmentControlItem alloc] initWithFrame:rect title:title type:XTSegmentControlItemTypeTitle];
            if (i == 0) {
                [item setSelected:YES];
            }
            [_items addObject:item];
            [_contentView addSubview:item];
        }

    }
    
    [_contentView setContentSize:CGSizeMake(CGRectGetMaxX([[_itemFrames lastObject] CGRectValue]), CGRectGetHeight(self.bounds))];
    self.currentIndex = 0;
    [self selectIndex:0];
}

- (void)addRedLine
{
    if (!_lineView) {
        CGRect rect = [_itemFrames[0] CGRectValue];
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"0x3bbd79"];
        [_contentView addSubview:_lineView];
        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(rect)-0.5, CGRectGetWidth(self.bounds), 0.5)];
        bottomLineView.backgroundColor = [UIColor colorWithHexString:@"0xc8c7cc"];
        [self addSubview:bottomLineView];
    }
}

- (void)selectIndex:(NSInteger)index
{
    [self addRedLine];
    if (index != self.currentIndex) {
        self.currentIndex = index;
        CGRect rect = [_itemFrames[index] CGRectValue];
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + XTSegmentControlHspace, CGRectGetHeight(rect) - XTSegmentControlLineHeight, CGRectGetWidth(rect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
        [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
            _lineView.frame = lineRect;
        } completion:^(BOOL finished) {
            [self setScrollOffset:index];
        }];
    }
}

- (void)moveIndexWithProgress:(float)progress
{
    CGRect origionRect = [_itemFrames[self.currentIndex] CGRectValue];
    
    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + XTSegmentControlHspace, CGRectGetHeight(origionRect) - XTSegmentControlLineHeight, CGRectGetWidth(origionRect) - 2 * XTSegmentControlHspace, XTSegmentControlLineHeight);
    
    //增加下划线滚动的效果
    [UIView animateWithDuration:0.5 animations:^{
        _lineView.frame = origionLineRect;
    } completion:nil];
    
    [self setScrollOffset:(int)progress];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (currentIndex != _currentIndex) {
        XTSegmentControlItem *preItem = [_items objectAtIndex:_currentIndex];
        XTSegmentControlItem *curItem = [_items objectAtIndex:currentIndex];
        [preItem setSelected:NO];
        [curItem setSelected:YES];
        _currentIndex = currentIndex;
    }
}

- (void)endMoveIndex:(NSInteger)index
{
    [self selectIndex:index];
}

- (void)setScrollOffset:(NSInteger)index
{
    CGFloat minW = (kScreen_Width - XTSegmentControlHspace)/XTSegmentControlItemCount;
    
    // 当前偏移量换算成index, 手动滑动contentView时会使 contentOffset.x 少一个XTSegmentControlHspace
    NSUInteger offsetIndex = (self.contentView.contentOffset.x+XTSegmentControlHspace)/minW;
    // 最大可视的index
    NSUInteger maxOffsetIndex = (offsetIndex + XTSegmentControlItemCount - 1);
    
    if (index < offsetIndex || (index == offsetIndex && index != 0)) {
        [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
            [self.contentView setContentOffset:CGPointMake(self.contentView.contentOffset.x-minW, self.contentView.contentOffset.y)];
        }];
    } else if (index > maxOffsetIndex || (index == maxOffsetIndex && index != self.items.count-1)) {
        [UIView animateWithDuration:XTSegmentControlAnimationTime animations:^{
            [self.contentView setContentOffset:CGPointMake(self.contentView.contentOffset.x+minW, self.contentView.contentOffset.y)];
        }];
    }
}

int ExceMinIndex(float f)
{
    int i = (int)f;
    if (f != i) {
        return i+1;
    }
    return i;
}
@end

