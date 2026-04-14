//
//  CommentTableViewCell.swift
//  CustomUI
//
//  Created by 김정원 on 4/14/26.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var isLiked: Bool = false
    var likeCount: Int = 0
    
    var comment: String! {
        didSet {
            commentLabel.text = comment
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    func setupUI() {
        profileImageView.layer.cornerRadius = 17
        likeCountLabel.isHidden = true
    }

    @IBAction func likeButtonTapped(_ sender: UIButton) {
        isLiked.toggle()
        
        if isLiked {
            likeButton.tintColor = .red
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeCount += 1
        } else {
            likeButton.tintColor = .systemGray
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            likeCount -= 1
        }
        
        if likeCount > 0 {
            likeCountLabel.text = String(likeCount)
            likeCountLabel.isHidden = false
        } else {
            likeCountLabel.isHidden = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
