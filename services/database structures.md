# improve database structures and test new api

Created: November 5, 2025 8:53 PM

- books ( modify `date` to DATE type)
    
    ```basic
    
    $app->get('/books/all', 'App\Services\GetAllBooks');
    $app->post('/books/add', 'App\Services\AddBook');
    $app->put('/books/update/{book_id}', 'App\Services\UpdateBook');
    $app->delete('/books/delete/{book_id}', 'App\Services\DeleteBook');
    ```
    
    ```jsx
    MariaDB [elibrary]> DESCRIBE books;
    +--------------+-----------------+------+-----+-------------------+-----------------------------+
    | Field        | Type            | Null | Key | Default           | Extra                       |
    +--------------+-----------------+------+-----+-------------------+-----------------------------+
    | book_id      | int(6) unsigned | NO   | PRI | NULL              | auto_increment              |
    | title        | varchar(50)     | NO   | UNI | NULL              |                             |
    | authors      | varchar(50)     | NO   |     | NULL              |                             |
    | publishers   | varchar(50)     | NO   |     | NULL              |                             |
    | date         | date            | NO   |     | NULL              |                             |
    | isbn         | varchar(50)     | NO   | UNI | NULL              |                             |
    | status       | int(6)          | NO   |     | 0                 |                             |
    | borrowed_by  | int(6)          | YES  |     | -1                |                             |
    | last_updated | timestamp       | NO   |     | CURRENT_TIMESTAMP | on update CURRENT_TIMESTAMP |
    +--------------+-----------------+------+-----+-------------------+-----------------------------+
    CREATE TABLE books (
        book_id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        title VARCHAR(50) NOT NULL UNIQUE,
        authors VARCHAR(50) NOT NULL,
        publishers VARCHAR(50) NOT NULL,
        date DATE NOT NULL,
        isbn VARCHAR(50) NOT NULL UNIQUE,
        status INT(6) NOT NULL DEFAULT 0,
        borrowed_by INT(6) DEFAULT -1,
        last_updated TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
    );
    
    ```
    
- users (add `created_at last_login email`) three columns and (`password` length to char 255 for hash value)
    
    ```basic
    $app->get('/user/all', 'App\Services\GetAllUsers'); // admin only
    $app->post('/user/add', 'App\Services\AddUser');
    $app->put('/user/update/{user_id}', 'App\Services\UpdateUser');
    $app->delete('/user/delete/{user_id}', 'App\Services\DeleteUser');
    ```
    
    ```jsx
    +------------+-----------------+------+-----+-------------------+----------------+
    | Field      | Type            | Null | Key | Default           | Extra          |
    +------------+-----------------+------+-----+-------------------+----------------+
    | user_id    | int(6) unsigned | NO   | PRI | NULL              | auto_increment |
    | username   | varchar(50)     | NO   | UNI | NULL              |                |
    | password   | varchar(255)    | NO   |     | NULL              |                |
    | is_admin   | int(6)          | NO   |     | 0                 |                |
    | created_at | timestamp       | NO   |     | CURRENT_TIMESTAMP |                |
    | last_login | timestamp       | YES  |     | NULL              |                |
    | email      | varchar(255)    | NO   | UNI | NULL              |                |
    +------------+-----------------+------+-----+-------------------+----------------+
    CREATE TABLE users (
        user_id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        is_admin INT(6) NOT NULL DEFAULT 0,
        created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
        last_login TIMESTAMP NULL DEFAULT NULL,
        email VARCHAR(255) NOT NULL UNIQUE
    );
    ```
    
    - add
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%201.png)
        
    - get
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%202.png)
        
    - update
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%203.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%204.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%205.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%206.png)
        
    - del
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%207.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%208.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%209.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2010.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2011.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2012.png)
        
- user_favorites
    
    ```basic
    
    $app->post('/user/favorite', 'App\Services\AddFavorite');
    $app->delete('/user/favorite', 'App\Services\DeleteFavorite');
    ```
    
    ```basic
    CREATE TABLE user_favorites (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT UNSIGNED NOT NULL,
        book_id INT UNSIGNED NOT NULL,
        favorited_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(user_id, book_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id),
        FOREIGN KEY (book_id) REFERENCES books(book_id)
    );
    
    +--------------+------------------+------+-----+-------------------+----------------+
    | Field        | Type             | Null | Key | Default           | Extra          |
    +--------------+------------------+------+-----+-------------------+----------------+
    | id           | int(11)          | NO   | PRI | NULL              | auto_increment |
    | user_id      | int(10) unsigned | NO   | MUL | NULL              |                |
    | book_id      | int(10) unsigned | NO   | MUL | NULL              |                |
    | favorited_at | timestamp        | NO   |     | CURRENT_TIMESTAMP |                |
    +--------------+------------------+------+-----+-------------------+----------------+
    
    ```
    
    - add
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2013.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2014.png)
        
    - delete
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2015.png)
        
- **user_likes**
    
    ```basic
    $app->post('/user/like', 'App\Services\AddLike');
    $app->delete('/user/like', 'App\Services\DeleteLike');
    ```
    
    ```basic
    CREATE TABLE user_likes (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT UNSIGNED NOT NULL,
        book_id INT UNSIGNED NOT NULL,
        liked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(user_id, book_id),
        FOREIGN KEY (user_id) REFERENCES users(user_id),
        FOREIGN KEY (book_id) REFERENCES books(book_id)
    );
    +----------+------------------+------+-----+-------------------+----------------+
    | Field    | Type             | Null | Key | Default           | Extra          |
    +----------+------------------+------+-----+-------------------+----------------+
    | id       | int(11)          | NO   | PRI | NULL              | auto_increment |
    | user_id  | int(10) unsigned | NO   | MUL | NULL              |                |
    | book_id  | int(10) unsigned | NO   | MUL | NULL              |                |
    | liked_at | timestamp        | NO   |     | CURRENT_TIMESTAMP |                |
    +----------+------------------+------+-----+-------------------+----------------+
    ```
    
    - add
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2016.png)
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2017.png)
        
    - delete
        
        ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2018.png)
        
- get users favorites
    
    ```basic
    $app->get('/user/{user_id}/favorites', 'App\Services\GetUserFavorites');
    ```
    
    ![image.png](improve%20database%20structures%20and%20test%20new%20api/image%2019.png)