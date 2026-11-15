# Setup của DucHA

Repo lưu cấu hình cá nhân để dựng lại môi trường làm việc nhanh mỗi khi đổi máy. Mỗi thư mục là một phần độc lập, có script riêng và README riêng.

## Cấu trúc

| Thư mục | Nội dung | Cách dùng |
| ------- | -------- | --------- |
| [font/](font/) | Font SF Mono Ligatures (12 file `.otf`) | `font\install.bat` |
| [clink/](clink/) | Cài Clink (nâng cấp `cmd`) và áp dụng config cá nhân | `clink\install.bat` |
| [skills/](skills/) | Skill dùng chung cho Claude Code và Codex | `skills\sync.bat [claude\|codex]` |

## Dựng máy mới

Yêu cầu: Windows, `git`, kết nối mạng. Clone repo rồi chạy lần lượt (không cần quyền admin):

```bat
git clone <url-repo-nay> setup
cd setup

font\install.bat           :: cài font, sau đó khởi động lại VS Code / terminal
clink\install.bat          :: cài Clink + config, mở cmd mới để dùng
skills\sync.bat            :: đồng bộ skill vào Claude global
skills\sync.bat codex      :: (tuỳ chọn) đồng bộ vào Codex global
```

Cần Node.js nếu dùng một số skill (ví dụ `agent-browser`, `hallmark`).

## Cập nhật

- **Skill:** `skills\update.bat sync` kéo bản mới của các skill từ repo gốc (khai báo trong `skills\sources.txt`) rồi đồng bộ vào Claude global; thêm `codex` ở cuối cho Codex.
- **Clink:** tự cập nhật bằng cơ chế có sẵn của Clink; chạy lại `clink\install.bat` chỉ để áp dụng lại config.
- **Font:** không đổi; chạy lại `font\install.bat` nếu cần cài lại.

## Quy ước

- Mỗi thư mục tự mô tả đầy đủ trong README của nó; file này chỉ là bản đồ và thứ tự chạy.
- Các `install.bat` / `sync.bat` chạy lại nhiều lần vẫn an toàn.
- Cấu hình sửa trực tiếp trên máy (ví dụ `clink set`, sửa skill ở thư mục global) sẽ bị ghi đè lần chạy sau. Muốn giữ thì sửa trong repo này rồi chạy lại script.
- Đổi máy: chép thay đổi mới nhất vào repo, commit và push trước khi rời máy cũ.

## Lưu ý

- Font SF Mono là sản phẩm của Apple; xem phần bản quyền trong [font/README.md](font/README.md) trước khi chia sẻ repo công khai.
