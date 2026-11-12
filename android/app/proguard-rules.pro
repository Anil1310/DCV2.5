# ProGuard rules for Divine Classes Android WebView App

# Preserve JavascriptInterface annotations and methods for WebView bridges
-keepattributes JavascriptInterface
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Preserve Android WebChromeClient and WebViewClient subclasses
-keepclassmembers class * extends android.webkit.WebChromeClient {
    public *;
}
-keepclassmembers class * extends android.webkit.WebViewClient {
    public *;
}

