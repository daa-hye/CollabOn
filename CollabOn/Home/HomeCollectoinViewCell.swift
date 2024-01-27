//
//  HomeCollectoinViewCell.swift
//  CollabOn
//
//  Created by 박다혜 on 1/27/24.
//

import UIKit

final class HomeCollectoinViewCell: UICollectionViewCell {

    private let section: HomeViewSection

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let badgeLabel = UILabel()

    init(_ section: HomeViewSection) {
        self.section = section

        configHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configHierarchy() {
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(badgeLabel)
    }

    func setLayout() {
        switch section {
        case .channel:
            imageView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.size.equalTo(18)
                $0.centerY.equalToSuperview()
            }
            titleLabel.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing).offset(16)
                $0.centerY.equalToSuperview()
            }
        case .dms:
            imageView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(14)
                $0.size.equalTo(24)
                $0.centerY.equalToSuperview()
            }
            titleLabel.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing).offset(8)
                $0.centerY.equalToSuperview()
            }
        case .add:
            imageView.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(16)
                $0.size.equalTo(18)
                $0.centerY.equalToSuperview()
            }
            titleLabel.snp.makeConstraints {
                $0.leading.equalTo(imageView.snp.trailing).offset(16)
                $0.centerY.equalToSuperview()
            }
        }

    }

    func setUIProperties() {
        titleLabel.font = .caption
        badgeLabel.backgroundColor = .main
        badgeLabel.layer.cornerRadius = 8
        badgeLabel.textColor = .white
        badgeLabel.font = .caption
        badgeLabel.textAlignment = .center
        badgeLabel.clipsToBounds = true
    }

    func setData(channel: Channel) {

    }

    func setData(dms: DmsResponse) {

    }

}
