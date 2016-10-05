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
	let parse: (Data) -> A?
}

extension Resource {
	
	init(url: URL, parseJSON: @escaping (Any) -> A?) {
		self.url = url
		self.parse = { data in
			do {
				let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
				return parseJSON(jsonData)
			} catch {
				fatalError("Error parsing JSON")
			}
		}
	}
}

extension Forecast {
	
	static let parseAll = Resource<[Forecast]>(url: url, parseJSON: { jsonData in
		guard let json = jsonData as? [JSONDictionary] else { print("MOW") ; return nil }
		return json.flatMap { Forecast(dictionary: $0) }
	})
}


final class WebService {
	func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
		URLSession.shared.dataTask(with: resource.url) { data, _, _ in
			let result = data.flatMap(resource.parse)
			completion(result)
			}.resume()
	}
}
