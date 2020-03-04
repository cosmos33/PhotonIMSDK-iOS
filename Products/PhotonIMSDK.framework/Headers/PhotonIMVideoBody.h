/*!

 @header PhotonIMMediaBody.h

 @abstract 视频消息体类，包含视频消息体类的各个基础属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <PhotonIMSDK/PhotonIMSDK.h>
#import "PhotonIMMediaBody.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMVideoBody

@abstract 视频消息体类，包含视频消息体类的各个基础属性
*/
@interface PhotonIMVideoBody : PhotonIMMediaBody
/*!

@property coverUrl

@abstract 封面图服务器地址
 */
@property(nonatomic, copy, nullable) NSString *coverUrl;
/*!

@property whRatio

@abstract 封面图宽高比
 */
@property(nonatomic, assign)CGFloat  whRatio;
/*!

@abstract 遍历构造方法
 
@discussion 使用视频内容构建文本消息体对象
 
@param url 服务端资源地址
 
@param mediaTime 语音资源的时长
 
@param coverUrl 封面图服务器地址
 
@param whRatio whRatio
 
@param localFileName 本地资源名称
 
@return 语音消息体对象

*/
+ (PhotonIMVideoBody *)videoBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                               coverUrl:(nullable NSString *)coverUrl
                                whRatio:(CGFloat)whRatio
                          localFileName:(nullable NSString *)localFileName;
@end

NS_ASSUME_NONNULL_END
