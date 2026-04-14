//
//  CommentView.swift
//  CustomUI
//
//  Created by 김정원 on 4/13/26.
//

import UIKit

protocol CommentViewDelegate: AnyObject {
    func commentViewDidBeginEditing(_ view: CommentView)
    func uploadButtonTapped(_ comment: String)
}

class CommentView: UIView, UITextFieldDelegate {
    private let hairlineView: HairlineView = {
        let line = HairlineView()
        line.backgroundColor = .systemGray5
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ppomi")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 25
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.borderWidth = 2.0 / UIScreen.main.scale
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "대화에 참여하세요..."
        tf.borderStyle = .none
        tf.font = .systemFont(ofSize: 18, weight: .medium)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return tf
    }()
    
    private lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.setImage(UIImage(systemName: "arrow.up"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(uploadButtonTapped), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    weak var delegate: CommentViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(hairlineView)
        addSubview(profileImageView)
        addSubview(borderView)
        borderView.addSubview(textField)
        borderView.addSubview(uploadButton)
        
        NSLayoutConstraint.activate([
            hairlineView.topAnchor.constraint(equalTo: self.topAnchor),
            hairlineView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: hairlineView.bottomAnchor, constant: 8),
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            profileImageView.trailingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: -10),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor, multiplier: 1.0),
            
            borderView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            borderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            borderView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor),
            
            textField.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: borderView.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: uploadButton.leadingAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -8),
            
            uploadButton.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 8),
            uploadButton.trailingAnchor.constraint(equalTo: borderView.trailingAnchor, constant: -8),
            uploadButton.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -8),
            uploadButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        textField.delegate = self
        uploadButton.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.commentViewDidBeginEditing(self)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        uploadButton.isHidden = text.isEmpty
    }

    @objc func uploadButtonTapped() {
        delegate?.uploadButtonTapped(textField.text ?? "")
        textField.text = ""
        uploadButton.isHidden = true
    }
}
