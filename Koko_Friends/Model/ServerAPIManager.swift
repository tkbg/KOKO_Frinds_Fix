//
//  ServerAPIManager.swift
//  WiEss
//
//  Created by Rika on 2018/11/13.
//  Copyright © 2018年 wistron. All rights reserved.
//

import UIKit
import CoreTelephony
import Alamofire
//import CryptoSwift

class ServerAPIManager: NSObject {

    static let sharedInstance = ServerAPIManager()
    

    override init() {
        
        super.init()
    }
    let urlHost = "https://myapp.wistron.com/itsm/"
    
    var apiBaseURL: String {
        
        return "\(urlHost)api/"
    }
    let loginPath = "account/login"
    let logoutPath = "account/logout"
    let checkAuthPath = "account/checkAuth"
    let checkServicePath = "system/checkService"
    let checkAppVersionPath = "account/checkAppVersion"
    let questionListPath = "SRTicket/questionList"
    let locationListPath = "SRTicket/locationList"
    let ticketListPath = "SRTicket/SRTicketList"
    let ticketDetailPath = "SRTicket/SRTicketDetail"
    let createTicketPath = "SRTicket/createSRTicket"
    
    class var isConnectedToInternet: Bool {
        
        return NetworkReachabilityManager()!.isReachable
    }

    func printLog<log>(_ log: log) {
        #if DEBUG
        print("[#\(#line)]-\(log)")
        #endif
    }

    //MARK: - API method
    func manAPI(onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping([String: String]) -> Void) {
        
        let urlString = "https://dimanyen.github.io/man.json"
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                        
                    case 200:
                        
                        let json = response.result.value as? NSDictionary
                        onSuccess(json ?? [:])
                        
                    default:
                        onFailure(["errorCode": String(describing: status), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                } else {
                    let error = response.result.error
                    switch (error?._code) {
                    case NSURLErrorCannotFindHost:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_server", comment: "")])
                    case NSURLErrorTimedOut:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_timeOut", comment: "")])
                    default:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                }
        }
    }
    func friend1API(onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping([String: String]) -> Void) {
        
        let urlString = "https://dimanyen.github.io/friend1.json"
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                        
                    case 200:
                        
                        let json = response.result.value as? NSDictionary
                        onSuccess(json ?? [:])
                        
                    default:
                        onFailure(["errorCode": String(describing: status), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                } else {
                    let error = response.result.error
                    switch (error?._code) {
                    case NSURLErrorCannotFindHost:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_server", comment: "")])
                    case NSURLErrorTimedOut:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_timeOut", comment: "")])
                    default:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                }
        }
    }
    func friend2API(onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping([String: String]) -> Void) {
        
        let urlString = "https://dimanyen.github.io/friend2.json"
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                        
                    case 200:
                        
                        let json = response.result.value as? NSDictionary
                        onSuccess(json ?? [:])
                        
                    default:
                        onFailure(["errorCode": String(describing: status), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                } else {
                    let error = response.result.error
                    switch (error?._code) {
                    case NSURLErrorCannotFindHost:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_server", comment: "")])
                    case NSURLErrorTimedOut:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_timeOut", comment: "")])
                    default:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                }
        }
    }
    func friend3API(onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping([String: String]) -> Void) {
        
        let urlString = "https://dimanyen.github.io/friend3.json"
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                        
                    case 200:
                        
                        let json = response.result.value as? NSDictionary
                        onSuccess(json ?? [:])
                        
                    default:
                        onFailure(["errorCode": String(describing: status), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                } else {
                    let error = response.result.error
                    switch (error?._code) {
                    case NSURLErrorCannotFindHost:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_server", comment: "")])
                    case NSURLErrorTimedOut:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_timeOut", comment: "")])
                    default:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                }
        }
    }
    func friend4API(onSuccess: @escaping(NSDictionary) -> Void, onFailure: @escaping([String: String]) -> Void) {
        
        let urlString = "https://dimanyen.github.io/friend4.json"
        
        Alamofire.request(urlString, method: .get, parameters: nil)
            .responseJSON { response in
                if let status = response.response?.statusCode {
                    switch(status){
                        
                    case 200:
                        
                        let json = response.result.value as? NSDictionary
                        onSuccess(json ?? [:])
                        
                    default:
                        onFailure(["errorCode": String(describing: status), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                } else {
                    let error = response.result.error
                    switch (error?._code) {
                    case NSURLErrorCannotFindHost:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_server", comment: "")])
                    case NSURLErrorTimedOut:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_timeOut", comment: "")])
                    default:
                        onFailure(["errorCode": String(describing: error?._code), "errorMsg": NSLocalizedString("error_other", comment: "")])
                    }
                }
        }
    }
    //MARK: - Common methods
    func cleanUserDefaultData() {

//        UserDefaults.standard.removeObject(forKey: self.tokenKey)
    }
}
