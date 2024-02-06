//
//  MemberListTableViewCell.swift
//  CollabOn
//
//  Created by 박다혜 on 2/5/24.
//

import UIKit
import Kingfisher

final class MemberListTableViewCell: UITableViewCell {

    private let thumbnailImageView = UIImageView()
    private let contentStackView = UIStackView()
    private let nameLabel = UILabel()
    private let mailLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configHierarchy() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(nameLabel)
        contentStackView.addArrangedSubview(mailLabel)
    }

    func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.size.equalTo(44)
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
        }

        contentStackView.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(74)
            $0.height.equalTo(36)
        }
    }

    func setUIProperties() {

        thumbnailImageView.image = .dummy
        thumbnailImageView.layer.cornerRadius = 8
        thumbnailImageView.clipsToBounds = true

        nameLabel.font = .bodyBold

        mailLabel.font = .body
        mailLabel.textColor = .textSecondary

        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        contentStackView.distribution = .fillEqually

    }

    func setData(_ data: Member) {
        thumbnailImageView.kf.setImage(with: data.profileImage, options: [.requestModifier(ImageService.shared.getImage())])
        nameLabel.text = data.nickname
        mailLabel.text = data.email
    }

}
