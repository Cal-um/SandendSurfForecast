//
//  MagicSeaweedClient.swift
//  SandendDreams
//
//  Created by Calum Harris on 03/10/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import Foundation

import UIKit

// simple network layer for get request to MagicSeaweedAPI

typealias JSONDictionary = [String : Any]

struct Forecast {
	let minWaveHeight: Double
	let maxWaveHeight: Double
	let timeStamp: Date
}


extension Forecast {
	
	init?(dictionary: JSONDictionary){
		guard let swell = dictionary["swell"] as? JSONDictionary ,let minWaveHeight = swell["minBreakingHeight"] as? Double, let maxWaveHeight = swell["maxBreakingHeight"] as? Double, let timeStamp = dictionary["localTimestamp"] as? Double else { return nil }
		self.minWaveHeight = minWaveHeight
		self.maxWaveHeight = maxWaveHeight
		self.timeStamp = Date(timeIntervalSince1970: timeStamp)
	}
}

let url = URL(string: "http://magicseaweed.com/api/\(MagicSeaweedConstants.APIKey)/forecast/?spot_id=\(MagicSeaweedConstants.SurfSpot.Sandend)")!

struct Resource<A> {
	let url: URL
	let parse: (Data) -> Result<A>
}

extension Resource {
	
	init(url: URL, parseJSON: @escaping (Any) -> Result<A>) {
		self.url = url
		self.parse = { data	in
			do {
				let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
				return parseJSON(jsonData)
			} catch {
				fatalError("Error parsing data")
			}
		}
	}
}

extension Forecast {
	
	static let parseAll = Resource<[Forecast]>(url: url, parseJSON: { jsonData in
		guard let json = jsonData as? [JSONDictionary] else { return .failure(.errorParsingJSON)  }
		return .success(json.flatMap { Forecast(dictionary: $0) })
	})
}


final class WebService {
	func load<A>(resource: Resource<A>, completion: @escaping (Result<A>) -> ()) {
		URLSession.shared.dataTask(with: resource.url) { data, response, error in
			
			guard error == nil else {
				if (error as! NSError).domain == NSURLErrorDomain && ((error as! NSError).code == NSURLErrorNotConnectedToInternet || (error as! NSError).code == NSURLErrorTimedOut) {
					return completion(.failure(.noInternetConnection))
				} else {
					return completion(.failure(.returnedError(error!))) }
				}
			guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
				
				return completion(.failure(.invalidStatusCode("Request returned status code other than 2xx \(response)")))
			}
			let result = data.flatMap(resource.parse)
			completion(result!)
		}.resume()
	}
}

enum Result<T> {
	case success(T)
	case failure(NetworkingErrors)
}

enum NetworkingErrors: Error {
	case errorParsingJSON
	case noInternetConnection
	case dataReturnedNil
	case returnedError(Error)
	case invalidStatusCode(String)
}
