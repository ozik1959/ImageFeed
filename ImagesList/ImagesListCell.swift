import Foundation
import UIKit
final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var dataLable: UILabel!
    @IBOutlet weak var likeButton: UIButton!
}
