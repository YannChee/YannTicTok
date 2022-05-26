//
//  PostInfo.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/26.
//

import Foundation
import HandyJSON

struct PostContentInfo: HandyJSON {
    var applyStatus: Int = 0
    var authorId: Int = 0
    var avatar: String!
    var createdAt: Int = 0
    var disLikeType: Int = 0
    var followStatus: Int = 0
    var h265Size: Int = 0
    var h265Url: String!
    var hd265Url: String!
    var height: Int = 0
    var likeCount: Int = 0
    var likeType: Int = 0
    var m3U8Url: String!
    var nickname: String!
    var opTopicIds: String!
    var pendantUrl: String!
    var postId: Int = 0
    var postType: Int = 0
    var recCount: Int = 0
    var replyCount: Int = 0
    var size: Int = 0
    var tagId: String!
    /** 视频 缩略图 */
    var thumb: String!
    var title: String!
    var topicIds: String!
    var topics: String!
    var url: String!
    var viewLen: Int = 0
    var width: Int = 0
}

struct PostCommentInfo: HandyJSON {
    
}


struct PostInfo: HandyJSON {
   
    let content: PostContentInfo? = nil
    let hotComment: PostCommentInfo? = nil
    
    
}



/*
 {
     "code": 0,
     "data": {
         "authToken": "",
         "list": [{
             "content": {
                 "applyStatus": 1,
                 "authorId": 6555972126208,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/6555972126208/1652800422363.jpg",
                 "createdAt": 1651015467000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 8496745,
                 "h265Url": "trans/h265/20220427/h265_8cbe9a845677782c84bec5149d6877e6_1651015581.mov",
                 "hd265Url": "",
                 "height": 720.0,
                 "likeCount": 325,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "笑星人",
                 "opTopicIds": "10547",
                 "pendantUrl": "",
                 "postId": 6642346475520,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 0,
                 "size": 16618118,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/trans/webp/20220427/8cbe9a845677782c84bec5149d6877e6_1651015512.webp",
                 "title": "#海绵宝宝#沙雕",
                 "topicIds": "10157,10495",
                 "topics": "#海绵宝宝#沙雕",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/trans/h265/20220427/h265_8cbe9a845677782c84bec5149d6877e6_1651015581.mov",
                 "viewLen": 86,
                 "width": 1280.0
             },
             "hotComment": {
                 "commentId": 0,
                 "hotContent": "",
                 "hotLikeSum": 0,
                 "hotName": "",
                 "hotThumb": "",
                 "hotUserIcon": "",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 562408969728,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/postfile/system_user_head/2021-07-3010.46.54.png",
                 "createdAt": 1643266851000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 4075449,
                 "h265Url": "",
                 "hd265Url": "",
                 "height": 1920.0,
                 "likeCount": 1084,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "影视圈大佬",
                 "opTopicIds": "",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/danshengou.png",
                 "postId": 4658700870912,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 9,
                 "size": 7732849,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220224/6_1643263739971_161694_6930868402600889607ZheKaiXinGu_1645632782.webp",
                 "title": "这开心鬼也太会玩了，来一打我都不怕！#搞笑影视片段",
                 "topicIds": "12108",
                 "topics": "#搞笑影视片段",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/trans/ld/20220306/ld_6_1643263739971_161694_6930868402600889607ZheKaiXinGu_1646496807.mp4",
                 "viewLen": 70,
                 "width": 1080.0
             },
             "hotComment": {
                 "commentId": 15863,
                 "hotContent": "什么电影？",
                 "hotLikeSum": 0,
                 "hotName": "笑星人qc0z3e30",
                 "hotThumb": "",
                 "hotUserIcon": "",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 562410729472,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/postfile/system_user_head/2021-07-304.15.39.png",
                 "createdAt": 1648804786000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 2900147,
                 "h265Url": "trans/h265/20220401/h265_6_1648727034254_205952_6990927701066534174NaXieNiBuZh_1648804929.mov",
                 "hd265Url": "",
                 "height": 1280.0,
                 "likeCount": 585,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "极品沙雕",
                 "opTopicIds": "",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/yueyinhuaxian.png",
                 "postId": 6076412208640,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 2,
                 "size": 3416539,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/trans/webp/20220401/6_1648727034254_205952_6990927701066534174NaXieNiBuZh_1648804901.webp",
                 "title": "那些你不知道的故事#沙雕动画#搞笑#看一遍笑一遍#沙雕动画",
                 "topicIds": "11213",
                 "topics": "#沙雕动画",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/trans/ld/20220401/ld_6_1648727034254_205952_6990927701066534174NaXieNiBuZh_1648804910.mp4",
                 "viewLen": 59,
                 "width": 720.0
             },
             "hotComment": {
                 "commentId": 16876,
                 "hotContent": "good",
                 "hotLikeSum": 0,
                 "hotName": "……",
                 "hotThumb": "",
                 "hotUserIcon": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/3317430373888/1642750638893.JPG",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 3094187554816,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/3094187554816/1637155688222.jpg",
                 "createdAt": 1641881142000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 12233221,
                 "h265Url": "trans/h265/20220309/h265_b995d32c124603159957fc5efc1cb191_1646765854.mov",
                 "hd265Url": "",
                 "height": 1280.0,
                 "likeCount": 543,
                 "likeType": 0,
                 "m3U8Url": "postfile/m3u8/20220223/m3u8_h265_b995d32c124603159957fc5efc1cb191_1645600165/m3u8_h265_b995d32c124603159957fc5efc1cb191.m3u8",
                 "nickname": "天天让你笑不停",
                 "opTopicIds": "10495,10670",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/gaoxiaoxingqiudav.png",
                 "postId": 4303959278336,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 0,
                 "size": 22129984,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220223/b995d32c124603159957fc5efc1cb191_1645599883.webp",
                 "title": "#笑出声#搞笑段子#迷惑行为大赏",
                 "topicIds": "10644,10000,10005",
                 "topics": "#笑出声#搞笑段子#迷惑行为大赏",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/trans/h265/20220309/h265_b995d32c124603159957fc5efc1cb191_1646765854.mov",
                 "viewLen": 126,
                 "width": 720.0
             },
             "hotComment": {
                 "commentId": 0,
                 "hotContent": "",
                 "hotLikeSum": 0,
                 "hotName": "",
                 "hotThumb": "",
                 "hotUserIcon": "",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 562410446080,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/562410446080/1644922246020.jpg",
                 "createdAt": 1644994854000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 2368124,
                 "h265Url": "",
                 "hd265Url": "",
                 "height": 1280.0,
                 "likeCount": 500,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "剧中梗",
                 "opTopicIds": "",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/yueyinhuaxian.png",
                 "postId": 5101069632000,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 4,
                 "size": 3244947,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220225/thumb_5_1644993331365_484811_6918601143576775949NaMeWenTiLa_1645707677_1645761809.webp",
                 "title": "那么问题来，这到底像什么呢？展示一下你们的想象力！影视 搞笑 沙雕#影视搞笑片段",
                 "topicIds": "13344",
                 "topics": "#影视搞笑片段",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/postfile/20220216/5_1644993331365_484811_6918601143576775949NaMeWenTiLa.mp4",
                 "viewLen": 46,
                 "width": 720.0
             },
             "hotComment": {
                 "commentId": 16925,
                 "hotContent": "像子宫，卵巢",
                 "hotLikeSum": 0,
                 "hotName": "笑星人j9e4kn4p",
                 "hotThumb": "",
                 "hotUserIcon": "",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 562409281280,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/562409281280/1645513001683.jpg",
                 "createdAt": 1646125531000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 2457706,
                 "h265Url": "trans/h265/20220307/h265_resize_5_1646103353693_151145_7009934097178987776ZhongQiuJie_1646125818_1646663959.mov",
                 "hd265Url": "",
                 "height": 1280.0,
                 "likeCount": 3,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "高清不纸壁",
                 "opTopicIds": "",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/danshengou.png",
                 "postId": 5390522996224,
                 "postType": 1,
                 "recCount": 779,
                 "replyCount": 0,
                 "size": 5035655,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220301/5_1646103353693_151145_7009934097178987776ZhongQiuJie_1646125819.webp",
                 "title": "中秋节我希望收到你的一张自拍 因为别人都在赏天上的月亮 而我在赏自己的月亮#美女",
                 "topicIds": "10548",
                 "topics": "#美女",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/trans/h265/20220307/h265_resize_5_1646103353693_151145_7009934097178987776ZhongQiuJie_1646125818_1646663959.mov",
                 "viewLen": 12,
                 "width": 720.0
             },
             "hotComment": {
                 "commentId": 0,
                 "hotContent": "",
                 "hotLikeSum": 0,
                 "hotName": "",
                 "hotThumb": "",
                 "hotUserIcon": "",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 2649699959808,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/2649699959808/1643291983569.jpg",
                 "createdAt": 1645190143000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 462778,
                 "h265Url": "",
                 "hd265Url": "",
                 "height": 960.0,
                 "likeCount": 1547,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "大鸭梨",
                 "opTopicIds": "10005",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/gaoxiaoxingqiudav.png",
                 "postId": 5151063670784,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 17,
                 "size": 630806,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220224/2454a593dd2a3367c3e285579be1f74b_1645707862.webp",
                 "title": "#迷惑行为大赏  太快了",
                 "topicIds": "10005",
                 "topics": "#迷惑行为大赏",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/postfile/20220218/2454a593dd2a3367c3e285579be1f74b.mp4",
                 "viewLen": 9,
                 "width": 540.0
             },
             "hotComment": {
                 "commentId": 15414,
                 "hotContent": "大哥，你是憋了多久啊",
                 "hotLikeSum": 0,
                 "hotName": "开朗的网友",
                 "hotThumb": "",
                 "hotUserIcon": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/5457336537600/1646388346340.jpg",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 562408835584,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/562408835584/1646037642246.JPG",
                 "createdAt": 1646037841000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 5480027,
                 "h265Url": "trans/h265/20220307/h265_6_1646033909467_949128_6930069639800163597YaoShuoZenM_1646657923.mov",
                 "hd265Url": "",
                 "height": 1280.0,
                 "likeCount": 504,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "原来是舅先生",
                 "opTopicIds": "14570,12235",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/gegejixiang.png",
                 "postId": 5368074223616,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 3,
                 "size": 8224617,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220228/6_1646033909467_949128_6930069639800163597YaoShuoZenM_1646038513.webp",
                 "title": "要说怎么治舅舅们，我可是有不外传的绝招#家长#搞笑段子",
                 "topicIds": "10000",
                 "topics": "#搞笑段子",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/trans/h265/20220307/h265_6_1646033909467_949128_6930069639800163597YaoShuoZenM_1646657923.mov",
                 "viewLen": 32,
                 "width": 720.0
             },
             "hotComment": {
                 "commentId": 17181,
                 "hotContent": "@原来是舅先生  你好",
                 "hotLikeSum": 0,
                 "hotName": "韩雨鑫",
                 "hotThumb": "",
                 "hotUserIcon": "http://oss-ios.gaoxiaoxingqiu.com/userIcon/6795936951040/1651615513111.JPG",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 3246420690944,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/3246420690944/1637757558318.JPG",
                 "createdAt": 1644480884000,
                 "disLikeType": 0,
                 "followStatus": 0,
                 "h265Size": 19636582,
                 "h265Url": "trans/h265/20220307/h265_21579983E37B420C9ECC3A4543303086202202101613144169_1646607025.mov",
                 "hd265Url": "",
                 "height": 1280.0,
                 "likeCount": 490,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "笑出声",
                 "opTopicIds": "10005,10012",
                 "pendantUrl": "http://oss-andriod.gaoxiaoxingqiu.com/funny_store/pendant/gaoxiaoxingqiudav.png",
                 "postId": 4969493252352,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 3,
                 "size": 36493277,
                 "tagId": "",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220224/21579983E37B420C9ECC3A4543303086202202101613144169_1645650759.webp",
                 "title": " #笑出声  #搞笑段子  #迷惑行为大赏 ",
                 "topicIds": "10644,10000,10005",
                 "topics": "#笑出声#搞笑段子#迷惑行为大赏",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/trans/h265/20220307/h265_21579983E37B420C9ECC3A4543303086202202101613144169_1646607025.mov",
                 "viewLen": 73,
                 "width": 720.0
             },
             "hotComment": {
                 "commentId": 14844,
                 "hotContent": "香不香",
                 "hotLikeSum": 0,
                 "hotName": "大鸭梨",
                 "hotThumb": "",
                 "hotUserIcon": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/2649699959808/1643291983569.jpg",
                 "isHot": 0
             }
         }, {
             "content": {
                 "applyStatus": 1,
                 "authorId": 2557681645568,
                 "avatar": "http://oss-andriod.gaoxiaoxingqiu.com/userIcon/2557681645568/1640868961428.jpg",
                 "createdAt": 1636628389000,
                 "disLikeType": 0,
                 "followStatus": 1,
                 "h265Size": 3357260,
                 "h265Url": "",
                 "hd265Url": "",
                 "height": 406.0,
                 "likeCount": 95,
                 "likeType": 0,
                 "m3U8Url": "",
                 "nickname": "云北北",
                 "opTopicIds": "10619",
                 "pendantUrl": "",
                 "postId": 2959254584064,
                 "postType": 1,
                 "recCount": 0,
                 "replyCount": 0,
                 "size": 5214119,
                 "tagId": "79",
                 "thumb": "http://oss-andriod.gaoxiaoxingqiu.com/postcover/20220224/cd61c29c-6c71-4c8d-9ab1-306ba9785dbc_1645706036.webp",
                 "title": "#搞笑段子",
                 "topicIds": "10000",
                 "topics": "#搞笑段子",
                 "url": "http://oss-andriod.gaoxiaoxingqiu.com/postfile/delogo_files/delogo_resize_3fdbe1063a5a2f28bb503cf7c81f137b_1644417427.mp4",
                 "viewLen": 47,
                 "width": 720.0
             },
             "hotComment": {
                 "commentId": 0,
                 "hotContent": "",
                 "hotLikeSum": 0,
                 "hotName": "",
                 "hotThumb": "",
                 "hotUserIcon": "",
                 "isHot": 0
             }
         }],
         "longTermToken": "",
         "size": 10,
         "userId": 1630431855104
     },
     "msg": ""
 }
 */
