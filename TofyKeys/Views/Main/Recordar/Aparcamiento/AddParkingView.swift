//
//  AddParkingView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 14/5/23.
//

import SwiftUI
import MapKit

struct Parking {
    var reference: String?
    var latitude: CGFloat?
    var longitude: CGFloat?
}

struct AddParkingView: View {
    
    @State var reference: String = ""
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
            TextField(LocalizedStringKey("Reference"), text: $reference)
                .textFieldStyle(LoginTextFieldStyle())
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
                print("add parking")
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
