# 🍄 Champix – Edible Mushroom Recognizer Powered by AI

Champix is an AI-powered mobile application that helps users identify whether a mushroom is **edible or toxic** using a photo.  
Trained on over **10,000 mushroom images**, it uses a machine learning model to analyze photos and predict the species and edibility with high confidence.

---

## 🚀 Features

- 📷 **Photo-based detection**  
  Upload or take a photo of a mushroom to get instant analysis.

- 🧠 **AI & Machine Learning**  
  Uses a deep learning model trained on 10k+ mushroom images.

- 📊 **Prediction details**  
  Get confidence score and probabilities for multiple mushroom species.

- 🗂️ **Analysis history**  
  View and manage your previous scans.

- 🧭 **Cross-platform mobile app**  
  Built with Flutter — works on Android and iOS.

---

## 🧱 Tech Stack

| Component | Technology |
|----------|-------------|
| Frontend | Flutter     |
| Backend  | Python (FastAPI) |
| AI Model | PyTorch     |
| Database | PostgreSQL  |
| Containerization | Docker / Docker Compose |

---

## 📦 Installation

### 🐍 Backend Setup

1. Go to the backend folder:

   ```bash
   cd ./champix-backend
   ```

2. Start the backend using Docker:

   ```bash
   docker-compose up --build
   ```

This will launch the FastAPI backend, PostgreSQL database, and serve static image uploads.

---

### 📱 Frontend Setup

1. Go to the frontend folder:

   ```bash
   cd ./champix
   ```

2. Run the Flutter app:

   ```bash
   flutter run
   ```

Make sure you have Flutter installed and set up correctly for your platform (Android/iOS).

---

## 🧠 About the AI

The AI model is trained on a dataset of **10,000+ mushroom images**, covering both edible and toxic species.  
It uses convolutional neural networks (CNNs) and is served via FastAPI for prediction.

---

## 📁 Project Structure

```
champix/
├── champix-backend/       # FastAPI backend
├── champix/               # Flutter frontend app
└── README.md              # Project documentation
```

---

## 📷 Sample Use Case

1. Open the app  
2. Take a picture of a mushroom  
3. Let the AI analyze it  
4. Get a prediction: _"Chanterelle - Edible (95% confidence)"_

---

## 🔐 Auth & Users

The app includes basic authentication (sign up / sign in) and associates predictions with a user account for history tracking.

---

## 📄 License

MIT License.  
Feel free to use, contribute, and improve.