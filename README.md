# RickAndMortySwiftUI - MultiverseKIS
A production-style SwiftUI feature built using the Rick and Morty public REST API.

This project implements a complete character browsing experience including listing, searching, filtering, pagination, and a detailed character screen.  
It follows clean architecture principles, emphasizes testability, and demonstrates real-world engineering practices suitable for a take-home assignment.

---

## 📦 Images & Assets

| Preview | File Name | Purpose |
|--------|-----------|---------|
| <img width="105" height="108" alt="appicon" src="https://github.com/user-attachments/assets/80525ca9-d5af-41bd-b87d-08bb4c1cc06d" /> | `appicon.png` | Main iOS application icon |
| <img width="20%" alt="launchscreen" src="https://github.com/user-attachments/assets/50c9b1f0-ad20-45b7-b867-dd36ef9aea16" /> | `launchscreen.png` | App launch screen / splash |
| <img width="20%" alt="preloader" src="https://github.com/user-attachments/assets/f02f31bd-c3f4-4894-a0c8-765b6eee7deb" /> | `loader.png` | App data loader screen |
| <img width="20%" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-01-05 at 21 38 18" src="https://github.com/user-attachments/assets/fc16f111-0d0c-4470-8a72-3b1c94d882f2" /> | `character_list.png` | UI screenshot: Characters list |
| <img width="20%" alt="Simulator Screenshot - iPhone 17 Pro Max - 2026-01-05 at 21 38 27" src="https://github.com/user-attachments/assets/b68b9fb4-4ac3-452f-83af-0e4e152f8a00" /> | `character_detail.png` | UI screenshot: Character detail view |
| <img width="20%" alt="Spanish" src="https://github.com/user-attachments/assets/993434cb-10c9-46f4-a8c1-1b2a0815fd6e" /> | `localization.png` | Example of the app running in English/Spanish |

---

## 🌟 Overview

The application provides:

- Paginated character listing using the Rick and Morty REST API  
- Search by character name with debounce  
- Filtering by status (Alive, Dead, Unknown, All)  
- Infinite scrolling (automatic pagination)  
- Detail screen fetched via character ID  
- Full UI state handling: loading, error, empty, loaded  
- Multilanguage support (English and Spanish)  
- Custom application icon  
- High test coverage (~94%) with Unit Tests and UI Tests  
- Clean MVVM architecture without third-party libraries  

---

## 🚀 How to Run the Project

```bash
git clone https://github.com/henryb-dev/RickAndMortySwiftUI.git
```

1. Open **RickAndMorty.xcodeproj** in **Xcode 17+**.  
2. Run the project on a simulator or physical device running **iOS 17+**.  
3. No configuration or API keys required.

---

## 🏗️ Architecture

This project uses an **MVVM** structure with clear boundaries:

```
Presentation (SwiftUI Views)
   → ViewModels (state + orchestration logic)
        → Data Layer (API client + decodable models)
```

### **🔹 Presentation Layer**
SwiftUI-only UI:

- `CharacterListView`
- `CharacterDetailView`
- `CharacterRowView`

Views observe state and contain no business logic.

### **🔹 ViewModels**
- `CharacterListViewModel`
- `CharacterDetailViewModel`

Responsibilities:

- State transitions  
- Handling pagination  
- Search debounce logic  
- Filter logic  
- Error handling  
- Updating content for views  
- Constructor-injected dependencies  
- `@MainActor` to ensure UI safety  

### **🔹 Data Layer**
- `APIClient` (conforming to `APIClientProtocol`)
- Models: `Character`, `CharacterResponse`, `Origin`, `Location`, `Info`

Responsibilities:

- Networking  
- JSON decoding  
- Error handling  
- Fully mockable  
- No global singletons  

---

## 💉 Dependency Injection

Each ViewModel receives its dependencies explicitly:

```swift
@StateObject var vm = CharacterListViewModel(api: APIClient())
```

**Benefits:**

- Highly testable (mock-friendly)  
- Decoupled and clean  
- Aligns with SOLID (Dependency Inversion)  
- No hidden global state  

---

## 🔍 Search & Debounce

The search bar uses Combine:

- 180 ms debounce  
- Remove duplicates  
- Reset pagination on each text change  
- Prevents excessive API calls  

This produces a smooth and efficient search experience.

---

## 🌐 API Endpoints Used

Base URL:  
https://rickandmortyapi.com/api

Endpoints:

- `GET /character?page=1`
- `GET /character/?name={query}`
- `GET /character/?status={status}`
- `GET /character/{id}`

No authentication required.

---

## 📱 Character List Screen

Each row displays:

- Character image  
- Name  
- Species  
- Status  

**Features:**

- Automatic infinite scroll  
- Search with debounce  
- Status filter (All / Alive / Dead / Unknown)  
- Loading state  
- Error with retry  
- Empty state  

---

## 📄 Character Detail Screen

Fetched via:

```swift
viewModel.load(id: id)
```

Displays:

- Animated character image  
- Name (custom themed styling)  
- Status • Species • Gender  
- Origin  
- Current location  
- Episode count  

---

## 🌍 Multilanguage (English / Spanish)

Uses:

- `Localizable.strings (English)`
- `Localizable.strings (Spanish)`

All UI text uses localization keys.  
The app automatically switches based on the device language.

---

## 🧪 Testing

The project includes extensive Unit and UI Tests, achieving **~94% code coverage**.

### **✔️ Unit Tests cover:**

- Debounce timing  
- Filter logic  
- Pagination reset  
- ViewModel state transitions  
- Mocked API scenarios:
  - success  
  - network failure  
  - invalid JSON  
  - 404 error  

All unit tests are deterministic and **do not call the real API**.

### **✔️ UI Tests cover:**

- Navigation to detail screen  
- Search field interactions  
- Status filter interactions  
- Loading / empty / error states  

---

## 🔒 Observability & Security

- No sensitive data stored  
- No external dependencies  
- No singletons  
- Controlled error propagation  
- Fully isolated networking layer  

---

## 📦 Project Structure

```
RickAndMorty
├── RickAndMorty
│   ├── Core
│   │   └── Models
│   │       ├── Character
│   │       ├── CharacterResponse
│   │       ├── Info
│   │       └── SimpleLocation
│   ├── Networking
│   │   ├── APIClient
│   │   └── APIError
│   ├── Feature
│   │   ├── CharacterDetail
│   │   │   ├── CharacterDetailView
│   │   │   └── CharacterDetailViewModel
│   │   └── CharacterList
│   │       ├── CharacterListView
│   │       ├── CharacterListViewModel
│   │       ├── CharacterRowView
│   │       └── StatusFilter
│   ├── Root
│   │   └── RootView
│   ├── Assets
│   ├── Info
│   ├── Localizable
│   │   ├── Localizable (English)
│   │   └── Localizable (...Latin America)
│   ├── RickAndMortyApp
│   └── Schwifty
├── RickAndMortyTests
│   ├── APIClientTests
│   ├── CharacterDetailViewModelTests
│   ├── CharacterListViewModelTests
│   └── MockAPI
└── RickAndMortyUITests
    ├── RickAndMortyUITests
    └── RickAndMortyUITestsLaunchTests
```

---

## 🧭 Technical Decisions & Trade-offs

### **Why MVVM?**
- Natural fit for SwiftUI  
- Easy to test  
- Clear separation of concerns  

### **Why Combine debounce?**
- Prevents API spamming  
- Matches real-world search UX patterns  

### **Why constructor injection?**
- Improves testability  
- Avoids hidden shared state  
- Supports clean architecture principles  

### **Why fetch detail by ID?**
- Ensures data accuracy  
- Demonstrates boundary separation  

---

## 🔧 Future Improvements (with more time)

- Image caching  
- Offline persistence  
- Modularization via Swift Packages  
- Advanced animations and transitions  
- Full accessibility (VoiceOver, Dynamic Type)  
- Deep links & Quick Actions   

---

## 👤 Author

**Henry Bautista – Sr iOS Engineer**  
Developed as part of a technical take-home assignment.
