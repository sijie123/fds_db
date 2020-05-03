### Introduction
This is the database component of the FDS App.
The scripts included in this folder represent a snapshot of our development database.
Before running the app, you should initialize your database with our provided init script.

### Pre-requisites
You need the following software to run this application.
1. PostgreSQL
  - You need to install PostgreSQL.

### Deployment Instructions
1. Checkout this git repository (or unzip the zip file) and enter the `sql` folder.
2. Switch to a user that has admin privileges on the database server. (This is usually the `postgres` user.)
  - You can use the `sudo -u postgres psql` command on Linux to start a Postgres Shell as the `postgres` user.
3. Create a Postgres Database (and optionally a new user, for security purposes), taking note of the credentials and the database name. You will need this information when deploying the back-end.
4. Connect to the newly created database with `\c db_name`.
5. Run the command `\i init.sql` to initialise the database and populate some sample entries.

Refer to the client-side deployment instructions to setup the front-end.
Also refer to the server-side deployment instructions to setup the back-end.
After setting up the client-side, server-side and database deployments, you can begin using the FDS App.

### About
This FDS App is created by Team 57: Lin Si Jie, Jonathan Cheng, Hilda Ang, Ong Ai Hui for the purposes of CS2102.