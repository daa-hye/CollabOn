//
//  CoinCollectionViewCell.swift
//  CollabOn
//
//  Created by 박다혜 on 3/1/24.
//

import UIKit

final class CoinCollectionViewCell: UICollectionViewCell {

    private let titleLabel = UILabel()
    let button = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        configHierarchy()
        setLayout()
        setUIProperties()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configHierarchy() {
        addSubview(titleLabel)
        addSubview(button)
    }

    private func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(74)
            $0.height.equalTo(28)
        }
    }

    private func setUIProperties() {
        titleLabel.font = .bodyBold

        button.titleLabel?.font = .title2
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .main
    }

    func setData(title: String, value: String) {
        let text = "\(title) \(value)" + String(localized: "개")
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: UIFont.bodyBold, range: .init(location: 0, length: text.count))
        attributedString.addAttribute(.foregroundColor, value: UIColor.main, range: .init(location: 12, length: text.count))
        titleLabel.attributedText = attributedString
    }

    func setCoinList(title: String, value: String) {
        titleLabel.text = "🌱 \(title)"
        button.setTitle("₩\(value)", for: .normal)
        button.layer.cornerRadius = 5
    }

}
