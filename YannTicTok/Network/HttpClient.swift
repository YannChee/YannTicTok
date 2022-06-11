//
//  HttpClient.swift
//  YannTicTok
//
//  Created by YannChee on 2022/6/11.
//

import SwiftyJSON
import HandyJSON


struct ResponseObject: HandyJSON {
    var code: Int32? = -1 /**< 错误状态码 */
    var msg: String? = "" /**< 错误消息 */
    var data: Any? = nil /**< 可能是 数据字典 ,可能是数组,或者其它类型 */
}
/// 成功回调
typealias completionBlock = (_ isFailed: Bool,_ responseObj: ResponseObject?) -> Void

class HttpClient {
    
    /// Post请求
    public class func POST(url: String,
                           parameters: [String: Any]? = nil,
                           headers: [String: String]? = nil,
                           completion: completionBlock? = nil) -> Void {
        QYHttpTool.POST(url: url, parameters: parameters, headers: headers).success { responseObj in
            handelResponse(responseObj: responseObj, completion: completion)
        }.failure { error in
            handelError(error: error, completion: completion)
        }
    }
    
    /// Post请求
    public class func GET(url: String,
                          parameters: [String: Any]? = nil,
                          headers: [String: String]? = nil,
                          completion: completionBlock? = nil) -> Void {
        QYHttpTool.GET(url: url, parameters: parameters, headers: headers).success { responseObj in
            handelResponse(responseObj: responseObj, completion: completion)
        }.failure { error in
            handelError(error: error, completion: completion)
        }
    }
    
    
    private class func handelResponse(responseObj: Any,completion: completionBlock?) -> Void {
        guard completion != nil else {
            return
        }
        let jsonDict:[String: Any]? = JSON(responseObj) as? [String: Any]? ?? nil
        let  resObj:ResponseObject? = ResponseObject.deserialize(from:jsonDict)
        completion!(true, resObj)
    }
    
    private class func handelError(error: Error,completion: completionBlock?) -> Void {
        guard completion != nil else {
            return
        }
        
        error
        
        var resObj: ResponseObject = ResponseObject()
        resObj.data = nil
        completion!(false, resObj)
    }
    
    
    
    
}
