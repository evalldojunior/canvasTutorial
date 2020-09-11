//
//  ViewController.swift
//  Canvas
//
//  Created by Evaldo Garcia de Souza Júnior on 09/09/20.
//  Copyright © 2020 Evaldo Júnior. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIView!
    var cor: UIColor = UIColor.black
    var imagemAdd:UIImageView = UIImageView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func adicionarTriangulo(_ sender: UIButton) {
        // processo para renderizar o triangulo
        let render = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let img = render.image { ctx in
            // parece estranho ter o nome retangulo aqui quando se trata de um triangulo, mas é que vamos desenhar um triangulo a partir de um retangulo :)
            // posicao e tamanho que ele é gerado dentro do render
            let retangulo = CGRect(x: 0, y: 0, width: 100, height: 100)
            // cor de preenchimento
            ctx.cgContext.setFillColor(cor.cgColor)
            // tamanho da borda -> 0 px
            ctx.cgContext.setLineWidth(0)
            // aqui que faz o desenho do triangulo, veja o gif abaixo pra melhor entendimento dos passos
            // passo 1
            ctx.cgContext.move(to: CGPoint(x: retangulo.minX,y: retangulo.minY))
            // passo 2
            ctx.cgContext.addLine(to: CGPoint(x: retangulo.maxX, y: retangulo.midY))
            // passo 3
            ctx.cgContext.addLine(to: CGPoint(x: retangulo.minX, y: retangulo.maxY))
            // passo 4
            ctx.cgContext.closePath()
            // passo 5
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        // aqui inicializa um ImageView com a imagem criada acima e seu posicionamento
        let triangulo = UIImageView.init(image: img)
        triangulo.frame.origin = CGPoint(x: canvasView.frame.midX-50, y: canvasView.frame.midY-50)
        // permite o usuario a ter interacao com o triangulo criado
        triangulo.isUserInteractionEnabled = true
        // adiciona o triangulo na base so canvas
        canvasView.addSubview(triangulo)
        chamarGesture(imagem: triangulo)
    }
    
    @IBAction func adicionarQuadrado(_ sender: UIButton) {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let img = render.image { ctx in
            let retangulo = CGRect(x: 0, y: 0, width: 100, height: 100)
            ctx.cgContext.setFillColor(cor.cgColor)
            ctx.cgContext.setLineWidth(0)
            ctx.cgContext.addRect(retangulo)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        let quadrado = UIImageView.init(image: img)
        quadrado.frame.origin = CGPoint(x: canvasView.frame.midX-50, y: canvasView.frame.midY-50)
        quadrado.isUserInteractionEnabled = true
        canvasView.addSubview(quadrado)
        chamarGesture(imagem: quadrado)
    }
    
    @IBAction func adicionarCirculo(_ sender: UIButton) {
        let render = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let img = render.image { ctx in
            let retangulo = CGRect(x: 0, y: 0, width: 100, height: 100)
            ctx.cgContext.setFillColor(cor.cgColor)
            ctx.cgContext.setLineWidth(0)
            ctx.cgContext.addEllipse(in: retangulo)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        let circulo = UIImageView.init(image: img)
        circulo.frame.origin = CGPoint(x: canvasView.frame.midX-50, y: canvasView.frame.midY-50)
        canvasView.addSubview(circulo)
        circulo.isUserInteractionEnabled = true
        chamarGesture(imagem: circulo)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        guard let gestureView = gesture.view else {
            return
        }
        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )
        gesture.setTranslation(.zero, in: view)
    }
    
    @objc func handleRotate(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        gestureView.transform = gestureView.transform.rotated(
            by: gesture.rotation
        )
        gesture.rotation = 0
    }
    
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
            return
        }
        gestureView.transform = gestureView.transform.scaledBy(
            x: gesture.scale,
            y: gesture.scale
        )
        gesture.scale = 1
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        canvasView.bringSubviewToFront(sender.view!)
    }
    
    func chamarGesture(imagem: UIImageView){
        //adc gesto de arrastar
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        imagem.addGestureRecognizer(pan)
        
        //adc redimensionar
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        imagem.addGestureRecognizer(pinch)
        
        //adc rotacionar
        let rotate = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate))
        imagem.addGestureRecognizer(rotate)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(sender:)))
        imagem.addGestureRecognizer(tap)
    }
    
    @IBAction func selecionarCor(_ sender: UIButton) {
        guard let button = sender as? UIButton else {
            return
        }
        switch button.tag {
        case 1:
            cor = button.backgroundColor!
        case 2:
            cor = button.backgroundColor!
        case 3:
            cor = button.backgroundColor!
        case 4:
            cor = button.backgroundColor!
        case 5:
            cor = button.backgroundColor!
        case 6:
            cor = button.backgroundColor!
        default:
            return
        }
    }
    
    @IBAction func adicionarImagem() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
        canvasView.addSubview(imagemAdd)
        imagemAdd.isUserInteractionEnabled = true
        chamarGesture(imagem: imagemAdd)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imagemAdd.image = image
        }
        //chamada para caso adicione outra foto
        imagemAdd = UIImageView(frame: CGRect(x: 100, y: 200, width: 200, height: 200))
        dismiss(animated: true, completion: nil)
    }
}
