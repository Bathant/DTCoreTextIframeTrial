//
//  ViewController.swift
//  DTCoreTextIframeTrial
//
//  Created by Bathant on 03/12/2020.
//

import UIKit
import DTCoreText
import WebKit
class ViewController: UIViewController {
    
    @IBOutlet weak var contentView: DTAttributedTextContentView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let str = "<p><em><strong>Spring, Texas &#8211;</strong></em> A 16-year-old male is in police custody after stabbing his grandmother with a knife according to Harris County Precinct 4 Constables.</p>\n<p>The scene is unfolding in the 5800 block of Slashwood Lane in the Terranova subdivision.</p>\n<p>Officials say that the juvenile male stabbed his grandmother multiple times with a knife. She was transported to the hospital but is reported to be in stable condition.</p>\n<p>According to police, this same juvenile was arrested last year after assaulting his grandfather. He suffered life-threatening injuries from the assault which led to his death.</p>\n<p>This is an active and developing scene.</p>\n<p><iframe style=\"border: 0;\" tabindex=\"0\" src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3454.328031026047!2d-95.50082718447224!3d30.027445626329452!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8640ccc755c669c1%3A0xba267a5bbf8928b5!2s5800%20Slashwood%20Ln%2C%20Spring%2C%20TX%2077379!5e0!3m2!1sen!2sus!4v1606929929850!5m2!1sen!2sus\" width=\"100%\" height=\"450\" frameborder=\"0\" allowfullscreen=\"allowfullscreen\" aria-hidden=\"false\"><span data-mce-type=\"bookmark\" style=\"display: inline-block; width: 0px; overflow: hidden; line-height: 0;\" class=\"mce_SELRES_start\">﻿</span></iframe></p>\n"
        contentView.delegate = self
        contentView.attributedString = returnAttributedStringForHTMLString(with: str)
        // Do any additional setup after loading the view.
    }
    
    public func returnAttributedStringForHTMLString (with str: String) -> NSAttributedString {
        let encodedData = str.data(using: String.Encoding.utf8)!
        let builder = DTHTMLAttributedStringBuilder(html: encodedData, options: [DTUseiOS6Attributes: true], documentAttributes: nil)
        var returnValue:NSAttributedString?
        returnValue = builder?.generatedAttributedString()
        if returnValue != nil {
            //needed to show link highlighting
            return  returnValue!
        }else{
            return NSAttributedString(string: "")
        }
    }
    
}

extension ViewController:
    DTAttributedTextContentViewDelegate, DTLazyImageViewDelegate{
    func attributedTextContentView(_ attributedTextContentView: DTAttributedTextContentView!, viewFor attachment: DTTextAttachment!, frame: CGRect) -> UIView! {
//        if attachment is DTImageTextAttachment {
//            let imageView = DTLazyImageView(frame: frame)
//            imageView.delegate = self
//            // url for deferred loading
//            imageView.url = attachment.contentURL
//            return imageView
//        }
        if attachment is DTIframeTextAttachment {
            let webview = WKWebView(frame: frame)
            let html = "<iframe src= \(attachment!.contentURL.absoluteString)></iframe>"
            webview.loadHTMLString(html, baseURL: nil)
            return webview
        }
        return UIView(frame: CGRect.zero)
    }
    
    func lazyImageView(_ lazyImageView: DTLazyImageView, didChangeImageSize: CGSize) {
        guard let url = lazyImageView.url else {return}
        let pred = NSPredicate(format: "contentURL == %@", url as CVarArg)
        
        let array = contentView.layoutFrame.textAttachments(with: pred)
        
        
        
        for (_, _) in (array?.enumerated())! {
            let element = DTTextAttachment()
            element.originalSize = didChangeImageSize
        }
        
        contentView.layouter = nil
        contentView.relayoutText()
    }
    
}
