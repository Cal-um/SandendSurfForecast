//
//  ForecastTableViewCell.swift
//  SandendDreams
//
//  Created by Calum Harris on 06/10/2016.
//  Copyright © 2016 Calum Harris. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
	
	@IBOutlet weak var mainTitleLabel: UILabel!
	@IBOutlet weak var minFTLabel: UILabel!
	@IBOutlet weak var minWaveLabel: UILabel!
	@IBOutlet weak var minLabel: UILabel!
	@IBOutlet weak var waveHeightStackView: UIStackView!
	@IBOutlet weak var maxFTLabel: UILabel!
	@IBOutlet weak var maxLabel: UILabel!
	@IBOutlet weak var maxWaveLabel: UILabel!
	@IBOutlet weak var waveHeightBoundingBox: UIImageView!
	@IBOutlet weak var waveHeightsNowLabel: UILabel!
	
	
	
	@IBOutlet weak var tailsLabel: UILabel!
	@IBOutlet weak var headsLabel: UILabel!
	@IBOutlet weak var flipCoinLabel: UILabel!
	@IBOutlet weak var noInternetConnectionStackView: UIStackView!
	@IBOutlet weak var noInternetConnectionBoundingBox: UIImageView!
	
// These colour changes are only necessary because the white text is not visible in IB
	override func layoutSubviews() {
		mainTitleLabel.textColor = UIColor.white
		minFTLabel.textColor = UIColor.white
		minWaveLabel.textColor = UIColor.white
		minLabel.textColor = UIColor.white
		maxFTLabel.textColor = UIColor.white
		maxWaveLabel.textColor = UIColor.white
		waveHeightsNowLabel.textColor = UIColor.white
		tailsLabel.textColor = UIColor.white
		headsLabel.textColor = UIColor.white
		flipCoinLabel.textColor = UIColor.white
		maxLabel.textColor = UIColor.white
		
		waveHeightBoundingBox.layer.cornerRadius = 10
		noInternetConnectionStackView.layer.cornerRadius = 10
	}
	
	
}
