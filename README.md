<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Smart Attendance Manager</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f5f7fa;
      color: #222;
      line-height: 1.6;
      margin: 40px;
    }
    h1, h2, h3 {
      color: #1976d2;
    }
    code, pre {
      background-color: #eee;
      border-radius: 6px;
      padding: 10px;
      display: block;
      overflow-x: auto;
    }
    ul {
      list-style: none;
      padding: 0;
    }
    li::before {
      content: "⚡ ";
    }
    .badge {
      display: inline-block;
      background-color: #1976d2;
      color: white;
      border-radius: 4px;
      padding: 3px 8px;
      margin-right: 5px;
      font-size: 0.85rem;
    }
    .screenshot {
      width: 250px;
      border-radius: 8px;
      margin: 10px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }
    .author {
      margin-top: 30px;
      background-color: #e3f2fd;
      padding: 15px;
      border-radius: 8px;
    }
    a {
      color: #1976d2;
      text-decoration: none;
    }
    a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

  <h1>📲 Smart Attendance Manager App</h1>
  <p>
    A <strong>Flutter-based Smart Attendance Management System</strong> designed for colleges and institutes to automate attendance using 
    <strong>QR code scanning</strong>, <strong>Firebase integration</strong>, and <strong>role-based dashboards</strong> for teachers and students.
  </p>

  <hr>

  <h2>🚀 Features</h2>
  <ul>
    <li><strong>Firebase Authentication</strong> – Secure login and signup for Teachers & Students</li>
    <li><strong>Role-based Dashboards</strong> – Separate interfaces for Teachers and Students</li>
    <li><strong>QR Code Attendance</strong> – Automated attendance marking using <code>mobile_scanner</code> and <code>qr_flutter</code></li>
    <li><strong>Real-time Analytics</strong> – Attendance percentage, class summaries, and reports</li>
    <li><strong>Cloud Firestore Integration</strong> – Real-time database for classes and attendance</li>
    <li><strong>Responsive UI</strong> – Adaptive design for all screen sizes</li>
    <li><strong>Clean Architecture</strong> – Modular, maintainable code with <code>Provider</code> / <code>Riverpod</code></li>
  </ul>

  <hr>

  <h2>🛠️ Tech Stack</h2>
  <p>
    <span class="badge">Flutter</span>
    <span class="badge">Dart</span>
    <span class="badge">Firebase Auth</span>
    <span class="badge">Cloud Firestore</span>
    <span class="badge">QR Flutter</span>
    <span class="badge">Mobile Scanner</span>
    <span class="badge">Provider</span>
    <span class="badge">Material Design</span>
  </p>

  <hr>

  <h2>📸 Screenshots</h2>
  <img src="screenshots/login.png" alt="Login Screen" class="screenshot">
  <img src="screenshots/teacher_dashboard.png" alt="Teacher Dashboard" class="screenshot">
  <img src="screenshots/qr_scan.png" alt="QR Scan" class="screenshot">
  <img src="screenshots/attendance_report.png" alt="Attendance Report" class="screenshot">

  <hr>

  <h2>⚡ Getting Started</h2>
  <h3>1️⃣ Clone the repository</h3>
  <pre><code>git clone https://github.com/yourusername/smart_attendance_manager.git
cd smart_attendance_manager</code></pre>

  <h3>2️⃣ Install dependencies</h3>
  <pre><code>flutter pub get</code></pre>

  <h3>3️⃣ Setup Firebase</h3>
  <ul>
    <li>Create a Firebase project</li>
    <li>Add Android/iOS apps</li>
    <li>Place <code>google-services.json</code> in <code>/android/app/</code></li>
    <li>Enable Authentication and Firestore in Firebase Console</li>
  </ul>

  <h3>4️⃣ Run the app</h3>
  <pre><code>flutter run</code></pre>

  <hr>

  <h2>🧩 Folder Structure</h2>
  <pre><code>lib/
│
├── domain/
│   └── constants/       # App colors, styles, etc.
│
├── repository/
│   ├── screens/         # UI screens (Teacher, Student)
│   ├── widgets/         # Reusable widgets
│   └── services/        # Firebase logic
│
└── main.dart            # App entry point
</code></pre>

  <hr>

  <h2>🔒 Firebase Security Rules (Example)</h2>
  <pre><code>rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
</code></pre>

  <hr>

  <h2>🧠 Future Enhancements</h2>
  <ul>
    <li>📅 Calendar-based attendance tracking</li>
    <li>🔔 Push notifications for attendance alerts</li>
    <li>📤 Export attendance data to Excel</li>
    <li>🧾 Report generation for each class</li>
  </ul>

  <div class="author">
    <h3>👨‍💻 Author</h3>
    <p><strong>Taranpreet Singh</strong><br>
    Flutter Developer | B.Tech CSE<br>
    📧 <a href="mailto:youremail@example.com">youremail@example.com</a><br>
    🔗 <a href="https://linkedin.com/in/your-link">LinkedIn</a> • <a href="https://github.com/yourusername">GitHub</a></p>
  </div>

  <p>⭐ If you like this project, give it a star on <a href="https://github.com/yourusername/smart_attendance_manager">GitHub</a>!</p>

</body>
</html>
