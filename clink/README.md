# Clink

[Clink](https://github.com/chrisant996/clink) bổ sung cho `cmd.exe` các tính năng như readline, autosuggest, màu cú pháp, lịch sử mạnh hơn.

Thư mục này có script cài Clink kèm config cá nhân.

## Cài đặt

Chạy [install.bat](install.bat) (double-click, hoặc `install.bat` trong cmd / `.\install.bat` trong PowerShell). Không cần quyền admin. Script làm 2 việc:

1. **Cài Clink nếu máy chưa có:** tải bản mới nhất từ GitHub, giải nén vào `%LOCALAPPDATA%\clink-app\<phiên bản>` rồi chạy `clink autorun install` để Clink tự nạp mỗi khi mở `cmd`. Nếu đã có Clink (trong `Program Files` hoặc `clink-app`) thì bỏ qua bước này.
2. **Áp dụng config:** chép [clink_settings](clink_settings) vào `%LOCALAPPDATA%\clink\clink_settings`. Nếu đã có config cũ thì sao lưu thành `clink_settings.bak`.

Xong thì mở cửa sổ `cmd` mới. Cần có mạng khi cài lần đầu.

### Cập nhật

Không cần làm gì: Clink có cơ chế tự cập nhật riêng (`clink.autoupdate`, mặc định là kiểm tra bản mới và báo cho bạn). Chạy lại `install.bat` chỉ để áp dụng lại config.

> Config trong repo sẽ **ghi đè** `clink_settings` hiện tại. Nếu bạn chỉnh trực tiếp bằng `clink set`, hãy chép ngược về file `clink_settings` trong thư mục này trước khi chạy lại.

## Config đang dùng

File [clink_settings](clink_settings) (xuất từ máy gốc, chỉ chứa phần khác mặc định):

- Autosuggest bật (gợi ý nội dung gõ dở, hiện inline).
- Phím tắt kiểu Windows (`clink.default_bindings = windows`), `Ctrl+D` không thoát shell.
- Bảng màu 256 màu cho lệnh, flag, tham số, gợi ý...
- Lịch sử tối đa 25000 dòng, có dấu thời gian, không tự mở rộng `!`.
- Khớp chuỗi con (`match.substring`) và mở rộng biến môi trường khi gợi ý.

## Gỡ cài đặt

```bat
%LOCALAPPDATA%\clink-app\<phiên bản>\clink_x64.exe autorun uninstall
```

Sau đó xoá thư mục `%LOCALAPPDATA%\clink-app`.

## Ghi chú

- Nếu máy đã cài Clink bằng installer (ví dụ vào `Program Files`), `install.bat` giữ nguyên bản đó và chỉ áp dụng config.
