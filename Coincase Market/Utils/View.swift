import UIKit

extension UIView {
	func roundedCorners(top: Bool){
		let corners:UIRectCorner = (top ? [.topLeft , .topRight] : [.bottomRight , .bottomLeft])
		let maskPath = UIBezierPath(roundedRect: self.bounds,
									byRoundingCorners: corners,
									cornerRadii:CGSize(width:20.0, height: 20.0))
		let maskLayer = CAShapeLayer()
		maskLayer.frame = self.bounds
		maskLayer.path = maskPath.cgPath
		self.layer.mask = maskLayer
	}
}
