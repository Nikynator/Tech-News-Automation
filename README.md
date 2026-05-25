# 📰 Automated IT News Aggregator

A PowerShell-based automation tool designed to streamline weekly IT news gathering for classroom discussions. Instead of manually searching for updates, this script fetches, filters, and serves the latest IT news on a local web page at the click of a button.

---

## 🚀 Features

* **One-Click Automation:** Instantly fetches the latest IT news using PowerShell and a News API.
* **Smart Categorization:** Automatically filters news into four core subjects:
  * 🤖 **AI** (Artificial Intelligence & Machine Learning)
  * 💻 **Development** (Software Engineering, Frameworks, Tech Stacks)
  * 🔒 **Cybersecurity** (Vulnerabilities, Breaches, InfoSec updates)
  * 🛡️ **Data Protection** (Privacy laws, GDPR, Compliance)
* **Local Web Interface:** Generates and launches a clean, summarized HTML page locally for easy viewing and sharing in class.

---

## 🛠️ How It Works
1. The user executes the PowerShell script.
2. The script fetches IT news from top IT news sources.
3. Content is categorized into specific buckets (AI, Dev, Cybersec, Data Protection).
4. A local `index.html` file is generated with a clean summary layout.
5. The script automatically opens the page in your default web browser.

---

## 📋 Prerequisites

Before running the script, ensure you have:
* **Windows 10/11**
* **PowerShell 5.1** or higher (PowerShell Core 7+ recommended)
* An active internet connection

---

## 💻 Getting Started
1. Clone the Repository
git clone [https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git](https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git)
cd YOUR-REPO-NAME
2. Execution Policy (If required)
If your system blocks script execution, run PowerShell as Administrator and execute:
powershell: Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
3. Execute and enjoy
