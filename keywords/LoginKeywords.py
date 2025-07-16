# -*- coding: utf-8 -*-
"""
Login Keywords cho Robot Framework
Cung cấp các keywords chuyên biệt cho chức năng đăng nhập
"""

import time
import logging
from robot.api import logger
from robot.libraries.BuiltIn import BuiltIn
from AppiumLibrary import AppiumLibrary
from pageobjects.LoginPage import LoginPage

class LoginKeywords:
    """
    Login Keywords cho Robot Framework
    Cung cấp các keywords chuyên biệt cho chức năng đăng nhập
    """
    
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    def __init__(self):
        """Khởi tạo Login Keywords"""
        self.builtin = BuiltIn()
        self.appium = AppiumLibrary()
        self.logger = logging.getLogger(self.__class__.__name__)
        self.login_page = None
        
        # Timeouts
        self.implicit_timeout = 10
        self.explicit_timeout = 20
        self.page_load_timeout = 30
    
    def initialize_login_page(self):
        """Khởi tạo Login Page Object"""
        try:
            self.login_page = LoginPage()
            self.logger.info("Đã khởi tạo Login Page Object")
        except Exception as e:
            self.logger.error(f"Lỗi khi khởi tạo Login Page Object: {e}")
            raise
    
    def navigate_to_login_screen(self):
        """Điều hướng đến màn hình đăng nhập"""
        try:
            # Giả sử app mở ra màn hình đăng nhập đầu tiên
            # Nếu không, cần thêm logic điều hướng
            self.logger.info("Đang ở màn hình đăng nhập")
            
            # Chờ màn hình đăng nhập load
            self.wait_for_login_screen()
            
        except Exception as e:
            self.logger.error(f"Lỗi khi điều hướng đến màn hình đăng nhập: {e}")
            raise
    
    def wait_for_login_screen(self, timeout=None):
        """
        Chờ màn hình đăng nhập load xong
        
        Args:
            timeout: Thời gian chờ (giây)
        """
        timeout = timeout or self.page_load_timeout
        try:
            # Chờ các element cơ bản xuất hiện
            self.appium.wait_until_element_is_visible("id=com.example.app:id/username_field", timeout)
            self.appium.wait_until_element_is_visible("id=com.example.app:id/password_field", timeout)
            self.appium.wait_until_element_is_visible("id=com.example.app:id/login_button", timeout)
            
            self.logger.info("Màn hình đăng nhập đã load xong")
            
        except Exception as e:
            self.logger.error(f"Lỗi khi chờ màn hình đăng nhập: {e}")
            raise
    
    def enter_username(self, username):
        """
        Nhập tên đăng nhập
        
        Args:
            username: Tên đăng nhập
        """
        try:
            self.appium.input_text("id=com.example.app:id/username_field", username)
            self.logger.info(f"Đã nhập username: {username}")
        except Exception as e:
            self.logger.error(f"Lỗi khi nhập username: {e}")
            raise
    
    def enter_password(self, password):
        """
        Nhập mật khẩu
        
        Args:
            password: Mật khẩu
        """
        try:
            self.appium.input_text("id=com.example.app:id/password_field", password)
            self.logger.info("Đã nhập password")
        except Exception as e:
            self.logger.error(f"Lỗi khi nhập password: {e}")
            raise
    
    def click_login_button(self):
        """Click nút đăng nhập"""
        try:
            self.appium.click_element("id=com.example.app:id/login_button")
            self.logger.info("Đã click nút đăng nhập")
        except Exception as e:
            self.logger.error(f"Lỗi khi click nút đăng nhập: {e}")
            raise
    
    def perform_login(self, username, password):
        """
        Thực hiện đăng nhập
        
        Args:
            username: Tên đăng nhập
            password: Mật khẩu
        """
        try:
            self.logger.info(f"Thực hiện đăng nhập với username: {username}")
            
            # Nhập username
            self.enter_username(username)
            
            # Nhập password
            self.enter_password(password)
            
            # Click nút đăng nhập
            self.click_login_button()
            
            # Chờ loading
            self.wait_for_login_loading()
            
            self.logger.info("Đăng nhập hoàn tất")
            
        except Exception as e:
            self.logger.error(f"Lỗi khi thực hiện đăng nhập: {e}")
            raise
    
    def wait_for_login_loading(self, timeout=10):
        """
        Chờ loading đăng nhập hoàn thành
        
        Args:
            timeout: Thời gian chờ (giây)
        """
        try:
            start_time = time.time()
            
            while time.time() - start_time < timeout:
                try:
                    # Kiểm tra loading indicator có còn hiển thị không
                    self.appium.element_should_not_be_visible("id=com.example.app:id/loading_indicator")
                    self.logger.info("Loading đăng nhập đã hoàn thành")
                    return
                except:
                    time.sleep(0.5)
            
            self.logger.warning(f"Loading đăng nhập không hoàn thành sau {timeout}s")
            
        except Exception as e:
            self.logger.error(f"Lỗi khi chờ loading đăng nhập: {e}")
            raise
    
    def verify_login_success(self):
        """Xác minh đăng nhập thành công"""
        try:
            # Chờ màn hình dashboard xuất hiện
            self.appium.wait_until_element_is_visible("id=com.example.app:id/dashboard", 10)
            
            # Kiểm tra không còn màn hình đăng nhập
            self.appium.element_should_not_be_visible("id=com.example.app:id/login_button")
            
            self.logger.info("Đăng nhập thành công")
            
        except Exception as e:
            self.logger.error(f"Lỗi khi xác minh đăng nhập thành công: {e}")
            raise
    
    def verify_login_failure(self, expected_error):
        """
        Xác minh đăng nhập thất bại
        
        Args:
            expected_error: Thông báo lỗi mong đợi
        """
        try:
            # Chờ thông báo lỗi xuất hiện
            self.appium.wait_until_element_is_visible("id=com.example.app:id/error_message", 10)
            
            # Kiểm tra nội dung thông báo lỗi
            error_text = self.appium.get_text("id=com.example.app:id/error_message")
            
            if expected_error not in error_text:
                raise AssertionError(f"Thông báo lỗi không khớp. Mong đợi: {expected_error}, Thực tế: {error_text}")
            
            self.logger.info(f"Đăng nhập thất bại với thông báo: {expected_error}")
            
        except Exception as e:
            self.logger.error(f"Lỗi khi xác minh đăng nhập thất bại: {e}")
            raise
    
    def clear_login_fields(self):
        """Xóa nội dung các trường đăng nhập"""
        try:
            self.appium.clear_text("id=com.example.app:id/username_field")
            self.appium.clear_text("id=com.example.app:id/password_field")
            self.logger.info("Đã xóa nội dung các trường đăng nhập")
        except Exception as e:
            self.logger.error(f"Lỗi khi xóa nội dung: {e}")
            raise
    
    def verify_login_screen_elements(self):
        """Xác minh các element trên màn hình đăng nhập"""
        try:
            # Kiểm tra các element cơ bản
            self.appium.element_should_be_visible("id=com.example.app:id/username_field")
            self.appium.element_should_be_visible("id=com.example.app:id/password_field")
            self.appium.element_should_be_visible("id=com.example.app:id/login_button")
            self.appium.element_should_be_visible("id=com.example.app:id/forgot_password_link")
            self.appium.element_should_be_visible("id=com.example.app:id/register_link")
            
            # Kiểm tra các element có enabled
            self.appium.element_should_be_enabled("id=com.example.app:id/username_field")
            self.appium.element_should_be_enabled("id=com.example.app:id/password_field")
            self.appium.element_should_be_enabled("id=com.example.app:id/login_button")
            
            self.logger.info("Tất cả element trên màn hình đăng nhập đều hiển thị và enabled")
            
        except Exception as e:
            self.logger.error(f"Lỗi khi xác minh element màn hình đăng nhập: {e}")
            raise
    
    def click_forgot_password_link(self):
        """Click link quên mật khẩu"""
        try:
            self.appium.click_element("id=com.example.app:id/forgot_password_link")
            self.logger.info("Đã click link quên mật khẩu")
        except Exception as e:
            self.logger.error(f"Lỗi khi click link quên mật khẩu: {e}")
            raise
    
    def click_register_link(self):
        """Click link đăng ký"""
        try:
            self.appium.click_element("id=com.example.app:id/register_link")
            self.logger.info("Đã click link đăng ký")
        except Exception as e:
            self.logger.error(f"Lỗi khi click link đăng ký: {e}")
            raise
    
    def toggle_password_visibility(self):
        """Chuyển đổi hiển thị/ẩn mật khẩu"""
        try:
            # Kiểm tra trạng thái hiện tại
            try:
                self.appium.element_should_be_visible("id=com.example.app:id/password_visible_icon")
                # Nếu hiển thị, click để ẩn
                self.appium.click_element("id=com.example.app:id/hide_password_button")
                self.logger.info("Đã ẩn mật khẩu")
            except:
                # Nếu ẩn, click để hiển thị
                self.appium.click_element("id=com.example.app:id/show_password_button")
                self.logger.info("Đã hiển thị mật khẩu")
                
        except Exception as e:
            self.logger.error(f"Lỗi khi chuyển đổi hiển thị mật khẩu: {e}")
            raise
    
    def verify_password_visible(self):
        """Xác minh mật khẩu đang hiển thị"""
        try:
            self.appium.element_should_be_visible("id=com.example.app:id/password_visible_icon")
            self.logger.info("Mật khẩu đang hiển thị")
        except Exception as e:
            self.logger.error(f"Lỗi khi xác minh mật khẩu hiển thị: {e}")
            raise
    
    def verify_password_hidden(self):
        """Xác minh mật khẩu đang ẩn"""
        try:
            self.appium.element_should_not_be_visible("id=com.example.app:id/password_visible_icon")
            self.logger.info("Mật khẩu đang ẩn")
        except Exception as e:
            self.logger.error(f"Lỗi khi xác minh mật khẩu ẩn: {e}")
            raise
    
    def check_remember_login_checkbox(self):
        """Tích vào checkbox ghi nhớ đăng nhập"""
        try:
            self.appium.click_element("xpath=//android.widget.CheckBox[@text='Ghi nhớ đăng nhập']")
            self.logger.info("Đã tích vào checkbox ghi nhớ đăng nhập")
        except Exception as e:
            self.logger.error(f"Lỗi khi tích checkbox ghi nhớ đăng nhập: {e}")
            raise
    
    def verify_auto_login(self):
        """Xác minh tự động đăng nhập"""
        try:
            # Kiểm tra đã ở màn hình dashboard
            self.appium.element_should_be_visible("id=com.example.app:id/dashboard")
            
            # Kiểm tra không còn màn hình đăng nhập
            self.appium.element_should_not_be_visible("id=com.example.app:id/login_button")
            
            self.logger.info("Tự động đăng nhập thành công")
            
        except Exception as e:
            self.logger.error(f"Lỗi khi xác minh tự động đăng nhập: {e}")
            raise 