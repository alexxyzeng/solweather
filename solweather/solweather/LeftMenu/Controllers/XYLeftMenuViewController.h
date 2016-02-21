//
//  XYLeftMenuViewController.h
//
//
//  Created by xiayao on 16/2/13.
//
//

#import <UIKit/UIKit.h>
#import "XYWeatherStateManager.h"

@protocol XYLeftMenuViewControllerDelegate <NSObject>
/**
 *  移动天气城市列表的城市排序
 *
 *  @param sourceIndex      源位置
 *  @param destinationIndex 目标位置
 */
- (void)didMoveWeatherViewAtIndex:(NSInteger)sourceIndex toIndex:(NSInteger)destinationIndex;
/**
 *  移除相应tag的天气城市
 *
 *  @param tag 城市tag
 */
- (void)didRemoveWeatherViewWithTag:(NSInteger)tag;
/**
 *  离开左侧设置菜单视图
 */
- (void)dismissXYLeftMenuViewController;
@end

@interface XYLeftMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
/**
 *  天气城市列表数据
 */
@property (nonatomic, strong) NSMutableArray *locations;

@property (nonatomic, strong) id<XYLeftMenuViewControllerDelegate> delegate;

@end
