"""Repository for Loan database operations."""

from datetime import date
from decimal import Decimal
from typing import Sequence

from advanced_alchemy.repository import SQLAlchemySyncRepository
from litestar.exceptions import HTTPException
from sqlalchemy.orm import Session

from app.models import Loan, LoanStatus


class LoanRepository(SQLAlchemySyncRepository[Loan]):
    """Repository for loan database operations."""

    model_type = Loan

    def get_active_loans(self) -> Sequence[Loan]:
        """Préstamos con status == ACTIVE"""
        return self.list(Loan.status == LoanStatus.ACTIVE)

    def get_overdue_loans(self) -> Sequence[Loan]:
        """Préstamos con due_date pasado y status == ACTIVE, actualizar su status a OVERDUE"""
        today = date.today()
        overdue_loans = self.list(
            Loan.due_date < today,
            Loan.status == LoanStatus.ACTIVE,
        )
        
        for loan in overdue_loans:
            loan.status = LoanStatus.OVERDUE
        
        self.session.commit()
        return overdue_loans

    def calculate_fine(self, loan_id: int) -> Decimal:
        """Calcular multa ($500 por día de retraso)"""
        loan = self.get(loan_id)
        
        if loan.status != LoanStatus.OVERDUE:
            return Decimal("0.00")
        
        today = date.today()
        days_overdue = (today - loan.due_date).days
        
        if days_overdue <= 0:
            return Decimal("0.00")
        
        fine = Decimal(str(days_overdue * 500))
        return fine

    def return_book(self, loan_id: int) -> Loan:
        """Procesar devolución (actualizar status a RETURNED, establecer return_dt a la fecha actual, 
        calcular y guardar fine_amount si corresponde, incrementar stock)"""
        loan = self.get(loan_id)
        
        if loan.status == LoanStatus.RETURNED:
            raise HTTPException(
                detail="El préstamo ya fue devuelto",
                status_code=400,
            )
        
        # Actualizar status y return_dt
        loan.status = LoanStatus.RETURNED
        loan.return_dt = date.today()
        
        # Calcular multa si hay retraso
        if loan.return_dt > loan.due_date:
            days_overdue = (loan.return_dt - loan.due_date).days
            loan.fine_amount = Decimal(str(days_overdue * 500))
        else:
            loan.fine_amount = Decimal("0.00")
        
        # Incrementar stock del libro
        loan.book.stock += 1
        
        self.session.commit()
        self.session.refresh(loan)
        return loan

    def get_user_loan_history(self, user_id: int) -> Sequence[Loan]:
        """Historial completo de préstamos de un usuario ordenado por fecha"""
        return self.list(
            Loan.user_id == user_id,
            order_by=Loan.loan_dt.desc(),
        )


async def provide_loan_repo(db_session: Session) -> LoanRepository:
    """Provide loan repository instance with auto-commit."""
    return LoanRepository(session=db_session, auto_commit=True)