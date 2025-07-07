import Flutter
import UIKit

class TimeView: NSObject, FlutterPlatformView {
    private var label: UILabel
    private var methodChannel: FlutterMethodChannel?
    
    init(frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, messenger: FlutterBinaryMessenger) {
        label = UILabel(frame: frame)
        label.textAlignment = .center
        label.text = "iOS原生时间视图"
        
        super.init()
        
        // 解析Flutter传递的参数
        if let params = args as? [String: Any], 
           let textSize = params["textSize"] as? Double {
            label.font = UIFont.systemFont(ofSize: CGFloat(textSize))
        } else {
            label.font = UIFont.systemFont(ofSize: 20)
        }
        
        label.textColor = .blue
        
        // 创建方法通道
        methodChannel = FlutterMethodChannel(
            name: "com.example/time_channel", 
            binaryMessenger: messenger
        )
        
        methodChannel?.setMethodCallHandler(handleMethodCall)
    }
    
    func view() -> UIView {
        return label
    }
    
    func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getCurrentTime":
            // 返回当前时间给Flutter
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm:ss"
            result(formatter.string(from: Date()))
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}