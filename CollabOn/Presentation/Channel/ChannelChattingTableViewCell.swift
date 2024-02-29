//
//  ChannelChattingTableViewCell.swift
//  CollabOn
//
//  Created by 박다혜 on 2/25/24.
//

import UIKit
import Kingfisher

final class ChannelChattingTableViewCell: UITableViewCell {

    private let profileImageView = UIImageView()
    private let stackview = UIStackView()
    private let nicknameLabel = UILabel()
    private let chatBubbleView = UIView()
    private let chatTextLabel = UILabel()
    private let timeLabel = UILabel()
    private let fileImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configHierarchy()
        setLayout()
        setUIProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        profileImageView.image = nil
        nicknameLabel.text = nil
        chatTextLabel.text = nil
        timeLabel.text = nil
        fileImageView.image = nil
    }

    private func configHierarchy() {
        addSubview(profileImageView)
        addSubview(stackview)
        stackview.addArrangedSubview(nicknameLabel)
        stackview.addArrangedSubview(chatBubbleView)
        stackview.addArrangedSubview(fileImageView)
        chatBubbleView.addSubview(chatTextLabel)
        addSubview(timeLabel)
    }

    private func setLayout() {
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
            $0.height.greaterThanOrEqualTo(18)
        }

        fileImageView.snp.makeConstraints {
            $0.width.equalTo(244)
            $0.height.equalTo(160)
        }
    }

    private func setUIProperties() {
        profileImageView.layer.cornerRadius = 8
        profileImageView.clipsToBounds = true

        chatBubbleView.layer.cornerRadius = 12
        chatBubbleView.layer.borderWidth = 1
        chatBubbleView.layer.borderColor = UIColor.inactive.cgColor
        chatBubbleView.clipsToBounds = true

        timeLabel.font = .caption2

        nicknameLabel.font = .caption

        chatTextLabel.font = .body
        chatTextLabel.numberOfLines = 0

        fileImageView.layer.cornerRadius = 10
        fileImageView.clipsToBounds = true
        fileImageView.contentMode = .scaleAspectFill

        stackview.axis = .vertical
        stackview.spacing = 5
        stackview.alignment = .leading
        stackview.distribution = .fillProportionally
    }

    func setData(_ chat: ChannelChat) {
        nicknameLabel.text = chat.user?.nickname

        if chat.content == nil || chat.content == "" {
            chatBubbleView.isHidden = true
        } else {
            chatTextLabel.text = chat.content
        }

        if !chat.files.isEmpty, let file = chat.files.first?.path, let url = URL(string: file) {
            fileImageView.kf.setImage(with: url, options: [.requestModifier(ImageService.shared.getImage())])
        } else {
            fileImageView.isHidden = true
        }

        timeLabel.text = chat.createdAt.formatted()

        if let path = chat.user?.profileImage, let url = URL(string: path) {
            profileImageView.kf.setImage(with: url, options: [.requestModifier(ImageService.shared.getImage())])
        } else {
            profileImageView.image = .noProfile
        }
    }

}
