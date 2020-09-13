//
//  TweetTableViewCell.swift
//  PlatziTweets
//
//  Created by XCodeClub on 2020-09-03.
//  Copyright © 2020 avilamisc. All rights reserved.
//

import UIKit
import Kingfisher

class TweetTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    // NOTA IMPORTANTE:
    // Las celdas NUNCA deben invocar ViewControllers
    
    // MARK: - IBActions
    @IBAction func openVideoAction() {
        guard let videoURL = videoUrl else {
            return
        }
        
        needsToShowVideo?(videoURL)
    }
    
    // MARK: - PRoperties
    private var videoUrl: URL?
    var needsToShowVideo: ((_ url: URL) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCellWith(post: PostItem) {
        videoButton.isHidden = !post.hasVideo
        nameLabel.text = post.author.names
        nicknameLabel.text = post.author.nickname
        messageLabel.text = post.text
        
        if post.hasImage {
            // configurar imagen
            tweetImageView.isHidden = false
            tweetImageView.kf.setImage(with: URL(string: post.imageUrl!))
        } else {
            tweetImageView.isHidden = true
        }
        
        videoUrl = URL(string: post.videoUrl ?? "")
    }
}
