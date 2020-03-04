/*!

 @header PhotonIMBaseBody.h

 @abstract 消息体基类，包含消息体的各个基础属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMBaseBody

@abstract 消息体基类，包含消息体的各个基础属性

*/
@interface PhotonIMBaseBody : NSObject
/*!

@property url

@abstract 服务端资源地址
 */
@property (nonatomic, copy, nullable)NSString *url;

/*!

@property localFileName

@abstract  本地资源名称或者路径
 */
@property (nonatomic, copy, nullable)NSString *localFileName;
@end

NS_ASSUME_NONNULL_END
