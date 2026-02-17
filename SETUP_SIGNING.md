# 🔐 Setting Up Release Signing for Play Store

## Problem
Your app bundle is currently signed with **debug keys**, which Google Play Store rejects. You need to sign it with **release keys**.

## Solution: Create a Keystore

### Step 1: Run the Setup Script

```bash
cd android
./setup_keystore.sh
```

The script will ask you for:
- **Keystore password** (min 6 characters) - Remember this!
- **Key password** (can be same as keystore) - Remember this!
- **Key alias** (default: "upload")
- **Certificate information** (name, organization, city, state, country)

### Step 2: Rebuild the App Bundle

After the keystore is created, rebuild your app bundle:

```bash
flutter build appbundle --flavor production -t lib/main_production.dart --release
```

The new bundle will be signed with release keys and ready for Play Store!

## Alternative: Manual Setup

If you prefer to set it up manually:

### 1. Create Keystore

```bash
cd android
keytool -genkey -v -keystore app/upload-keystore.jks \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias upload
```

You'll be prompted for:
- Password (remember this!)
- Certificate information

### 2. Create key.properties

Create `android/key.properties` with:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=upload
storeFile=../app/upload-keystore.jks
```

Replace `YOUR_KEYSTORE_PASSWORD` and `YOUR_KEY_PASSWORD` with your actual passwords.

### 3. Rebuild

```bash
flutter build appbundle --flavor production -t lib/main_production.dart --release
```

## 🔒 Security Reminders

**CRITICAL:**
- ✅ Keep `upload-keystore.jks` in a secure location
- ✅ Make multiple backups
- ✅ Store passwords securely
- ❌ **Never** commit keystore files to Git
- ❌ **Never** share keystore files publicly
- ⚠️ If you lose the keystore, you **cannot** update your app on Play Store

## 📍 File Locations

After setup:
- Keystore: `android/app/upload-keystore.jks`
- Config: `android/key.properties`
- App Bundle: `build/app/outputs/bundle/productionRelease/app-production-release.aab`

## ✅ Verification

After rebuilding, you can verify the signing:

```bash
jarsigner -verify -verbose -certs build/app/outputs/bundle/productionRelease/app-production-release.aab
```

You should see "jar verified" if properly signed.

## 🚀 Next Steps

1. ✅ Run `./setup_keystore.sh` in the `android` directory
2. ✅ Rebuild the app bundle
3. ✅ Upload the new bundle to Play Store

---

**Need help?** The setup script will guide you through the process step by step.

