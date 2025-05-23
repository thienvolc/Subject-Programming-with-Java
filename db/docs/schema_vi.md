# 🐦 **Tai Lieu Luoc Do Co So Du Lieu**

## 1. 💀 Quan Ly Nguoi Dung & Vai Tro (5 bang)

**`NguoiDung`**

```sql
(Id, HoTen, SoDienThoai, Email, MatKhau, NgaySinh, GioiTinh, SoCMND, EmailDaXacThuc, SoDienThoaiDaXacThuc, TrangThai, AnhDaiDienUrl, TaoLuc, CapNhatLuc)

-- GioiTinh [ Nam | Nu | Khac ]
-- TrangThai [ DangHoatDong | KhongHoatDong | BiCam ]
-- Email | SoDienThoai | SoCMND: duy nhat
-- EmailDaXacThuc | SoDienThoaiDaXacThuc: boolean
```

**`VaiTroNguoiDung`**

```sql
(VaiTroId, NguoiDungId, TenVaiTro, MoTa, TaoLuc)

-- TenVaiTro [ QuanTriVien | NguoiDung ]
```

**`YeuCauOTP`**

```sql
(Id, NguoiDungId, MaOTP, SoDienThoai, LoaiYeuCau, SoLanThu, SoLanThuToiDa, ThoiGianHetHan, TrangThai, TaoLuc)

-- LoaiYeuCau [ DangKy | KhoiPhucMatKhau ]
-- TrangThai [ HieuLuc | DaHuy | DaSuDung ]
-- SoLanThuToiDa: 5
-- ThoiGianHetHan: 5 phut
-- SoLanThu <= SoLanThuToiDa
```

**`PhienDangNhap`**

```sql
(Id, NguoiDungId, ThongTinThietBi, DiaChiIP, TrinhDuyet, HoatDongGanNhatLuc, DangHoatDong, HetHanLuc, TaoLuc)

-- HetHanLuc: thoi gian hien tai + 30 ngay
-- DangHoatDong: boolean
```

**`BangLaiXe`**

```sql
(Id, NguoiDungId, SoBangLai, TenTrenBang, AnhBangLaiUrl, TrangThaiXacThuc, TaoLuc, CapNhatLuc)

-- TrangThaiXacThuc [ DaXacThuc | ChoXacThuc | TuChoi ]
-- SoBangLai: duy nhat
```

---

## 2. 🐸 Quan Ly Xe (5 bang)

**`Xe`**

```sql
(Id, ChuSoHuuId, BienSoXe, NamSanXuat, HangXe, MauXe, SoChoNgoi, LoaiNhienLieu, LoaiHopSo, MucTieuThuNhienLieu, NgayDangKyXe, TrangThaiDangTin, MoTa, GiaCoBanMotNgay, TongLuotDat, DiemDanhGiaTrungBinh, TaoLuc, CapNhatLuc)

-- TrangThaiDangTin [ SanSang | KhongSanSang | DangDuyet ]
-- LoaiHopSo [ SoSan | TuDong ]
-- LoaiNhienLieu [ Xang | Dau ]
-- BienSoXe: duy nhat
-- DiemDanhGiaTrungBinh: 0-5
```

**`HinhAnhXe`**

```sql
(Id, XeId, AnhUrl, LaAnhChinh, TaiLenLuc)

-- LaAnhChinh: boolean & chi co 1 anh chinh/xac dinh
-- AnhUrl: duy nhat
```

**`GiayToXe`**

```sql
(Id, XeId, GiayDangKyXeUrl, GiayDangKiemUrl, BaoHiemXeUrl, TaoLuc, CapNhatLuc)

-- XeId: duy nhat
-- GiayDangKyXeUrl: duy nhat 
-- GiayDangKiemUrl: duy nhat
-- BaoHiemXeUrl: duy nhat
```

**`ViTriXe`**

```sql
(Id, XeId, Tinh, Huyen, Xa, DiaChiChiTiet, KinhDo, ViDo)
```

**`YeuCauDangTinXe`**

```sql
(Id, XeId, TrangThai, ThoiGianDuyet, TaoLuc, CapNhatLuc)

-- TrangThai [ ChoDuyet | DaDuyet | TuChoi ]
```

---

## 3. 🐧 Quan Ly Thue Xe (6 bang)

**`KhoangThoiGianSanSang`**

```sql
(Id, XeId, ThoiGianBatDauNhanXe, ThoiGianKetThucNhanXe, ThoiGianBatDauTraXe, ThoiGianKetThucTraXe, TaoLuc, CapNhatLuc)

-- XeId: duy nhat
-- Khoang thoi gian: duy nhat
-- ThoiGianBatDauNhanXe < ThoiGianKetThucNhanXe
-- ThoiGianBatDauTraXe < ThoiGianKetThucTraXe
```

**`ChinhSachPhuThuXe`**

```sql
(Id, XeId, PhiVuotSoKm, GioiHanSoKmMoiNgay, PhiVeSinh, PhiPhatSinhTheoGio, GioiHanGioPhatSinhMoiNgay, PhiKhuMui, NgayBatDau, NgayKetThuc, TaoLuc, CapNhatLuc)

-- NgayBatDau < NgayKetThuc
```

**`ChinhSachDieuKienThue`**

```sql
(Id, CanCoc, CanBangLai, CanCMND, GhiChuThem)

-- CanCoc: boolean
-- CanBangLai: boolean
-- CanCMND: boolean
```

**`GiaThueTheoNgay`**

```sql
(Id, XeId, Gia, NgayApDung, TaoLuc, CapNhatLuc)

-- NgayApDung + XeId: duy nhat
```

**`UuDaiNgayTrongTuan`**

```sql
(Id, XeId, ThuTrongTuan, TiLeUuDai, TaoLuc, CapNhatLuc)

-- ThuTrongTuan + XeId: duy nhat
-- ThuTrongTuan [ T2, T3, T4, T5, T6, T7, CN ]
-- TiLeUuDai: 0-100
```

**`NgayKhongTheThue`**

```sql
(Id, XeId, NgayApDung, LyDo, TaoLuc)

-- NgayApDung + XeId: duy nhat
```

---

## 4. 🐖 Quan Ly Chuyen Di (7 bang)

**`YeuCauDatChuyen`**

```sql
(Id, ChuyenDiId, ChuSoHuuId, NguoiThueId, TaoLuc, TrangThai, CapNhatLuc)

-- TrangThai [ ChoDuyet | DaDuyet | TuChoi ]
```

**`ChuyenDi`**

```sql
(Id, XeId, NguoiThueId, TongTien, TienCoc, NgayNhanXe, DiaChiNhanXe, NgayTraXe, DiaChiTraXe, TrangThai, TaoLuc, CapNhatLuc)

-- TrangThai [ ChoDuyet | DaDuyet | TuChoi | DaHuy | HoanTat ]
-- NgayNhanXe < NgayTraXe
-- TienCoc <= TongTien
```

**`ThongTinXeChuyenDi`**

```sql
(Id, ChuyenDiId, BienSoXe, NamSanXuat, HangXe, MauXe, SoChoNgoi, LoaiNhienLieu, LoaiHopSo, MucTieuThuNhienLieu, NgayDangKyXe, TaoLuc)

-- ChuyenDiId: duy nhat
-- Snapshot thong tin xe luc dat chuyen
```

**`ChiTietPhuThuChuyenDi`**

```sql
(Id, ChuyenDiId, PhiVuotSoKm, GioiHanSoKmMoiNgay, PhiVeSinh, PhiPhatSinh, GioiHanGioPhatSinhMoiNgay, PhiKhuMui, TaoLuc)

-- ChuyenDiId: duy nhat
-- Snapshot chinh sach phu thu luc dat chuyen
```

**`ChinhSachDieuKienChuyenDi`**

```sql
(Id, CanCoc, CanBangLai, CanCMND, GhiChuThem)

-- ChuyenDiId: duy nhat
-- Snapshot chinh sach dieu kien luc dat chuyen
```

**`HuyChuyenDi`**

```sql
(Id, ChuyenDiId, NguoiHuyId, LyDo, HuyLuc, TrangThaiHoanTien)

-- ChuyenDiId: duy nhat
-- TrangThaiHoanTien [ KhongApDung | DangXuLy | DaXuLy | TuChoi ]
```

**`DanhGiaChuyenDi`**

```sql
(Id, ChuyenDiId, NguoiDanhGiaId, XeId, DiemDanhGia, BinhLuan, TaoLuc, CapNhatLuc)

-- ChuyenDiId: duy nhat
-- DiemDanhGia: 0-5
```

---

## 5. 👽 Quan Ly Thanh Toan (3 bang)

**`ThanhToan`**

```sql
(Id, ChuyenDiId, NguoiThanhToanId, SoTien, PhuongThucThanhToan, MaGiaoDichNgoai, ThanhToanLuc, TrangThai, TaoLuc, CapNhatLuc)

-- PhuongThucThanhToan [ Momo | ZaloPay ]
-- MaGiaoDichNgoai: duy nhat
-- TrangThai [ ThanhCong | DangXuLy | DaHoan | ThatBai ]
```

**`TienCoc`**

```sql
(Id, ChuyenDiId, SoTienCoc, LoaiTienCoc, TiLeCoc, PhuongThucThanhToan, ThanhToanLuc, TrangThai, TaoLuc, CapNhatLuc)

-- ChuyenDiId: duy nhat
-- LoaiTienCoc [ MotPhan | ToanBo ]
-- TiLeCoc: 0-100
-- PhuongThucThanhToan [ Momo | ZaloPay ]
-- TrangThai [ DangXuLy | HoanTat | ThatBai ]
```

**`HoanTien`**

```sql
(Id, ChuyenDiId, ThanhToanId, SoTienHoan, LoaiHoanTien, PhuongThucThanhToan, HoanTienLuc, LyDoHoanTien, TrangThai, TaoLuc, CapNhatLuc)

-- ChuyenDiId: duy nhat 
-- LoaiHoanTien [ MotPhan | ToanBo ]
-- TrangThai [ DangXuLy | DaXuLy | ThatBai ]
```
