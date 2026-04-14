//
//  CommentTableViewCell.swift
//  CustomUI
//
//  Created by 김정원 on 4/14/26.
//

import UIKit

struct CommentData {
    let comment: String
    var isLiked: Bool = false
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var data: CommentData! {
        didSet {
            setupUI()
        }
    }
    
    var isLikedChanged: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = 17
    }
    
    func setupUI() {
        commentLabel.text = data.comment
        
        if data.isLiked {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeCountLabel.text = "1"
            likeCountLabel.isHidden = false
        } else {
            likeButton.tintColor = .systemGray
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeCountLabel.isHidden = true
        }
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        isLikedChanged?()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
