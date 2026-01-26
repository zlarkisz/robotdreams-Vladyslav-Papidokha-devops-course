-- ============================================================
-- SchoolDB - Запити
-- ============================================================

USE SchoolDB;

-- ============================================================
-- Запит 1: Діти з закладами та напрямами навчання
-- ============================================================
-- Отримати список всіх дітей разом із закладом, в якому вони 
-- навчаються, та напрямом навчання в класі

SELECT 
    c.first_name,
    c.last_name,
    c.age,
    i.institution_name,
    i.institution_type,
    cl.class_name,
    cl.direction
FROM Children c
JOIN Institutions i ON c.institution_id = i.institution_id
JOIN Classes cl ON c.class_id = cl.class_id;

-- ============================================================
-- Запит 2: Батьки з дітьми та вартістю навчання
-- ============================================================
-- Отримати інформацію про батьків і їхніх дітей разом із 
-- вартістю навчання

SELECT 
    p.first_name AS parent_first_name,
    p.last_name AS parent_last_name,
    c.first_name AS child_first_name,
    c.last_name AS child_last_name,
    p.tuition_fee
FROM Parents p
JOIN Children c ON p.child_id = c.child_id;

-- ============================================================
-- Запит 3: Заклади з кількістю дітей
-- ============================================================
-- Отримати список всіх закладів з адресами та кількістю дітей, 
-- які навчаються в кожному закладі

SELECT 
    i.institution_name,
    i.address,
    COUNT(c.child_id) AS children_count
FROM Institutions i
LEFT JOIN Children c ON i.institution_id = c.institution_id
GROUP BY i.institution_id, i.institution_name, i.address;
