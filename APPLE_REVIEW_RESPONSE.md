# Apple App Store Review Response

## Guideline 2.1 - Information Needed: Personal Information Requirements

### Required Personal Information

1. **Phone Number (Mobile Number)**
   - **Why Required**: Phone number is essential for account creation and authentication. It serves as the primary identifier for driver accounts and is used for:
     - User registration and login via OTP (One-Time Password) verification
     - Account security and two-factor authentication
     - Communication between drivers and passengers through the platform
     - Account recovery in case of lost credentials

2. **Full Name (First Name and Last Name)**
   - **Why Required**: Full name is required for:
     - Driver profile identification and verification
     - Display to passengers when they view driver information
     - Legal compliance and identity verification for transportation services
     - Business owner registration and account management

3. **Email Address**
   - **Why Required**: Email is used for:
     - Account recovery and password reset functionality
     - Important notifications and communications
     - Business correspondence for business owner accounts
     - Receipt and transaction notifications

4. **Profile Picture**
   - **Why Required**: Profile picture is necessary for:
     - Driver identification by passengers
     - Building trust and safety in the transportation platform
     - Verification purposes during account setup

5. **National ID/Identity Document**
   - **Why Required**: Identity documents are mandatory for:
     - Driver verification and background checks
     - Compliance with transportation regulations
     - Legal requirements for operating as a driver or business owner
     - Account security and fraud prevention

6. **Vehicle Information (for drivers)**
   - **Why Required**: Vehicle details including:
     - Vehicle registration and license plate
     - Vehicle photos for verification
     - Vehicle type and specifications
   - **Purpose**: Required for driver registration, vehicle verification, and matching drivers with appropriate trip requests

7. **Location Data**
   - **Why Required**: Location access is essential for:
     - Finding nearby transportation requests
     - Navigation to pickup and drop-off locations
     - Real-time tracking during active trips
     - Displaying driver location to passengers

### Optional Personal Information

1. **Additional Contact Information**
   - **Why Optional**: Additional contact methods beyond phone and email are optional and may be provided for enhanced communication preferences.

2. **Profile Additional Details**
   - **Why Optional**: Additional profile information beyond required fields is optional and allows drivers to provide more details about themselves.

---

## Guideline 5.1.1(v) - Account Deletion

### Account Deletion Feature Location

The account deletion feature is available in the **Profile Screen** of the app. 

**How to Access:**
1. Open the Twsila Driver app
2. Navigate to the "My Profile" tab (bottom navigation)
3. Scroll down to the bottom of the profile menu
4. You will find "Delete Account" option located directly below the "Logout" option
5. Tap on "Delete Account"
6. A confirmation dialog will appear asking "Are you sure you want to delete your account?"
7. Tap "Confirm Delete" to proceed with account deletion

**Account Deletion Process:**
- The app displays a confirmation dialog to prevent accidental deletion
- Upon confirmation, the account deletion process is initiated
- The account and associated data are permanently deleted from our systems
- The user is logged out and redirected to the registration/login screen

**Note**: The account deletion feature is fully functional within the app and does not require visiting a website or contacting customer service. The deletion is permanent and cannot be undone.

---

## Guideline 5.1.5 - Location Services

### App Functionality Without Location Services

The app is **fully functional** even when Location Services are disabled. All tabs and features work without requiring location access:

1. **Search Trips Tab**: 
   - Fully accessible without location
   - Users can browse and search all available trips
   - Location is only used for "nearby trips" filtering (optional feature)
   - Manual search and filtering work without location

2. **My Trips Tab (Previous Trips)**:
   - Fully accessible without location
   - Users can view all their trip history
   - All trip details and information are available

3. **My Profile Tab**:
   - Fully accessible without location
   - Users can view and edit profile information
   - Account settings and preferences can be managed
   - Payment and wallet features work
   - Account deletion feature works

**Location-Dependent Features** (require location when used, but don't block app):
- **Map Selection**: When users need to select a location on a map, location is requested. If denied, the map still works with a default center and users can manually select locations.
- **Navigation/Trip Tracking**: During active trips, location is needed for real-time navigation and tracking. If location is unavailable, the feature shows an error message but doesn't crash the app.
- **"Nearby trips" filter**: Location is used to show trips closest to the user. If location is denied, users can still browse all trips manually.

**How the App Handles Location Denial:**
- The app does NOT block access to any tabs or features when location is denied
- All three main tabs (Search Trips, My Trips, My Profile) are fully accessible without location
- Location requests are made only when needed for specific features (maps, navigation, nearby trips)
- If location is denied for a specific feature:
  - Map features: Show default location, allow manual selection
  - Navigation: Show error message, but app continues to function
  - Nearby trips: Fall back to showing all trips
- The app never forces users to enable location to use basic features
- Users can browse trips, view history, manage profile, and delete account all without location

---

## Guideline 5.1.1(ix) - Organization Account Requirement

### Response

We acknowledge that the app must be submitted through an Apple Developer Program account enrolled as an organization. We are in the process of:

1. Converting our individual Apple Developer account to an organization account, OR
2. Creating a new organization account for app submission

We will resubmit the app once the organization account is properly set up. We understand this is a requirement for apps operating in highly regulated fields or handling sensitive user information.

---

## Summary

All requested information has been addressed:
- ✅ Purpose strings updated with detailed explanations and examples
- ✅ Account deletion feature implemented and accessible in Profile Screen
- ✅ App is fully functional without location services - all tabs work
- ✅ Location denial does not block app access or functionality
- ✅ Personal information requirements and purposes clearly explained
- ⚠️ Organization account conversion in progress (Guideline 5.1.1(ix))


