//
//  InstagramCommentSheetViewController.swift
//  CustomUI
//
//  Created by 김정원 on 4/8/26.
//

import UIKit

class InstagramCommentSheetViewController: UIViewController {
    
    enum SheetState {
        case expanded
        case partial
        case folded
    }
    
    @IBOutlet weak var dimmedView: UIView!
    @IBOutlet weak var bottomSheetView: UIView!
    @IBOutlet weak var sheetTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var grabber: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentView: CommentView!
    
    var currentState: SheetState = .folded
    var preConstant: CGFloat = 0
    var expandedConstant: CGFloat = 59
    var partialConstant: CGFloat { view.frame.height * 0.35 }
    var foldedConstant: CGFloat { view.frame.height }
    
    var commentData: [CommentData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimmedView.alpha = 0;
        dimmedView.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissBottomSheet))
        dimmedView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        bottomSheetView.addGestureRecognizer(pan)
        
        sheetTopConstraint.constant = view.frame.height
        
        bottomSheetView.clipsToBounds = true
        bottomSheetView.layer.cornerRadius = 40
        bottomSheetView.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        
        grabber.clipsToBounds = true
        grabber.layer.cornerRadius = 1
        
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        
        commentView.delegate = self
        commentView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
    }

    @IBAction func commentButtonTapped(_ sender: UIButton) {
        presentBottomSheet()
    }
    
    func presentBottomSheet() {
        currentState = .partial
        dimmedView.isHidden = false
        sheetTopConstraint.constant = partialConstant
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.dimmedView.alpha = 0.5
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissBottomSheet() {
        currentState = .folded
        sheetTopConstraint.constant = foldedConstant
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn) {
            self.dimmedView.alpha = 0.0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dimmedView.isHidden = true
        }
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        //gesture.translation: 변화량
        let translation = gesture.translation(in: view)
        let yTranslation = translation.y
        
        switch gesture.state {
        case .began:
            preConstant = sheetTopConstraint.constant
        case .changed:
            updateSheetTopConstraint(with: yTranslation)
        case .ended:
            let yLocation = gesture.location(in: view).y
            snapToNearestState(velocity: gesture.velocity(in: view).y, location: yLocation)
        default:
            break
        }
    }
    
    func updateSheetTopConstraint(with y: CGFloat) {
        let targetConstant = preConstant + y
        if targetConstant >= 20 && targetConstant <= foldedConstant - 20 {
            sheetTopConstraint.constant = preConstant + y
        }
        
        let progress = min((self.foldedConstant - targetConstant) / (self.foldedConstant - self.partialConstant), 1)
        dimmedView.alpha = progress * 0.5
    }
    
    func snapToNearestState(velocity: CGFloat, location: CGFloat) {
        let currentConstant = sheetTopConstraint.constant
        let targetState: SheetState
        
        if abs(velocity) > 1000 {
            if velocity < 0 {
                if location >= partialConstant {
                    targetState = .partial
                } else {
                    targetState = .expanded
                }
            } else {
                if location >= partialConstant {
                    targetState = .folded
                } else {
                    targetState = .partial
                }
            }
        } else {
            targetState = findNearestState(constant: currentConstant)
        }
        
        currentState = targetState
        animateSheet(to: targetStateValue(state: targetState))
    }
    
    func targetStateValue(state: SheetState) -> CGFloat {
        switch state {
        case .expanded:
            expandedConstant
        case .partial:
            partialConstant
        case .folded:
            foldedConstant
        }
    }
    
    private func findNearestState(constant: CGFloat) -> SheetState {
        let boundary1 = (expandedConstant + partialConstant) / 2
        let boundary2 = (partialConstant + foldedConstant) / 2
        
        if constant < boundary1 {
            return .expanded
        } else if constant < boundary2 {
            return .partial
        } else {
            return .folded
        }
    }
    
    private func animateSheet(to constant: CGFloat) {
        sheetTopConstraint.constant = constant
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
            
            let progress = min((self.foldedConstant - constant) / (self.foldedConstant - self.partialConstant), 1)
            self.dimmedView.alpha = progress * 0.5
        }, completion: nil)
    }
}

extension InstagramCommentSheetViewController: UITableViewDataSource, CommentViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        cell.data = commentData[indexPath.row]
        cell.isLikedChanged = { [weak self] in
            self?.commentData[indexPath.row].isLiked.toggle()
            self?.tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
    
    func uploadButtonTapped(_ comment: String) {
        commentData.append(CommentData(comment: comment))
        tableView.reloadData()
    }
    
    func commentViewDidBeginEditing(_ view: CommentView) {
        currentState = .expanded
        animateSheet(to: targetStateValue(state: currentState))
    }
}
