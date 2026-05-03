# VoteBuddy Hybrid – Technical Documentation

## 1. System Architecture
VoteBuddy Hybrid is a standalone Flutter application structured to handle state smoothly using the `Provider` architecture. The current MVP implementation heavily utilizes mocked verification algorithms, but is structured in a way that allows easy drops-ins for real API responses in the future.

### Application Flow
1. **Entry Point** (`main.dart`): Configures application theme, provides the `VotingProvider` globally, and routes to `AuthGate`.
2. **AuthGate**: Checks `SharedPreferences` to see if a vote has already been cast.
   - If yes: Renders the `ConfirmationScreen`.
   - If no: Renders the `LoginScreen`.
3. **Login (`LoginScreen`)**: Takes the user's EPIC/Voter ID.
4. **Eligibility Check (`EligibilityScreen`)**: Checks if the fetched Voter object meets the minimum age requirement ($\ge$ 18).
5. **Location Routing (`ModeSelectionScreen`)**: Compares current mocked location to the voter's home constituency.
   - Match $\rightarrow$ Routes to `LocalVotingScreen`
   - Mismatch $\rightarrow$ Routes to `RemoteVotingScreen`
6. **Verification (`VerificationScreen`)**: Steps through simulated verification phases.
7. **Voting (`VotingInterfaceScreen`)**: A symbol-based UI allows the user to cast their vote.
8. **Confirmation (`ConfirmationScreen`)**: Stores a vote token securely on the device to prevent duplicate casting and displays the success state.

## 2. Directory Structure
```
lib/
├── main.dart             # Application entry point and Provider setup
├── theme.dart            # Centralized Black & White styling
├── voting_provider.dart  # Business logic, state management, and mock API
└── screens.dart          # All UI screens for the user journey
```

## 3. State Management (Provider)
The `VotingProvider` extends `ChangeNotifier` to offer reactive state management across all widgets.

**Key State Variables:**
- `VoterData? _voterData`: Holds the currently loaded user profile.
- `String? _currentLocation`: Holds the fetched geolocation data.
- `bool _hasVoted`: Prevents repeat voting.
- `String? _confirmationId`: The cryptographic/receipt token of the vote.

**Core Methods:**
- `fetchVoterData(String epicId)`: Simulates a network call to retrieve user data.
- `fetchLocation()`: Simulates GPS coordinate fetching.
- `submitVote()`: Writes to memory and local storage that the vote is completed.
- `resetApp()`: Utility function to clear storage (useful for demo purposes).

## 4. Local Persistence
The app employs the `shared_preferences` package.
- `hasVoted (bool)`: Ensures that if the app is killed and restarted, the user cannot vote twice.
- `confirmationId (String)`: Persists the generated confirmation receipt so it can be displayed.

## 5. UI / UX Design System
All UI components reside in `theme.dart`. The project actively avoids colorful clutter, relying strictly on Black (`Colors.black`) and White (`Colors.white`).
- Thick borders (`width: 2`) are used to delineate buttons and active zones.
- Icons are drawn largely (`size: 80` to `100`) to guarantee high legibility for low-literacy users.

## 6. Testing Scenarios (Mock Data)
You can test various edge cases by entering different IDs on the Login Screen:
- **`LOCAL123`**: Simulates a user currently located in their home constituency (Routes to Local Voting).
- **`REMOTE123`**: Simulates a user currently located outside their home constituency (Routes to Remote AVN Voting).
- **`UNDERAGE`**: Simulates a user whose age is under 18 (Stops at Eligibility Screen).
- **Anything Else**: Defaults to a valid local user for demonstration.
