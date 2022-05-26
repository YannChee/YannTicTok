//
//  QYHttpSession.swift
//  YannTicTok
//
//  Created by YannChee on 2022/5/26.
//

import Alamofire

final class QYHttpSessionManager {

    static private let shared = QYHttpSessionManager();
    
    var sessoion: Alamofire.Session!
    
    /// Initialization
    /// `private` for singleton pattern
    private init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 30  // Timeout interval
        config.timeoutIntervalForResource = 30  // Timeout interval
        sessoion = Alamofire.Session(configuration: config)
    }
    
    
    class func sharedSession () -> Alamofire.Session! {
        return QYHttpSessionManager.shared.sessoion
    }
}
