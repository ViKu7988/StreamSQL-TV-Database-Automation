# StreamSQL: TV Series Database Manager

## Project Overview

**StreamSQL** is a backend database system designed to power a TV streaming service similar to Netflix or Hulu.

Rather than just storing data, this project focuses on **automation** and **data integrity**. It uses advanced SQL features to automatically calculate ratings, track how long users watch shows, and generate reports on actor popularity.

## Database Schema

The system is built on a relational model that connects users, series, episodes, and actors.

![Database Schema](https://github.com/ViKu7988/StreamSQL-TV-Database-Automation/blob/main/tv_series_schema.sql)

* **Users & History:** Tracks who is watching what and for how long.
* **Content:** Organized into Series, Seasons, and Episodes.
* **Cast:** Links actors to specific episodes they appeared in.

## Key Features

### 1. Automated Logic (Triggers)

I implemented "smart triggers" that run automatically whenever new data is added:

* **Automatic Rating Adjustments:** When a user watches an episode, the system automatically updates the rating of that series. If the show is popular, its rating grows slightly.
* **Error Correction:** If a system glitch records a user watching 60 minutes of a 40-minute episode, the database automatically corrects the record to match the actual episode length.

### 2. Analytics Dashboard (Views)

I created pre-built "Views" to answer business questions instantly without writing complex code every time:

* **Top Cast Lists:** Instantly retrieves the cast members for the highest-rated series.
* **Actor Screen Time:** A view that calculates the total minutes an actor has been watched across the entire platform.

### 3. Safe Content Management (Stored Procedures)

* **`AddEpisode` Procedure:** A custom tool for administrators. It safely adds new episodes by first checking if the series exists and ensuring the episode isn't a duplicate. This prevents "bad data" from entering the system.

### 4. Custom Helper Tools (Functions)

* **`GetEpisodeList`:** A function that takes a Series ID and Season Number and generates a clean, comma-separated text list of all episodes for that season.

## Tech Stack

* **Database Engine:** MariaDB / MySQL
* **Language:** SQL (Structured Query Language)
* **Key Concepts:** Normalization, Triggers, Stored Procedures, Views, ACID Compliance

## How to Use

1. **Setup:** Install a MySQL server (like XAMPP or MySQL Workbench).
2. **Import:** Run the SQL scripts to build the tables.
3. **Deploy Logic:** Execute the Stored Procedure and Trigger files to enable the automation features.
4. **Test:** Try using the `AddEpisode` procedure to insert a new show, or add a record to `user_history` to see the rating update automatically.

## License

This project is open-source and available for educational purposes.
