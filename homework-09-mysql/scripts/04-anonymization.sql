-- ============================================================
-- SchoolDB - Анонімізація даних
-- ============================================================
-- УВАГА: Виконувати на копії бази даних (SchoolDB_Restored)!

USE SchoolDB_Restored;

-- ============================================================
-- 1. Анонімізація Children
-- ============================================================
-- Замінюємо імена та прізвища дітей на узагальнені значення

UPDATE Children 
SET first_name = 'Child',
    last_name = CONCAT('Anonymous', child_id);

-- Перевірка
SELECT * FROM Children;

-- ============================================================
-- 2. Анонімізація Parents
-- ============================================================
-- Замінюємо імена та прізвища батьків на псевдоніми

UPDATE Parents 
SET first_name = CONCAT('Parent', parent_id),
    last_name = 'Anonymous';

-- Перевірка
SELECT * FROM Parents;

-- ============================================================
-- 3. Анонімізація Institutions
-- ============================================================
-- Замінюємо назви закладів та адреси на умовні

UPDATE Institutions 
SET institution_name = CONCAT('Institution', institution_id),
    address = CONCAT('Address ', institution_id);

-- Перевірка
SELECT * FROM Institutions;

-- ============================================================
-- 4. Анонімізація фінансових даних
-- ============================================================
-- Замінюємо вартість навчання на випадкові значення в діапазоні 4000-6000

UPDATE Parents 
SET tuition_fee = ROUND(4000 + (RAND() * 2000), 2);

-- Перевірка
SELECT * FROM Parents;

-- ============================================================
-- 5. Фінальна перевірка анонімізації
-- ============================================================

SELECT 
    c.first_name AS child_name,
    c.last_name AS child_lastname,
    i.institution_name,
    p.first_name AS parent_name,
    p.tuition_fee
FROM Children c
JOIN Institutions i ON c.institution_id = i.institution_id
JOIN Parents p ON c.child_id = p.child_id;
