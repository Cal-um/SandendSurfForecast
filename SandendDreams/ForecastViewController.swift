//
//  ForecastViewController.swift
//  SandendDreams
//
//  Created by Calum Harris on 06/10/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
	
	var networkState: NetworkState = .startUp
	@IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
	@IBOutlet weak var tableView: UITableView!
	let refreshControl = UIRefreshControl()

	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	
	// this method is required because the cell does not update height size when screen rotates
	override func viewDidLayoutSubviews() {
		tableView.reloadData()
	}
	
	override func viewDidLoad() {
		tableViewConfiguration()
		getForecast()
	}
	
	enum NetworkState {
		case forecastAvailable(Forecast)
		case internetUnavailable
		case startUp
	}

	func getForecast() {
		WebService().load(resource: Forecast.parseAll) { [unowned self] data in
			// there are always 40 results that come back from the load. So there are 8 forecasts per day for 5 days.
			switch data {
			case .success(let result):
				let sortedByTime = result.sorted (by: { $0.timeStamp < $1.timeStamp })
				let latestForecast = sortedByTime.filter( { $0.timeStamp <= Date() }).last
				DispatchQueue.main.async { _ in
					self.loadingSpinner.stopAnimating()
					self.networkState = .forecastAvailable(latestForecast!)
					self.tableView.reloadData()
					self.refreshControl.endRefreshing()
				}
			case .failure(let error):
				switch error {
				case .noInternetConnection:
					DispatchQueue.main.async { _ in
						self.alertNoInternet()
						self.networkState = .internetUnavailable
						self.tableView.reloadData()
						self.refreshControl.endRefreshing()
					}
				default: print(error)
				}
			}
		}
	}
	
	func reloadDataByPullAction() {
		getForecast()
	}
	
	func alertNoInternet() {
		let ac = UIAlertController(title: "Whoops", message: "No Internet Connection", preferredStyle: .alert)
		let okButton = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
		self.tableView.reloadData()
		self.refreshControl.endRefreshing()
		})
		ac.addAction(okButton)
		present(ac, animated: true, completion: nil)
	}
	
}

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
	
	// Table View Methods
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! ForecastTableViewCell
		
		switch networkState {
		case .startUp:
			loadingSpinner.startAnimating()
			cell.mainTitleLabel.isHidden = true
			cell.waveHeightBoundingBox.isHidden = true
			cell.noInternetConnectionStackView.isHidden = true
			cell.waveHeightStackView.isHidden = true
			cell.noInternetConnectionBoundingBox.isHidden = true
			cell.waveHeightsNowLabel.isHidden = true
			return cell
		case .forecastAvailable(let forecast):
			loadingSpinner.stopAnimating()
			cell.mainTitleLabel.isHidden = false
			cell.waveHeightBoundingBox.isHidden = false
			cell.noInternetConnectionStackView.isHidden = true
			cell.waveHeightStackView.isHidden = false
			cell.noInternetConnectionBoundingBox.isHidden = true
			cell.maxWaveLabel.text = String(forecast.maxWaveHeight)
			cell.minWaveLabel.text = String(forecast.minWaveHeight)
			cell.waveHeightsNowLabel.isHidden = false
			return cell
		case .internetUnavailable:
			loadingSpinner.stopAnimating()
			cell.mainTitleLabel.isHidden = false
			cell.waveHeightBoundingBox.isHidden = true
			cell.noInternetConnectionStackView.isHidden = false
			cell.waveHeightStackView.isHidden = true
			cell.noInternetConnectionBoundingBox.isHidden = false
			cell.waveHeightsNowLabel.isHidden = true
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return view.frame.height
	}
	
	func tableViewConfiguration() {
		tableView.backgroundView = nil
		tableView.backgroundColor = UIColor.clear
		refreshControl.addTarget(self, action: #selector(self.reloadDataByPullAction), for: .valueChanged)
		tableView.addSubview(refreshControl)
		tableView.dataSource = self
		tableView.delegate = self
		refreshControl.backgroundColor = UIColor.blue.withAlphaComponent(0.3)
	}
	
}
