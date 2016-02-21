//
//  XYRightViewController.h
//  
//
//  Created by xiayao on 16/2/13.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol XYRightViewControllerDelegate <NSObject>
/**
 *  根据地标添加城市
 *
 *  @param placemark 城市的地标
 */
- (void)didAddLocationWithPlacemark:(CLPlacemark *)placemark;

/**
 *  离开添加城市视图控制器
 */
- (void)dismissXYRightViewController;

@end

@interface XYRightViewController : UIViewController <UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) id<XYRightViewControllerDelegate> delegate;

@end
