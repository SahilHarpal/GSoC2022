# Development install

### Requirements:

- Python 3 (tested with version 3.7)
- Django 3.2
- PostgreSQL (tested with version 13, but should work fine with anything newer)
- NGINX
- Other dependencies in requirements.txt

### Procedure:
- Navigate to the cloned repository

    ```
    cd <project_directory_name>     #   pgarchives
    ```
- Create a new virtual environment and activate it
    ```
    sudo apt-get install -y python3-venv
    python3 -m venv env
    source env/bin/activate
    ```
- Use pip to install other dependencies from `requirements.txt`
    ```
    sudo pip install -r requirements.txt
    ```
- Start PostgreSQL server
    ```
    sudo service postgresql start
    ```
- Create a database in your PostgreSQL called `archives` (other names are of course possible, but that's the standard one)
    ```
    sudo -u postgres psql
    create database archives;
    ```
    
-   Provide following details in the `settings.py` file
    ```
      DATABASES = {
          'default': {
              'ENGINE': 'django.db.backends.postgresql_psycopg2',  # Add 'postgresql_psycopg2', 'postgresql', 'mysql', 'sqlite3' or 'oracle'.
              'NAME': 'archives',                      # Or path to database file if using sqlite3.
              'USER': '',                      # Not used with sqlite3.
              'PASSWORD': '',                  # Not used with sqlite3.
              'HOST': '',                      # Set to empty string for localhost. Not used with sqlite3.
              'PORT': '',                      # Set to empty string for default. Not used with sqlite3.
          }
      }
    ```
    
    Add `ALLOWED_HOSTS = ['127.0.0.1', 'localhost']`
    
    To display public data that doesn't require authentication. Change `PUBLIC_ARCHIVES=True`
    
    (Otherwise, you must also set up a Pgweb project and connect them to authenticate users.)
- Select archives database and create tables using **table.sql**
    ```
    \c archives
    ```
    Copy SQL queries from `table.sql` file and paste in the postgres shell
    
- Insert sample data
    In the same postgres shell, execute below insert queries
    ```
    INSERT INTO listgroups (groupid, groupname, sortkey) VALUES (1, 'Developer lists', 1);
    INSERT INTO lists (listid, listname, shortdesc, description, active, groupid, subscriber_access) VALUES (1, 'pgsql-hackers', 'pgsql-hackers', 'The PostgreSQL developers team lives here. Discussion of current development issues, problems and bugs, and proposed new features. If your question cannot be answered by people in the other lists, and it is likely that only a developer will know the answer, you may re-post your question in this list. You must try elsewhere first!', True, 1,   True);
    ```
    Close the postgres shell and switch to postgres user
    ```
    sudo su postgres
    ```
    Copy archives.ini.sample as archives.ini and provide database name (Default = archives)
    
    Navigate to `/loader` directory and execute `load_message.py` 
    ```
    python3 load_message.py -l pgsql-hackers -m pgsql-hackers.202207
    ```

- Navigate to `/django` directory and run the server
    ```
    python3 manage.py runserver 8000
    ```

    After running the above command, you will see that the Django server is running at [http://127.0.0.1:8000](http://127.0.0.1:8000/)

    If you open the above URL in the browser you will see that CSS/JS files are not loaded properly. To resolve this, we need to use Nginx. It works as a reverse proxy and helps to serve staticfiles on its own.

- Open new terminal, install Nginx, create config file `pgarchives.conf` inside `/etc/nginx/sites-enabled` and add the following code snippet in the file
    ```
        server {
            listen 88;
            listen [::]:88;
            server_name localhost;
            location / {
                proxy_pass http://127.0.0.1:8000;
                proxy_http_version 1.1;
                proxy_set_header Upgrade $http_upgrade;
                proxy_set_header Connection 'upgrade';
                proxy_set_header Host $host;
                proxy_cache_bypass $http_upgrade;
            }
             location /media-archives/ {
                autoindex on;
                alias /path_to_pgarchives_media_directory/;
            }
        }
    ```

    For the **<path_to_pgarchives_media_directory>**, go inside the media directory of pgarchives and enter `pwd`

- Create symbolic link
    ```
    sudo ln -s /etc/nginx/sites-available/pgarchives.conf /etc/nginx/sites-enabled/
    ```
- Start Nginx service
    ```
    sudo service nginx start
    ```
- Open http://127.0.0.1:88/ in the browser
