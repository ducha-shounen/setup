# Skills

Nơi lưu trữ tập trung các skill dùng chung cho Claude Code và Codex. Mỗi thư mục con có `SKILL.md` là một skill; `sync.bat` đẩy chúng sang thư mục skill global của từng công cụ để dùng ở mọi dự án.

## Đồng bộ vào global

Dùng [sync.bat](sync.bat). Chạy trong cmd hoặc PowerShell, tại thư mục này (hoặc double-click để sync Claude):

```bat
:: Mặc định: Claude  ->  %USERPROFILE%\.claude\skills
sync.bat

:: Codex  ->  %USERPROFILE%\.codex\skills
sync.bat codex

:: Ghi đè thư mục đích
sync.bat codex D:\my\skills
```

(Trong PowerShell dùng `.\sync.bat codex`.)

### Tham số

| Vị trí | Mặc định    | Ý nghĩa                 |
| ------ | ----------- | ----------------------- |
| 1      | `claude`    | `claude` hoặc `codex`   |
| 2      | theo target | Thư mục đích (tuỳ chọn) |

### Hành vi

- Mỗi skill được mirror riêng (`robocopy /MIR`): file đã xoá ở nguồn sẽ bị xoá ở đích **trong thư mục skill đó**.
- Skill khác đang có sẵn ở đích mà không nằm trong thư mục này thì **không bị đụng tới**.
- Sửa skill ở đây rồi chạy lại lệnh để cập nhật. Đừng sửa trực tiếp ở thư mục global vì sẽ bị ghi đè.
- Cần mở phiên Claude Code / Codex mới để nhận skill mới.

## Cập nhật skill từ repo gốc

Các skill ở đây được lấy từ repo bên ngoài và có thể đổi theo thời gian. Nguồn của từng skill (repo + đường dẫn) khai báo trong [sources.txt](sources.txt), mỗi dòng một skill:

```text
<tên-skill>  <repo-git>  <đường-dẫn-trong-repo>
```

Dùng [update.bat](update.bat) để kéo bản mới:

```bat
:: Chỉ cập nhật thư mục này, in skill nào có thay đổi
update.bat

:: Cập nhật rồi đồng bộ luôn vào Claude global
update.bat sync

:: Cập nhật rồi đồng bộ vào Codex global
update.bat sync codex
```

Script chỉ tải phần cần thiết: với mỗi repo nó hỏi commit mới nhất (`git ls-remote`), nếu không đổi so với lần trước thì bỏ qua hẳn (chạy lại mất vài giây). Nếu có đổi, nó clone nông kiểu sparse, chỉ lấy đúng thư mục skill khai báo trong `sources.txt` chứ không tải cả repo (repo lớn như hallmark ~230 MB). Sau đó so sánh nội dung từng skill, chỉ ghi đè skill nào thực sự khác và in `[CAP NHAT]` hoặc `[giu nguyen]`. Cần có `git` và mạng.

Commit đã xử lý lưu trong `.update-state.json`; xoá file này nếu muốn ép tải lại.

> Sửa trực tiếp skill nguồn ở đây sẽ bị `update.bat` ghi đè. Muốn giữ chỉnh sửa riêng, hãy đổi tên skill đó và bỏ dòng tương ứng khỏi `sources.txt`.

### Thêm skill mới

1. Thêm một dòng vào `sources.txt`.
2. Chạy `update.bat sync` (skill mới được tải về và đồng bộ).

Skill tự viết, không có repo gốc: chép thư mục (có `SKILL.md`) vào đây rồi chạy `sync.bat`.

### Dành cho agent

Khi người dùng bảo "cập nhật skill": chạy `update.bat sync` (thêm `codex` nếu là Codex) trong thư mục này, rồi báo lại những skill có `[CAP NHAT]`. Danh sách nguồn và link repo nằm trong `sources.txt`; không tự sửa file skill bằng tay vì sẽ bị ghi đè lần cập nhật sau.
