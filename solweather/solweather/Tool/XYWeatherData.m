//<string>湖北</string>
//<string>襄樊</string>
//<string>57278</string>
//<string>57278.jpg</string>
//<string>2016-2-2 16:14:57</string>
//<string>0℃/7℃</string>
//<string>2月2日 多云转晴</string>
//<string>无持续风向微风</string>
//<string>1.gif</string>
//<string>0.gif</string>
//<string>今日天气实况：气温：7℃；风向/风力：南风 3级；湿度：27%；紫外线强度：最弱。空气质量：中。</string>
//<string>
//紫外线指数：最弱，辐射弱，涂擦SPF8-12防晒护肤品。 感冒指数：易发，昼夜温差大，易感冒。 穿衣指数：较冷，建议着厚外套加毛衣等服装。 洗车指数：较适宜，无雨且风力较小，易保持清洁度。 交通指数：良好，气象条件良好，车辆可以正常行驶。 空气污染指数：中，易感人群应适当减少室外活动。
//</string>
//<string>1℃/9℃</string>
//<string>2月3日 多云转阴</string>
//<string>无持续风向微风</string>
//<string>1.gif</string>
//<string>2.gif</string>
//<string>0℃/11℃</string>
//<string>2月4日 多云转晴</string>
//<string>无持续风向微风</string>
//<string>1.gif</string>
//<string>0.gif</string>
//<string>
//襄阳地处湖北省西北部，汉水中游，东连江汉平原，西通川、陕，南接湘、粤，北达宛、洛，自古就有“南船北马”、“七省通衢”之说。襄阳历史悠久，文化源远流长，古老的汉水流域，自远古的旧石器时代以来就有人类栖息繁衍，是我国南北文化交流，融合的中心地区。襄阳市（原襄樊市）1987年被国务院公布为全国历史文化名城。市域内现已查明各时期的文化遗址200多处，有些文物古迹堪称世界之最。1990年至1992年在枣阳市雕龙碑发掘一处新石器时代原始氏族公社聚落遗址，距今约6000年，内涵丰富，独具特色，属一种新的文化类型，秦汉以后又是三国文化的中心区域和历朝历代的重镇。襄樊市境内历代战争频繁，人文荟萃。著名的战例就有白起水灌鄢城之战、关羽水淹七军之战、朱序抗拒苻丕之战、岳飞收复襄阳之战、李自成进占襄阳之战、张自忠枣阳抗日会战以及解放战争中的襄樊战役等。其间英才名士也如繁星。这里是伍子胥、宋玉、刘秀、庞统、杜甫、孟浩然、皮日休的桑梓之地，又是诸葛亮、王粲、米芾的第二故乡。全区属亚热带季风气候，年均气温15-16度，年降水量1000毫米左右，具有我国南北过渡型的气候特征。（2010年12月2日，国务院批复同意，湖北省襄樊市更名为襄阳市。）
//</string>
#import "XYWeatherData.h"
#import "XYGetWeatherData.h"
#import <AddressBook/AddressBook.h>


@interface XYWeatherData ()
/**
 *  Description
 */
@end

@implementation XYWeatherData

#pragma mark 编码和解码天气数据
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.placemark = [aDecoder decodeObjectForKey:@"placemark"];
        self.weatherOverview = [aDecoder decodeObjectForKey:@"overview"];
        self.weatherDesc = [aDecoder decodeObjectForKey:@"desc"];
        self.weatherImgStr = [aDecoder decodeObjectForKey:@"weatherImg"];
        self.currTemp = [aDecoder decodeObjectForKey:@"currTemp"];
        self.todayTemp = [aDecoder decodeObjectForKey:@"todayTemp"];
        self.airQuality = [aDecoder decodeObjectForKey:@"airquality"];
        self.humidity = [aDecoder decodeObjectForKey:@"humidity"];
        self.windScale = [aDecoder decodeObjectForKey:@"windscale"];
        self.tomorrowImgStr = [aDecoder decodeObjectForKey:@"tomorrowImg"];
        self.tomorrowTemp = [aDecoder decodeObjectForKey:@"tomorrowTemp"];
        self.thirdTemp = [aDecoder decodeObjectForKey:@"thirdTemp"];
        self.thirdImgStr = [aDecoder decodeObjectForKey:@"thirdImg"];

    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.placemark forKey:@"placemark"];
    [aCoder encodeObject:self.weatherOverview forKey:@"overview"];
    [aCoder encodeObject:self.weatherDesc forKey:@"desc"];
    [aCoder encodeObject:self.weatherImgStr forKey:@"weatherImg"];
    [aCoder encodeObject:self.currTemp forKey:@"currTemp"];
    [aCoder encodeObject:self.todayTemp forKey:@"todayTemp"];
    [aCoder encodeObject:self.airQuality forKey:@"airquality"];
    [aCoder encodeObject:self.humidity forKey:@"humidity"];
    [aCoder encodeObject:self.windScale forKey:@"windscale"];
    [aCoder encodeObject:self.tomorrowImgStr forKey:@"tomorrowImg"];
    [aCoder encodeObject:self.tomorrowTemp forKey:@"tomorrowTemp"];
    [aCoder encodeObject:self.thirdImgStr forKey:@"thirdImg"];
    [aCoder encodeObject:self.thirdTemp forKey:@"thirdTemp"];
}
@end
