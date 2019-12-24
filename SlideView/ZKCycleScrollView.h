
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZKCycleScrollView;

@compatibility_alias ZKCycleScrollViewCell UICollectionViewCell;

typedef NS_ENUM(NSInteger, ZKScrollDirection) {
    ZKScrollDirectionHorizontal = 0,
    ZKScrollDirectionVertical
};

@protocol ZKCycleScrollViewDataSource <NSObject>

// Return number of pages
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView;
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndex:
- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index;

@end

@protocol ZKCycleScrollViewDelegate <NSObject>

@optional
// Called when the cell is clicked
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;
// Called when the offset changes. The progress range is from 0 to the maximum index value, which means the progress value for a round of scrolling
- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress;
// Called when scrolling to a new index page
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

@end

IB_DESIGNABLE
@interface  ZKCycleScrollView : UIView

// Must specify infiniteLoop at creation. -initWithFrame: calls this with YES.
- (instancetype)initWithFrame:(CGRect)frame shouldInfiniteLoop:(BOOL)infiniteLoop NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@property (nullable, nonatomic, weak) IBOutlet id<ZKCycleScrollViewDelegate> delegate;
@property (nullable, nonatomic, weak) IBOutlet id<ZKCycleScrollViewDataSource> dataSource;

#if TARGET_INTERFACE_BUILDER
@property (nonatomic, assign) IBInspectable NSInteger scrollDirection;
@property (nonatomic, assign) IBInspectable double autoScrollInterval; 
#else
@property (nonatomic, assign) ZKScrollDirection scrollDirection; // default horizontal. scroll direction
@property (nonatomic, assign) NSTimeInterval autoScrollInterval; // default 3.f. automatic scroll time interval
#endif

@property (nonatomic, assign) IBInspectable BOOL autoScroll; // default YES
@property (nonatomic, assign) IBInspectable BOOL allowsDragging; // default YES. turn off any dragging temporarily
@property (nonatomic, readonly, assign) IBInspectable BOOL infiniteLoop; // default YES. infinite cycle

@property (nonatomic, assign) IBInspectable CGSize  itemSize; // default the view size
@property (nonatomic, assign) IBInspectable CGFloat itemSpacing; // default 0.f
@property (nonatomic, assign) IBInspectable CGFloat itemZoomScale; // default 1.f(no scaling), it ranges from 0.f to 1.f

@property (nonatomic, assign) IBInspectable BOOL hidesPageControl; // default NO
@property (nullable, nonatomic, strong) IBInspectable UIColor *pageIndicatorTintColor; // default gray
@property (nullable, nonatomic, strong) IBInspectable UIColor *currentPageIndicatorTintColor; // default white

@property (nonatomic, readonly, assign) NSInteger pageIndex; // current page index
@property (nonatomic, readonly, assign) CGPoint contentOffset;  // current content offset

@property (nullable, nonatomic, copy) dispatch_block_t loadCompletion; // load completed callback

- (void)registerCellClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerCellNib:(nullable UINib *)nib forCellWithReuseIdentifier:(NSString *)identifier;

- (__kindof ZKCycleScrollViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)reloadData;

// Call -beginUpdates and -endUpdates to update layout
// Allows multiple scrollDirection/itemSize/itemSpacing/itemZoomScale to be set simultaneously.
- (void)beginUpdates;
- (void)endUpdates;

// Scroll to page
- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated;
// Returns the visible cell object at the specified index
- (__kindof ZKCycleScrollViewCell * _Nullable)cellForItemAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
