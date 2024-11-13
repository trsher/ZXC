from PySide6.QtWidgets import (
    QApplication, QMainWindow, QWidget, QVBoxLayout, QHBoxLayout, QFrame, QLabel, QPushButton, QLineEdit, QDialog, QScrollArea, QTableWidget, QTableWidgetItem, 
)

from PySide6.QtCore import Qt
from PySide6.QtGui import QFont, QPixmap, QIcon
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey, select
from sqlalchemy.orm import sessionmaker, relationship
from sqlalchemy.ext.declarative import declarative_base
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from sqlalchemy import func
import sys

# Создание базы данных с помощью SQLAlchemy
Base = declarative_base()

# Модель данных для таблицы партнеров
class Partner(Base):
    __tablename__ = 'partners'
    partners_id = Column(Integer, primary_key=True, autoincrement=True)
    type_partner = Column(String)
    company_name = Column(String)
    u_address = Column(String)
    director_name = Column(String)
    phone = Column(String)
    rating = Column(Integer)
    partnerproducts = relationship("PartnerProduct", back_populates="partner_relation")

# Модель данных для таблицы продуктов партнеров
class PartnerProduct(Base):
    __tablename__ = 'partnerproduct'
    pp_id = Column(Integer, primary_key=True)
    id_partner = Column(Integer, ForeignKey('partners.partners_id'))
    id_product = Column(Integer)
    quantity = Column(Integer)
    partner_relation = relationship("Partner", back_populates="partnerproducts")

# Главный класс приложения
class PartnerApp(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("МастерПол")
        self.resize(700, 700)
        self.setWindowIcon(QIcon('icons.ico'))

        self.engine = create_engine('postgresql://postgres:1234@localhost:5432/postgres')
        Session = sessionmaker(bind=self.engine)
        self.session = Session()

        main_widget = QWidget()
        main_layout = QVBoxLayout()
        main_widget.setStyleSheet("background-color: white;")
        
        # Шапка с кнопками
        self.header = QWidget()
        header_layout = QHBoxLayout(self.header)
        self.header.setStyleSheet("background-color: #F4E8D3; padding: 10px;")

        # Кнопки "История", "Партнеры" и "Добавить"
        self.history_button = QPushButton("История")
        self.history_button.setStyleSheet("background-color: #67BA80; color: black; padding: 10px; border-radius: 5px;")
        self.history_button.clicked.connect(self.show_history)

        self.partners_button = QPushButton("Партнеры")
        self.partners_button.setStyleSheet("background-color: #67BA80; color: black; padding: 10px; border-radius: 5px;")
        self.partners_button.clicked.connect(self.load_partners)

        self.add_button = QPushButton("Добавить")
        self.add_button.setStyleSheet("background-color: #67BA80; color: black; padding: 10px; border-radius: 5px;")
        self.add_button.clicked.connect(self.open_add_partner_dialog)

        # Компоновка кнопок в шапке
        header_layout.addWidget(self.history_button)
        header_layout.addWidget(self.partners_button)
        header_layout.addWidget(self.add_button)

        # Логотип и название
        logo_label = QLabel()
        logo_pixmap = QPixmap('logotype.png').scaled(50, 50, Qt.KeepAspectRatio)
        logo_label.setPixmap(logo_pixmap)

        # Добавление логотипа и текста в одну горизонтальную компоновку
        logo_and_title_layout = QHBoxLayout()
        logo_and_title_layout.addWidget(logo_label)
        
        title_label = QLabel("Мастер пол")
        title_label.setFont(QFont("Segoe UI", 16, QFont.Bold))
        title_label.setStyleSheet("color: black;")
        logo_and_title_layout.addWidget(title_label)

        # Выравнивание по центру для логотипа и текста
        logo_and_title_layout.setAlignment(Qt.AlignCenter)

        # Вставляем компоновку логотипа и названия в шапку
        header_layout.addLayout(logo_and_title_layout)

        main_layout.addWidget(self.header)

        # Прокручиваемая область для списка партнеров
        scroll_area = QScrollArea()
        scroll_area.setWidgetResizable(True)
        scroll_widget = QWidget()
        self.partner_list_layout = QVBoxLayout(scroll_widget)
        scroll_area.setWidget(scroll_widget)
        main_layout.addWidget(scroll_area)

        main_widget.setLayout(main_layout)
        self.setCentralWidget(main_widget)

        self.load_partners()

    def show_history(self):
        history_dialog = HistoryDialog(self, self.session)
        history_dialog.exec()

    def open_add_partner_dialog(self):
        dialog = PartnerDialog(self, self.session)
        dialog.exec()
        self.load_partners()

    def open_edit_partner_dialog(self, event, partner_id, partner_type, partner_name, director_name, phone, rating):
        dialog = PartnerDialog(self, self.session, partner_id, partner_type, partner_name, director_name, phone, rating)
        dialog.exec()
        self.load_partners()

    def load_partners(self):
        while self.partner_list_layout.count():
            child = self.partner_list_layout.takeAt(0)
            if child.widget():
                child.widget().deleteLater()

        partners = self.session.query(Partner).all()
        for partner in partners:
            partner_id = partner.partners_id
            partner_type = partner.type_partner
            partner_name = partner.company_name
            director_name = partner.director_name
            phone = partner.phone
            rating = partner.rating
            
            
           # Запрос для получения общей суммы продаж партнера
            sales_query = self.session.execute(
                select(func.sum(PartnerProduct.quantity)).where(PartnerProduct.id_partner == partner_id)
            )           
            total_sales = sales_query.scalar() or 0
            discount = self.calculate_discount(total_sales)# Расчет скидки
            
            
            # Создание карточки партнера
            partner_card = QFrame()
            partner_card.setStyleSheet("background-color: #FFFFFF; border: 1px solid black; padding: 1px;")
            partner_card_layout = QHBoxLayout()

            partner_card.mousePressEvent = lambda event, pid=partner_id, pt=partner_type, pn=partner_name, dn=director_name, ph=phone, rt=rating: self.open_edit_partner_dialog(event, pid, pt, pn, dn, ph, rt)

            left_layout = QVBoxLayout()
            name_label = QLabel(f"{partner_type} | {partner_name}")
            name_label.setFont(QFont("Segoe UI", 12, QFont.Bold))
            name_label.setStyleSheet("color: black;border: 0px;")

            director_label = QLabel(f"Директор: {director_name}")
            phone_label = QLabel(f"Телефон: {phone}")
            rating_label = QLabel(f"Рейтинг: {rating}")
            for label in (director_label, phone_label, rating_label):
                label.setFont(QFont("Segoe UI", 10))
                label.setStyleSheet("color: black;border: 0px;")

            left_layout.addWidget(name_label)
            left_layout.addWidget(director_label)
            left_layout.addWidget(phone_label)
            left_layout.addWidget(rating_label)

            right_layout = QVBoxLayout()
            total_sales_label = QLabel(f"Сумма покупок: {total_sales}")
            total_sales_label.setFont(QFont("Segoe UI", 10, QFont.Bold))
            discount_label = QLabel(f"Скидка: {discount}")
            discount_label.setFont(QFont("Segoe UI", 10, QFont.Bold))
            for label in (total_sales_label, discount_label):
                label.setStyleSheet("color: black; border: 0px;")

            right_layout.addWidget(total_sales_label)
            right_layout.addWidget(discount_label)

            partner_card_layout.addLayout(left_layout)
            partner_card_layout.addLayout(right_layout)
            partner_card.setLayout(partner_card_layout)
            
            
            # Добавление карточки партнера в список
            self.partner_list_layout.addWidget(partner_card)

        self.partner_list_layout.addStretch()
        self.update()

    def calculate_discount(self, total_sales):
        if total_sales >= 300000:
            return "15%"
        elif total_sales >= 50000:
            return "10%"
        elif total_sales >= 10000:
            return "5%"
        else:
            return "0%"

class PartnerDialog(QDialog):
    def __init__(self, parent=None, session=None, partner_id=None, partner_type="", partner_name="", director_name="", phone="", rating=0):
        super().__init__(parent)
        self.setWindowTitle("Добавить или Редактировать Партнера")
        self.setFixedSize(300, 400)
        self.setStyleSheet("background-color: #F4E8D3; border: 1px solid #67BA80; padding: 15px;")

        self.session = session
        self.partner_id = partner_id

        self.name_input = QLineEdit(partner_name)
        self.name_input.setPlaceholderText("Название компании")
        
        self.type_input = QLineEdit(partner_type)
        self.type_input.setPlaceholderText("Тип партнера")
        
        self.director_input = QLineEdit(director_name)
        self.director_input.setPlaceholderText("Директор")

        self.phone_input = QLineEdit(phone)
        self.phone_input.setPlaceholderText("Телефон")

        self.rating_input = QLineEdit(str(rating))
        self.rating_input.setPlaceholderText("Рейтинг")

        for field in [self.name_input, self.type_input, self.director_input, self.phone_input, self.rating_input]:
            field.setStyleSheet("border: 1px solid black; padding: 5px;")
            field.setFont(QFont("Segoe UI", 10))

        self.save_button = QPushButton("Сохранить")
        self.save_button.setStyleSheet("background-color: #67BA80; color: white; padding: 10px; font-weight: bold; border-radius: 5px;")
        self.save_button.clicked.connect(self.save_partner)

        layout = QVBoxLayout()
        layout.addWidget(self.name_input)
        layout.addWidget(self.type_input)
        layout.addWidget(self.director_input)
        layout.addWidget(self.phone_input)
        layout.addWidget(self.rating_input)
        layout.addWidget(self.save_button)
        self.setLayout(layout)

    def save_partner(self):
        if self.partner_id is None:
            partner = Partner(
                type_partner=self.type_input.text(),
                company_name=self.name_input.text(),
                director_name=self.director_input.text(),
                phone=self.phone_input.text(),
                rating=int(self.rating_input.text())
            )
            self.session.add(partner)
        else:
            partner = self.session.query(Partner).filter(Partner.partners_id == self.partner_id).first()
            partner.type_partner = self.type_input.text()
            partner.company_name = self.name_input.text()
            partner.director_name = self.director_input.text()
            partner.phone = self.phone_input.text()
            partner.rating = int(self.rating_input.text())

        self.session.commit()
        self.accept()


class HistoryDialog(QDialog):
    def __init__(self, parent=None, session=None):
        super().__init__(parent)
        self.setWindowTitle("История реализации")
        self.setFixedSize(500, 500)
        self.setStyleSheet("background-color: #F4E8D3; border: 1px solid #67BA80; padding: 5px;")
        self.session = session

        self.layout = QVBoxLayout()
        self.table = QTableWidget(self)
        self.layout.addWidget(self.table)

        self.generate_report_button = QPushButton("Сгенерировать отчет PDF")
        self.generate_report_button.setStyleSheet("background-color: #67BA80; color: white; padding: 10px; font-weight: bold; border-radius: 5px;")
        self.generate_report_button.clicked.connect(self.generate_pdf_report)
        self.layout.addWidget(self.generate_report_button)

        self.setLayout(self.layout)

        self.load_history_data()

    def load_history_data(self):
        self.table.setRowCount(0)
        self.table.setColumnCount(3)
        self.table.setHorizontalHeaderLabels(["Партнер", "Продукция", "Количество"])

        # Стиль заголовков столбцов
        self.table.horizontalHeader().setStyleSheet(
            "QHeaderView::section {"
            "background-color: #F4E8D3; color: black; font-weight: bold; font-size: 12pt; padding: 2px; border: 0px solid black;}"
        )
        
        # Стиль для всей таблицы, чтобы шрифт был черным
        self.table.setStyleSheet("QTableWidget { color: black; background-color: #F4E8D3; }")
        
        # Загружаем данные из базы данных
        history_data = self.session.query(Partner, PartnerProduct).join(PartnerProduct).all()

        for i, (partner, product) in enumerate(history_data):
            self.table.insertRow(i)
            self.table.setItem(i, 0, QTableWidgetItem(partner.company_name))
            self.table.setItem(i, 1, QTableWidgetItem(str(product.id_product)))
            self.table.setItem(i, 2, QTableWidgetItem(str(product.quantity)))

            # Устанавливаем высоту строки
            self.table.setRowHeight(i, 50)

        # Устанавливаем минимальную ширину столбцов
        self.table.setColumnWidth(0, 250)  # Ширина столбца "Партнер"
        self.table.setColumnWidth(1, 150)  # Ширина столбца "Продукция"
        self.table.setColumnWidth(2, 150)  # Ширина столбца "Количество"

        # Автоматическая настройка ширины столбцов
        self.table.resizeColumnsToContents()

        # Это поможет столбцам занимать больше места, если контент не помещается
        self.table.horizontalHeader().setStretchLastSection(True)

    def generate_pdf_report(self):
        try:
            file_name = "report.pdf"
            c = canvas.Canvas(file_name, pagesize=letter)
            c.setFont("Segoe UI", 12)

            # Получаем данные для отчета
            history_data = self.session.query(Partner, PartnerProduct).join(PartnerProduct).all()

            if not history_data:
                print("Нет данных для отчета.")
                return

            y_position = 750  # Начальная позиция для записи текста
            c.drawString(30, y_position, "Отчет о партнерах и продуктах")
            y_position -= 20  # Сдвигаем вниз для следующего текста

            # Записываем данные по каждому партнеру и продукту
            for partner, product in history_data:
                text = f"Партнер: {partner.company_name}, Продукция: {product.id_product}, Количество: {product.quantity}"
                c.drawString(30, y_position, text)
                y_position -= 20  # Сдвигаем вниз после записи

                # Если текст выходит за пределы страницы, добавляем новую страницу
                if y_position < 50:
                    c.showPage()  # Перенос на новую страницу
                    c.setFont("Segoe UI", 12)  # Сброс шрифта на новый
                    y_position = 750  # Сбрасываем высоту

            c.save()
            print(f"Отчет сохранен в {file_name}")
        except Exception as e:
            print(f"Произошла ошибка при создании отчета: {e}")


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = PartnerApp()
    window.show()
    sys.exit(app.exec())