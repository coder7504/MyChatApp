//
//  MainViewController.swift
//  ExampleChat
//
//  Created by Mac user on 13/08/21.
//

import AsyncDisplayKit


class MainViewController: ASDKViewController<ASDisplayNode> {

    // MARK: -- ASTableNode
    
    var tableNode: ASTableNode = {
        var tableNode = ASTableNode(style: .plain)
        tableNode.view.leadingScreensForBatching = 1.0
        return tableNode
    }()
    
var animals = [
    "The annelids, also known as the ringed worms or segmented worms, are a large phylum, with over 22,000 extant species including ragworms, earthworms, and leeches. The species exist in and have adapted to various ecologies – some in marine environments as distinct as tidal zones and hydrothermal vents, others in fresh water, and yet others in moist terrestrial environments.",
    "Arthropods are invertebrate animals having an exoskeleton, a segmented body, and paired jointed appendages. Arthropods form the phylum Euarthropoda, which includes insects, arachnids, myriapods, and crustaceans. The term Arthropoda as originally proposed refers to a proposed grouping of Euarthropods and the phylum Onychophora. They are distinguished by their jointed limbs and cuticle made of chitin, often mineralised with calcium carbonate. The arthropod body plan consists of segments, each with a pair of appendages. In order to keep growing, they have to go through moulting, which sheds their skin. Arthropods are bilaterally symmetrical and their body possesses an external skeleton. Some species have wings. They are an extremely diverse group, with up to 10 million species.",
    "A chordate is an animal of the phylum Chordata. All chordates possess 5 synapomorphies, or primary characteristics, at some point during their larval or adulthood stages that distinguish them from all other taxa. These 5 synapomorphies include a notochord, dorsal hollow nerve cord, endostyle or thyroid, pharyngeal slits, and a post-anal tail. Chordates get their name from their characteristic “notochord”, which plays a significant role in chordate structure and movement. Chordates are also bilaterally symmetric, have a coelom, possess a circulatory system, and exhibit metameric segmentation.",
    "Cnidaria is a phylum under kingdom Animalia containing over 11,000 species of aquatic animals found both in freshwater and marine environments, predominantly the latter.",
    "An echinoderm is any member of the phylum Echinodermata of marine animals. The adults are recognizable by their radial symmetry, and include starfish, sea urchins, sand dollars, and sea cucumbers, as well as the sea lilies or . Adult echinoderms are found on the sea bed at every ocean depth, from the intertidal zone to the abyssal zone. The phylum contains about 7000 living species, making it the second-largest grouping of deuterostomes, after the chordates. Echinoderms are the largest phylum that has no freshwater or terrestrial members.",
    "Mollusca is the second-largest phylum of invertebrate animals after the Arthropoda. The members are known as molluscs or mollusks. Around 85,000 extant species of molluscs are recognized. The number of fossil species is estimated between 60,000 and 100,000 additional species. The proportion of undescribed species is very high. Many taxa remain poorly studied.",
    "The nematodes or roundworms constitute the phylum Nematoda, with plant-parasitic nematodes being known as eelworms. They are a diverse animal phylum inhabiting a broad range of environments. Taxonomically, they are classified along with insects and other moulting animals in the clade Ecdysozoa, and unlike flatworms, have tubular digestive systems with openings at both ends. Like tardigrades they have a reduced number of Hox genes, but as their sister phylum Nematomorpha has kept the ancestral protostome Hox genotype, it shows that the reduction has occurred within the nematode phylum.",
    "The flatworms, flat worms, Platyhelminthes, or platyhelminths are a phylum of relatively simple bilaterian, unsegmented, soft-bodied invertebrates. Unlike other bilaterians, they are acoelomates, and have no specialized circulatory and respiratory organs, which restricts them to having flattened shapes that allow oxygen and nutrients to pass through their bodies by diffusion. The digestive cavity has only one opening for both ingestion and egestion ; as a result, the food cannot be processed continuously.",
    "The rotifers, commonly called wheel animals or wheel animalcules, make up a phylum of microscopic and near-microscopic pseudocoelomate animals.",
    "Sponges, the members of the phylum Porifera, are a basal animal clade as a sister of the Diploblasts. They are multicellular organisms that have bodies full of pores and channels allowing water to circulate through them, consisting of jelly-like mesohyl sandwiched between two thin layers of cells. The branch of zoology that studies sponges is known as spongiology.",
    "The first fossils that might represent animals appear in the 665-million-year-old rocks of the Trezona Formation of South Australia. These fossils are interpreted as most probably being early sponges.",
    "The oldest animals are found in the Ediacaran biota, towards the end of the Precambrian, around 610 million years ago. It had long been doubtful whether these included animals,[79][80][81] but the discovery of the animal lipid cholesterol in fossils of Dickinsonia establishes that these were indeed animals",
    "Animals are thought to have originated under low-oxygen conditions, suggesting that they were capable of living entirely by anaerobic respiration, but as they became specialized for aerobic metabolism they became fully dependent on oxygen in their environments.",
    "Some palaeontologists have suggested that animals appeared much earlier than the Cambrian explosion, possibly as early as 1 billion years ago",
    "Trace fossils such as tracks and burrows found in the Tonian period may indicate the presence of triploblastic worm-like animals, rou",
    ", the layered mats of microorganisms called stromatolites decreased in diversity, perhaps due to grazing by newly evolved ani"
]
    
    var animalImage = [
        "Unknown-0",
        "Unknown-1",
        "Unknown-2",
        "Unknown-3",
        "Unknown-4",
        "Unknown-5",
        "Unknown-6",
        "Unknown-0",
        "Unknown-1",
        "Unknown-2",
        "Unknown-3",
        "Unknown-4",
        "Unknown-5",
        "Unknown-6",
        "Unknown-0",
        "Unknown-1",
    ]
    
    // MARK: -- buttonNode
    
    let buttonNode = ASDisplayNode { () -> UIButton in
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.backgroundColor = .blue
        return button
    }
    
    // MARK: -- ASTextNode2
    
    let labelNode: ASTextNode2  = {
        let lnode = ASTextNode2()
        lnode.attributedText = NSAttributedString(string: "ASTextNode2")
        lnode.backgroundColor = .red
        
        let layzoutSize = lnode.calculateLayoutThatFits(ASSizeRangeMake(.zero, CGSize(width: 999, height: 999)))
        lnode.frame = CGRect(x: 120, y: 50, width: 300, height: layzoutSize.size.height)
        return lnode
        
    }()
    
    
    
    // MARK: -- ASTextNode
    
    lazy var text = "ASTextNode"
    
    lazy var aStr = NSAttributedString(string: text, attributes: [.font:UIFont.systemFont(ofSize: 20), .foregroundColor:UIColor.white])
       
       lazy var textNode1: ASTextNode = {
           let node = ASTextNode()
           
           node.attributedText = aStr
           node.backgroundColor = UIColor.green
           
           let layzoutSize = node.calculateLayoutThatFits(ASSizeRangeMake(.zero, CGSize(width: 999, height: 999)))
           node.frame = CGRect(x: 120, y: 100, width: 300, height: layzoutSize.size.height)
           return node
       }()
    
    
    
    // MARK: -- viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubnode(tableNode)
        self.appStyle()
        self.wireDelegation()
        tableNode.view.tableFooterView = UIView()
        tableNode.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        self.view.addSubnode(labelNode)
        self.view.addSubnode(textNode1)
        
        setButton()
        
        self.view.addSubnode(buttonNode)
        buttonNode.frame = CGRect(x: 50, y: 50, width: 60, height: 70)
//        buttonNode.style.width = ASDimension(unit: .auto, value: 30)
//        buttonNode.style.width = ASDimension(unit: .auto, value: 30)
        
//        tableNode.view.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);
//        tableNode.view.allowsSelection = false
//        tableNode.view.separatorStyle = .none
//        tableNode.view.leadingScreensForBatching = 3.0
        
    }
  
    // MARK: -- setButton
    
    func setButton(){

        if let button = buttonNode.view as? UIButton {
            button.setTitle("buttonNode", for: .normal)
            button.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        }
    
        
    }
    
    
    @objc func tapAction(){
        print("Tap button")
    }
    
    // MARK: -- setTableNode
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        tableNode.frame = CGRect(x: 20, y: 100, width: self.view.frame.width-40, height: self.view.frame.height-100)
        
        
    }
    
    // MARK: -- appStyle
    
    func appStyle() {
        self.view.backgroundColor = .white
        self.tableNode.view.separatorStyle = .none
    }
    
    func wireDelegation() {
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
    }
 


}

// MARK: -- ASTableDataSource

extension MainViewController: ASTableDataSource {

    
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        animalImage.count
    }
    
//    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
//        <#code#>
//    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let node = { [unowned self] () -> ASCellNode in
            return ExampleNode(text: self.animals[indexPath.row]+"\(indexPath.row)", image: animalImage[indexPath.row])
        }
        return node
    }
    
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        true
    }
    
}



// MARK: -- ASTableDelegate


extension MainViewController: ASTableDelegate {
    
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        return ASSizeRange(min: CGSize(width: self.tableNode.frame.width-200, height: 400), max: CGSize(width: self.tableNode.frame.width-200, height: 400))
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let vc = MessageText()
        navigationItem.backButtonTitle = ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


// MARK: -- ASCellNode


class ExampleNode: ASCellNode {

    private lazy var textNode: ASTextNode = {
        let node = ASTextNode()
        node.backgroundColor = .clear
        node.maximumNumberOfLines = 200
        node.highlightStyle = .light
        
        return node
    }()

    private lazy var imageNode: ASImageNode = {
        let image = ASImageNode()
        image.contentMode = .scaleToFill
        image.cornerRadius = 16
        image.shadowColor = UIColor.red.cgColor
        image.shadowOffset = CGSize(width: 0, height: 0)
        image.shadowOpacity = 1
        image.shadowRadius = 3
        return image
    }()
    
    let containerNode: BaseNode = {
       var node = BaseNode()
        node.backgroundColor = .white
        return node
    }()
    
    
    
    init(text: String, image: String) {
        super.init()
//        addSubnode(containerNode)
//        containerNode.frame = CGRect(x: 0, y: 0, width: self.view.frame.width-200, height: 400)
        imageNode.image = UIImage(named: image)
        imageNode.cropRect = CGRect(x: 0.5, y: 0.5, width: 0.0, height: 0.0)
        imageNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.width-60, height: 200)
        addSubnode(imageNode)
        textNode.attributedText = NSAttributedString(string: text)
        backgroundColor = .white
        addSubnode(textNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec(direction: .vertical, spacing: 20, justifyContent: .center, alignItems: .center, flexWrap: .noWrap, alignContent: .spaceAround, lineSpacing: 100, children: [imageNode,textNode])
        
        stack.style.flexShrink = 1
        stack.style.flexGrow = 1
        
        
        return stack
        
    }
    
}
