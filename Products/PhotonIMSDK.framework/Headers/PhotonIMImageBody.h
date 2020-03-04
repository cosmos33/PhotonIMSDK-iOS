/*!

 @header PhotonIMImageBody.h

 @abstract 图片消息体类，包含图片消息体的各个基础属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMTextBody

@abstract 图片消息体类，包含图片消息体的各个基础属性
*/
@interface PhotonIMImageBody : PhotonIMBaseBody
/*!

@property thumbURL

@abstract 服务端缩略图地址
 */
@property (nonatomic, copy, nullable)NSString *thumbURL;

/*!

@property whRatio

@abstract 图片的宽高比
 */
@property (nonatomic, assign)CGFloat whRatio;

/*!

@abstract 遍历构造方法
 
@discussion 使用文本内容构建文本消息体对象
 
@param url 服务端资源地址
 
@param thumbURL 服务端缩略图地址
 
@param localFileName 本地资源名称
 
@param whRatio 图片的宽高比
 
@return 图片消息体对象

*/
+ (PhotonIMImageBody *)imageBodyWithURL:(NSString *)url
                            thumbURL:(nullable NSString *)thumbURL
                               localFileName:(nullable NSString *)localFileName
                                whRatio:(CGFloat)whRatio;
@end

NS_ASSUME_NONNULL_END
