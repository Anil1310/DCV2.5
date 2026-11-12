# Divine Classes Android app

This Android Studio project opens the deployed Divine Classes web app (`https://script.google.com/macros/s/AKfycbzlbJUklVvhuJzIDoWv3a3CXY4trX435BiGD1JGIOeuYJC7PiR5lqI15Ymz0kFEpf0P/exec`), uses the institute logo for the launcher icon and branded loading screen, and launches Android's native speech-recognition interface from the chatbot microphone button. It requests Android camera permission when the student-photo picker is opened, then offers camera capture and photo selection. It also shows a branded offline screen for both lost internet and page-load errors, without exposing the Apps Script URL, then reconnects automatically. Recognized words are inserted into the message box and are not sent automatically.

The mobile interface features a 4-button responsive header action group (Cloud Sync, Theme Toggle, Notification Bell, User Profile/Login) with equal 6px spacing and optimized 32×32dp touch targets.

## Build an APK

### Debug APK
1. Install Android Studio on a computer with Android SDK Platform 35 and a Java 17+ runtime.
2. Open this `android` folder as a project and allow Gradle sync to finish.
3. Connect an Android phone with USB debugging enabled, or start an emulator.
4. Choose **Build → Build Bundle(s) / APK(s) → Build APK(s)**, or run `./gradlew assembleDebug` from this folder.
5. Install `app/build/outputs/apk/debug/app-debug.apk`.

### Signed Release APK
To build a production-signed release APK for distribution or device installation:
1. Ensure `local.properties` specifies the keystore parameters (configured by default with `divine-release.jks`):
   ```properties
   RELEASE_STORE_FILE=divine-release.jks
   RELEASE_STORE_PASSWORD=DivineClasses@2026
   RELEASE_KEY_ALIAS=divineclasses
   RELEASE_KEY_PASSWORD=DivineClasses@2026
   ```
2. Run `./gradlew clean assembleRelease` from the `android` folder.
3. The signed APK is produced at `app/build/outputs/apk/release/app-release.apk`.
4. To verify the signature:
   ```bash
   apksigner verify --verbose app/build/outputs/apk/release/app-release.apk
   ```

## Cloud App Updates
Because the Android app is cloud-powered via WebView, updates pushed and deployed to the production Apps Script URL (`AKfycbzlbJUklVvhuJzIDoWv3a3CXY4trX435BiGD1JGIOeuYJC7PiR5lqI15Ymz0kFEpf0P`) reflect immediately inside the Android application without requiring users to reinstall the APK. When testing freshly deployed versions, swipe away the app from the Android recent apps list to clear the WebView cache and reopen.

The first time voice typing or student-photo capture is used, Android asks the user to allow the relevant microphone or camera permission. A compatible speech-recognition service must also be available on the device. The speech transcript is returned to the chatbot composer and remains under the user's control until they tap Send.

The application ID is `com.divineclasses.portal`. Change it before publishing if you need a different Play Store identity. A signed release APK or Play Store bundle requires an app-signing key managed by the app owner; do not share that key.
