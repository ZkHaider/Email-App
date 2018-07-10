//
//  Email.Provider.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import Moya

public enum EmailAPIProvider {
    case emails
    case updateEmail(id: String?)
}

extension EmailAPIProvider: TargetType {
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var baseURL: URL { return URL(string: "https://s3.us-east-2.amazonaws.com/twine-public/apis")! }
    
    public var path: String {
        switch self {
        case .emails: return "twine-mail-get.json"
        case .updateEmail(let id):
            guard let id = id else { return "/emails/" }
            return "/emails/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .emails: return .get
        case .updateEmail: return .put
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .emails:
            return nil
        case .updateEmail(let id):
            guard let id = id else { return [:] }
            return ["id": id]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .emails:
            return URLEncoding.default
        case .updateEmail:
            return URLEncoding.queryString
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .emails:
            return """
            {
                "emails": [
                {
                "id": 0,
                "subject": "Tahoe Trip Next Weekend",
                "from": "x@gmail.com",
                "to": [
                "a@gmail.com",
                "b@gmail.com",
                "c.gmail.com"
                ],
                "body": "Mi augue mattis vitae erat risus nibh, mauris sodales nonummy a, vestibulum lacinia",
                "date": "2017-08-01T14:30Z",
                "unread": true
                },
                {
                "id": 1,
                "subject": "Next steps",
                "from": "x@gmail.com",
                "to": [
                "a@gmail.com",
                "b@gmail.com",
                "c.gmail.com"
                ],
                "body": "Ornare integer tincidunt quis ut nam, lobortis dignissim, montes eros",
                "date": "2017-08-01T12:15Z",
                "unread": false
                },
                {
                "id": 2,
                "subject": "Hooray!",
                "from": "x@gmail.com",
                "to": [
                "a@gmail.com",
                "b@gmail.com",
                "c.gmail.com"
                ],
                "body": "Eget non amet senectus. Aliquam tincidunt nullam tellus morbi bibendum leo",
                "date": "2017-04-01T09:47Z",
                "unread": false
                },
                {
                "id": 3,
                "subject": "Communications Director",
                "from": "x@gmail.com",
                "to": [
                "a@gmail.com",
                "b@gmail.com",
                "c.gmail.com"
                ],
                "body": "Mi augue mattis vitae erat risus nibh, mauris sodales nonummy a, vestibulum lacinia",
                "date": "2012-12-23T19:20Z",
                "unread": true
                },
                {
                "id": 4,
                "subject": "Jupiter photos",
                "from": "x@gmail.com",
                "to": [
                "a@gmail.com",
                "b@gmail.com",
                "c.gmail.com"
                ],
                "body": "Ornare integer tincidunt quis ut nam, lobortis dignissim, montes eros",
                "date": null,
                "unread": false
                },
                {
                "id": 5,
                "subject": "History of Lorem Ipsum",
                "from": "x@gmail.com",
                "to": [
                "a@gmail.com",
                "b@gmail.com",
                "c.gmail.com"
                ],
                "body": "It has been used as dummy text since the 1500s",
                "date": "2014-11-16T00:30Z",
                "unread": true
                }
                ]
            }
        """.data(using: .utf8)!
        case .updateEmail(_):
            return """
            {
              "id": 0,
              "subject": "Tahoe Trip Next Weekend",
              "from": "x@gmail.com",
              "to": [
                  "a@gmail.com",
                  "b@gmail.com",
                  "c.gmail.com"
              ],
              "body": "Mi augue mattis vitae erat risus nibh, mauris sodales nonummy a, vestibulum lacinia",
              "date": "2017-08-01T14:30Z",
              "unread": false
            }
            """.data(using: .utf8)!
        }
    }
    
    public var task: Task {
        switch self {
        case .emails: return .requestPlain
        case .updateEmail(_): return .requestPlain
        }
    }
    
}
