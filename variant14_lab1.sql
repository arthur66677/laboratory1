-- Главная таблица (родительская)
CREATE TABLE faculties (
    faculty_id        SERIAL PRIMARY KEY,          -- автоинкремент
    faculty_name      VARCHAR(100) NOT NULL,
    foundation_date   DATE         NOT NULL,
    activity_type     TEXT         NOT NULL,       -- род деятельности
    max_students      INTEGER      NOT NULL CHECK (max_students > 0)
);

-- Зависимая таблица (дочерняя)
CREATE TABLE groups (
    group_number      VARCHAR(20) PRIMARY KEY,     -- номер группы
    max_people        INTEGER     NOT NULL CHECK (max_people > 0),
    faculty_id        INTEGER     NOT NULL,
    curator           VARCHAR(100) NOT NULL,
    FOREIGN KEY (faculty_id) REFERENCES faculties(faculty_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Факультеты (10 записей)
INSERT INTO faculties (faculty_name, foundation_date, activity_type, max_students) VALUES
('Факультет информатики',              '1995-09-01', 'ИТ-образование',        500),
('Факультет экономики',                '1990-09-01', 'Экономическое образование', 400),
('Факультет юриспруденции',            '1988-09-01', 'Юридическое образование', 350),
('Факультет иностранных языков',       '2000-09-01', 'Лингвистика',           300),
('Факультет математики и механики',    '1985-09-01', 'Математические науки',  450),
('Факультет физики',                   '1982-09-01', 'Физические науки',      250),
('Факультет химии и биологии',         '1992-09-01', 'Естественные науки',    280),
('Факультет психологии',               '2005-09-01', 'Психология',            320),
('Факультет журналистики',             '1998-09-01', 'Медиа и коммуникации',  200),
('Факультет дизайна и искусств',       '2010-09-01', 'Творческие специальности', 180);

-- Группы (10 записей)
INSERT INTO groups (group_number, max_people, faculty_id, curator) VALUES
('ИВТ-101',  25, 1, 'Иванов И.И.'),
('ИВТ-102',  25, 1, 'Петров П.П.'),
('ЭК-201',   30, 2, 'Сидорова А.А.'),
('ЭК-202',   30, 2, 'Кузнецов С.С.'),
('ЮР-301',   28, 3, 'Смирнов А.Н.'),
('ЮР-302',   28, 3, 'Волкова М.И.'),
('ЛНГ-401',  20, 4, 'Морозов Д.О.'),
('МАТ-501',  22, 5, 'Лебедева О.В.'),
('ФИЗ-601',  18, 6, 'Козлов А.М.'),
('ПСИ-801',  24, 8, 'Новикова Е.А.');

-- Каскадное обновление
UPDATE faculties SET faculty_id = 99 WHERE faculty_id = 1;

-- Проверка (все группы faculty_id=1 стали faculty_id=99)
SELECT * FROM groups WHERE faculty_id = 99;

-- Каскадное удаление (удалит связанные группы)
DELETE FROM faculties WHERE faculty_id = 99;

-- Откат (проверка)
SELECT * FROM groups WHERE faculty_id = 99; -- пусто

-- Все таблицы
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';

-- Структура таблиц
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name IN ('faculties','groups')
ORDER BY table_name, ordinal_position;

-- Внешние ключи
SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
  ON tc.constraint_name = kcu.constraint_name
JOIN information_schema.constraint_column_usage AS ccu
  ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY';

-- Количество записей
SELECT 'faculties' AS table_name, COUNT(*) FROM faculties
UNION ALL
SELECT 'groups', COUNT(*) FROM groups;

-- Группы с названием факультета (JOIN)
SELECT g.group_number, g.max_people, g.curator, f.faculty_name
FROM groups g
JOIN faculties f ON f.faculty_id = g.faculty_id
ORDER BY f.faculty_name, g.group_number;
