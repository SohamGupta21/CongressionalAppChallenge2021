
//
//  CameraScreen.swift
//  QuickDictionary
//
//  Created by soham gupta on 6/13/21.
//
import SwiftUI
import AVFoundation
import Vision

struct CameraScreen: View {
    init() {
            // this is not the same as manipulating the proxy directly
            let appearance = UINavigationBarAppearance()
            
            // this overrides everything you have set up earlier.
            appearance.configureWithTransparentBackground()
            
            // this only applies to big titles
            appearance.largeTitleTextAttributes = [
                .font : UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : Color.blue
            ]
            // this only applies to small titles
            appearance.titleTextAttributes = [
                .font : UIFont.systemFont(ofSize: 20),
                NSAttributedString.Key.foregroundColor : Color.blue
            ]
            
            //In the following two lines you make sure that you apply the style for good
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            UINavigationBar.appearance().standardAppearance = appearance
            
            // This property is not present on the UINavigationBarAppearance
            // object for some reason and you have to leave it til the end
            UINavigationBar.appearance().tintColor = .white
            
        }
    @StateObject var camera = CameraModel()
    var body: some View {
        NavigationView{
            ZStack{
                CameraPreview(camera: camera)
                    .ignoresSafeArea(.all, edges: .all)
                VStack{
                    if camera.isTaken{
                        HStack{
                            Spacer()
                            Button(action: camera.reTake, label:{
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                            })
                            .padding(.trailing)
                        }
                    }
                    Spacer()
                    HStack{
                        if camera.isTaken{
                            NavigationLink(
                                destination: DictionaryScreen(word: ""),
                                label: {
                                    Text("hello")
//                                    Button(action: {if !camera.isSaved{camera.savePic()}}, label:{
//                                        Text(camera.isSaved ? "Saved":"Save")
//                                            .foregroundColor(.black)
//                                            .fontWeight(.semibold)
//                                            .padding(.vertical, 10)
//                                            .padding(.horizontal,20)
//                                            .background(Color.white)
//                                            .clipShape(Capsule())
//                                    })
//                                    .padding(.leading)
                                })
                            Spacer()
                        }else{
                            Button(action:camera.takePic,label:{
                                ZStack{
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 65, height: 65)
                                    Circle()
                                        .stroke(Color.white, lineWidth:3)
                                        .frame(width:75, height:75)
                                }
                            })
                        }
                        
                    }
                    .frame(height:75)
                }
            }
            .onAppear(perform:{
                camera.Check()
            })
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview = AVCaptureVideoPreviewLayer()
    
    @Published var isSaved = false
   
    @Published var picData = Data(count: 0)
    func Check(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case.authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp(){
        do{
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera,for:.video, position:.back)
            
            let input = try AVCaptureDeviceInput(device:device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.output){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func takePic(){
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
            
            self.recognizeText()
        }
    }
    
    func reTake(){
        DispatchQueue.global(qos:.background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        
        print("pic taken...")
        
        guard let imageData = photo.fileDataRepresentation() else{return}
        
        self.picData = imageData
    }
    
    func savePic(){
        guard let image = UIImage(data: self.picData) else { return }
        
        //saving image
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

        self.isSaved = true
        print("saved success")
    }
    func recognizeText(image: UIImage = UIImage(imageLiteralResourceName: "stopsing")) {
            guard let cgImage =  image.cgImage else {
                return
            }
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            let request = VNRecognizeTextRequest { [weak self] request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation],
                      error == nil else {
                    return
                }
                
                let text = observations.compactMap({
                    $0.topCandidates(1).first?.string
                }).joined(separator: ", ")
                
                DispatchQueue.main.async {
                    print(text)
                }
                
            }
            
            do {
                try handler.perform([request])
            }
            catch {
                print("\(error)")
            }
            
            
        }
}

struct CameraScreen_Previews: PreviewProvider {
    static var previews: some View {
            CameraScreen()
    }
}

struct CameraPreview: UIViewRepresentable{
    
    @ObservedObject var camera: CameraModel
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame:UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        return
    }
}
