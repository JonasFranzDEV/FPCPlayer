//
// Created by Jonas Franz on 15.11.17.
// Copyright (c) 2017 Jonas Franz. All rights reserved.
//

import Foundation

public protocol CookieStore {
    var authenticationCookies: [HTTPCookie] { get set }
}

public extension CookieStore {

    var authenticationData: Data? {
        get {
            let headers = Dictionary(elements: authenticationCookies.map({ (cookie) -> (String, String) in
                return (cookie.name, cookie.value)
            }))
            return try? JSONEncoder().encode(headers)
        }
        mutating set {
            authenticationCookies = convertToCookies(from: newValue)
        }
    }

    func convertToCookies(from newValue: Data?) -> [HTTPCookie] {
        if newValue == nil {
            return []
        } else {
            var cookies: [HTTPCookie] = []
            let rawCookies = (try? JSONDecoder().decode([String: String].self, from: newValue!)) ?? [:]
            for cookie in rawCookies {
                let properties: [HTTPCookiePropertyKey: Any] = [.name: cookie.key, .value: cookie.value, .path: "/main/", .domain: "linustechtips.com"]
                cookies.append(HTTPCookie(properties: properties)!)
            }
            return cookies
        }
    }
}

extension Dictionary {
    init(elements: [(Key, Value)]) {
        self.init()
        for (key, value) in elements {
            updateValue(value, forKey: key)
        }
    }
}
