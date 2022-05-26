//
//  QYHttpTool.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/26.
//

//import Foundation
import Alamofire

class QYHttpTool {
    
    /// base请求
    public class func request(url: String,
                        method: HTTPMethod = .get,
                        parameters: [String: Any]?,
                        headers: [String: String]? = nil,
                        encoding: ParameterEncoding = URLEncoding.default) -> QYHttpTask {
        let task = QYHttpTask()

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }

        task.request = QYHttpSessionManager.sharedSession().request(url,
                                                     method: method,
                                                     parameters: parameters,
                                                     encoding: encoding,
                                                     headers:h
        ).validate().responseJSON { response in
            
            task.handleResponse(response: response)
        }
        return task
    }
    
    /// Creates a `UploadRequest` from a `URLRequest` created using the passed components
    ///
    /// - Parameters:
    ///   - method: `HTTPMethod` for the `URLRequest`. `.post` by default.
    ///   - parameters: 为了方便格式化参数，采用了[String: String]格式. `nil` by default.
    ///   - datas: Data to upload. The data is encapsulated here! more see `HWMultipartData`
    ///   - headers: `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///
    /// - Returns: The created `UploadRequest`.
    public func upload(url: String,
                       method: HTTPMethod = .post,
                       parameters: [String: String]?,
                       datas: [QYUploadFile],
                       headers: [String: String]? = nil) -> QYHttpTask {
        let task = QYHttpTask()

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }

        task.request = QYHttpSessionManager.sharedSession().upload(multipartFormData: { (multipartData) in
            // 1.参数 parameters
            if let parameters = parameters {
                for p in parameters {
                    multipartData.append(p.value.data(using: .utf8)!, withName: p.key)
                }
            }
            // 2.数据 datas
            for d in datas {
                multipartData.append(d.data, withName: d.name, fileName: d.fileName, mimeType: d.mimeType)
            }
        }, to: url, method: method, headers: h).uploadProgress(queue: .main, closure: { (progress) in
            task.handleProgress(progress: progress)
        }).validate().responseJSON(completionHandler: { [weak self] response in
            task.handleResponse(response: response)

        })
        
        return task
    }
    
    
    
}

// MARK: - 类方法
extension QYHttpTool {
    
    @discardableResult
    /// Post请求
    public class func POST(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> QYHttpTask {
        request(url: url,
                method: .post,
                parameters: parameters,
                headers: nil)
    }
    
    
    @discardableResult
    /// Get 请求
    public class func GET(url: String, parameters: [String: Any]? = nil, headers: [String: String]? = nil) -> QYHttpTask {
        request(url: url,
                method: .get,
                parameters: parameters,
                headers: nil)
    }
    
    
    @discardableResult
    /// 上传文件
    public func UploadByPOST(url: String, parameters: [String: String]? = nil, headers: [String: String]? = nil, datas: [QYUploadFile]? = nil) -> QYHttpTask {
        guard datas != nil else {
            return QYHttpTool.request(url: url, method: .post, parameters: parameters, headers: nil)
        }
        return upload(url: url, parameters: parameters, datas: datas!, headers: headers)
    }
    
   
}



/// 常见数据类型的`MIME Type
 enum QYDataMimeType: String {
    case JPEG = "image/jpeg"
    case PNG = "image/png"
    case GIF = "image/gif"
    case HEIC = "image/heic"
    case HEIF = "image/heif"
    case WEBP = "image/webp"
    case TIF = "image/tif"
    case JSON = "application/json"
}

/// HWMultipartData for upload datas, eg: images/photos
 struct QYUploadFile {
    /// The data to be encoded and appended to the form data.
    let data: Data
    /// Name to associate with the `Data` in the `Content-Disposition` HTTP header.
    let name: String
    /// Filename to associate with the `Data` in the `Content-Disposition` HTTP header.
    let fileName: String
    /// The MIME type of the specified data. (For example, the MIME type for a JPEG image is image/jpeg.) For a list of valid MIME types
    /// see http://www.iana.org/assignments/media-types/. This parameter must not be `nil`.
    let mimeType: String

 
    init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }

     init(data: Data, name: String, fileName: String, mimeType: QYDataMimeType) {
        self.init(data: data, name: name, fileName: fileName, mimeType: mimeType.rawValue)
    }
}

