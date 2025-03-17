# ArXiv Visualizer

**ArXiv Visualizer** is a web application built with Ruby on Rails on the backend and Vue.js on the frontend. It allows users to search for research papers from arXiv, bookmark and manage them, and organize their research using a sleek, minimalistic interface.

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
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
- [Rails](https://rubyonrails.org/) (recommended version 8.0.1)
- [Node.js](https://nodejs.org/) and [Yarn](https://yarnpkg.com/) (recommended version 22.13.0)
- [MySQL](https://www.mysql.com/) (make sure it's running on your machine)

---

## Installation

### 1. Setting Up Your Development Environment

#### Installing Homebrew

First, we need to install Homebrew. Homebrew allows us to install and compile software packages easily from source.

Homebrew comes with a very simple install script. When it asks you to install XCode CommandLine Tools, say yes.

Open Terminal and run the following command:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### Installing Ruby

We'll be installing Ruby 3.4.1 (Recommended) using a version manager called ASDF.

The reason we use ASDF over rbenv, rvm, or others is that ASDF can manage other languages like Node.js too.

Installing ASDF is a simple two-step process. First, you install ASDF, and then add it to your shell:

```bash
cd
git clone https://github.com/excid3/asdf.git ~/.asdf
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc
echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
echo 'legacy_version_file = yes' >> ~/.asdfrc
exec $SHELL
```

Then, we can install ASDF plugins for each language we want to use. For Rails, we can install Ruby and Node.js for our frontend JavaScript.

```bash
asdf plugin add ruby
asdf plugin add nodejs
```

To install Ruby and set the default version, we'll run the following commands:

```bash
asdf install ruby 3.4.1
asdf global ruby 3.4.1
```

Update to the latest RubyGems version:

```bash
gem update --system
```

Confirm the default Ruby version matches the version you just installed:

```bash
which ruby
#=> /Users/username/.asdf/shims/ruby
ruby -v
#=> 3.4.1
```

#### Installing Node.js

Then, we can install the latest Node.js for handling JavaScript in our Rails apps:

```bash
asdf install nodejs 22.13.0
asdf global nodejs 22.13.0
```

Confirm the Node.js installation:

```bash
which node
#=> /Users/username/.asdf/shims/node
node -v
#=> 22.13.0
```

#### Installing Rails

Install Rails using the gem command:

```bash
gem install rails -v 8.0.1
```

And now we can verify Rails is installed:

```bash
rails -v
#=> Rails 8.0.1
```

#### Installing MySQL

You can install MySQL server and client from Homebrew:

```bash
brew install mysql
```

Once this command is finished, it gives you a couple commands to run. Follow the instructions and run them:

To have `launchd` start MySQL at login:

```bash
brew services start mysql
```

### 2. Setting Up the Project

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
   @import "tailwindcss";
   ```

---

## Database Setup

This application uses MySQL as its database. The configuration is defined in `config/database.yml`:

```yaml
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: root
  password:
  
  # Either use socket connection (more efficient for local development)
  socket: /opt/homebrew/var/mysql/mysql.sock
  
  # Or use host and port for TCP/IP connection (uncomment these and comment the socket line)
  # host: localhost
  # port: 3306

development:
  <<: *default
  database: arxiv_visualizer_development

test:
  <<: *default
  database: arxiv_visualizer_test
```

To set up your database:

1. **Install MySQL** if you haven't already:
   ```bash
   # On macOS using Homebrew
   brew install mysql
   brew services start mysql
   ```

2. **Choose Connection Method:**
   - **Socket connection** (default in configuration): Faster for local development.
   - **Host/port connection**: Required for connecting to a MySQL server on a different machine.

3. **Configure MySQL User:**
   The application is configured to use the root user with no password for simplicity since the app is in development mode.

4. **Create and Migrate the Database:**
   ```bash
   # Create the development and test databases
   rails db:create
   
   # Run migrations to set up the schema
   rails db:migrate
   ```

Note: If you have a different MySQL setup (different username, password, socket path, or need to use host/port instead of socket), modify the `database.yml` file accordingly. Remember to use either the socket method **OR** the host/port method, not both simultaneously.


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
   
2. **Start the Vite Development Server:**
   ```bash
   bin/dev
   ```

3. Open your browser and navigate to [http://localhost:3000](http://localhost:3000) (or the configured port).