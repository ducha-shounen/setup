# SF Mono Ligatures

Phiên bản **SF Mono** có hỗ trợ **ligature** (chữ ghép) dành cho lập trình viên, đóng gói dưới dạng file OpenType (`.otf`) với đầy đủ 6 độ đậm và các kiểu nghiêng tương ứng.

## Mục lục

- [Giới thiệu](#giới-thiệu)
- [Danh sách file font](#danh-sách-file-font)
- [Cài đặt](#cài-đặt)
- [Cấu hình trình soạn thảo](#cấu-hình-trình-soạn-thảo)
- [Ligature là gì?](#ligature-là-gì)
- [Xử lý sự cố](#xử-lý-sự-cố)
- [Bản quyền và giấy phép](#bản-quyền-và-giấy-phép)

## Giới thiệu

SF Mono là font monospace do Apple thiết kế, nổi tiếng với độ rõ nét ở cỡ chữ nhỏ và rất hợp để đọc code. Bản gốc không có ligature. Dự án này cung cấp bản font có thêm ligature để các ký hiệu lập trình thường gặp (ví dụ `=>`, `!=`, `->`, `>=`) hiển thị thành một glyph liền mạch, dễ đọc hơn.

**Đặc điểm**

- 12 file font: 6 độ đậm × 2 kiểu (thẳng / nghiêng)
- Định dạng OpenType (`.otf`), dùng được trên Windows, macOS và Linux
- Hỗ trợ ligature qua tính năng OpenType `liga` / `calt`
- Giữ nguyên độ rộng ký tự cố định (monospace)

## Danh sách file font

| Độ đậm   | Thẳng (Upright)                  | Nghiêng (Italic)                       |
| -------- | -------------------------------- | -------------------------------------- |
| Light    | `SFMonoLigatures-Light.otf`      | `SFMonoLigatures-LightItalic.otf`      |
| Regular  | `SFMonoLigatures-Regular.otf`    | `SFMonoLigatures-RegularItalic.otf`    |
| Medium   | `SFMonoLigatures-Medium.otf`     | `SFMonoLigatures-MediumItalic.otf`     |
| Semibold | `SFMonoLigatures-Semibold.otf`   | `SFMonoLigatures-SemiboldItalic.otf`   |
| Bold     | `SFMonoLigatures-Bold.otf`       | `SFMonoLigatures-BoldItalic.otf`       |
| Heavy    | `SFMonoLigatures-Heavy.otf`      | `SFMonoLigatures-HeavyItalic.otf`      |

## Cài đặt

Tải hoặc clone repo:

```bash
git clone <url-repo-cua-ban>
cd SFMonoLigatures
```

### Windows

**Cách nhanh (khuyên dùng):** chạy [install.bat](install.bat) (double-click, hoặc `install.bat` trong cmd / `.\install.bat` trong PowerShell).

- Cài tất cả file `.otf` trong thư mục này cho **user hiện tại**, không cần quyền admin.
- Font được chép vào `%LOCALAPPDATA%\Microsoft\Windows\Fonts` và đăng ký trong `HKCU`.
- Chạy lại nhiều lần vẫn an toàn (ghi đè bản cũ). Nếu font đang được ứng dụng dùng mà báo `[LOI]`, hãy đóng ứng dụng rồi chạy lại.
- Xong thì khởi động lại VS Code / terminal để nhận font.

**Cách thủ công:**

1. Chọn tất cả các file `.otf`.
2. Nhấp chuột phải → **Install** (hoặc **Install for all users**).
3. Khởi động lại ứng dụng đang dùng font.

Hoặc kéo thả các file vào `Settings → Personalization → Fonts`.

### macOS

1. Mở các file `.otf` bằng **Font Book** (nhấp đúp từng file).
2. Chọn **Install Font**.
3. Khởi động lại ứng dụng.

Hoặc chép thủ công vào `~/Library/Fonts`.

### Linux

```bash
mkdir -p ~/.local/share/fonts/SFMonoLigatures
cp *.otf ~/.local/share/fonts/SFMonoLigatures/
fc-cache -fv
```

Kiểm tra đã cài thành công:

```bash
fc-list | grep -i "SFMonoLigatures"
```

## Cấu hình trình soạn thảo

> Tên font hiển thị có thể là `SFMonoLigatures` hoặc `SF Mono Ligatures` tùy hệ điều hành. Hãy kiểm tra tên chính xác trong danh sách font của hệ thống.

### Visual Studio Code

Mở `settings.json` và thêm:

```json
{
  "editor.fontFamily": "'SFMonoLigatures', Consolas, monospace",
  "editor.fontLigatures": true,
  "editor.fontSize": 14
}
```

Muốn tắt ligature cho một số trường hợp cụ thể, dùng chuỗi tính năng OpenType:

```json
{
  "editor.fontLigatures": "'calt' 1, 'liga' 1"
}
```

### JetBrains IDE (IntelliJ, PyCharm, WebStorm, ...)

`Settings → Editor → Font`:

- Font: `SFMonoLigatures`
- Bật **Enable ligatures**

### Windows Terminal

Trong `settings.json`:

```json
{
  "profiles": {
    "defaults": {
      "font": { "face": "SFMonoLigatures", "size": 12 }
    }
  }
}
```

### Sublime Text

```json
{
  "font_face": "SFMonoLigatures",
  "font_options": ["gdi"]
}
```

### Terminal khác

Ligature chỉ hoạt động trên terminal có hỗ trợ (ví dụ Windows Terminal, iTerm2, WezTerm, Kitty, Alacritty bản mới). Hãy bật tùy chọn ligature trong phần cài đặt của terminal đó.

## Ligature là gì?

Ligature là việc ghép nhiều ký tự liên tiếp thành một glyph duy nhất. Trong code, chuỗi như `!=` hay `=>` sẽ được vẽ như một ký hiệu liền mạch thay vì hai ký tự rời nhau. **Nội dung file không thay đổi**: bạn vẫn lưu và sao chép đúng các ký tự gốc, chỉ cách hiển thị là khác.

Ví dụ minh họa:

```
=>   ->   >=   <=   !=   ==   ===   !==   &&   ||   ::   ++   --   <-   |>   //
```

Bạn có thể dán đoạn trên vào trình soạn thảo đã bật ligature để xem font hiển thị thế nào.

## Xử lý sự cố

| Vấn đề | Cách khắc phục |
| ------ | -------------- |
| Không thấy ligature | Kiểm tra `editor.fontLigatures` đã bật; terminal/ứng dụng phải hỗ trợ ligature. |
| Không thấy font trong danh sách | Khởi động lại ứng dụng hoặc đăng xuất/đăng nhập lại để hệ thống nạp font. |
| Độ đậm bị sai hoặc thiếu | Cài đủ cả 12 file; một số ứng dụng chỉ hiển thị Regular và Bold. |
| Font hiển thị mờ trên Windows | Bật ClearType (`Adjust ClearType text`) và thử các cỡ chữ khác nhau. |
| Cài đặt trước đó bị xung đột | Gỡ các phiên bản cũ của font cùng tên rồi cài lại. |

## Bản quyền và giấy phép

**Lưu ý quan trọng:** SF Mono là font độc quyền của **Apple Inc.** và được cấp phép theo các điều khoản riêng của Apple (SF Pro / SF Mono license), chủ yếu dành cho việc phát triển và thiết kế giao diện ứng dụng cho nền tảng Apple. Bản chỉnh sửa có ligature trong repo này là sản phẩm phái sinh.

- Repo này **không** có quan hệ với, và không được chứng thực bởi Apple.
- Hãy tự kiểm tra điều khoản sử dụng của Apple trước khi dùng cho mục đích thương mại hoặc khi phân phối lại font.
- Nếu bạn là chủ sở hữu bản quyền và muốn gỡ nội dung, vui lòng liên hệ qua Issues.

Phần tài liệu (README) được phát hành tự do; hãy thêm file `LICENSE` nếu bạn muốn quy định điều khoản rõ ràng hơn.

## Đóng góp

Mọi góp ý đều được hoan nghênh: mở Issue để báo lỗi glyph, ligature hiển thị sai hoặc đề xuất cải tiến.
