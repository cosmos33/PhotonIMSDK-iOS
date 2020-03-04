/*!

 @header PhotonIMCustomBody.h

 @abstract 自定义消息体类，包含自定义消息体类的各个基础属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <PhotonIMSDK/PhotonIMSDK.h>

NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMCustomBody

@abstract 自定义消息体类，包含自定义消息体类的各个基础属性
*/
@interface PhotonIMCustomBody : PhotonIMBaseBody
/*!

@property arg1

@abstract 自定义int参数1，可作为消息类型或数据类型等用途
 */
@property(nonatomic) int32_t arg1;

/*!

@property arg2

@abstract 自定义int参数2，可作为消息类型或数据类型等用途
 
*/
@property(nonatomic) int32_t arg2;

/*!

@property data

@abstract 自定义二进制数据
 
 */
@property(nonatomic, copy, nullable) NSData *data;

/*!

@abstract 遍历构造方法
 
@discussion 使用语音内容构建文本消息体对象
 
@param arg1 自定义int参数1
 
@param arg2 自定义int参数2
 
@param data 自定义二进制数据
 
@return 自定义消息体对象

*/
+ (PhotonIMCustomBody *)customBodyWithURL:(int32_t *)arg1
                              mediaTime:(int32_t)arg2
                          localFileName:(nullable NSData *)data;
@end

NS_ASSUME_NONNULL_END
