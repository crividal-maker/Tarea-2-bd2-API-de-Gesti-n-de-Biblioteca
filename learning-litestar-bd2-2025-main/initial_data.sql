-- Categorías
INSERT INTO categories (id, name, description, created_at, updated_at) VALUES
(1, 'Ficción', 'Libros de ficción literaria', NOW(), NOW()),
(2, 'No Ficción', 'Libros de no ficción', NOW(), NOW()),
(3, 'Ciencia', 'Libros de ciencia y tecnología', NOW(), NOW()),
(4, 'Historia', 'Libros de historia', NOW(), NOW()),
(5, 'Fantasía', 'Libros de fantasía épica', NOW(), NOW());

-- Libros
INSERT INTO books (id, title, author, isbn, pages, published_year, stock, description, language, publisher, created_at, updated_at) VALUES
(1, 'Cien años de soledad', 'Gabriel García Márquez', 'ISBN-BD2-2025-1001', 471, 1967, 5, 'Una obra maestra del realismo mágico', 'es', 'Editorial Sudamericana', NOW(), NOW()),
(2, 'Don Quijote de la Mancha', 'Miguel de Cervantes', 'ISBN-BD2-2025-1002', 863, 1605, 3, 'La obra cumbre de la literatura española', 'es', 'Francisco de Robles', NOW(), NOW()),
(3, '1984', 'George Orwell', 'ISBN-BD2-2025-1003', 328, 1949, 4, 'Distopía sobre un futuro totalitario', 'en', 'Secker & Warburg', NOW(), NOW()),
(4, 'Sapiens', 'Yuval Noah Harari', 'ISBN-BD2-2025-1004', 443, 2011, 6, 'De animales a dioses: Breve historia de la humanidad', 'en', 'Debate', NOW(), NOW()),
(5, 'El principito', 'Antoine de Saint-Exupéry', 'ISBN-BD2-2025-1005', 96, 1943, 8, 'Un cuento filosófico sobre la vida', 'fr', 'Reynal & Hitchcock', NOW(), NOW()),
(6, 'Harry Potter y la piedra filosofal', 'J.K. Rowling', 'ISBN-BD2-2025-1006', 223, 1997, 7, 'El inicio de la saga mágica', 'en', 'Bloomsbury', NOW(), NOW()),
(7, 'Crónica de una muerte anunciada', 'Gabriel García Márquez', 'ISBN-BD2-2025-1007', 120, 1981, 4, 'Una novela corta magistral', 'es', 'Editorial Oveja Negra', NOW(), NOW()),
(8, 'La sombra del viento', 'Carlos Ruiz Zafón', 'ISBN-BD2-2025-1008', 565, 2001, 5, 'Misterio en la Barcelona de posguerra', 'es', 'Planeta', NOW(), NOW()),
(9, 'El código Da Vinci', 'Dan Brown', 'ISBN-BD2-2025-1009', 489, 2003, 3, 'Thriller de misterio histórico', 'en', 'Doubleday', NOW(), NOW()),
(10, 'Breve historia del tiempo', 'Stephen Hawking', 'ISBN-BD2-2025-1010', 256, 1988, 4, 'Del Big Bang a los agujeros negros', 'en', 'Bantam Books', NOW(), NOW());

-- Relaciones libro-categoría
INSERT INTO book_categories (book_id, category_id) VALUES
(1, 1), (1, 5),
(2, 1), (2, 4),
(3, 1),
(4, 2), (4, 3), (4, 4),
(5, 1), (5, 5),
(6, 1), (6, 5),
(7, 1),
(8, 1),
(9, 1), (9, 4),
(10, 2), (10, 3);

-- Usuarios (contraseñas hasheadas con argon2)
INSERT INTO users (id, username, fullname, password, email, phone, address, is_active, created_at, updated_at) VALUES
(1, 'user1', 'Juan Pérez', '$argon2id$v=19$m=65536,t=3,p=4$XMu59z6HcI5RinEOYSxljA$WN+xQKZ9VrATfz+w6mjmYFClIqqd6sVdkdGj8fCM6v4', 'juan.perez@example.com', '+56912345678', 'Av. Libertador 123, Santiago', true, NOW(), NOW()),
(2, 'user2', 'María González', '$argon2id$v=19$m=65536,t=3,p=4$XMu59z6HcI5RinEOYSxljA$WN+xQKZ9VrATfz+w6mjmYFClIqqd6sVdkdGj8fCM6v4', 'maria.gonzalez@example.com', '+56987654321', 'Calle Principal 456, Valparaíso', true, NOW(), NOW()),
(3, 'user3', 'Carlos Rodríguez', '$argon2id$v=19$m=65536,t=3,p=4$XMu59z6HcI5RinEOYSxljA$WN+xQKZ9VrATfz+w6mjmYFClIqqd6sVdkdGj8fCM6v4', 'carlos.rodriguez@example.com', '+56956781234', 'Pasaje Los Álamos 789, Concepción', true, NOW(), NOW()),
(4, 'user4', 'Ana Martínez', '$argon2id$v=19$m=65536,t=3,p=4$XMu59z6HcI5RinEOYSxljA$WN+xQKZ9VrATfz+w6mjmYFClIqqd6sVdkdGj8fCM6v4', 'ana.martinez@example.com', '+56943218765', 'Av. España 321, La Serena', true, NOW(), NOW()),
(5, 'user5', 'Pedro Sánchez', '$argon2id$v=19$m=65536,t=3,p=4$XMu59z6HcI5RinEOYSxljA$WN+xQKZ9VrATfz+w6mjmYFClIqqd6sVdkdGj8fCM6v4', 'pedro.sanchez@example.com', '+56976543210', 'Calle O Higgins 654, Temuco', true, NOW(), NOW());

-- Préstamos (algunos activos, algunos devueltos, algunos vencidos)
INSERT INTO loans (id, loan_dt, return_dt, due_date, fine_amount, status, user_id, book_id, created_at, updated_at) VALUES
-- Préstamos activos
(1, '2025-11-20', NULL, '2025-12-04', NULL, 'ACTIVE', 1, 1, NOW(), NOW()),
(2, '2025-11-25', NULL, '2025-12-09', NULL, 'ACTIVE', 2, 3, NOW(), NOW()),
(3, '2025-11-28', NULL, '2025-12-12', NULL, 'ACTIVE', 3, 5, NOW(), NOW()),

-- Préstamos devueltos
(4, '2025-10-15', '2025-10-28', '2025-10-29', 0.00, 'RETURNED', 1, 2, NOW(), NOW()),
(5, '2025-10-20', '2025-11-05', '2025-11-03', 1000.00, 'RETURNED', 4, 4, NOW(), NOW()),

-- Préstamos vencidos
(6, '2025-10-10', NULL, '2025-10-24', NULL, 'OVERDUE', 2, 6, NOW(), NOW()),
(7, '2025-10-05', NULL, '2025-10-19', NULL, 'OVERDUE', 5, 7, NOW(), NOW()),
(8, '2025-11-01', NULL, '2025-11-15', NULL, 'OVERDUE', 3, 8, NOW(), NOW());

-- Reseñas
INSERT INTO reviews (id, rating, comment, review_date, user_id, book_id, created_at, updated_at) VALUES
(1, 5, 'Una obra maestra absoluta, García Márquez en su máximo esplendor', '2025-11-01', 1, 1, NOW(), NOW()),
(2, 5, 'Impresionante historia de la familia Buendía', '2025-11-05', 4, 1, NOW(), NOW()),
(3, 4, 'Clásico imprescindible de la literatura española', '2025-10-20', 2, 2, NOW(), NOW()),
(4, 5, 'Distopía aterradoramente relevante en nuestros días', '2025-11-10', 3, 3, NOW(), NOW()),
(5, 5, 'Me cambió la perspectiva sobre la humanidad', '2025-11-15', 1, 4, NOW(), NOW()),
(6, 4, 'Fascinante recorrido por la historia humana', '2025-11-18', 5, 4, NOW(), NOW()),
(7, 5, 'Un libro que todo adulto debería leer', '2025-10-25', 2, 5, NOW(), NOW()),
(8, 5, 'La magia de Hogwarts nunca envejece', '2025-11-08', 3, 6, NOW(), NOW()),
(9, 5, 'El inicio perfecto de una saga inolvidable', '2025-11-12', 4, 6, NOW(), NOW()),
(10, 4, 'García Márquez magistral como siempre', '2025-10-30', 5, 7, NOW(), NOW()),
(11, 5, 'Zafón te atrapa desde la primera página', '2025-11-20', 1, 8, NOW(), NOW()),
(12, 4, 'Intriga y misterio en cada capítulo', '2025-11-22', 2, 8, NOW(), NOW()),
(13, 3, 'Entretenido pero algo predecible', '2025-10-28', 3, 9, NOW(), NOW()),
(14, 5, 'Hawking explica el universo de forma accesible', '2025-11-14', 4, 10, NOW(), NOW()),
(15, 4, 'Complejo pero fascinante', '2025-11-17', 5, 10, NOW(), NOW());

-- Actualizar secuencias
SELECT setval('categories_id_seq', (SELECT MAX(id) FROM categories));
SELECT setval('books_id_seq', (SELECT MAX(id) FROM books));
SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));
SELECT setval('loans_id_seq', (SELECT MAX(id) FROM loans));
SELECT setval('reviews_id_seq', (SELECT MAX(id) FROM reviews));