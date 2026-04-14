//
//  HairlineView.swift
//  CustomUI
//
//  Created by 김정원 on 4/11/26.
//

import UIKit

class HairlineView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setContentHuggingPriority(.required, for: .vertical)
        setContentCompressionResistancePriority(.required, for: .vertical)
    }

    override var intrinsicContentSize: CGSize {
        let pixel = 1.0 / UIScreen.main.scale
        return CGSize(width: UIView.noIntrinsicMetric, height: pixel)
    }
}
