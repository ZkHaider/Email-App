//
//  Email.Network.Response.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation

public struct EmailResponse: Codable {
    let emails: [EmailModel]
}
