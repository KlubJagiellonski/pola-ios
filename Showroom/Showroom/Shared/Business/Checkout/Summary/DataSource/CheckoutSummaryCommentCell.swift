import UIKit

protocol CheckoutSummaryCommentCellDelegate: class {
    func checkoutSummaryCommentCellDidTapAdd(cell: CheckoutSummaryCommentCell)
    func checkoutSummaryCommentCellDidTapEdit(cell: CheckoutSummaryCommentCell)
    func checkoutSummaryCommentCellDidTapDelete(cell: CheckoutSummaryCommentCell)
}

/// This cell shows options to add/edit/remove user comment to brand.
class CheckoutSummaryCommentCell: UITableViewCell {
    private let commentLabel = TitleValueLabel()
    private let addButton = UIButton()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    private let buttonsStackView = UIStackView()
    let separatorView = UIView()
    
    weak var delegate: CheckoutSummaryCommentCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        
        commentLabel.font = UIFont(fontType: .CheckoutSummary)
        commentLabel.valueLabel.numberOfLines = 3
        commentLabel.valueLabel.textColor = UIColor(named: .OldLavender)
        commentLabel.title = tr(.CheckoutSummaryCommentTitle)
        commentLabel.value = nil
        commentLabel.hidden = true
        
        addButton.applyPlainStyle()
        addButton.setTitle(tr(.CheckoutSummaryAddComment), forState: .Normal)
        addButton.hidden = false
        addButton.addTarget(self, action: #selector(CheckoutSummaryCommentCell.didTapAddComment), forControlEvents: .TouchUpInside)
        
        editButton.applyPlainStyle()
        editButton.setTitle(tr(.CheckoutSummaryEditComment), forState: .Normal)
        editButton.hidden = true
        editButton.addTarget(self, action: #selector(CheckoutSummaryCommentCell.didTapEditComment), forControlEvents: .TouchUpInside)
        
        deleteButton.applyPlainStyle()
        deleteButton.setTitle(tr(.CheckoutSummaryDeleteComment), forState: .Normal)
        deleteButton.hidden = true
        deleteButton.addTarget(self, action: #selector(CheckoutSummaryCommentCell.didTapDeleteComment), forControlEvents: .TouchUpInside)
        
        buttonsStackView.distribution = .EqualSpacing
        buttonsStackView.spacing = Dimensions.defaultCellHeight
        buttonsStackView.addArrangedSubview(addButton)
        buttonsStackView.addArrangedSubview(deleteButton)
        buttonsStackView.addArrangedSubview(editButton)
        
        separatorView.backgroundColor = UIColor(named: .Separator)
        
        contentView.addSubview(commentLabel)
        contentView.addSubview(buttonsStackView)
        contentView.addSubview(separatorView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        commentLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        buttonsStackView.snp_makeConstraints { make in
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().inset(4)
        }
        
        separatorView.snp_makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
    
    func didTapAddComment() {
        delegate?.checkoutSummaryCommentCellDidTapAdd(self)
    }
    
    func didTapEditComment() {
        delegate?.checkoutSummaryCommentCellDidTapEdit(self)
    }
    
    func didTapDeleteComment() {
        delegate?.checkoutSummaryCommentCellDidTapDelete(self)
    }
    
    func updateData(withComment comment: String?) {
        logInfo("Update data with comment: \(comment)")
        guard let comment = comment else {
            commentLabel.hidden = true
            addButton.hidden = false
            deleteButton.hidden = true
            editButton.hidden = true
            return
        }
        
        commentLabel.value = comment
        commentLabel.hidden = false
        addButton.hidden = true
        deleteButton.hidden = false
        editButton.hidden = false
    }
    
    class func getHeight(forWidth width: CGFloat, comment: String?) -> CGFloat {
        guard let comment = comment else {
            return 24
        }
        
        let commentHeight = comment.heightWithConstrainedWidth(width - Dimensions.defaultMargin * 2, font: UIFont(fontType: .CheckoutSummary), numberOfLines: 3)
        return commentHeight + 44 // + 44 for buttons height and margins
    }
}
