//
//  VoiceTableViewCell.swift
//  VoiceRecorderDemo
//
//  Created by F_Sur on 31/03/2022.
//

import UIKit

class VoiceTVCell: UITableViewCell {
    static let Cell_ID_Voice = "Cell_ID_Voice"
    
    lazy var voicePlayBtn: UIButton = {
        let btn = UIButton()
        btn.clipsToBounds = true
        btn.isHidden = false
        btn.setImage(UIImage(systemName: "play.circle"), for: .normal)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.white.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    
    lazy var recordedVoiceName: UILabel = {
        let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.3529411765, green: 0.368627451, blue: 0.4039215686, alpha: 1)
        lb.font = UIFont(name: "Arial", size: headerSize3)
        lb.font = UIFont.systemFont(ofSize: headerSize3, weight: .bold)
        lb.textAlignment = .left
        lb.clipsToBounds = true
        lb.adjustsFontSizeToFitWidth = true
        lb.numberOfLines = 1
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    lazy var mainStackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 5.0
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
        
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(voicePlayBtn)
        mainStackView.addArrangedSubview(recordedVoiceName)
        
        voicePlayBtn.layer.cornerRadius = 25
//
        mainStackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
            
        NSLayoutConstraint.activate([
//
            voicePlayBtn.heightAnchor.constraint(equalToConstant: 50),
            voicePlayBtn.widthAnchor.constraint(equalToConstant: 50),
            
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
