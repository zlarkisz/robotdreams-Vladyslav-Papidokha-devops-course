-- ============================================================
-- SchoolDB - Заповнення даними
-- ============================================================

USE SchoolDB;

-- ============================================================
-- 1. Заклади освіти
-- ============================================================
INSERT INTO Institutions (institution_name, institution_type, address) VALUES
('School No.15', 'School', '10 Main Street, Kyiv'),
('Intellect Lyceum', 'School', '25 Science Ave, Lviv'),
('Sunshine Kindergarten', 'Kindergarten', '5 Park Road, Odesa'),
('Gymnasium No.1', 'School', '100 Victory Blvd, Kharkiv');

-- ============================================================
-- 2. Класи
-- ============================================================
INSERT INTO Classes (class_name, institution_id, direction) VALUES
('1-A', 1, 'Mathematics'),
('5-B', 1, 'Language Studies'),
('3-C', 2, 'Biology and Chemistry'),
('Bunnies Group', 3, 'Language Studies'),
('10-A', 4, 'Mathematics'),
('7-B', 4, 'Biology and Chemistry');

-- ============================================================
-- 3. Діти
-- ============================================================
INSERT INTO Children (first_name, last_name, birth_date, year_of_entry, age, institution_id, class_id) VALUES
('Ivan', 'Petrenko', '2017-03-15', 2023, 7, 1, 1),
('Maria', 'Kovalenko', '2012-07-22', 2018, 12, 1, 2),
('Oleksandr', 'Shevchenko', '2014-01-10', 2020, 10, 2, 3),
('Anna', 'Bondarenko', '2020-11-05', 2024, 4, 3, 4),
('Dmytro', 'Melnyk', '2009-05-30', 2015, 15, 4, 5),
('Sofia', 'Kravchuk', '2011-09-18', 2017, 13, 4, 6);

-- ============================================================
-- 4. Батьки
-- ============================================================
INSERT INTO Parents (first_name, last_name, child_id, tuition_fee) VALUES
('Petro', 'Petrenko', 1, 5000.00),
('Olena', 'Petrenko', 1, 5000.00),
('Viktor', 'Kovalenko', 2, 4500.00),
('Natalia', 'Shevchenko', 3, 6000.00),
('Andriy', 'Bondarenko', 4, 3500.00),
('Iryna', 'Melnyk', 5, 7000.00),
('Serhiy', 'Kravchuk', 6, 7000.00);

-- Перевірка
SELECT 'Institutions' AS table_name, COUNT(*) AS count FROM Institutions
UNION ALL
SELECT 'Classes', COUNT(*) FROM Classes
UNION ALL
SELECT 'Children', COUNT(*) FROM Children
UNION ALL
SELECT 'Parents', COUNT(*) FROM Parents;
