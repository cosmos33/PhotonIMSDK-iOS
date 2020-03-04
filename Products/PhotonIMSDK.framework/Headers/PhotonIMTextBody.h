/*!

 @header PhotonIMBaseBody.h

 @abstract 文本消息体类，包含文本消息体的各个基础属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import <Foundation/Foundation.h>
#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMTextBody

@abstract 文本消息体类，包含文本消息体的各个基础属性
*/

@interface PhotonIMTextBody : PhotonIMBaseBody

/*!

@property text

@abstract 文本消息内容
 */
@property (nonatomic, copy, readonly, nullable)NSString *text;


/*!

@abstract 初始化方法
 
@discussion 使用文本内容构建文本消息体对象
 
@param text 会话类型
 
@return 文本消息体对象

*/
- (instancetype)initWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
