CREATE TABLE Institutions (
    institution_id INT AUTO_INCREMENT PRIMARY KEY,
    institution_name VARCHAR(255) NOT NULL,
    institution_type ENUM('School', 'Kindergarten') NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Вставка даних
INSERT INTO Institutions (institution_name, institution_type, address)
VALUES
('Greenfield Elementary School', 'School', '123 Main St, City A'),
('Sunshine Kindergarten', 'Kindergarten', '456 Elm St, City B'),
('Hillside High School', 'School', '789 Oak St, City C');

CREATE TABLE Classes (
    class_id INT AUTO_INCREMENT PRIMARY KEY,
    class_name VARCHAR(255) NOT NULL,
    institution_id INT,
    direction ENUM('Mathematics', 'Biology and Chemistry', 'Language Studies') NOT NULL,
    FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id)
);

-- Вставка даних
INSERT INTO Classes (class_name, institution_id, direction)
VALUES
('Class 1A', 1, 'Mathematics'),
('Class 2B', 1, 'Biology and Chemistry'),
('Class KG-A', 2, 'Language Studies');

CREATE TABLE Children (
    child_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    year_of_entry YEAR NOT NULL,
    age INT NOT NULL,
    institution_id INT,
    class_id INT,
    FOREIGN KEY (institution_id) REFERENCES Institutions(institution_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Вставка даних
INSERT INTO Children (first_name, last_name, birth_date, year_of_entry, age, institution_id, class_id)
VALUES
('John', 'Doe', '2010-05-12', 2016, 14, 1, 1),
('Mary', 'Smith', '2011-09-23', 2017, 13, 1, 2),
('Lily', 'Johnson', '2017-03-15', 2023, 7, 2, 3);

CREATE TABLE Parents (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    child_id INT,
    tuition_fee DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (child_id) REFERENCES Children(child_id)
);

-- Вставка даних
INSERT INTO Parents (first_name, last_name, child_id, tuition_fee)
VALUES
('James', 'Doe', 1, 1200.00),
('Anna', 'Smith', 2, 1100.00),
('Emily', 'Johnson', 3, 800.00);


