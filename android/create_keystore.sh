#!/bin/bash

# Script to create a keystore for Android app signing
# Run this script from the android directory

echo "=========================================="
echo "Creating Android Keystore for Play Store"
echo "=========================================="
echo ""

# Check if keystore already exists
if [ -f "app/upload-keystore.jks" ]; then
    echo "⚠️  WARNING: upload-keystore.jks already exists!"
    read -p "Do you want to overwrite it? (y/N): " overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo "Cancelled. Using existing keystore."
        exit 0
    fi
fi

echo "Please provide the following information:"
echo ""

read -p "Keystore password: " -s storePassword
echo ""
read -p "Key password (can be same as keystore): " -s keyPassword
echo ""
read -p "Key alias (e.g., upload): " keyAlias
read -p "Your name (for certificate): " name
read -p "Organization unit (e.g., Development): " orgUnit
read -p "Organization (e.g., Your Company): " org
read -p "City: " city
read -p "State/Province: " state
read -p "Country code (2 letters, e.g., US): " country

echo ""
echo "Creating keystore..."

keytool -genkey -v -keystore app/upload-keystore.jks \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias "$keyAlias" \
    -storepass "$storePassword" \
    -keypass "$keyPassword" \
    -dname "CN=$name, OU=$orgUnit, O=$org, L=$city, ST=$state, C=$country"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Keystore created successfully!"
    echo ""
    echo "Now creating key.properties file..."
    
    # Create key.properties file
    cat > key.properties << EOF
storePassword=$storePassword
keyPassword=$keyPassword
keyAlias=$keyAlias
storeFile=../app/upload-keystore.jks
EOF
    
    echo "✅ key.properties created!"
    echo ""
    echo "⚠️  IMPORTANT: Keep your keystore file and passwords safe!"
    echo "   - Store upload-keystore.jks in a secure location"
    echo "   - Keep a backup of the keystore"
    echo "   - If you lose it, you won't be able to update your app on Play Store"
    echo ""
    echo "✅ Setup complete! You can now build your app bundle."
else
    echo ""
    echo "❌ Failed to create keystore. Please check the error above."
    exit 1
fi

