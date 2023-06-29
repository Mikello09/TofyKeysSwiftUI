//
//  ParkingView.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 14/5/23.
//

import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct ParkingView: View {
    
    @ObservedObject var claveViewModel: ClaveViewModel
    
    @State var parkings: [Parking] = []
    @State var showAddParking: Bool = false
    
    var body: some View {
        TofyNavigation {
            ZStack {
                if parkings.isEmpty {
                    VStack {
                        Spacer()
                        LottieView(name: "add", loopMode: .loop)
                            .frame(width: 64, height: 64)
                            .onTapGesture {
                                self.showAddParking = true
                            }
                        Text(LocalizedStringKey("EmptyParking"))
                            .title()
                            .multilineTextAlignment(.center)
                            .padding([.leading, .trailing], 64)
                        Spacer()
                    }
                } else {
                    VStack {
                        if let actualParking = parkings.first {
                            ActualParkingCell(parking: actualParking)
                                .frame(height: (actualParking.latitude ?? 0) == 0 ? 128 : 350)
                        }
                        HStack {
                            Text(LocalizedStringKey("HistoricoParkings"))
                                .title()
                                .padding()
                            Spacer()
                        }
                        ScrollView {
                            ForEach(Array(parkings.enumerated()), id: \.offset) { index, parking in
                                if index != 0 {
                                    HistoricParkingCell(parking: parking)
                                        .frame(height: 64)
                                }
                            }
                        }
                        Spacer()
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("Parking"))
            .toolbar(content: {
                Button (action: {
                    self.showAddParking = true
                }, label: {
                    imageButton(systemName: "plus.circle", color: .primaryColor, size: 24)
                })
            })
            .background(Image("tofy_background"))
        }
        .sheet(isPresented: $showAddParking) {
            AddParkingView() { reference, color, latitude, longitude in
                self.showAddParking = false
                claveViewModel.addClave(titulo: Date().toString(),
                                        valores: Valores(tipo: ClaveType.aparcamiento.rawValue,
                                                         valor: "\(reference)\(VALUE_SEPARATOR)\(color)\(VALUE_SEPARATOR)\(latitude)\(VALUE_SEPARATOR)\(longitude)"))
            }
        }
        .onReceive(claveViewModel.$parkings) { parkings in
            let orderedParkings = parkings.sorted(by: {$0.date < $1.date})
            self.parkings = orderedParkings.reversed()
        }
    }
        
}

struct ActualParkingCell: View {
    
    var parking: Parking
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey("ActualParkingTitle"))
                .title()
                .padding()
            ZStack(alignment: .top) {
                if parking.latitude != 0, parking.longitude != 0 {
                    Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: parking.latitude ?? 0,
                                                                                                      longitude: parking.longitude ?? 0),
                                                                       span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
                        showsUserLocation: true,
                        annotationItems: [MapLocation(name: "Parking", latitude: parking.latitude ?? 0, longitude: parking.longitude ?? 0)],
                        annotationContent: { location in
                        MapMarker(coordinate: location.coordinate, tint: .red)
                    })
                    .cornerRadius(12)
                    .padding()
                }
                if let reference = parking.reference {
                    HStack {
                        Text(reference)
                            .frame(height: 32)
                        if let color = parking.color {
                            Rectangle()
                                .fill(Color(hex: color))
                                .frame(width: 32, height: 32)
                        }
                    }
                    .frame(height: 42)
                    .padding()
                    .background(.white)
                    .cornerRadius(12)
                    
                }
            }
            //.frame(height: 168)
        }
        
    }
}

struct HistoricParkingCell: View {
    
    var parking: Parking
    
    var body: some View {
        HStack {
            Text(parking.date.toString())
                .padding()
            Spacer()
            if parking.latitude != 0, parking.longitude != 0 {
                Image("mapa")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding()
            }
        }
    }
}
