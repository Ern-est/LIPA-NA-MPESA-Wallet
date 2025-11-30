# Lipa na MPESA Clone (Flutter)

A **Flutter mobile app** simulating the Lipa na M-PESA payment flow.  
Supports **real-time STK Push payments** using **Daraja API** and **Supabase** for backend & realtime updates.

---

## Features

- Input phone number and amount to trigger STK Push  
- Real-time payment status updates (success/failure)  
- Polished, card-style UI resembling the real M-PESA app  
- Supabase Edge Functions for STK Push integration  
- Realtime listener updates the UI automatically  

---

## Screenshots
<img width="558" height="1068" alt="mpesa_clone" src="https://github.com/user-attachments/assets/5c862e71-9146-4fe1-a4db-f03c913fac37" />

<img width="508" height="1068" alt="mpesa_clone1" src="https://github.com/user-attachments/assets/12e4b44a-2d25-4091-9099-08a75cb0c078" />


---

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)  
- Supabase account  
- Daraja (MPESA) API credentials  

### Setup

1. Clone the repo:

```bash
git clone https://github.com/<your-username>/mpesa_clone.git
cd mpesa_clone
Install dependencies:

bash
Copy code
flutter pub get
Create a .env file in the root directory:

env
Copy code
SUPABASE_URL=https://your-supabase-url.supabase.co
SUPABASE_ANON_KEY=your-anon-key
Run the app:

bash
Copy code
flutter run
Project Structure
bash
Copy code
lib/
├─ features/
│  ├─ home/
│  │  └─ presentation/screens/home_screen.dart
│  ├─ payment/
│  │  └─ presentation/screens/payment_screen.dart
├─ services/
│  └─ supabase_service.dart
└─ main.dart
Notes
Replace YOUR_SUPABASE_ANON_KEY in PaymentScreen with the key from your .env.

This project is for development/testing purposes. For production, configure secure Daraja callbacks and Supabase service role key for transaction updates.

License
MIT License
