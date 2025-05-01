# Online_Classroom_App

A **Flutter**-based virtual classroom application that enables teachers to create and manage classes while students can join, view announcements, and leave classes easily.

## 🚀 Features

### 👨‍🏫 For Teachers:
- Create and manage virtual classrooms.
- Post announcements and classwork.
- View list of enrolled students.

### 👩‍🎓 For Students:
- Join multiple classes.
- View announcements, classwork, and classmates.
- Leave a class with immediate effect.

### 🔐 Authentication:
- Firebase Authentication (email/password).

### ☁️ Cloud Backend:
- Firebase Firestore for storing:
  - Class data (`Classes` collection)
  - Student data (`Students` collection)
  - Announcements (`Announcements` collection)

## 🛠️ Tech Stack

| Layer             | Technology         |
|------------------|--------------------|
| Frontend          | Flutter (Dart)     |
| Backend           | Firebase Firestore |
| Authentication    | Firebase Auth      |
| State Management  | Provider           |

## 🧠 App Flow

1. **User Authenticates** via Firebase.
2. **Student lands on their "Classes" page**, showing only the classes they’ve joined.
3. **Tapping a class** opens its detail page with tabs: Stream, Classwork, and People.
4. **Three-dots menu** allows a student to leave the class.
5. After leaving, the student is navigated back, and the **Classes list updates automatically**.

