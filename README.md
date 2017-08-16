# XYCrashManager
swift crash manager
是一个可在swift上捕获crash的demo，已经集成捕获，存储，读取，删除crash信息等功能
如果不想关心具体实现，可将CrashManager直接拖到你的工程中，然后在AppDelegate中的如下方法中添加代码即可使用

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //crash捕获
        crashHandle { (crashInfoArr) in
            
            for info in crashInfoArr{
                //这里添加对每一条crash信息的操作
            }
        }
        
        return true
    }
