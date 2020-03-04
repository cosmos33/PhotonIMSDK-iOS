/*!

 @header PhotonIMMediaBody.h

 @abstract 媒体消息体基类，包含媒体消息体的各个基础属性

 @author Created by Bruce on 2019/6/27.

 @version 2.1.1 2019/12/25 Creation

*/

#import "PhotonIMBaseBody.h"
NS_ASSUME_NONNULL_BEGIN
/*!

@class PhotonIMMediaBody

@abstract 媒体消息体基类，包含媒体消息体的各个基础属性
*/
@interface PhotonIMMediaBody : PhotonIMBaseBody
/*!

@property mediaTime

@abstract 媒体资源时长
 */
@property(nonatomic) int64_t mediaTime;

/*!

@property localMediaPlayed

@abstract 媒体资源是否被播放
 */
@property(nonatomic) BOOL localMediaPlayed;

@end

NS_ASSUME_NONNULL_END
