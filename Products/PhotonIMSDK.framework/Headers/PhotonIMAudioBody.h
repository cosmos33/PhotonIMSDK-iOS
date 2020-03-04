/*!

 @header PhotonIMAudioBody.h

 @abstract 语音消息体类，包含语音消息体类的各个基础属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <Foundation/Foundation.h>
#import "PhotonIMMediaBody.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMAudioBody

@abstract 语音消息体类，包含语音消息体类的各个基础属性
*/
@interface PhotonIMAudioBody : PhotonIMMediaBody
/*!

@abstract 遍历构造方法
 
@discussion 使用语音内容构建文本消息体对象
 
@param url 服务端资源地址
 
@param mediaTime 语音资源的时长
 
@param localFileName 本地资源名称
 
@return 语音消息体对象

*/
+ (PhotonIMAudioBody *)audioBodyWithURL:(NSString *)url
                              mediaTime:(int64_t)mediaTime
                          localFileName:(nullable NSString *)localFileName;
@end

NS_ASSUME_NONNULL_END
