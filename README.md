# fbdbmobdemo

A demo application, showing how to implement and deploy an Android application, which uses the [fbdb](https://github.com/hipercompl/fbdb) database access library.

## Description

This is a farly simple application, making use of the *employee* database, which should be available in every standard installation of the [Firebird](https://firebirdsql.org) server.

The application allows the user to enter database location and user credentials.

It then attempts to attach to the *employee* database (or any other specified database with a compatible structure) and retrieves the list of employees, together with their salaries.

![fbdbmobdemo screenshots](fbdbmobdemo_scr.png)

## Building and running
First, clone the repository:
```bash
git clone https://github.com/hipercompl/fbdbmobdemo
cd fbdbmobdemo
```
Next, install all dependencies:
```bash
flutter pub get
```

To run the application in an Android emulator or on a real Android device, look up the device ID:
```bash
adb devices
```
and start the application with:
```bash
flutter run -d <your device ID>
```

## Deployment
The application already includes the native client libraries from the Firebird 5.0 Android build (actually, from the 5.0.1 snapshot build due to [this Firebird issue](https://github.com/FirebirdSQL/firebird/issues/8110)), so there's no need to install / copy them separately.

The libraries are placed in the `android/app/src/main/jniLibs` subdirectory of the project directory. There are shared libraries there for all supported architectures:
- arm64-v8a
- armeabi-v7a
- x86
- x86_64

To upgrade the libraries to a different version, download the official Android build of the Firebird server, extract the appropriate dynamic libraries from the downloaded archive, and place them in the directories mentioned above (making sure the directory names and the actual architectures of the dynamic libraries match).

### Android permissions
If you plan to deploy this demo application on a physical Android device in **release** mode, you need to remember to add the following permission declaration to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

Otherwise the application won't be able to connect to a Firebird server via the network and you'll get "unable to complete network request to..." error.
The `AndroidManifest.xml` file in this repo already contains this addition, but should you restart the Flutter Android project from scratch, please remember to modify the manifest.

> Issue initially reported by [arturmois](https://github.com/arturmois) (thanks Artur!).

## More information
For more information about the *fbdb* project, please visit the [official fbdb repository](https://github.com/hipercompl/fbdb).

## License
The application is licensed under a BSD-3 license (see the [LICENSE](https://github.com/hipercompl/fbdb/blob/main/LICENSE) file).

## Changelog
- 1.0.2: upgraded Firebird client libraries for Android to official stable version 5.0.1 (the previous version used developmen snapshot versions of the libraries). Added INTERNET permission request to AndroidManifest.xml, otherwise the app can't connecti via network when built in release mode and deployed to an actual device.
- 1.0.1: upgraded Firebird client libraries for Android to version 5.0.1 (snapshot), due to Firebird 5.0 [issue 8110](https://github.com/FirebirdSQL/firebird/issues/8110). The shared libraries from the snapshot work fine on Android 14 (tested with a physical device).
- 1.0.0: the first public release.