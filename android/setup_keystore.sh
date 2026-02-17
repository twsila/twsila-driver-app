#!/bin/bash

# Script to set up Android keystore for Play Store signing
# This will create the keystore and key.properties file

echo "=========================================="
echo "Setting up Android Keystore for Play Store"
echo "=========================================="
echo ""
echo "This script will create a keystore file and key.properties configuration."
echo "You'll need to provide passwords and certificate information."
echo ""

# Check if keystore already exists
if [ -f "app/upload-keystore.jks" ]; then
    echo "⚠️  WARNING: upload-keystore.jks already exists!"
    read -p "Do you want to overwrite it? (y/N): " overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo "Cancelled. Using existing keystore."
        if [ -f "key.properties" ]; then
            echo "✅ key.properties already exists. Setup complete!"
            exit 0
        else
            echo "⚠️  key.properties not found. You need to create it manually."
            exit 1
        fi
    fi
fi

echo "Please provide the following information:"
echo ""

# Get keystore password
read -p "Enter keystore password (min 6 characters): " -s storePassword
echo ""
if [ ${#storePassword} -lt 6 ]; then
    echo "❌ Error: Password must be at least 6 characters"
    exit 1
fi

# Get key password
read -p "Enter key password (can be same as keystore, min 6 characters): " -s keyPassword
echo ""
if [ ${#keyPassword} -lt 6 ]; then
    echo "❌ Error: Password must be at least 6 characters"
    exit 1
fi

# Get key alias
read -p "Enter key alias (default: upload): " keyAlias
if [ -z "$keyAlias" ]; then
    keyAlias="upload"
fi

# Get certificate information
echo ""
echo "Now provide certificate information:"
read -p "Your first and last name: " name
read -p "Organizational unit (e.g., Development): " orgUnit
read -p "Organization (e.g., Your Company Name): " org
read -p "City: " city
read -p "State/Province: " state
read -p "Country code (2 letters, e.g., US, SA): " country

# Validate country code
if [ ${#country} -ne 2 ]; then
    echo "❌ Error: Country code must be exactly 2 letters"
    exit 1
fi

echo ""
echo "Creating keystore..."

# Create the keystore
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
    echo "Creating key.properties file..."
    
    # Create key.properties file
    cat > key.properties << EOF
storePassword=$storePassword
keyPassword=$keyPassword
keyAlias=$keyAlias
storeFile=../app/upload-keystore.jks
EOF
    
    # Set proper permissions
    chmod 600 key.properties
    
    echo "✅ key.properties created!"
    echo ""
    echo "=========================================="
    echo "✅ Setup Complete!"
    echo "=========================================="
    echo ""
    echo "⚠️  IMPORTANT SECURITY NOTES:"
    echo "   1. Keep your keystore file (upload-keystore.jks) safe!"
    echo "   2. Store it in a secure location with backups"
    echo "   3. If you lose it, you CANNOT update your app on Play Store"
    echo "   4. Never commit keystore files to version control"
    echo ""
    echo "📦 Next step: Rebuild your app bundle"
    echo "   Run: flutter build appbundle --flavor production -t lib/main_production.dart --release"
    echo ""
else
    echo ""
    echo "❌ Failed to create keystore. Please check the error above."
    exit 1
fi

