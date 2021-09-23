//
//  MessageTableNode.swift
//  ExampleChat
//
//  Created by Mac user on 14/08/21.
//

import AsyncDisplayKit
import Lottie
import AVFoundation

class MessageTableNode: ASDKViewController<ASDisplayNode> {
    
    ///
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var meterTimer: Timer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false
    var recordingTime: String!
    
    ///
    
    var isHiddin = false
    var textArr: [String] = []
    var imageArr: [UIImage] = []
    var selectedImage: UIImage!
    var audioArr: [Int] = []
    
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
    
    var photoView: UIView = {
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
        b.setImage(UIImage(named: "microphone"), for: .normal)
        b.tintColor = .red
        return b
    }()
    
    var photoButton: UIButton = {
        let b = UIButton()
        b.contentEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.tintColor = .systemGray4
        b.setImage(UIImage(named: "camera"), for: .normal)
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
    
    let date = Date()
    let calendar = Calendar.current
    var imageHour = ""
    var audioHour = ""
    var textHour = ""
    
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
    
    private var animationView: AnimationView?
    var longPressRecognizer = UILongPressGestureRecognizer()
    var isRecordingStart: Bool = true
    var isTableNodeText: Bool = false
    var isTableNodeAudio: Bool = false
    var isTableNodeImage: Bool = false
    var isDelete: Bool = false
    private var lastContentOffset: CGFloat = 0
    var tapGesture = UITapGestureRecognizer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(tableNode)
        self.view.addSubview(vStack)
        view.addSubview(micView)
        setMicButton()
        setStack()
        textViewNode.delegate = self
        vStack.addArrangedSubview(photoView)
        vStack.addArrangedSubview(viewShadow)
        viewShadow.addSubview(viewT)
        self.appStyle()
        setViewT()
        self.wireDelegation()
        setPhotoButton()
        buttonAddtarget()
        setTableNote()
                

        ///
        setTapGesture()
        check_record_permission()
        getFileUrl()
        getDocumentsDirectory()
        ///
        
    }
    
    var viewArr: [BaseNode] = []
    var rangeStack1 = ASStackLayoutSpec()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initNotifications()
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        self.micView.addGestureRecognizer(longPressRecognizer)

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
        textViewNode.layer.cornerRadius = 25
        viewT.layer.cornerRadius = 25
        photoView.layer.cornerRadius = 25
        micView.layer.cornerRadius = 25
        tableNode.frame = self.view.safeAreaLayoutGuide.layoutFrame
        
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
        tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        textViewNode.resignFirstResponder()
    }
    
    // MARK: -- UILongPressGestureRecognizer
    var timer = 0

    @objc func longPressed(sender: UILongPressGestureRecognizer) {
        if isRecordingStart {
            var t = Timer()
            if sender.state == UIGestureRecognizer.State.began  {
                timer = 0
                t = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [self] _ in
                    timer += 1
                })
                setLottie()
                start_recording()
                micButton.setImage(nil, for: .normal)
            } else if sender.state == UIGestureRecognizer.State.ended  {
                t.invalidate()
                print("tugatdi")
                photoButton.setImage(UIImage(named: "delete"), for: .normal)
                photoButton.tintColor = .red
                viewT.backgroundColor = .red
                animationView?.isHidden = true
                animationView?.stop()
                micButton.setImage(UIImage(named: "send"), for: .normal)
                micButton.tintColor = .green
                meterTimer.invalidate()
    //            audioPlayer.stop()
                placeholderLabel.isHidden = true
                textViewNode.resignFirstResponder()
            }
        }
    }
    
    // MARK: -- Lottie
    
    func setLottie() {
          animationView = .init(name: "voice")
          animationView!.frame = CGRect(x: -micView.frame.width*1.5, y: -micView.frame.height*1.2, width: micView.frame.width*3.4, height: micView.frame.height*3.4)
          animationView!.contentMode = .scaleAspectFit
          animationView!.loopMode = .loop
          micView.insertSubview(animationView!, at: 0)
          animationView!.play()
    }
    
    func setTableNote() {
        tableNode.view.tableFooterView = UIView()
        tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        tableNode.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        tableNode.view.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        self.tableNode.view.separatorStyle = .none
    }
    
    func buttonAddtarget(){
        photoButton.addTarget(self, action: #selector(photoTapped(_:)), for: .touchUpInside)
        micButton.addTarget(self, action: #selector(micTapped(_:)), for: .touchUpInside)
    }
    
    @objc func photoTapped(_ sender: UIButton) {
        if isDelete {
            print("delete")
        } else {
            isTableNodeAudio = false
            isTableNodeText = false
            isTableNodeImage = true
            ImagePickerManager().pickImage(self){ [self] image in
                imageArr.append(image)
                tableNode.insertRows(at: [IndexPath(row: textArr.count + audioArr.count + imageArr.count-1, section: 0)], with: .fade)
                tableNode.scrollToRow(at: IndexPath(row: textArr.count + audioArr.count + imageArr.count-1, section: 0), at: .bottom, animated: true)
                imageHour = setTime(hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date))
            }
        }
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
        print("keldi = ",isRecordingStart)
        if isRecordingStart {
            isTableNodeAudio = true
            isTableNodeText = false
            isTableNodeImage = false
            audioArr.append(3)
            placeholderLabel.isHidden = false
            tableNode.insertRows(at: [IndexPath(row: textArr.count + imageArr.count +  audioArr.count-1, section: 0)], with: .fade)
            tableNode.scrollToRow(at: IndexPath(row: textArr.count + imageArr.count + audioArr.count-1, section: 0), at: .bottom, animated: true)
            audioHour = setTime(hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date))
            micButton.setImage(UIImage(named: "microphone"), for: .normal)
            micButton.tintColor = .red
            viewT.backgroundColor = .white
            photoButton.setImage(UIImage(named: "camera"), for: .normal)
            photoButton.tintColor = .systemGray4
        } else {
            if  !textViewNode.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty  {
                isTableNodeAudio = false
                isTableNodeText = true
                isTableNodeImage = false
                textArr.append(textViewNode.text)
                textHour = setTime(hour: calendar.component(.hour, from: date), minute: calendar.component(.minute, from: date))
                tableNode.insertRows(at: [IndexPath(row: imageArr.count + audioArr.count + textArr.count-1, section: 0)], with: .fade)
                tableNode.scrollToRow(at: IndexPath(row: imageArr.count + audioArr.count + textArr.count-1, section: 0), at: .bottom, animated: true)
            }
            textViewNode.text = ""
        }
    }
    
    func setMicButton(){
        micView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        micView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        micView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        micView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        
        micView.addSubview(micButton)
        
        
        micButton.bottomAnchor.constraint(equalTo: micView.bottomAnchor, constant: 0).isActive = true
        micButton.leftAnchor.constraint(equalTo: micView.leftAnchor, constant: 0).isActive = true
        micButton.trailingAnchor.constraint(equalTo: micView.trailingAnchor, constant: 0).isActive = true
        micButton.topAnchor.constraint(equalTo: micView.topAnchor, constant: 0).isActive = true
        
    }
    
    func setPhotoButton() {
        
        photoView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        photoView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        //        photoView.bottomAnchor.constraint(equalTo: self.vStack.bottomAnchor, constant: -45).isActive = true
        //        photoView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        
        photoView.addSubview(photoButton)
        
        photoButton.bottomAnchor.constraint(equalTo: photoView.bottomAnchor, constant: 0).isActive = true
        photoButton.leftAnchor.constraint(equalTo: photoView.leftAnchor, constant: 0).isActive = true
        photoButton.trailingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 0).isActive = true
        photoButton.topAnchor.constraint(equalTo: photoView.topAnchor, constant: 0).isActive = true
    }
    
    func appStyle() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
    }
    
    func wireDelegation() {
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
    }
    
    func setViewT() {
        
        viewShadow.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
        
        viewT.bottomAnchor.constraint(equalTo: self.viewShadow.bottomAnchor, constant: 0).isActive = true
        viewT.topAnchor.constraint(equalTo: self.viewShadow.topAnchor, constant: 0).isActive = true
        viewT.leftAnchor.constraint(equalTo: self.viewShadow.leftAnchor, constant: 0).isActive = true
        viewT.trailingAnchor.constraint(equalTo: self.viewShadow.trailingAnchor, constant: 0).isActive = true
        //
        viewT.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.bottomAnchor.constraint(equalTo: self.viewT.bottomAnchor, constant: -5).isActive = true
        placeholderLabel.leftAnchor.constraint(equalTo: self.viewT.leftAnchor, constant: 20).isActive = true
        placeholderLabel.trailingAnchor.constraint(equalTo: self.viewT.trailingAnchor, constant: -5).isActive = true
        placeholderLabel.topAnchor.constraint(equalTo: self.viewT.topAnchor, constant: 5).isActive = true
        
        viewT.addSubview(textViewNode)
        
        textViewNode.translatesAutoresizingMaskIntoConstraints = false
        textViewNode.isScrollEnabled = false
        textViewNode.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        textViewNode.bottomAnchor.constraint(equalTo: self.viewT.bottomAnchor, constant: -5).isActive = true
        textViewNode.leftAnchor.constraint(equalTo: self.viewT.leftAnchor, constant: 0).isActive = true
        textViewNode.trailingAnchor.constraint(equalTo: self.viewT.trailingAnchor, constant: 0).isActive = true
        textViewNode.topAnchor.constraint(equalTo: self.viewT.topAnchor, constant: 0).isActive = true
    }
    
    func setStack(){
        vStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -40).isActive = true
        vStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15).isActive = true
        vStack.trailingAnchor.constraint(equalTo: self.micView.trailingAnchor, constant: -60).isActive = true
    }
    
}





// MARK: -- ASTableDataSource

extension MessageTableNode: ASTableDataSource {
    
//    func numberOfSections(in tableNode: ASTableNode) -> Int {
//        textArr.count
//    }
//
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
            return imageArr.count + textArr.count + audioArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if isTableNodeAudio {
            if indexPath.row%2 == 0 {
                let node = { [self] () -> ASCellNode in
                    let n = MessageAudioNode(text: "qwe", leftOrRight: true, time: "\(audioHour)", mb: recordingTime, isDownload: true)
                    n.delegate = self
                    return n
                }
                
                return node
            } else {
                let node = { [self] () -> ASCellNode in
                    let n = MessageAudioNode(text: "qwe", leftOrRight: false, time: "\(audioHour)", mb: recordingTime, isDownload: false)
                    n.delegate = self
                    return n
                }
                return node
            }
        } else if isTableNodeText {
            if indexPath.row%2 == 0 {
                let node = { [self] () -> ASCellNode in
                    let n = MessageTextNode(text: textArr[indexPath.row - imageArr.count - audioArr.count ], leftOrRight: false, time: "\(textHour)")
                    return n
                }
                
                return node
            } else {
                let node = { [self] () -> ASCellNode in
                    let n = MessageTextNode(text: textArr[indexPath.row - imageArr.count - audioArr.count ], leftOrRight: true, time: "\(textHour)")
                    return n
                }
                return node
            }
        } else {
            if indexPath.row%2 == 0 {
                let node = { [self] () -> ASCellNode in
                    let currentImage = imageArr[indexPath.row - textArr.count - audioArr.count ]
                    let imgMb = currentImage.getSizeIn(.megabyte)
                    let n = MessageImageNode(image: currentImage, leftOrRight: true, time: "\(imageHour)", mb: "\(imgMb) mb", isDownload: true)
                    return n
                }
                
                return node
            } else {
                let node = { [self] () -> ASCellNode in
                    let currentImage = imageArr[indexPath.row - textArr.count - audioArr.count ]
                    let imgMb = currentImage.getSizeIn(.megabyte)
                    let n =  MessageImageNode(image: currentImage, leftOrRight: false, time: "\(imageHour)", mb: "\(imgMb) mb", isDownload: true)
                    return n
                }
                return node
            }
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


extension MessageTableNode: ASTableDelegate {
    
    //    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
    //        return ASSizeRange(min: .zero, max: CGSize(width: self.tableNode.frame.width, height: 100))
    //    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset > scrollView.contentOffset.y) {
//             move up
            tableNode.view.keyboardDismissMode = .onDrag
//            micButton.setImage(UIImage(named: "microphone"), for: .normal)
//            micButton.tintColor = .red
//            print("move up")
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
           // move down
        }

        // update the new position acquired
//        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        let label = UILabel(frame: CGRect(x: tableView.frame.size.width/2-50, y: 0, width: 100, height: 20))
        label.text = "Today"
        label.textAlignment = .center
        label.textColor = UIColor.gray
        view.addSubview(label)
        self.view.addSubview(view)
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        self.view.addSubview(view)
        return view
    }
    
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
}


// MARK: -- MessageTextNode


class MessageTextNode: ASCellNode {
    
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
        //        img.contentMode = .scaleAspectFill
        //        img.style.width = ASDimension(unit: .auto, value: 1)
        return img
    }()
    
    private lazy var markChat: ASImageNode = {
        let img = ASImageNode()
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
        imgChat.cornerRadius = 5
        addSubnode(markChat)
        str = text
        addSubnode(textNode)
        addSubnode(timeNode)
        textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .regular)])
        timeNode.attributedText = NSAttributedString(string: time)
        backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        self.leftOrRight = leftOrRight
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if leftOrRight {
            imgChat.backgroundColor = .green
            //            markChat.style.width.value = 20
            //            markChat.style.height.value = 20
            markChat.image = UIImage(named: "check-2")
            markChat.tintColor = .red
            //            let s9 = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .end, children: [markChat])
            
            let s0 = ASStackLayoutSpec(direction: .horizontal, spacing: 6, justifyContent: .start, alignItems: .end, children: [timeNode,markChat])
            s0.style.flexGrow = 1.0
            s0.style.flexShrink = 1
            let s = ASStackLayoutSpec(direction: .vertical, spacing: 6.0, justifyContent: .start, alignItems: .start, children: [textNode,s0])
            let stack = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: [], child: s)
            
            
            let  inset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
            let headerInset = ASInsetLayoutSpec(insets: inset, child: stack)
            
            let v = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .start, sizingOption: .minimumWidth, child: imgChat)
            
            let s2 = ASBackgroundLayoutSpec(child: headerInset, background: v) //ASOverlayLayoutSpec(child: v, overlay: stack)
            var insets = UIEdgeInsets()
            
            let width = str.widthOfString(usingFont: UIFont.systemFont(ofSize: 16, weight: .regular))
            let q = Int(width) % Int(UIScreen.main.bounds.width-80)
             if width < 50 {
               insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: (UIScreen.main.bounds.width-80))
             } else if width <= UIScreen.main.bounds.width-80 {
                print("👁👁👁👁👁👁👁👁",str.count)
                if str.count <= 3{
                    insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: UIScreen.main.bounds.width-CGFloat(q)-65)
                } else if str.count <= 6 && str.count > 3 {
                    insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: UIScreen.main.bounds.width-CGFloat(q)-50)
                }  else if Int(width) < 150 {
                    print("qoldiq",q)
                    print("width",Int(width))
                    insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: UIScreen.main.bounds.width-CGFloat(q)-15)
                } else  {
                    print("👀👀👀👀👀👀👀👀")
                    print("qoldiq",q)
                    print("width",Int(width))
                    print("screen",Int(UIScreen.main.bounds.width-80))
                    insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: UIScreen.main.bounds.width-CGFloat(q)+10)
                }
            } else {
                insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 80)
            }
            let headerWithInset = ASInsetLayoutSpec(insets: insets, child: s2)
            
            return headerWithInset
            
//            let s2 = ASBackgroundLayoutSpec(child: headerInset, background: v) //ASOverlayLayoutSpec(child: v, overlay: stack)
//            var insets = UIEdgeInsets()
//            let width = str.widthOfString(usingFont: UIFont.systemFont(ofSize: 20))
//            let q = Int(width) % Int(UIScreen.main.bounds.width)
//            if width < UIScreen.main.bounds.width*3/4 {
//                if str.count <= 3 {
//                    insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: UIScreen.main.bounds.width-CGFloat(q)-70)
//                } else if str.count <= 5 && str.count > 3{
//                    insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: UIScreen.main.bounds.width-CGFloat(q)-30)
//                } else {
//                    insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: UIScreen.main.bounds.width-CGFloat(q)-20)
//                }
//            }else {
//                insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 80)
//            }
//            let headerWithInset = ASInsetLayoutSpec(insets: insets, child: s2)
//
//            return headerWithInset
            
        } else {
            
            imgChat.backgroundColor = .red
            markChat.image = UIImage(named: "check-1")
            markChat.tintColor = .white
            
            let s0 = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .start, alignItems: .end, children: [timeNode,markChat])
            s0.style.flexGrow = 1.0
            s0.style.flexShrink = 1
            
            let s = ASStackLayoutSpec(direction: .vertical, spacing: 6.0, justifyContent: .end, alignItems: .end, children: [textNode,s0])
            let stack = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .start, sizingOption: [], child: s)   //ASStackLayoutSpec(direction: .horizontal, spacing: 6.0, justifyContent: .end, alignItems: .end, children: [textNode])
            
            
            let  inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 10)
            let headerInset = ASInsetLayoutSpec(insets: inset, child: stack)
            
            let v = ASRelativeLayoutSpec(horizontalPosition: .end, verticalPosition: .end, sizingOption: .minimumWidth, child: imgChat)
            
            
            let s2 = ASBackgroundLayoutSpec(child: headerInset, background: v) //ASOverlayLayoutSpec(child: v, overlay: stack)
            var insets = UIEdgeInsets()
            
            let width = str.widthOfString(usingFont: UIFont.systemFont(ofSize: 16, weight: .regular))
            let q = Int(width) % Int(UIScreen.main.bounds.width-80)
             if width < 50 {
               insets = UIEdgeInsets(top: 10, left: (UIScreen.main.bounds.width-80), bottom: 10, right: 10)
             } else if width <= UIScreen.main.bounds.width-80 {
                print("👁👁👁👁👁👁👁👁",str.count)
                if str.count <= 3{
                    insets = UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width-CGFloat(q)-65, bottom: 10, right: 10)
                } else if str.count <= 6 && str.count > 3 {
                    insets = UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width-CGFloat(q)-50, bottom: 10, right: 10)
                }  else if Int(width) < 150 {
                    print("qoldiq",q)
                    print("width",Int(width))
                    insets = UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width-CGFloat(q)-15, bottom: 10, right: 10)
                } else  {
                    print("👀👀👀👀👀👀👀👀")
                    print("qoldiq",q)
                    print("width",Int(width))
                    print("screen",Int(UIScreen.main.bounds.width-80))
                    insets = UIEdgeInsets(top: 10, left: UIScreen.main.bounds.width-CGFloat(q)+10, bottom: 10, right: 10)
                }
            } else {
                insets = UIEdgeInsets(top: 10, left: 80, bottom: 10, right: 10)
            }
            let headerWithInset = ASInsetLayoutSpec(insets: insets, child: s2)
            
            return headerWithInset
            
        }
        
    }
    
}



// MARK: --  extension  UITextViewDelegate

extension MessageTableNode: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷🇸🇷")
        self.photoView.isHidden = true
        self.placeholderLabel.isHidden = true
        micButton.setImage(UIImage(named: "send"), for: .normal)
        micButton.tintColor = .green
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        print(textView.text,"👀")
//        if textView.text.isEmpty{
//            self.photoView.isHidden = false
//            self.placeholderLabel.isHidden = false
//            micButton.setImage(UIImage(named: "microphone"), for: .normal)
//            micButton.tintColor = .red
//        } else {
//
//        }
//    }

    
}




// MARK: -- MessageImageNode

class MessageImageNode: ASCellNode {
    
    private lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 0
        node.highlightStyle = .light
        node.textColorFollowsTintColor = true
        node.tintColor = .black
        return node
    }()
    
    
    private lazy var timeNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 0
        node.highlightStyle = .light
        node.textColorFollowsTintColor = true
        node.tintColor = .black
        return node
    }()
    
    private lazy var mbNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 0
        node.highlightStyle = .light
        node.textColorFollowsTintColor = true
        node.tintColor = .black
        return node
    }()
    
    private lazy var bigImg: ASImageNode = {
        let img = ASImageNode()
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .clear
        img.cornerRadius = 16
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var smallImg: ASImageNode = {
        let img = ASImageNode()
        return img
    }()
    
    private lazy var markChat: ASImageNode = {
        let img = ASImageNode()
        return img
    }()
    
    private lazy var viewImg: BaseNode = {
        var v = BaseNode()
        v.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        return v
    }()
    
    
    func addBlur() {
        DispatchQueue.main.async { [self] in
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bigImg.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bigImg.view.addSubview(blurEffectView)
        }
    }
    
    private lazy var leftOrRight: Bool = false
    private lazy var str: String = ""
    private lazy var isDownload: Bool = false
    private var image: UIImage!

    
    
    let loaderButtonNode: ASButtonNode = {
       let b = ASButtonNode()
        b.backgroundColor = .clear
        b.tintColor = .black
        return b
    }()
    
    init(image: UIImage, leftOrRight: Bool, time: String, mb: String, isDownload: Bool) {
        super.init()
        self.image = image
        self.backgroundColor = #colorLiteral(red: 1, green: 0.9715173841, blue: 0.9762826562, alpha: 1)
        mbNode.attributedText = NSAttributedString(string: mb)
        bigImg.style.preferredSize = CGSize(width: UIScreen.main.bounds.width-100, height: 250)
        smallImg.style.preferredSize = CGSize(width: UIScreen.main.bounds.width-200, height: 150)
        loaderButtonNode.style.preferredSize = CGSize(width: 50, height: 50)
        loaderButtonNode.addTarget(self, action: #selector(loaderButtonTapped(_:)), forControlEvents: .touchUpInside)
        bigImg.clipsToBounds = true
        automaticallyManagesSubnodes = true
        self.leftOrRight = leftOrRight
        self.isDownload = isDownload
       
    }
    
    override func didLoad() {
        super.didLoad()
        addBlur()
//       setCornerRadius()
    }
    
    @objc func loaderButtonTapped(_ sender: ASButtonNode){
        print("Bosildii")
        isDownload = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if leftOrRight {
            bigImg.image = image
            smallImg.image = image
            loaderButtonNode.setImage(UIImage(named: "loader"), for: .normal)
            
            let i = UIEdgeInsets(top: 80, left: 50, bottom: 80, right: 50)
            let buttonInset = ASInsetLayoutSpec(insets: i, child: loaderButtonNode)
            
            var inset = UIEdgeInsets()
            inset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70)
           
            var headerInset = ASInsetLayoutSpec()
            
            if isDownload {
                headerInset = ASInsetLayoutSpec(insets: inset, child: smallImg)
            } else {
                headerInset = ASInsetLayoutSpec(insets: inset, child: buttonInset)
            }
            
            let s = ASOverlayLayoutSpec(child: bigImg, overlay: headerInset)
            
            let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .end, alignItems: .end, children: [s])
            
            
            let ins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
            let mbIns = ASInsetLayoutSpec(insets: ins, child: mbNode)
            
            let mbS = ASOverlayLayoutSpec(child: stack, overlay: mbIns)
            
            let stack1 = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .end, alignItems: .end, children: [mbS])
            
            var insets = UIEdgeInsets()
            insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
            let headerWithInset = ASInsetLayoutSpec(insets: insets, child: stack1)
            
            return headerWithInset
        } else {
            bigImg.image = image
            smallImg.image = image
            loaderButtonNode.setImage(UIImage(named: "loader"), for: .normal)
            
            
            //
            let i = UIEdgeInsets(top: 80, left: 50, bottom: 80, right: 50)
            let buttonInset = ASInsetLayoutSpec(insets: i, child: loaderButtonNode)
            //
            var inset = UIEdgeInsets()
            inset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 70)
            var headerInset = ASInsetLayoutSpec()
            
            if isDownload {
                headerInset = ASInsetLayoutSpec(insets: inset, child: smallImg)
            } else {
                headerInset = ASInsetLayoutSpec(insets: inset, child: buttonInset)
            }
            
            let s = ASOverlayLayoutSpec(child: bigImg, overlay: headerInset)
            
            let stack = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .start, alignItems: .end, children: [s])
            
            let ins = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
            let mbIns = ASInsetLayoutSpec(insets: ins, child: mbNode)
            
            let mbS = ASOverlayLayoutSpec(child: stack, overlay: mbIns)
            
            var insets = UIEdgeInsets()
            insets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
            let headerWithInset = ASInsetLayoutSpec(insets: insets, child: mbS)
            
            return headerWithInset
        }
       
    }
    
}



// MARK: -- MessageAudioNode

protocol PlayAudio {
    func playAudio()
}



class MessageAudioNode: ASCellNode {
    
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
    
    private lazy var mbNode: ASTextNode = {
        let node = ASTextNode()
        node.backgroundColor = .clear
        node.maximumNumberOfLines = 0
        node.highlightStyle = .dark
        node.textColorFollowsTintColor = true
        node.tintColor = .black
        return node
    }()
    
    private lazy var bigImg: ASImageNode = {
        let img = ASImageNode()
        img.contentMode = .scaleAspectFill
        img.cornerRadius = 25
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var smallImg: ASImageNode = {
        let img = ASImageNode()
        return img
    }()
    
    private lazy var markChat: ASImageNode = {
        let img = ASImageNode()
        return img
    }()
    
    func addBlur() {
        DispatchQueue.main.async { [self] in
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = bigImg.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            bigImg.view.addSubview(blurEffectView)
        }
    }
    
    private lazy var leftOrRight: Bool = false
    private lazy var str: String = ""
    private lazy var isDownload: Bool = false
    var delegate: PlayAudio!
    var isPlay: Bool = false

    
    let loaderButtonNode: ASButtonNode = {
       let b = ASButtonNode()
        b.backgroundColor = .clear
        b.tintColor = .white
        return b
    }()
    
    var viewArr: [BaseNode] = []
    
    init(text: String, leftOrRight: Bool, time: String, mb: String, isDownload: Bool) {
        super.init()
        timeNode.attributedText = NSAttributedString(string: time)
        mbNode.attributedText = NSAttributedString(string: mb)
        bigImg.style.preferredSize = CGSize(width: UIScreen.main.bounds.width-100, height: 70)
        
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
        
        
        loaderButtonNode.style.preferredSize = CGSize(width: 50, height: 50)
        loaderButtonNode.addTarget(self, action: #selector(loaderButtonTapped(_:)), forControlEvents: .touchUpInside)
        bigImg.clipsToBounds = true
        automaticallyManagesSubnodes = true
        self.leftOrRight = leftOrRight
        self.isDownload = isDownload
       
    }
    
    override func didLoad() {
        super.didLoad()
        addBlur()
//       setCornerRadius()
    }
    
    @objc func loaderButtonTapped(_ sender: ASButtonNode){
        print("Bosildii")
        isPlay = !isPlay
        if isPlay {
            loaderButtonNode.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            loaderButtonNode.setImage(UIImage(named: "play"), for: .normal)

        }
        delegate.playAudio()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

        if leftOrRight {
        
        bigImg.backgroundColor = #colorLiteral(red: 0.2362440526, green: 0.4158081412, blue: 0.5909337997, alpha: 1)
        loaderButtonNode.setImage(UIImage(named: "play"), for: .normal)
        markChat.image = UIImage(named: "check-1")
        markChat.tintColor = .black
        
        
        let rangeStack1 = ASStackLayoutSpec(direction: .horizontal, spacing: 2, justifyContent: .end, alignItems: .end, children: viewArr)
        
        let vStack1 = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .end, alignItems: .start, children: [rangeStack1,mbNode])
        
        let hStack1 = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .end, children: [timeNode,markChat])
        
        let vStack2 = ASStackLayoutSpec(direction: .horizontal, spacing: 15, justifyContent: .start, alignItems: .end, children: [loaderButtonNode,vStack1])
            
        let vStack3 = ASStackLayoutSpec(direction: .horizontal, spacing: -50, justifyContent: .end, alignItems: .end, children: [vStack2,hStack1])
        
        let ins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        let stackInset = ASInsetLayoutSpec(insets: ins, child: vStack3)
        
        let readyStack = ASOverlayLayoutSpec(child: bigImg, overlay: stackInset)
        
        let inset = UIEdgeInsets(top: 5, left: UIScreen.main.bounds.width - (30*5+120), bottom: 5, right: 20)
        let headerInset = ASInsetLayoutSpec(insets: inset, child: readyStack)
        
        return headerInset
            
        } else {
            
            bigImg.backgroundColor = #colorLiteral(red: 0.2362440526, green: 0.4158081412, blue: 0.5909337997, alpha: 1)
            loaderButtonNode.setImage(UIImage(named: "play"), for: .normal)
            markChat.image = UIImage(named: "check-2")
            markChat.tintColor = .black
            
            
            let rangeStack1 = ASStackLayoutSpec(direction: .horizontal, spacing: 2, justifyContent: .end, alignItems: .end, children: viewArr)
            
            let vStack1 = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .end, alignItems: .start, children: [rangeStack1,mbNode])
            
            let hStack1 = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .end, children: [timeNode,markChat])
            
            let vStack2 = ASStackLayoutSpec(direction: .horizontal, spacing: 15, justifyContent: .start, alignItems: .end, children: [loaderButtonNode,vStack1])
                
            let vStack3 = ASStackLayoutSpec(direction: .horizontal, spacing: -55, justifyContent: .end, alignItems: .end, children: [vStack2,hStack1])
            
            let ins = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 20)
            let stackInset = ASInsetLayoutSpec(insets: ins, child: vStack3)
            
            let readyStack = ASOverlayLayoutSpec(child: bigImg, overlay: stackInset)
            
            let inset = UIEdgeInsets(top: 5, left: 20, bottom: 5, right: UIScreen.main.bounds.width - (30*5+120))
            let headerInset = ASInsetLayoutSpec(insets: inset, child: readyStack)
            
            return headerInset
        }
       
    }
    
}


extension MessageTableNode: UIImagePickerControllerDelegate { }








// MARK: -- EXTENTION !





extension MessageTableNode: AVAudioRecorderDelegate, AVAudioPlayerDelegate, PlayAudio {
    
//    func addSwip() {
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//            swipeLeft.direction = .left
//            self.micView.addGestureRecognizer(swipeLeft)
//
//        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
//            swipeUp.direction = .up
//            self.micView.addGestureRecognizer(swipeUp)
//    }
    
//    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
//
//        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
//
//            switch swipeGesture.direction {
//            case .left:
//                print("Swiped left")
//                start_recording()
//
//            case .up:
//                print("Swiped up")
//                audioArr.append(2)
//                tableNode.insertRows(at: [IndexPath(row: audioArr.count-1, section: 0)], with: .fade)
//                animationView?.isHidden = true
//                meterTimer.invalidate()
////                audioPlayer.stop()
//            default:
//                break
//            }
//        }
//    }

    
    
    func check_record_permission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
                    if allowed {
                        self.isAudioRecordingGranted = true
                    } else {
                        self.isAudioRecordingGranted = false
                    }
            })
            break
        default:
            break
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileUrl() -> URL {
        let filename = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
    return filePath
    }
    
    
    func setup_recorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            }
            catch let error {
                display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
            }
        } else {
            display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
        }
    }
    
    func start_recording() {
        if (isRecording) {
            finishAudioRecording(success: true)
            animationView?.isHidden = false
//            record_btn_ref.setTitle("Record", for: .normal)
//            play_btn_ref.isEnabled = true
            isRecording = false
        } else {
            setup_recorder()
            audioRecorder.record()
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector:#selector(self.updateAudioMeter(timer:)), userInfo:nil, repeats:true)
//            record_btn_ref.setTitle("Stop", for: .normal)
//            play_btn_ref.isEnabled = false
            isRecording = true
        }
    }

    @objc func updateAudioMeter(timer: Timer) {
        if audioRecorder.isRecording {
//            let hr = Int((audioRecorder.currentTime / 60) / 60)
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let millisecond = Int((audioRecorder.currentTime*100).truncatingRemainder(dividingBy: 100))
            let totalTimeString = String(format: "%02d:%02d:%02d", min, sec, millisecond)
            print(millisecond, "👑👑👑👑👑👑👑👑👑")
            recordingTime = totalTimeString
            audioRecorder.updateMeters()
        }
    }

    func finishAudioRecording(success: Bool) {
        print(success)
        print(audioRecorder.currentTime)
        if success {
            audioRecorder.stop()
            audioRecorder = nil
            meterTimer.invalidate()
            print("recorded successfully.")
        } else {
            display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
        }
    }
    
    
    
    func prepare_play() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileUrl())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
    }

//    MARK: -- play_recording()
    
    func play_recording() {
        if (isPlaying) {
            audioPlayer.stop()
//            record_btn_ref.isEnabled = true
//            play_btn_ref.setTitle("Play", for: .normal)
            isPlaying = false
        } else {
            if FileManager.default.fileExists(atPath: getFileUrl().path) {
//                record_btn_ref.isEnabled = false
//                play_btn_ref.setTitle("pause", for: .normal)
                prepare_play()
                audioPlayer.play()
                isPlaying = true
            } else {
                display_alert(msg_title: "Error", msg_desc: "Audio file is missing.", action_title: "OK")
            }
        }
    }
    
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
//        print(flag)
//        if audioRecorder.currentTime < 0.53 {
//            audioPlayer.stop()
//            meterTimer.invalidate()
//        } else {
            if !flag {
                finishAudioRecording(success: false)
            }
//            play_btn_ref.isEnabled = true
//        }
    }
    
    

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    
    
    
    func display_alert(msg_title : String , msg_desc : String ,action_title : String) {
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
        _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    //  MARK: -- Audio Cell
    
    func playAudio() {
        print(getFileUrl(),"🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈🌈")
        play_recording()
    }
    
    
    

}



//  MARK: -- Keyboard


extension MessageTableNode {
    
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
            isRecordingStart = false
            let keyboardHeight: CGFloat = keyboardSize.height
            vStack.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+25)
            micView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight+25)
            
            tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75+keyboardHeight, right: 0)
            
            tableNode.scrollToRow(at: IndexPath(row: textArr.count-1+imageArr.count+audioArr.count, section: 0), at: .top, animated: true)
        }
        
        
    }
    
    
    @objc fileprivate func keyboardWillHide(sender: Notification) {
        vStack.transform = .identity
        isRecordingStart = true
        micView.transform = .identity
        tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        photoView.isHidden = false
        placeholderLabel.isHidden = !textViewNode.text.isEmpty
        micButton.setImage(UIImage(named: "microphone"), for: .normal)
        micButton.tintColor = .red
    }
    
    
}




