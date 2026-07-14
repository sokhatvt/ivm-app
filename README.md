# **Invoice Management System (IVM)**

A simple, lightweight Invoice Management application built using **Vanilla JavaScript** and **Node.js** at the backend, with **MariaDB** as the database engine.  
The application is designed to be high-performance, easy to use, and simple to self-host in just a few steps.

## **🚀 Key Features**

* **Simple & Lightweight**: Built without bulky frameworks, optimizing load speeds and processing performance.  
* **Easy Installation**: Get the system up and running quickly using automated script files.  
* **Reliable Database**: Safe, secure, and high-speed data management with MariaDB.  
* **Intuitive Interface**: Smooth invoice management operations directly on your web browser.

## **🛠️ System Requirements**

Before getting started, ensure that your computer or server has the following software installed:

1. **Node.js** (LTS version 18 or newer recommended).  
2. **MariaDB Server** (Active and ready).

## **📦 Installation & Setup Guide**

### **Step 1: Deploy the Source Code**

Extract the project directory or copy the files directly to your computer/server.

### **Step 2: Install Dependencies**

Open your terminal (or Command Prompt) at the root directory of the project and run:  
`npm install`  
**For Windows users:** You can simply double-click and run the install\_node\_modules.bat file, and the system will handle the installation automatically.

### **Step 3: Configure Process Management (Optional)**

To keep the application running stably on a server environment without closing when you shut down your terminal window, you can choose one of the following methods depending on your operating environment:

* **Using PM2 (Recommended for Servers/VPS):**  
  * **On Windows:** Right-click the pm2\_install.bat file and choose **Run as administrator** to install PM2. After that, you can configure PM2 to start up along with the operating system so the app automatically boots up when the server reboots.
  * **On Ubuntu/Linux VPS (Simple Setup):**  
  For a quick setup without running complex commands, please refer to the automated guide and configuration templates available at [github.com/sokhatvt/ivm-vps](https://github.com/sokhatvt/ivm-vps).
  
* **Running Offline normally on Windows:**  
  * If you do not install PM2, simply execute the START\_IVM.bat file to directly activate the index.js file.  
* **On Shared Hosting Environments:**  
  * Installing PM2 is unnecessary (and usually not permitted due to restricted permissions). The application will be managed directly via the built-in Node.js process manager (e.g., Phusion Passenger) provided in your hosting provider's cPanel/DirectAdmin.

## **🏃 Usage & Initial Setup**

### **Step 1: Access the Application**

Once the index.js file is running successfully, open your web browser (**Google Chrome is highly recommended**) and navigate to:  
`http://localhost:3000`

### **Step 2: Complete System Configuration**

On your very first access, the system will display a form interface to complete the final setup phase. You will need to provide information including:

* MariaDB connection details (Database Name, Database Password, Host...)  
* Administrator email and other basic system preferences.

### **Step 3: Log In and Change Password**

Upon completing the setup, the system will automatically connect to the database and generate a default administrator (Admin) account:

* **Username:** ivm\_admin  
* **Password:** 12345678

⚠️ **IMPORTANT NOTE:** For security reasons, immediately after logging in successfully with the default account, you must navigate to the account management section to **change your username and password** to a more secure combination.

## 📌 Notes & Feedback
* **Guides & Connect:** You can view the detailed documentation or follow/contact me via my [Personal Facebook](https://facebook.com/tvtsokha).
* **Project Status:** This application is currently in its **early development stage (Early Alpha/Beta)**. Since it is still actively being developed and improved, bugs and unexpected errors are inevitable.
* **Feedback & Contributions:** If you encounter any bugs or have suggestions for improvement, please send a direct message via Facebook or email me at `sokhatvt@gmail.com` so I can check and fix them promptly. Thank you so much for your understanding and support!