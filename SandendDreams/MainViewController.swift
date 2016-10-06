//
//  MainViewControllwe.swift
//  SandendDreams
//
//  Created by Calum Harris on 03/10/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class MainViewConrtroller: UIViewController {
	
	@IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
	@IBOutlet weak var mainTitle: UILabel!
	@IBOutlet weak var waveHeightsNowTitle: UILabel!
	@IBOutlet weak var minTitle: UILabel!
	@IBOutlet weak var maxTitle: UILabel!
	@IBOutlet weak var ftMaxTitle: UILabel!
	@IBOutlet weak var ftMinTitle: UILabel!
	@IBOutlet weak var flipACoin: UILabel!
	@IBOutlet weak var heads: UILabel!
	@IBOutlet weak var tails: UILabel!
	@IBOutlet weak var backgroundBox: UIView!
	@IBOutlet weak var boxView: UIImageView!
	@IBOutlet weak var noInternetBoxView: UIImageView!
	
	@IBOutlet weak var minHeightLabel: UILabel!
	@IBOutlet weak var maxHeightLabel: UILabel!

	
	override func viewDidLoad() {
		labelLoadingState()
		loadingSpinner.startAnimating()
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		
		WebService().load(resource: Forecast.parseAll) { [unowned self] data in
			
				// there are always 40 results that come back from the load. So there are 8 forecasts per day for 5 days.
			switch data {
			case .success(let result):
				let sortedByTime = result.sorted (by: { $0.timeStamp < $1.timeStamp })
				let latestForecast = sortedByTime.filter( { $0.timeStamp <= Date() }).last
				DispatchQueue.main.async { _ in
				self.loadingSpinner.stopAnimating()
				self.labelShowDataState()
				self.minHeightLabel.text = String(describing: latestForecast!.minWaveHeight)
				self.maxHeightLabel.text = String(describing: latestForecast!.maxWaveHeight)
			}
			case .failure(let error):
				switch error {
				case .noInternetConnection:
					DispatchQueue.main.async { _ in
						self.alertNoInternet()
					}
				default: print("error")
				}
			}
		}
	}
	
	func alertNoInternet() {
		let ac = UIAlertController(title: "Whoops", message: "No Internet Connection", preferredStyle: .alert)
		let okButton = UIAlertAction(title: "OK", style: .cancel, handler: { _ in self.labelNoInternetConnectionState() })
		ac.addAction(okButton)
		present(ac, animated: true, completion: nil)
	}
	
	func labelLoadingState() {
		mainTitle.isHidden = true
		waveHeightsNowTitle.isHidden = true
		minTitle.isHidden = true
		maxTitle.isHidden = true
		ftMaxTitle.isHidden = true
		ftMinTitle.isHidden = true
		flipACoin.isHidden = true
		heads.isHidden = true
		tails.isHidden = true
		minHeightLabel.isHidden = true
		maxHeightLabel.isHidden = true
		boxView.isHidden = true
		noInternetBoxView.isHidden = true
	}
	
	func labelNoInternetConnectionState() {
		loadingSpinner.stopAnimating()
		mainTitle.isHidden = false
		waveHeightsNowTitle.isHidden = true
		minTitle.isHidden = true
		maxTitle.isHidden = true
		ftMaxTitle.isHidden = true
		ftMinTitle.isHidden = true
		flipACoin.isHidden = false
		heads.isHidden = false
		tails.isHidden = false
		minHeightLabel.isHidden = true
		maxHeightLabel.isHidden = true
		boxView.isHidden = true
		noInternetBoxView.isHidden = false
	}
	
	func labelShowDataState() {
		mainTitle.isHidden = false
		waveHeightsNowTitle.isHidden = false
		minTitle.isHidden = false
		maxTitle.isHidden = false
		ftMaxTitle.isHidden = false
		ftMinTitle.isHidden = false
		flipACoin.isHidden = true
		heads.isHidden = true
		tails.isHidden = true
		minHeightLabel.isHidden = false
		maxHeightLabel.isHidden = false
		boxView.isHidden = false
		noInternetBoxView.isHidden = true
	}
	

}





