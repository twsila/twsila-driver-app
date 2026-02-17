# Building App Bundle for Google Play Store

## Prerequisites

Before building for Play Store, you need to set up app signing with a keystore.

## Step 1: Create Keystore (Required for Play Store)

You have two options:

### Option A: Use the provided script (Recommended)

```bash
cd android
./create_keystore.sh
```

This script will:
- Create a keystore file (`upload-keystore.jks`)
- Create `key.properties` with your signing configuration
- Guide you through the process

### Option B: Manual creation

1. Navigate to the `android` directory:
   ```bash
   cd android
   ```

2. Create the keystore:
   ```bash
   keytool -genkey -v -keystore app/upload-keystore.jks \
       -keyalg RSA -keysize 2048 -validity 10000 \
       -alias upload
   ```

3. Create `key.properties` file in the `android` directory:
   ```properties
   storePassword=YOUR_KEYSTORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=../app/upload-keystore.jks
   ```

**⚠️ IMPORTANT:**
- Keep your keystore file and passwords safe!
- Store `upload-keystore.jks` in a secure location
- Keep a backup of the keystore
- If you lose it, you won't be able to update your app on Play Store
- **DO NOT** commit `key.properties` or `*.jks` files to version control

## Step 2: Build App Bundle

Once keystore is set up, build the app bundle:

### For Production:
```bash
flutter build appbundle --flavor production -t lib/main_production.dart --release
```

### For Staging (testing):
```bash
flutter build appbundle --flavor staging -t lib/main_staging.dart --release
```

### For Development:
```bash
flutter build appbundle --flavor development -t lib/main_development.dart --release
```

## Step 3: Find Your App Bundle

The app bundle will be located at:
```
build/app/outputs/bundle/productionRelease/app-release.aab
```
(or `stagingRelease`/`developmentRelease` depending on flavor)

## Step 4: Upload to Play Store

1. Go to [Google Play Console](https://play.google.com/console)
2. Select your app
3. Go to "Production" (or "Testing" for staging)
4. Click "Create new release"
5. Upload the `.aab` file
6. Fill in release notes and submit

## Troubleshooting

### If you get signing errors:
- Make sure `key.properties` exists in the `android` directory
- Verify the keystore file path in `key.properties` is correct
- Check that passwords are correct

### If you want to build without signing (for testing only):
The build will use debug signing, but **this won't work for Play Store uploads**. You must set up proper signing.

## Current App Version

- Version Name: 1.0.3 (from pubspec.yaml)
- Application ID: com.twsila.driver.app
- Flavors: development, staging, production

