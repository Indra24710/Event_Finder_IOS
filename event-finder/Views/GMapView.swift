import SwiftUI
import MapKit

struct MapView: View {
    @State var latitude:Double;
    @State var longitude:Double
    @State private var region:MKCoordinateRegion
    
    
    init(latitude:Double,longitude:Double){
        self.latitude=latitude;
        self.longitude=longitude;
        self._region = State(initialValue: MKCoordinateRegion(
                   center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                   span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
               ))
        
    }
    struct Location: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }
    var body: some View {
        let location = Location(coordinate:region.center);
        VStack{
            Spacer()
            Map(coordinateRegion: $region, annotationItems: [location]) { coordinate in
                MapAnnotation(coordinate: location.coordinate) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .imageScale(.large)
                }
            }.padding(.top,15)
            Spacer()

            
        }
    }
}
