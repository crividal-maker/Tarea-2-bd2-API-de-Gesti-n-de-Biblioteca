"""Repository for Book database operations."""

from typing import Sequence

from advanced_alchemy.repository import SQLAlchemySyncRepository
from litestar.exceptions import HTTPException
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from app.models import Book


class BookRepository(SQLAlchemySyncRepository[Book]):
    """Repository for book database operations."""

    model_type = Book

    def get_available_books(self) -> Sequence[Book]:
        """Retornar libros con stock > 0"""
        return self.list(Book.stock > 0)

    def find_by_category(self, category_id: int) -> Sequence[Book]:
        """Buscar libros de una categoría"""
        from app.models import book_categories
        
        stmt = (
            select(Book)
            .join(book_categories)
            .where(book_categories.c.category_id == category_id)
        )
        return self.session.execute(stmt).scalars().all()

    def get_most_reviewed_books(self, limit: int = 10) -> Sequence[Book]:
        """Libros ordenados por cantidad de reseñas (usar func.count() de SQLAlchemy)"""
        from app.models import Review
        
        stmt = (
            select(Book)
            .outerjoin(Review)
            .group_by(Book.id)
            .order_by(func.count(Review.id).desc())
            .limit(limit)
        )
        return self.session.execute(stmt).scalars().all()

    def update_stock(self, book_id: int, quantity: int) -> Book:
        """Actualizar stock de un libro, validar que no quede negativo"""
        book = self.get(book_id)
        new_stock = book.stock + quantity
        
        if new_stock < 0:
            raise HTTPException(
                detail="El stock no puede ser negativo",
                status_code=400,
            )
        
        book.stock = new_stock
        self.session.commit()
        self.session.refresh(book)
        return book

    def search_by_author(self, author_name: str) -> Sequence[Book]:
        """Buscar libros por nombre de autor (búsqueda parcial usando ilike)"""
        return self.list(Book.author.ilike(f"%{author_name}%"))


async def provide_book_repo(db_session: Session) -> BookRepository:
    """Provide book repository instance with auto-commit."""
    return BookRepository(session=db_session, auto_commit=True)