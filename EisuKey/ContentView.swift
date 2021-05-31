import SwiftUI
import AppKit
import ServiceManagement

struct ContentView: View {
    private static let userDefaultsKey = "launchAtLogin"
    @State private var isCheckedLaunchWhenLogin = UserDefaults.standard.bool(forKey: userDefaultsKey)
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("テストアプリ")
                .font(Font.system(size: 34.0))
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 16.0)
                .padding(.vertical, 12.0)
                .frame(width: 360.0, height: 320.0, alignment: .topLeading)
            CheckBox(isChecked: $isCheckedLaunchWhenLogin) { isChecked in
                if SMLoginItemSetEnabled("jp.scorebook.EisuKeyLauncher" as CFString, isChecked) {
                    UserDefaults.standard.setValue(isChecked, forKey: Self.userDefaultsKey)
                        } else {
                            isCheckedLaunchWhenLogin = UserDefaults.standard.bool(forKey: Self.userDefaultsKey)
                        }
            }
            Button(action: {
                NSApplication.shared.terminate(self)
            })
            {
                Text("Quit App")
                .font(.caption)
                .fontWeight(.semibold)
            }
            .padding(.trailing, 16.0)
            .frame(width: 360.0, alignment: .trailing)
        }
        .padding(0)
        .frame(width: 360.0, height: 360.0, alignment: .top)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
