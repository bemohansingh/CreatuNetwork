//
//  Authorize.swift
//  WowApp
//
//  Created by Mohan on 3/9/18.
//  Copyright © 2018 Mohan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

public enum AuthHeaderType {
    case bearer
    case basic
    case custom
    case none
}

public struct AuthorizeModel: Codable {
    public var accessToken: String?
    public var refreshToken: String?
    public var tokenType: String?
    public var updatedDate: Date?
    public var expireIn: Int = 0

    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case updatedDate = "updated_date"
        case expireIn = "expires_in"
    }

    public init(){}

}

public struct Authorize {
    //    public static var shared = Authorize()
    //    fileprivate init() {}

    public static var customHeader: [String: String]? {
        get {
            if let header = UserDefaults.standard.dictionary(forKey: "auth_custom_header") as? [String: String] {
                return header
            }
            return nil
        }

        set {
            if let values = newValue {
                UserDefaults.standard.set(values, forKey: "auth_custom_header")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: "auth_custom_header")
                UserDefaults.standard.synchronize()
            }
            UserDefaults.standard.synchronize()
        }
    }

    public static var refreshToken: String? {
        if let auth = self.auth {
            return auth.refreshToken
        }
        return nil
    }

    public static var authorizeModel: AuthorizeModel? {
        return self.auth
    }

    public static var accessToken: String? {
        if let auth = self.auth {
            return auth.accessToken
        }
        return nil
    }

    public static func updateAuthorize(_ authorize: [String: Any]) -> Bool {
        if let authorizeModelData = try? JSONSerialization.data(withJSONObject: authorize, options: .prettyPrinted), var authorizeModel = try? JSONDecoder().decode(AuthorizeModel.self, from: authorizeModelData) {
            if authorizeModel.updatedDate == nil {
                authorizeModel.updatedDate = Date()
            }
            self.auth = authorizeModel
            return true
        }
        return false
    }

    public static func updateAuthorize(_ authorize: AuthorizeModel) -> Bool {

        if authorize.updatedDate == nil {
            var auth = authorize
            auth.updatedDate = Date()
            self.auth = authorize
        }
        else{
            self.auth = authorize
        }

        return true
    }

    public static func clearSavedData() -> Bool {
        self.auth = nil
        self.customHeader = nil
        return true
    }

    public static func updateTokenExpireTime(_ expireAt: Int) -> Bool {
        if var auth = self.auth {
            auth.expireIn = expireAt
            auth.updatedDate = Date()
            self.auth = auth
        }
        return true
    }

    public static func setAccessToken(_ token: String, expireAt:Int = 0) -> Bool {
        if var auth = self.auth {
            auth.accessToken = token
            auth.expireIn = expireAt
            auth.updatedDate = Date()
            self.auth = auth
        } else {
            var auth = AuthorizeModel()
            auth.accessToken = token
            auth.expireIn = expireAt
            auth.updatedDate = Date()
            self.auth = auth
        }
        return true
    }

    public static func setAccessToken(_ clientId: String, clientSecret: String, expireAt: Int = 0) -> Bool {
        let authString = "\(clientId):\(clientSecret)"
        if let dataFromString = authString.data(using: .utf8) {
            let encodedToken = dataFromString.base64EncodedString()
            if var auth = self.auth {
                auth.accessToken = encodedToken
                auth.expireIn = expireAt
                auth.updatedDate = Date()
                self.auth = auth
            } else {
                var auth = AuthorizeModel()
                auth.accessToken = encodedToken
                auth.expireIn = expireAt
                auth.updatedDate = Date()
                self.auth = auth
            }
            return true
        }
        return false
    }

    /// Check whether its time to refresh the token or not
    public static var shouldRefreshToken: Bool {
        if let authValue = auth, let updateDate = authValue.updatedDate {
            return (-1) * updateDate.timeIntervalSinceNow > Double(authValue.expireIn)
        }
        return true
    }

}

extension Authorize {

    /// The auth data for current session after authorization of app
    fileprivate static var auth: AuthorizeModel? {
        set {
            if let newValue = newValue {
                guard let authValues = try? JSONEncoder().encode(newValue) else { return }
                UserDefaults.standard.setValue(authValues, forKey: "AuthSession")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: "AuthSession")
                UserDefaults.standard.synchronize()
            }
        }
        get {
            if let authData = UserDefaults.standard.value(forKey: "AuthSession") as? Data {
                let authValue = try? JSONDecoder().decode(AuthorizeModel.self, from: authData)
                return authValue
            }
            return nil
        }
    }
}

