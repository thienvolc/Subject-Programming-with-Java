# 🐦 **Database Schema Documentation**

## 1. 💀 User & Role Management (5 tables)

**`User`**
```sql
(Id, PhoneNumber, Email, Password, FullName, Gender, DateOfBirth, NationalIdNumber, AvatarUrl, IsPhoneVerified, IsEmailVerified, Status, CreatedAt, UpdatedAt)

-- Gender [ Male | Female | Other ]
-- Status [ Active | Inactive | Banned ]
-- Email | PhoneNumber | NationalId: unique
-- IsEmailVerified | IsPhoneVerified: boolean
```

**`Role`**
```sql
(Id, Name, Description, CreatedAt)

-- Name [ Admin | User ]
```

**`UserRole`**
```sql
(Id, UserId, RoleId, CreatedAt)

-- UserId + RoleId: unique
```

**`OTPRequest`**
```sql
(Id, UserId, Code, PhoneNumber, RequestType, AttemptCount, MaxAttempts, ExpirationTime, Status, CreatedAt)

-- RequestType [ Registration | PasswordReset ]
-- Status [ Valid | Canceled | Used ]
-- AttemptCount <= MaxAttempts
-- MaxAttempts: 5
-- ExpirationTime: 5 minutes
```

**`UserSession`**
```sql  
(Id, UserId, DeviceInfo, IPAddress, UserAgent, LastActivityAt, IsActive, ExpiredAt, CreatedAt)

-- IsActive: boolean
-- LastActivityAt >= CreatedAt
-- ExpiredAt > CreatedAt
-- ExpiredAt: CreatedAt + 30 days
```

**`DrivingLicense`**
```sql
(Id, UserId, VerifiedByUserId, LicenseNumber, FullNameOnLicense, ImageUrl, Status, CreatedAt, UpdatedAt)

-- Status [ Verified | Pending | Rejected ]
-- LicenseNumber: unique
```

---

## 2. 🐸 Car Management (5 tables)

**`CarListingRequest`**
```sql
(Id, CarId, Status, ApprovalTime, ApprovalByUserId, CreatedAt, UpdatedAt)

-- Status [ Pending | Approved | Rejected ]
```

**`Car`**
```sql
(Id, OwnerId, BasePricePerDay, LicensePlateNumber, YearOfManufacture, Brand, Model, NumberOfSeats, FuelType, TransmissionType, FuelConsumption, VehicleListingDate, TotalBookings, AverageStarRating, Description, Status, CreatedAt, UpdatedAt)

-- LicensePlateNumber: unique
-- BasePricePerDay > 0
-- NumberOfSeats > 0
-- FuelConsumption > 0
-- TransmissionType [ Manual | Automatic ]
-- FuelType [ Petrol | Diesel ]
-- Status [ Available | Unavailable | UnderReview ]
-- AverageStarRating: 0-5
```

**`CarImage`**
```sql
(Id, CarId, ImageUrl, CreatedAt, UpdatedAt)

-- ImageUrl: unique
```

**`CarCertificate`**
```sql
(Id, CarId, RegistrationCertificateUrl, InspectionCertificateUrl, InsuranceCertificateUrl, CreatedAt, UpdatedAt)

-- CarId: unique
-- RegistrationCertificateUrl: unique 
-- InspectionCertificateUrl: unique
-- InsuranceCertificateUrl: unique
```

**`CarLocation`**
```sql
(Id, CarId, Province, District, Ward, StreetAddress, Longitude, Latitude, CreatedAt, UpdatedAt)

-- CarId: unique
```

---

## 3. 🐧 Rental Management (6 tables)

**`CarAvailabilitySlot`**
```sql
(Id, CarId, PickupStartTime, PickupEndTime, ReturnStartTime, ReturnEndTime, CreatedAt, UpdatedAt)

-- Time slots: unique
-- PickupStartTime < PickupEndTime
-- ReturnStartTime < ReturnEndTime
```

**`CarSurchargePolicy`**
```sql
(Id, CarId, MileageOverageFee, DailyMileageLimit, CleaningFee, HourlyOvertimeFee, DailyOvertimeThreshold, OdorRemovalFee, CreatedAt, UpdatedAt)

-- MileageOverageFee > 0
-- DailyMileageLimit > 0
-- CleaningFee > 0
-- HourlyOvertimeFee > 0
-- DailyOvertimeThreshold > 0
-- OdorRemovalFee > 0
```

**`CarEligibilityPolicy`**
```sql
(Id, RequiresDeposit, RequiresDrivingLicense, RequiresNationalId, AdditionalNote, CreatedAt, UpdatedAt)

-- RequiresDeposit: boolean
-- RequiresDrivingLicense: boolean
-- RequiresNationalId: boolean
```

**`CarDailyPrice`**
```sql
(Id, CarId, Price, ApplyDate, CreatedAt, UpdatedAt)

-- Price > 0
-- ApplyDate + CarId: unique
```

**`CarWeekdayDiscount`**
```sql
(Id, CarId, Weekday, DiscountPercentage, CreatedAt, UpdatedAt)

-- Weekday + CarId: unique
-- Weekday [ Mon, Tue, Wed, Thu, Fri, Sat, Sun ]
-- DiscountPercentage: 0-100
```

**`CarUnavailableDate`**
```sql
(Id, CarId, ApplyDate, Reason, CreatedAt)

-- ApplyDate + CarId: unique
```

---

## 4. 🐖 Trip Management (4 tables + 3 snapshot tables)

**`Trip`**
```sql
(Id, CarId, RenterId, TotalAmount, DepositAmount, PickupDate, PickupAddress, ReturnDate, ReturnAddress, Status, CreatedAt, UpdatedAt)

-- Status [ Pending | Approved | Rejected | InProgress | Canceled | Completed ]
-- PickupDate < ReturnDate
-- DepositAmount <= TotalAmount
```

**`TripCarDetail`**
```sql
(Id, TripId, LicensePlateNumber, YearOfManufacture, Brand, Model, NumberOfSeats, FuelType, TransmissionType, FuelConsumption, VehicleListingDate, CreatedAt)

-- TripId: unique
-- Snapshot of Car at the time of booking
```

**`TripSurchargeDetail`**
```sql
(Id, TripId, MileageOverageFee, DailyMileageLimit, CleaningFee, OvertimeFee, DailyOvertimeThreshold, OdorRemovalFee, CreatedAt)

-- TripId: unique
-- Snapshot of CarSurchargePolicy at the time of booking
```

**`TripEligibilityPolicy`**
```sql
(Id, TripId, RequiresDeposit, RequiresDrivingLicense, RequiresNationalId, AdditionalNote, CreatedAt)

-- TripId: unique
-- Snapshot of CarEligibilityPolicy at the time of booking
```

**`TripCancellation`**
```sql
(Id, TripId, CancelledByUserId, Reason, CancelledAt, RefundStatus)

-- TripId: unique
-- RefundStatus [ NotApplicable | Pending | Processed | Denied ]
```

**`TripReview`**
```sql
(Id, TripId, ReviewerId, StarRating, ReviewComment, CreatedAt, UpdatedAt)

-- TripId: unique
-- StarRating: 0-5
```

---

## 5. 👽 Payment Management (3 tables)

**`Payment`**
```sql
(Id, TripId, PayerId, AmountPaid, PaymentMethod, ExternalTransactionId, PaidAt, Status, CreatedAt, UpdatedAt)

-- PaymentMethod [ Momo | ZaloPay ]
-- Status [ Success | Pending | Refunded | Failed ]
```

**`Deposit`**
```sql
(Id, TripId, DepositAmount, DepositType, DepositPercentage, PaymentMethod, PaidAt, Status, CreatedAt, UpdatedAt)

-- TripId: unique
-- DepositType [ Partial | Full ]
-- DepositPercentage: 0-100
-- PaymentMethod [ Momo | ZaloPay ]
-- Status [ Pending | Completed | Failed ]
```

**`Refund`**
```sql
(Id, TripId, PaymentId, AmountRefunded, RefundType, PaymentMethod, RefundedAt, Reason, Status, CreatedAt, UpdatedAt)

-- TripId: unique
-- RefundType [ Partial | Full ]
-- Status [ Pending | Processed | Failed ]
```
