# API con Litestar y PostgreSQL

API REST para gestión de biblioteca desarrollada con Litestar y SQLAlchemy. Permite administrar usuarios, libros, categorías, préstamos y reseñas. Incluye autenticación JWT, sistema de multas, gestión de inventario y documentación interactiva.

## Requisitos

- [uv](https://github.com/astral-sh/uv)
- PostgreSQL

## Inicio rápido
```bash
uv sync                      # Instala las dependencias
cp .env.example .env         # Configura las variables de entorno (ajusta según sea necesario)
uv run alembic upgrade head  # Aplica las migraciones de la base de datos
psql -d bd2_library_db -f reset_and_load.sql  # Carga datos iniciales (opcional)
uv run litestar run --reload # Inicia el servidor de desarrollo
# Accede a http://localhost:8000/schema para ver la documentación de la API
```

## Variables de entorno

Crea un archivo `.env` basado en `.env.example`:

- `DEBUG`: Modo debug (True/False)
- `JWT_SECRET`: Clave secreta para tokens JWT
- `DATABASE_URL`: URL de conexión a PostgreSQL (formato: `postgresql+psycopg://usuario:contraseña@host:puerto/nombre_bd`). Recuerda crear la base de datos antes de ejecutar la aplicación con `createdb bd2_library_db`.

## Características Implementadas

### Modelos
- Category: Categorías de libros con relación many-to-many
- Review: Sistema de reseñas con validación de rating (1-5)
- Book: Gestión de inventario con stock, idioma ISO 639-1, descripción y editorial
- User: Usuarios con email único, teléfono, dirección y estado activo
- Loan: Préstamos con estados (ACTIVE, RETURNED, OVERDUE) y sistema de multas automático

### Funcionalidades Principales

#### Sistema de Préstamos
- Cálculo automático de fecha de vencimiento (14 días)
- Sistema de multas: $500 por día de retraso
- Actualización automática de estado a OVERDUE
- Incremento automático de stock al devolver libros

#### Consultas Avanzadas
- Libros disponibles (stock > 0)
- Búsqueda por categoría, autor y título
- Libros más reseñados
- Historial de préstamos por usuario
- Préstamos activos y vencidos

#### Validaciones
- Stock no negativo en libros
- Rating entre 1 y 5 en reseñas
- Formato de email válido
- Códigos de idioma ISO 639-1 (2 letras)

## Estructura del proyecto
```
app/
├── controllers/     # Endpoints de la API (auth, book, category, loan, review, user)
├── dtos/            # Data Transfer Objects para validación
├── repositories/    # Capa de acceso a datos con lógica de negocio
├── models.py        # Modelos SQLAlchemy (User, Book, Category, Loan, Review)
├── db.py            # Configuración de base de datos
├── config.py        # Configuración de la aplicación
└── security.py      # Autenticación JWT y seguridad
migrations/          # Migraciones de Alembic
```

## Endpoints Principales

### Autenticación
- `POST /auth/login` - Login con JWT (username/password: user1/secret123)

### Libros
- `GET /books` - Listar todos los libros
- `GET /books/available` - Libros con stock disponible
- `GET /books/category/{id}` - Filtrar por categoría
- `GET /books/most-reviewed` - Libros más reseñados
- `GET /books/author/search?author={name}` - Buscar por autor
- `PATCH /books/{id}/stock?quantity={n}` - Actualizar stock
- CRUD completo (create, read, update, delete)

### Préstamos
- `GET /loans/active` - Préstamos activos
- `GET /loans/overdue` - Préstamos vencidos (actualiza status)
- `POST /loans/{id}/return` - Devolver libro (calcula multa)
- `GET /loans/user/{id}` - Historial de préstamos
- CRUD completo

### Categorías y Reseñas
- CRUD completo para gestión de categorías
- CRUD completo para reseñas con validación de rating

### Usuarios
- CRUD completo con validación de email
- Campo `is_active` protegido de modificación directa

## Datos de Prueba

La base de datos incluye datos iniciales:

- Usuarios: user1 a user5 (password: `secret123`)
- Categorías: Ficción, No Ficción, Ciencia, Historia, Fantasía
- Libros: 10 libros con diferentes categorías, reseñas y préstamos
- ISBNs: Formato ISBN-BD2-2025-XXXX
- Préstamos: Mezcla de activos, devueltos y vencidos
- Reseñas: 15 reseñas distribuidas entre libros

## Tecnologías

- Litestar 2.x: Framework web moderno y rápido
- SQLAlchemy + Advanced Alchemy: ORM y herramientas avanzadas
- Alembic: Migraciones de base de datos
- PostgreSQL: Base de datos relacional
- JWT: Autenticación con tokens
- pwdlib (argon2): Hash seguro de contraseñas
- Pydantic: Validación de datos

## Crear una copia privada de este repositorio

Para crear una copia privada de este repositorio en tu propia cuenta de GitHub, conservando el historial de commits, sigue estos pasos:

- Primero, crea un repositorio privado en tu cuenta de GitHub. Guarda la URL del nuevo repositorio.
- Luego, ejecuta los siguientes comandos en tu terminal, reemplazando `<URL_DE_TU_REPOSITORIO_PRIVADO>` con la URL de tu nuevo repositorio privado:
```bash
git clone https://github.com/dialvarezs/learning-litestar-bd2-2025 # Clona el repositorio
cd learning-litestar-bd2-2025
git remote remove origin                                           # Elimina el origen remoto existente
git remote add origin <URL_DE_TU_REPOSITORIO_PRIVADO>              # Agrega el nuevo origen remoto
git push -u origin main                                            # Sube la rama principal
```

## Documentación Interactiva

Una vez iniciado el servidor, accede a:
- http://localhost:8000/schema

Para usar los endpoints protegidos:
1. Haz login en `/auth/login` con Cris/Cris2006.
2. Copia el token de la respuesta
3. Click en "Authorize"
4. Pega el token(id=6) y autoriza
