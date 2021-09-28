import Foundation

public class FrameworkPrinter: NSObject {
    public class func printMain(_ word: String) {
		DispatchQueue.main.async {
			print(word)
		}
    }
}
