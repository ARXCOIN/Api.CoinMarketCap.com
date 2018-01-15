import UIKit

class MarketCell: UITableViewCell {

	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var percentageView: UIView!
	@IBOutlet weak var percentageLabel: UILabel!
	@IBOutlet weak var rankLabel: UILabel!
	@IBOutlet weak var symbolLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
