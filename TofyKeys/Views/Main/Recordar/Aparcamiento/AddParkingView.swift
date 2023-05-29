//
//  AddParkingView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 14/5/23.
//

import SwiftUI
import UIKit
import MapKit

struct Parking {
    var reference: String?
    var color: String?
    var latitude: CGFloat?
    var longitude: CGFloat?
    var date: Date
}

struct AddParkingView: View {
    
    var onAdd: ((String, String, CGFloat, CGFloat) -> Void)
    
    @State var reference: String = ""
    @State var color: Color = .clear
    @State var latitude: CGFloat?
    @State var longitude: CGFloat?
    
    @State var manager = CLLocationManager()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.390205, longitude: 2.154007), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @StateObject var managerDelegate = LocationDelegate()
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey("AddParking"))
                .title(.black)
                .padding()
            HStack(spacing: 0) {
                TextField(LocalizedStringKey("Reference"), text: $reference)
                    .textFieldStyle(LoginTextFieldStyle())
                ColorPicker("", selection: $color, supportsOpacity: false)
                    .labelsHidden()
                    .padding(.trailing)
            }
            if latitude == nil || longitude == nil {
                ZStack(alignment: .center) {
                    Image("mapa")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .cornerRadius(12)
                        .frame(height: 200)
                        .padding()
                    Button(LocalizedStringKey("Add_localization")) {
                        manager.delegate = managerDelegate
                        switch manager.authorizationStatus {
                        case .notDetermined, .denied, .restricted:
                            manager.requestWhenInUseAuthorization()
                        case .authorizedWhenInUse, .authorizedAlways:
                            manager.startUpdatingLocation()
                        @unknown default:
                            manager.requestWhenInUseAuthorization()
                        }
                    }.buttonStyle(HighlightButton())
                }
            } else {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .cornerRadius(12)
                    .frame(height: 200)
                    .padding()
            }
            Button {
                onAdd(reference == "" ? "-" : reference, color == .clear ? "-" : hexStringFromColor(color: UIColor(color)), latitude ?? 0, longitude ?? 0)
            } label: {
                PrincipalButtonText(LocalizedStringKey("AddParking"))
            }.buttonStyle(PrincipalButton())
            Spacer()
        }
        .onReceive(managerDelegate.$location) { location in
            if let location {
                region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
                manager.delegate = nil
            }
        }
    }
    
    func hexStringFromColor(color: UIColor) -> String {
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        print(hexString)
        return hexString
     }
}

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        } else {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
