//
//  MessageText.swift
//  ExampleChat
//
//  Created by Mac user on 25/08/21.
//

import Foundation
import AsyncDisplayKit
import Lottie
import AVFoundation
import SnapKit

class MessageText: ASDKViewController<ASDisplayNode> {
    
    
    var textArr: [String] = []
    
    var tableNode: ASTableNode = {
        var tableNode = ASTableNode(style: .plain)
        return tableNode
    }()
    
    var micView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.shadowColor = UIColor.gray.cgColor
        v.layer.shadowOpacity = 0.4
        v.layer.shadowRadius = 3
        v.layer.shadowOffset = CGSize(width: 0, height: 0)
        return v
    }()
    
    var micButton: UIButton = {
        let b = UIButton()
        b.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(named: "send"), for: .normal)
        b.tintColor = .green
        return b
    }()
    
    var textViewNode: UITextView = {
        var v = UITextView()
        v.backgroundColor = .clear
        v.textAlignment = NSTextAlignment.justified
        v.contentInsetAdjustmentBehavior = .automatic
        v.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return v
    }()
    
    var viewT: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    var viewShadow: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.layer.shadowColor = UIColor.gray.cgColor
        v.layer.shadowOpacity = 0.4
        v.layer.shadowRadius = 3
        v.layer.shadowOffset = CGSize(width: 0, height: 0)
        return v
    }()
    
    // MARK: -- get date
    
    var date = Date()
    var calendar = Calendar.current
    var imageHour = ""
    var audioHour = ""
    var textHour = ""
    var keyboardHeight: CGFloat!
    
    var placeholderLabel: UILabel = {
        let l = UILabel()
        l.text = "shu yerga yozing"
        l.backgroundColor = .clear
        l.textColor = .systemGray3
        return l
    }()
    
    var vStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.translatesAutoresizingMaskIntoConstraints = false
        s.distribution = .fill
        s.alignment = .center
        s.spacing = 10
        return s
    }()
    
    
    var isDelete: Bool = false
    private var lastContentOffset: CGFloat = 0
    var tapGesture = UITapGestureRecognizer()
    var viewArr: [BaseNode] = []
    var rangeStack1 = ASStackLayoutSpec()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(tableNode)
        self.view.addSubview(vStack)
        view.addSubview(micView)
        setMicButton()
        setStack()
        textViewNode.delegate = self
        vStack.addArrangedSubview(viewShadow)
        viewShadow.addSubview(viewT)
        self.appStyle()
        setViewT()
        self.wireDelegation()
        buttonAddtarget()
        setTableNote()
        
        setNavigationDetails()
        
        ///
        setTapGesture()
        ///
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNotifications()
        
        for i in 0...30 {
            let v = BaseNode()
            if i > 15 {
                v.backgroundColor = .white
            } else {
                v.backgroundColor = .systemGray4
            }
            v.style.preferredSize = CGSize(width: 3, height: 20-i%3*6)
            v.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
            v.cornerRadius = 1.5
            viewArr.append(v)
        }
        rangeStack1 = ASStackLayoutSpec(direction: .horizontal, spacing: 2, justifyContent: .end, alignItems: .end, children: viewArr)
        
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        textViewNode.layer.cornerRadius = 16
        viewT.layer.cornerRadius = 23
        micView.layer.cornerRadius = 23
        tableNode.frame = self.view.safeAreaLayoutGuide.layoutFrame
        
    }
    
    func setNavigationDetails() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "4")?.makeCircularImage(size: CGSize(width: 40, height: 40))
        
        let titleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = "Акбар Абдуллаев"
        titleLabel.font = .boldSystemFont(ofSize: 18)
                
        let hStack = UIStackView(arrangedSubviews: [imageView, titleLabel])
        hStack.spacing = 8
        hStack.alignment = .center
        
        let widthOfItem : CGFloat = 30.0
        let pading : CGFloat = 40
        let aWidth : CGFloat = (self.navigationController?.navigationBar.frame.width)! - CGFloat("Акбар Абдуллаев".count) * widthOfItem * 2.0 - pading
        titleView.frame = CGRect(x: 0, y: 0, width: aWidth, height: 40)
        
        titleView.addSubview(hStack)
        hStack.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(40)
        }
        
        navigationItem.titleView = titleView
        navigationController?.navigationBar.tintColor = UIColor.black
        removeButtomLineNavigation()
    }
    
    func removeButtomLineNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    // MARK: -- UITapGestureRecognizer
    
    func setTapGesture() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapTableNode))
        tableNode.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapTableNode() {
        print("tapped 👀👀👀👀👀👀👀👀👀👀👀👀")
        vStack.transform = .identity
        micView.transform = .identity
        tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        textViewNode.resignFirstResponder()
    }
    
    func setTableNote() {
        tableNode.view.tableFooterView = UIView()
        tableNode.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 80, right: 0)
        tableNode.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        tableNode.view.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        self.tableNode.view.separatorStyle = .none
    }
    
    func buttonAddtarget(){
        micButton.addTarget(self, action: #selector(micTapped(_:)), for: .touchUpInside)
    }
    
    
    
    // MARK: --  setTime
    
    func setTime(hour: Int, minute: Int) -> String {
        var str = ""
        if hour < 10 {
            if minute < 10 {
                str = "0\(hour):0\(minute)"
            } else {
                str = "0\(hour):\(minute)"
            }
        } else {
            if minute < 10 {
                str = "\(hour):0\(minute)"
            } else {
                str = "\(hour):\(minute)"
            }
        }
        return str
    }
    
    @objc func micTapped(_ sender: UIButton) {
        date = Date()
        calendar = Calendar.current
        if  !textViewNode.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  {
            textArr.append(textViewNode.text)
            date = Date()
            calendar = Calendar.current
            textHour = setTime(hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date))
            tableNode.insertRows(at: [IndexPath(row: textArr.count-1, section: 0)], with: .fade)
            tableNode.scrollToRow(at: IndexPath(row: textArr.count-1, section: 0), at: .bottom, animated: true)
        }
        textViewNode.text = ""
        if textViewNode.isFirstResponder {
            placeholderLabel.isHidden = true
            tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65+keyboardHeight, right: 0)
        } else {
            placeholderLabel.isHidden = !textViewNode.text.isEmpty
            tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        }
       
        tableNode.scrollToRow(at: IndexPath(row: textArr.count-1, section: 0), at: .bottom, animated: true)
    }
    
    func setMicButton(){
        micView.heightAnchor.constraint(equalToConstant: 46).isActive = true
        micView.widthAnchor.constraint(equalToConstant: 46).isActive = true
        micView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        micView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        micView.addSubview(micButton)
        
        micButton.bottomAnchor.constraint(equalTo: micView.bottomAnchor, constant: 5).isActive = true
        micButton.leftAnchor.constraint(equalTo: micView.leftAnchor, constant: -5).isActive = true
        micButton.trailingAnchor.constraint(equalTo: micView.trailingAnchor, constant: 3).isActive = true
        micButton.topAnchor.constraint(equalTo: micView.topAnchor, constant: -5).isActive = true
        
    }
    
    func appStyle() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
    }
    
    func wireDelegation() {
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
    }
    
    func setViewT() {
        
        viewShadow.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        viewT.bottomAnchor.constraint(equalTo: self.viewShadow.bottomAnchor, constant: 0).isActive = true
        viewT.topAnchor.constraint(equalTo: self.viewShadow.topAnchor, constant: 0).isActive = true
        viewT.leftAnchor.constraint(equalTo: self.viewShadow.leftAnchor, constant: 0).isActive = true
        viewT.trailingAnchor.constraint(equalTo: self.viewShadow.trailingAnchor, constant: 0).isActive = true
        viewT.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.bottomAnchor.constraint(equalTo: self.viewT.bottomAnchor, constant: -5).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: self.viewT.leftAnchor, constant: 20).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: self.viewT.trailingAnchor, constant: -5).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: self.viewT.topAnchor, constant: 4).isActive = true
        
        viewT.addSubview(textViewNode)
        
        textViewNode.translatesAutoresizingMaskIntoConstraints = false
        textViewNode.isScrollEnabled = false
        textViewNode.bottomAnchor.constraint(equalTo: self.viewT.bottomAnchor, constant: 0).isActive = true
        textViewNode.leftAnchor.constraint(equalTo: self.viewT.leftAnchor, constant: 15).isActive = true
        textViewNode.trailingAnchor.constraint(equalTo: self.viewT.trailingAnchor, constant: -15).isActive = true
        textViewNode.topAnchor.constraint(equalTo: self.viewT.topAnchor, constant: 3).isActive = true
    }
    
    func setStack(){
        vStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        vStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.micView.trailingAnchor, constant: -60).isActive = true
    }
    
}





// MARK: -- ASTableDataSource

extension MessageText: ASTableDataSource {
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        textArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        if indexPath.row%2 == 0 {
            let node = { [self] () -> ASCellNode in
                let n = MessageTextN(text: textArr[indexPath.row], leftOrRight: false, time: "\(textHour)")
                return n
            }
            
            return node
        } else {
            let node = { [self] () -> ASCellNode in
                let n = MessageTextN(text: textArr[indexPath.row], leftOrRight: true, time: "\(textHour)")
                return n
            }
            return node
        }
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        true
    }
    
    private func tableNode(_ tableNode: ASTableNode?, titleForHeaderInSection section: Int) -> String? {
        return "AAAAAAAAAAAAAAAA"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    
}



// MARK: -- ASTableDelegate


extension MessageText: ASTableDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let text = "Today"
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        let label = UILabel(frame: CGRect(x: tableView.frame.size.width/2-50, y: 0, width: text.widthOfString(usingFont: UIFont.systemFont(ofSize: 13, weight: .regular))+50, height: 20))
        label.text = text
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.backgroundColor = .systemGray5
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.textColor = UIColor.gray
        view.addSubview(label)
        self.view.addSubview(view)
        view.backgroundColor = .clear
        self.view.addSubview(view)
        return view
    }
    
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}


// MARK: -- MessageTextNode


class MessageTextN: ASCellNode {
    
    private lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        node.backgroundColor = .clear
        node.maximumNumberOfLines = 0
        node.highlightStyle = .dark
        node.textColorFollowsTintColor = true
        node.tintColor = .black
        return node
    }()
    
    
    private lazy var timeNode: ASTextNode = {
        let node = ASTextNode()
        node.backgroundColor = .clear
        node.maximumNumberOfLines = 0
        node.highlightStyle = .dark
        node.textColorFollowsTintColor = true
        node.tintColor = .black
      
        return node
    }()
    
    private lazy var imgChat: ASImageNode = {
        let img = ASImageNode()
        img.backgroundColor = .systemGray6
        img.contentMode = .scaleAspectFill
        //        img.style.width = ASDimension(unit: .auto, value: 1)
        return img
    }()
    
    private lazy var markChat: ASImageNode = {
        let img = ASImageNode()
        return img
    }()
    
    private lazy var arriveMessageUserImage: ASImageNode = {
        let img = ASImageNode()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    private lazy var viewChat: BaseNode = {
        var v = BaseNode()
        v.backgroundColor = .black
        return v
    }()
    
    private lazy var leftOrRight: Bool = false
    private lazy var str: String = ""
    
    init(text: String, leftOrRight: Bool, time: String) {
        super.init()
        addSubnode(imgChat)
        addSubnode(markChat)
        addSubnode(textNode)
        addSubnode(timeNode)
        addSubnode(arriveMessageUserImage)
        str = text
        textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular)])
        timeNode.attributedText = NSAttributedString(string: time)
        backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        self.leftOrRight = leftOrRight
        imgChat.cornerRadius = 16
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if leftOrRight {
 // MARK: --  bizga kelayotgan message
//            imgChat.image = UIImage(named: "yours")
            markChat.image = UIImage(named: "")
            markChat.tintColor = .red
            markChat.isHidden = true
            arriveMessageUserImage.image = UIImage(named: "4")?.makeCircularImage(size: CGSize(width: 40, height: 40))
//            arriveMessageUserImage.style.preferredSize = CGSize(width: 40, height: 40)
//            arriveMessageUserImage.image = UIImage(named: "4")

            let s0 = ASStackLayoutSpec(direction: .horizontal, spacing: 6, justifyContent: .start, alignItems: .end, children: [timeNode,markChat])
//            s0.style.flexGrow = 1.0
//            s0.style.flexShrink = 1
            let s = ASStackLayoutSpec(direction: .vertical, spacing: 6.0, justifyContent: .start, alignItems: .end, children: [textNode,s0])
            let stack = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: [], child: s)
            
            let  inset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
            let headerInset = ASInsetLayoutSpec(insets: inset, child: stack)
            
            let v = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumSize, child: imgChat)
                                    
            let s2 = ASBackgroundLayoutSpec(child: headerInset, background: v)
            
            let chatViewStack = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumSize, child: s2)
            
            let chatViewAndImage = ASStackLayoutSpec(direction: .horizontal, spacing: 6, justifyContent: .start, alignItems: .end, children: [arriveMessageUserImage,chatViewStack])
            
            chatViewStack.style.flexShrink = 1.0
//            chatViewStack.style.flexGrow = 1.0
            
            let chatViewAndImageStack = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumSize, child: chatViewAndImage)
            
            
//            let  inset1 = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
//            let headerInset1 = ASInsetLayoutSpec(insets: inset1, child: chatViewAndImageStack)
//
//            let v1 = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumSize, child: viewChat)
//
//            let s21 = ASBackgroundLayoutSpec(child: headerInset1, background: v1)

            var insets = UIEdgeInsets()
//
//            let width = str.widthOfString(usingFont: UIFont.systemFont(ofSize: 16, weight: .medium))
//            let q = Int(width) % Int(UIScreen.main.bounds.width-80)
//            if width < 50 {
//                insets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: (UIScreen.main.bounds.width-80))
//            } else if width <= UIScreen.main.bounds.width-80 {
//                if str.count <= 3{
//                    insets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: UIScreen.main.bounds.width-CGFloat(q)-65)
//                } else if str.count <= 6 && str.count > 3 {
//                    insets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: UIScreen.main.bounds.width-CGFloat(q)-40)
//                }  else if Int(width) < 150 {
//                    insets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: UIScreen.main.bounds.width-CGFloat(q)-25)
//                } else {
//                    insets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: UIScreen.main.bounds.width-CGFloat(q)-15)
//                }
//            } else {
                insets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 80)
//            }
            let headerWithInset = ASInsetLayoutSpec(insets: insets, child: chatViewAndImageStack)
            
            return headerWithInset
            
        } else {
// MARK: --           bizdan ketayotgan message
            //            imgChat.image = UIImage(named: "mine")
//            checkmark
            markChat.image = UIImage(named: "")
            markChat.isHidden = true
            markChat.tintColor = .blue
            
            let s0 = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .start, alignItems: .end, children: [timeNode,markChat])
            s0.style.flexGrow = 1.0
            s0.style.flexShrink = 1
            
            let s = ASStackLayoutSpec(direction: .vertical, spacing: 6.0, justifyContent: .end, alignItems: .end, children: [textNode,s0])
            let stack = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .start, sizingOption: [], child: s)   //ASStackLayoutSpec(direction: .horizontal, spacing: 6.0, justifyContent: .end, alignItems: .end, children: [textNode])
            
            
            let  inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
            let headerInset = ASInsetLayoutSpec(insets: inset, child: stack)
            
            let v = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: .minimumSize , child: imgChat)
            
            
            let s2 = ASBackgroundLayoutSpec(child: headerInset, background: v) //ASOverlayLayoutSpec(child: v, overlay: stack)
            
            let chatViewStack = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .end, sizingOption: .minimumSize, child: s2)
            
            let chatViewAndImage = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .start, alignItems: .start, children: [chatViewStack])
            
            chatViewStack.style.flexShrink = 1.0
            
            let chatViewAndImageStack = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .start, sizingOption: .minimumSize, child: chatViewAndImage)
            
            var insets = UIEdgeInsets()
            
//            let width = str.widthOfString(usingFont: UIFont.systemFont(ofSize: 16, weight: .medium))
//            let q = Int(width) % Int(UIScreen.main.bounds.width-80)
//            if width < 50 {
//                insets = UIEdgeInsets(top: 4, left: (UIScreen.main.bounds.width-80), bottom: 4, right: 10)
//            } else if width <= UIScreen.main.bounds.width-80 {
//                print("👁👁👁👁👁👁👁👁",str.count)
//                if str.count <= 3{
//                    insets = UIEdgeInsets(top: 4, left: UIScreen.main.bounds.width-CGFloat(q)-65, bottom: 4, right: 10)
//                } else if str.count <= 6 && str.count > 3 {
//                    insets = UIEdgeInsets(top: 4, left: UIScreen.main.bounds.width-CGFloat(q)-50, bottom: 4, right: 10)
//                }  else if Int(width) < 150 {
//                    print("qoldiq",q)
//                    print("width",Int(width))
//                    insets = UIEdgeInsets(top: 4, left: UIScreen.main.bounds.width-CGFloat(q)-35, bottom: 4, right: 10)
//                } else  {
//                    print("👀👀👀👀👀👀👀👀")
//                    print("qoldiq",q)
//                    print("width",Int(width))
//                    print("screen",Int(UIScreen.main.bounds.width-80))
//                    insets = UIEdgeInsets(top: 4, left: UIScreen.main.bounds.width-CGFloat(q)-20, bottom: 4, right: 10)
//                }
//            } else {
                insets = UIEdgeInsets(top: 4, left: 80, bottom: 4, right: 10)
//            }
            let headerWithInset = ASInsetLayoutSpec(insets: insets, child: chatViewAndImageStack)
            
            return headerWithInset
            
        }
        
    }
    
}



// MARK: --  extension  UITextViewDelegate

extension MessageText : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeholderLabel.isHidden = true
        micButton.setImage(UIImage(named: "send"), for: .normal)
        micButton.tintColor = .green
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        let currentHeight = (Double(textView.frame.height))
        let h = (currentHeight - 46)
        tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70+keyboardHeight+CGFloat(h), right: 0)
        tableNode.scrollToRow(at: IndexPath(row: textArr.count-1, section: 0), at: .bottom, animated: false)
    }
    
}


//  MARK: -- Keyboard


extension MessageText {
    
    fileprivate func initNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func deinitNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(sender: Notification) {
        
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            vStack.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+25)
            micView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+25)
            
            tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65+keyboardHeight, right: 0)
            
            tableNode.scrollToRow(at: IndexPath(row: textArr.count-1, section: 0), at: .top, animated: true)
        }
        
    }
    
    
    @objc fileprivate func keyboardWillHide(sender: Notification) {
        UIView.animate(withDuration: 2) { [self] in
            vStack.transform = .identity
            micView.transform = .identity
            tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        }
        placeholderLabel.isHidden = !textViewNode.text.isEmpty
    }
    
    
}

//  MARK: --  Extention UIImage

extension UIImage {

    func makeCircularImage(size: CGSize) -> UIImage {
        // make a CGRect with the image's size
        let circleRect = CGRect(origin: .zero, size: size)

        // begin the image context since we're not in a drawRect:
        UIGraphicsBeginImageContextWithOptions(circleRect.size, false, 0)

        // create a UIBezierPath circle
        let circle = UIBezierPath(roundedRect: circleRect, cornerRadius: circleRect.size.width * 0.5)

        // clip to the circle
        circle.addClip()

        UIColor.white.set()
        circle.fill()

        // draw the image in the circleRect *AFTER* the context is clipped
        self.draw(in: circleRect)

        // get an image from the image context
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()

        // end the image context since we're not in a drawRect:
        UIGraphicsEndImageContext()

        return roundedImage ?? self
    }
}
