//
//  ChannelChattingTableViewCell.swift
//  CollabOn
//
//  Created by 박다혜 on 2/25/24.
//

import UIKit

final class ChannelChattingTableViewCell: UITableViewCell {

    private let profileImageView = UIImageView()
    private let stackview = UIStackView()
    private let nicknameLabel = UILabel()
    private let chatBubbleView = UIView()
    private let chatTextLabel = UILabel()
    private let timeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configHierarchy() {
        addSubview(profileImageView)
        addSubview(stackview)
        stackview.addArrangedSubview(nicknameLabel)
        stackview.addArrangedSubview(chatBubbleView)
        chatBubbleView.addSubview(chatTextLabel)
        addSubview(timeLabel)
    }

    func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(34)
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview().inset(6)
        }

        stackview.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
        }

        timeLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(6)
            $0.leading.equalTo(stackview.snp.trailing).offset(8)
            $0.trailing.greaterThanOrEqualToSuperview().inset(14)
        }

        chatTextLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }

    func setUIProperties() {
        profileImageView.layer.cornerRadius = 8
        profileImageView.clipsToBounds = true

        chatBubbleView.layer.cornerRadius = 12
        chatBubbleView.layer.borderWidth = 1
        chatBubbleView.layer.borderColor = UIColor.inactive.cgColor
        chatBubbleView.clipsToBounds = true

        timeLabel.font = .caption2

        nicknameLabel.font = .caption

        chatTextLabel.font = .body
    }

}
