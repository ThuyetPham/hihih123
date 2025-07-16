# -*- coding: utf-8 -*-
"""
Login Page Object
Xử lý các thao tác trên màn hình đăng nhập
"""

import time
from typing import Optional
from .BasePage import BasePage

class LoginPage(BasePage):
    """
    Login Page Object
    Xử lý các thao tác trên màn hình đăng nhập
    """
    
    # Locators
    USERNAME_FIELD = "id=com.example.app:id/username_field"
    PASSWORD_FIELD = "id=com.example.app:id/password_field"
    LOGIN_BUTTON = "id=com.example.app:id/login_button"
    FORGOT_PASSWORD_LINK = "id=com.example.app:id/forgot_password_link"
    REGISTER_LINK = "id=com.example.app:id/register_link"
    ERROR_MESSAGE = "id=com.example.app:id/error_message"
    SUCCESS_MESSAGE = "id=com.example.app:id/success_message"
    LOADING_INDICATOR = "id=com.example.app:id/loading_indicator"
    
    # Page title
    PAGE_TITLE = "Đăng nhập"
    
    def __init__(self, driver=None):
        """Khởi tạo Login Page"""
        super().__init__(driver)
        self.logger.info("Khởi tạo Login Page")
    
    def is_page_loaded(self) -> bool:
        """
        Kiểm tra Login page đã load xong chưa
        
        Returns:
            bool: True nếu page đã load, False nếu chưa
        """
        try:
            return (self.is_element_visible(self.USERNAME_FIELD) and 
                   self.is_element_visible(self.PASSWORD_FIELD) and
                   self.is_element_visible(self.LOGIN_BUTTON))
        except Exception as e:
            self.logger.error(f"Lỗi khi kiểm tra page load: {e}")
            return False
    
    def wait_for_page(self, timeout: int = None) -> bool:
        """
        Chờ Login page load xong
        
        Args:
            timeout: Thời gian chờ (giây)
            
        Returns:
            bool: True nếu page load thành công, False nếu không
        """
        timeout = timeout or self.page_load_timeout
        start_time = time.time()
        
        while time.time() - start_time < timeout:
            if self.is_page_loaded():
                self.logger.info("Login page đã load thành công")
                return True
            time.sleep(1)
        
        self.logger.error(f"Login page không load sau {timeout}s")
        return False
    
    def enter_username(self, username: str) -> bool:
        """
        Nhập username
        
        Args:
            username: Tên đăng nhập
            
        Returns:
            bool: True nếu nhập thành công, False nếu không
        """
        return self.input_text(self.USERNAME_FIELD, username)
    
    def enter_password(self, password: str) -> bool:
        """
        Nhập password
        
        Args:
            password: Mật khẩu
            
        Returns:
            bool: True nếu nhập thành công, False nếu không
        """
        return self.input_text(self.PASSWORD_FIELD, password)
    
    def click_login_button(self) -> bool:
        """
        Click nút đăng nhập
        
        Returns:
            bool: True nếu click thành công, False nếu không
        """
        return self.click_element(self.LOGIN_BUTTON)
    
    def click_forgot_password(self) -> bool:
        """
        Click link quên mật khẩu
        
        Returns:
            bool: True nếu click thành công, False nếu không
        """
        return self.click_element(self.FORGOT_PASSWORD_LINK)
    
    def click_register_link(self) -> bool:
        """
        Click link đăng ký
        
        Returns:
            bool: True nếu click thành công, False nếu không
        """
        return self.click_element(self.REGISTER_LINK)
    
    def login(self, username: str, password: str) -> bool:
        """
        Thực hiện đăng nhập
        
        Args:
            username: Tên đăng nhập
            password: Mật khẩu
            
        Returns:
            bool: True nếu đăng nhập thành công, False nếu không
        """
        try:
            self.logger.info(f"Thực hiện đăng nhập với username: {username}")
            
            # Nhập username
            if not self.enter_username(username):
                self.logger.error("Không thể nhập username")
                return False
            
            # Nhập password
            if not self.enter_password(password):
                self.logger.error("Không thể nhập password")
                return False
            
            # Click nút đăng nhập
            if not self.click_login_button():
                self.logger.error("Không thể click nút đăng nhập")
                return False
            
            # Chờ loading
            self.wait_for_loading_to_complete()
            
            self.logger.info("Đăng nhập thành công")
            return True
            
        except Exception as e:
            self.logger.error(f"Lỗi khi đăng nhập: {e}")
            return False
    
    def get_error_message(self) -> Optional[str]:
        """
        Lấy thông báo lỗi
        
        Returns:
            str: Nội dung thông báo lỗi hoặc None
        """
        return self.get_element_text(self.ERROR_MESSAGE)
    
    def get_success_message(self) -> Optional[str]:
        """
        Lấy thông báo thành công
        
        Returns:
            str: Nội dung thông báo thành công hoặc None
        """
        return self.get_element_text(self.SUCCESS_MESSAGE)
    
    def is_error_displayed(self) -> bool:
        """
        Kiểm tra có hiển thị thông báo lỗi không
        
        Returns:
            bool: True nếu có lỗi, False nếu không
        """
        return self.is_element_visible(self.ERROR_MESSAGE)
    
    def is_success_displayed(self) -> bool:
        """
        Kiểm tra có hiển thị thông báo thành công không
        
        Returns:
            bool: True nếu thành công, False nếu không
        """
        return self.is_element_visible(self.SUCCESS_MESSAGE)
    
    def wait_for_loading_to_complete(self, timeout: int = 10):
        """
        Chờ loading hoàn thành
        
        Args:
            timeout: Thời gian chờ (giây)
        """
        start_time = time.time()
        
        while time.time() - start_time < timeout:
            if not self.is_element_visible(self.LOADING_INDICATOR):
                self.logger.info("Loading đã hoàn thành")
                return
            time.sleep(0.5)
        
        self.logger.warning(f"Loading không hoàn thành sau {timeout}s")
    
    def clear_fields(self):
        """Xóa nội dung các trường nhập liệu"""
        try:
            self.appium.clear_text(self.USERNAME_FIELD)
            self.appium.clear_text(self.PASSWORD_FIELD)
            self.logger.info("Đã xóa nội dung các trường nhập liệu")
        except Exception as e:
            self.logger.error(f"Lỗi khi xóa nội dung: {e}")
    
    def is_login_button_enabled(self) -> bool:
        """
        Kiểm tra nút đăng nhập có enabled không
        
        Returns:
            bool: True nếu enabled, False nếu không
        """
        return self.is_element_enabled(self.LOGIN_BUTTON)
    
    def get_username_field_text(self) -> Optional[str]:
        """
        Lấy nội dung trường username
        
        Returns:
            str: Nội dung username hoặc None
        """
        return self.get_element_text(self.USERNAME_FIELD)
    
    def get_password_field_text(self) -> Optional[str]:
        """
        Lấy nội dung trường password
        
        Returns:
            str: Nội dung password hoặc None
        """
        return self.get_element_text(self.PASSWORD_FIELD) 