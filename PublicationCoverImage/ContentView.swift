
import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WidthView()
                .tabItem {
                    Label {
                        Text("Width")
                    } icon: {
                        Image(systemName: "person.crop.square")
                    }
                }

            HeightView()
                .tabItem {
                    Label {
                        Text("Height")
                    } icon: {
                        Image(systemName: "square.and.at.rectangle")
                    }
                }

            ContainView()
                .tabItem {
                    Label {
                        Text("Contain")
                    } icon: {
                        Image(systemName: "soccerball.circle.inverse")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
