//
//  SuggestedVideosCell.swift
//  TestFilter
//
//  Created by Dang Duy Cuong on 3/11/21.
//  Copyright © 2021 Ngô Bảo Châu. All rights reserved.
//

import UIKit

class SuggestedVideosCell: BaseTableViewCell {
    @IBOutlet weak var kindTextView: UITextView!
    @IBOutlet weak var videoIdTextView: UITextView!
    
    @IBOutlet weak var thumbnailsImageView: UIImageView!
    var data = SuggestedVideosModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillData() {
        kindTextView.text = data.snippet?.title
        videoIdTextView.text = data.snippet?.descriptionVideo
        if let url = data.snippet?.thumbnails?.maxres?.url {
            thumbnailsImageView.dowloadFromServer(link: url)
        }
        
    }
    
}
