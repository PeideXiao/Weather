//
//  ParameterEncoding.swift
//  NetWorkLayer
//
//  Created by Peide Xiao on 11/2/23.
//  Copyright © 2023 Peide Xiao. All rights reserved.
//

import UIKit

public typealias Parameters = [String: Any]

public protocol ParameterEncoder {
    static func encode(urlRequest: inout URLRequest, with parameters:Parameters) throws
}

public enum NetworkError: String, Error {
    case encodingFailed = "Parameter encoding failed."
    case missingURL =   "URL is nil."
    case failedRequest = "Request failed."
    case noData = "city not found."
    case unableToDecode = "We could not decode the response."
    case invalidAPIKey = "Invalid API key. Please see https://openweathermap.org/faq#error401 for more info."
}
