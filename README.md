# ArXiv Visualizer

**ArXiv Visualizer** is a web application built with Ruby on Rails on the backend and Vue.js on the frontend. It allows users to search for research papers from arXiv, bookmark and manage them, and organize their research using a sleek, minimalistic interface.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Folder Structure](#folder-structure)
- [Running the Application](#running-the-application)

---

## Features

- **User Authentication:** Register, log in, and manage sessions.
- **Smart Paper Search:** Search for research papers directly from arXiv.
- **Bookmarking:** Bookmark and organize your favorite research papers.

---

## Tech Stack

- **Backend:** Ruby on Rails
- **Frontend:** Vue.js (with Vite), Pinia (state management), Vuex (for legacy state management)
- **Styling:** Tailwind CSS
- **Database:** MySQL
- **Other Tools:** GitHub Actions for CI

---

## Prerequisites

Before running the application, ensure you have the following installed:

- [Ruby](https://www.ruby-lang.org/en/) (recommended version 3.4.1)
- [Rails](https://rubyonrails.org/)
- [Node.js](https://nodejs.org/) and [Yarn](https://yarnpkg.com/) (or npm)
- A database server (configured in `config/database.yml`)

---

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/rupaut98/arxiv_visualizer.git
   cd arxiv_visualizer
   ```
2. **Install Ruby Gems:**
   ```bash
   bundle install
   ```
3. **Install Node Dependencies:**
   ```bash
   yarn install
   ```
4. **Tailwind CSS Setup:**
   Ensure you have a Tailwind CSS file at `app/frontend/styles/main.css` containing:
   ```css
   @tailwind base;
   @tailwind components;
   @tailwind utilities;
   ```
5. **Database Setup:**
   Create and migrate your database:
   ```bash
   rails db:create
   rails db:migrate
   ```

---

## Configuration

- **State Management:** 
  The search state is managed by Pinia in the `app/frontend/stores/searchStore.js` file with persistence enabled via the `pinia-plugin-persistedstate` plugin.

---

## Folder Structure

```
app 
├── assets 
│   ├── images 
│   │   └── .keep 
│   └── stylesheets 
│       └── application.css 
├── controllers 
│   ├── api 
│   │   ├── v1 
│   │   │   ├── auth_controller.rb 
│   │   │   ├── auth_status_controller.rb 
│   │   │   ├── bookmarks_controller.rb 
│   │   │   └── papers_controller.rb 
│   ├── concerns 
│   │   └── .keep 
│   └── application_controller.rb 
├── frontend 
│   ├── components 
│   │   ├── App.vue 
│   │   ├── BookmarkList.vue 
│   │   ├── CitationNetwork.vue 
│   │   ├── Home.vue 
│   │   ├── Login.vue 
│   │   ├── PaperDetail.vue 
│   │   ├── PaperList.vue 
│   │   ├── PaperSearch.vue 
│   │   └── Register.vue 
│   ├── entrypoints 
│   │   └── application.js 
│   ├── router 
│   │   └── index.js 
│   └── store 
│       └── index.js 
├── helpers 
│   └── application_helper.rb 
├── jobs 
│   └── application_job.rb 
├── mailers 
│   └── application_mailer.rb 
├── models 
│   ├── concerns 
│   │   └── .keep 
│   ├── application_record.rb 
│   ├── bookmark.rb 
│   ├── citation.rb 
│   ├── paper.rb 
│   └── user.rb 
├── services 
│   └── arxiv_service.rb 
└── views 
    ├── layouts 
    │   ├── application.html.erb 
    │   ├── mailer.html.erb 
    │   └── mailer.text.erb 
    └── pwa 
        ├── manifest.json.erb 
        └── service-worker.js
```

---

## Running the Application

1. **Start the Rails Server:**
   ```bash
   bin/rails server
   ```
   Open your browser and navigate to [http://localhost:3000](http://localhost:3000) (or the configured port).
    ```