//
//  QYHttpTask.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/26.
//

import Alamofire

/// 成功回调
public typealias QYSuccessClosure = (_ responseObj: Any) -> Void
///  失败回调
public typealias QYFailureClosure = (_ error: Error) -> Void
/// 进度回调
public typealias QYProgressHandler = (Progress) -> Void

public class QYHttpTask {
    
    /// Alamofire.DataRequest 请求信息
    var request: Alamofire.Request?
    
    /// 成功回调
    private var successHandler: QYSuccessClosure?
    ///  失败回调
    private var failedHandler: QYFailureClosure?
    /// 进度回调
    private var progressHandler: QYProgressHandler?
    
    
    
    ///  处理响应数据
    func handleResponse(response: AFDataResponse<Any>) {
        switch response.result {
            
        case .success(let jsonData):  do {
            if let closure = successHandler {
                closure(jsonData)
            }
        }
               
        case .failure(let error): do {
            if let closure = failedHandler {
                closure(error)
            }
        }
            
        }
    }
    
    /// 处理进度信息
    func handleProgress(progress: Foundation.Progress) {
        if let closure = progressHandler {
            closure(progress)
        }
    }
    
    
    // MARK: - Callback

    @discardableResult
    public func success(_ closure: @escaping QYSuccessClosure) -> Self {
        successHandler = closure
        return self
    }

    @discardableResult
    public func failure(_ closure: @escaping QYFailureClosure) -> Self {
        failedHandler = closure
        return self
    }

    @discardableResult
    public func progress(closure: @escaping QYProgressHandler) -> Self {
        progressHandler = closure
        return self
    }

    
}
