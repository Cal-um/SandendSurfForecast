//
//  ForecastCalculations.swift
//  SandendDreams
//
//  Created by Calum Harris on 05/10/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import Foundation

struct ForecastCalculations {
	
	func calculateMinMaxAverage(dayArray: [Forecast]) -> (Double, Double) {
		let dayMaxAverage = (dayArray.map { $0.maxWaveHeight }.reduce(0.0) { $0 + $1 })
			/ Double(dayArray.count)
		let dayMinAverage =  (dayArray.map { $0.minWaveHeight }.reduce(0.0) { $0 + $1 }) / Double(dayArray.count)
		return (dayMaxAverage, dayMinAverage)
	}
	
	func getDayOfWeekFrom(dayArray: [Forecast]) -> String? {
		let date = dayArray.first?.timeStamp
		let calendar = Calendar(identifier: .gregorian)
		let weekday = calendar.component(.weekday, from: date!)
		
		switch weekday {
		case 2: return "Monday"
		case 3: return "Tuesday"
		case 4: return "Wednesday"
		case 5: return "Thursday"
		case 6: return "Friday"
		case 7: return "Saturday"
		case 1: return "Sunday"
		default: return nil
		}
	}
	
	enum Day {
		case today, day2, day3, day4, day5
	}
	
	func splitDaysIntoArrays(dayRequired: Day, sortedByTime: [Forecast]) -> [Forecast] {
		
		var range = 0...0
		
		switch dayRequired {
		case .today: range = (0...7)
		case .day2: range = 8...15
		case .day3: range = 16...23
		case .day4: range = 24...31
		case .day5: range = 32...39
		}
		
		let todaysArray = sortedByTime.enumerated().map { (index, element) -> Forecast? in
			if range ~= index {
				return element
			} else {
				return nil
			}
			}.flatMap{$0}
		return todaysArray
	}
}
