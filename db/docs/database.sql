-- ========================================
-- MERGED SQL SCHEMA FILE
-- ========================================

-- Generated on: Fri May 23 20:05:22 +07 2025
-- Total files: 27


-- ========================================
-- FILE: user
-- Source: ../models/user/user.sql
-- Dependencies: none
-- ========================================


CREATE TABLE Users (
    id NUMBER PRIMARY KEY,
    phone_number VARCHAR2(20) UNIQUE NOT NULL,
    email VARCHAR2(255) UNIQUE NOT NULL,
    password VARCHAR2(255) NOT NULL,
    full_name NVARCHAR2(255) NOT NULL,
    gender VARCHAR2(10) CHECK (gender IN ('Male', 'Female', 'Other')),
    date_of_birth DATE,
    national_id_number VARCHAR2(50) UNIQUE NOT NULL,
    is_phone_verified NUMBER(1) DEFAULT 0 CHECK (is_phone_verified IN (0, 1)),
    is_email_verified NUMBER(1) DEFAULT 0 CHECK (is_email_verified IN (0, 1)),
    status VARCHAR2(20) DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Banned')),
    avatar_url VARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE user_seq 
    START WITH 1 
    INCREMENT BY 1 
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_user_bi
    BEFORE INSERT ON Users
    FOR EACH ROW
BEGIN
    :NEW.id := user_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_user_bu
    BEFORE UPDATE ON Users
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car
-- Source: ../models/car/car.sql
-- Dependencies: user
-- ========================================


CREATE TABLE Cars (
    id NUMBER PRIMARY KEY,
    owner_id NUMBER NOT NULL,
    base_price_per_day NUMBER(10,2) NOT NULL,
    license_plate_number VARCHAR2(20) UNIQUE NOT NULL,
    year_of_manufacture NUMBER(4) NOT NULL,
    brand NVARCHAR2(100) NOT NULL,
    model NVARCHAR2(100) NOT NULL,
    number_of_seats NUMBER NOT NULL,
    fuel_type VARCHAR2(20) CHECK (fuel_type IN ('Petrol', 'Diesel')),
    transmission_type VARCHAR2(20) CHECK (transmission_type IN ('Manual', 'Automatic')),
    fuel_consumption NUMBER(5,2),
    vehicle_listing_date DATE,
    total_bookings NUMBER DEFAULT 0,
    average_star_rating NUMBER(3,2) DEFAULT 0 CHECK (average_star_rating BETWEEN 0 AND 5),
    description NCLOB,
    status VARCHAR2(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Unavailable', 'UnderReview')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_owner ON Cars(owner_id);
CREATE INDEX idx_car_brand_model ON Cars(brand, model);
CREATE INDEX idx_car_number_of_seats ON Cars(number_of_seats);
CREATE INDEX idx_car_fuel_type ON Cars(fuel_type);
CREATE INDEX idx_car_transmission_type ON Cars(transmission_type);

CREATE SEQUENCE car_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_bi
    BEFORE INSERT ON Cars
    FOR EACH ROW
BEGIN
    :NEW.id := car_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_update
    BEFORE UPDATE ON Cars
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_certificate
-- Source: ../models/car/car_certificate.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarCertificates (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    car_registration_certificate_url VARCHAR2(500) UNIQUE,
    car_inspection_certificate_url VARCHAR2(500) UNIQUE,
    car_insurance_certificate_url VARCHAR2(500) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE SEQUENCE car_certificates_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_certificates_bi
    BEFORE INSERT ON CarCertificates
    FOR EACH ROW
BEGIN
    :NEW.id := car_certificates_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_certificates_bu
    BEFORE UPDATE ON CarCertificates
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_image
-- Source: ../models/car/car_image.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarImages (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    image_url VARCHAR2(500) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_image_car_id ON CarImages(car_id);

CREATE SEQUENCE car_image_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_image_bi
    BEFORE INSERT ON CarImages
    FOR EACH ROW
BEGIN
    :NEW.id := car_image_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_image_bu
    BEFORE UPDATE ON CarImages
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_listing_request
-- Source: ../models/car/car_listing_request.sql
-- Dependencies: car user
-- ========================================


CREATE TABLE CarListingRequests (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    approved_by_user_id NUMBER NOT NULL,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    approval_time TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_listing_request_car_id ON CarListingRequests(car_id);

CREATE SEQUENCE car_listing_request_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_listing_request_bi
    BEFORE INSERT ON CarListingRequests
    FOR EACH ROW
BEGIN
    :NEW.id := car_listing_request_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_listing_request_bu
    BEFORE UPDATE ON CarListingRequests
    FOR EACH ROW
BEGIN
    IF :NEW.status = 'Approved' OR :NEW.status = 'Rejected' THEN
        :NEW.approval_time := CURRENT_TIMESTAMP;
    END IF;
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_location
-- Source: ../models/car/car_location.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarLocations (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    province NVARCHAR2(100),
    district NVARCHAR2(100),
    ward NVARCHAR2(100),
    street_address NVARCHAR2(500),
    longitude NUMBER(10,7),
    latitude NUMBER(10,7),
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE INDEX idx_car_location_car_id ON CarLocations(car_id);

CREATE SEQUENCE car_location_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_location_bi
    BEFORE INSERT ON CarLocations
    FOR EACH ROW
BEGIN
    :NEW.id := car_location_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: trip
-- Source: ../models/trip/trip.sql
-- Dependencies: car user
-- ========================================


CREATE TABLE Trips (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    renter_id NUMBER NOT NULL,
    total_amount NUMBER(12,2) NOT NULL,
    deposit_amount NUMBER(12,2) NOT NULL,
    pickup_date TIMESTAMP NOT NULL,
    pickup_address NVARCHAR2(500),
    return_date TIMESTAMP NOT NULL,
    return_address NVARCHAR2(500),
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected', 'Canceled', 'InProgress', 'Completed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id),
    FOREIGN KEY (renter_id) REFERENCES Users(id),
    CHECK (pickup_date < return_date),
    CHECK (deposit_amount <= total_amount)
);

CREATE INDEX idx_trip_car_id ON Trips(car_id);
CREATE INDEX idx_trip_renter_id ON Trips(renter_id);

CREATE SEQUENCE trip_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_bi
    BEFORE INSERT ON Trips
    FOR EACH ROW
BEGIN
    :NEW.id := trip_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_trip_bu
    BEFORE UPDATE ON Trips
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: deposit
-- Source: ../models/payment/deposit.sql
-- Dependencies: trip
-- ========================================


CREATE TABLE Deposits (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    deposit_amount NUMBER(12,2) NOT NULL,
    deposit_type VARCHAR2(20) CHECK (deposit_type IN ('Partial', 'Full')),
    deposit_percentage NUMBER(5,2) CHECK (deposit_percentage >= 0 AND deposit_percentage <= 100),
    payment_method VARCHAR2(20) CHECK (payment_method IN ('Momo', 'ZaloPay')),
    paid_at TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Completed', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE deposit_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_deposit_bi
    BEFORE INSERT ON Deposits
    FOR EACH ROW
BEGIN
    :NEW.id := deposit_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_deposit_bu
    BEFORE UPDATE ON Deposits
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: payment
-- Source: ../models/payment/payment.sql
-- Dependencies: trip user
-- ========================================


CREATE TABLE Payments (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER NOT NULL,
    payer_id NUMBER NOT NULL,
    amount_paid NUMBER(12,2) NOT NULL,
    payment_method VARCHAR2(20) CHECK (payment_method IN ('Momo', 'ZaloPay')),
    external_transaction_id VARCHAR2(100) UNIQUE,
    paid_at TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Success', 'Pending', 'Refunded', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id),
    FOREIGN KEY (payer_id) REFERENCES Users(id)
);

CREATE INDEX idx_payment_trip_id ON Payments(trip_id);
CREATE INDEX idx_payment_payer_id ON Payments(payer_id);

CREATE SEQUENCE payment_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_payment_bi
    BEFORE INSERT ON Payments
    FOR EACH ROW
BEGIN
    :NEW.id := payment_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_payment_bu
    BEFORE UPDATE ON Payments
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: refund
-- Source: ../models/payment/refund.sql
-- Dependencies: trip payment
-- ========================================


CREATE TABLE Refunds (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    payment_id NUMBER,
    amount_refunded NUMBER(12,2) NOT NULL,
    refund_type VARCHAR2(20) CHECK (refund_type IN ('Partial', 'Full')),
    payment_method VARCHAR2(20) CHECK (payment_method IN ('Momo', 'ZaloPay')),
    refunded_at TIMESTAMP,
    refund_reason NCLOB,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Processed', 'Failed')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES Payments(id)
);

CREATE INDEX idx_refund_payment_id ON Refunds(payment_id);

CREATE SEQUENCE refund_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_refund_bi
    BEFORE INSERT ON Refunds
    FOR EACH ROW
BEGIN
    :NEW.id := refund_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_refund_bu
    BEFORE UPDATE ON Refunds
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_availability_slot
-- Source: ../models/rental/car_availability_slot.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarAvailabilitySlots (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    pickup_start_time TIMESTAMP NOT NULL,
    pickup_end_time TIMESTAMP NOT NULL,
    return_start_time TIMESTAMP NOT NULL,
    return_end_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    CHECK (pickup_start_time < pickup_end_time),
    CHECK (return_start_time < return_end_time)
);

CREATE SEQUENCE car_availability_slots_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_availability_slots_bi
    BEFORE INSERT ON CarAvailabilitySlots
    FOR EACH ROW
BEGIN
    :NEW.id := car_availability_slots_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_availability_slots_bu
    BEFORE UPDATE ON CarAvailabilitySlots
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_daily_price
-- Source: ../models/rental/car_daily_price.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarDailyPrices (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    price NUMBER(10,2) NOT NULL CHECK (price > 0),
    apply_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    UNIQUE (car_id, apply_date)
);

CREATE INDEX idx_car_daily_prices_car_id ON CarDailyPrices(car_id);

CREATE SEQUENCE car_daily_prices_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_daily_prices_bi
    BEFORE INSERT ON CarDailyPrices
    FOR EACH ROW
BEGIN
    :NEW.id := car_daily_prices_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_daily_prices_bu
    BEFORE UPDATE ON CarDailyPrices
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_eligibility_policy
-- Source: ../models/rental/car_eligibility_policy.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarEligibilityPolicies (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    requires_deposit NUMBER(1) DEFAULT 1 CHECK (requires_deposit IN (0, 1)),
    requires_driving_license NUMBER(1) DEFAULT 1 CHECK (requires_driving_license IN (0, 1)),
    requires_national_id NUMBER(1) DEFAULT 1 CHECK (requires_national_id IN (0, 1)),
    additional_note NCLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE SEQUENCE car_eligibility_policies_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_eligibility_policies_bi
    BEFORE INSERT ON CarEligibilityPolicies
    FOR EACH ROW
BEGIN
    :NEW.id := car_eligibility_policies_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_eligibility_policies_bu
    BEFORE UPDATE ON CarEligibilityPolicies
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_surcharge_policy
-- Source: ../models/rental/car_surcharge_policy.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarSurchargePolicies (
    id NUMBER PRIMARY KEY,
    car_id NUMBER UNIQUE NOT NULL,
    mileage_overage_fee NUMBER(10,2) CHECK (mileage_overage_fee > 0),
    daily_mileage_limit NUMBER CHECK (daily_mileage_limit > 0),
    cleaning_fee NUMBER(10,2) CHECK (cleaning_fee > 0),
    hourly_overtime_fee NUMBER(10,2) CHECK (hourly_overtime_fee > 0),
    daily_overtime_threshold NUMBER CHECK (daily_overtime_threshold > 0),
    odor_removal_fee NUMBER(10,2) CHECK (odor_removal_fee >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE
);

CREATE SEQUENCE car_surcharge_policies_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_surcharge_policies_bi
    BEFORE INSERT ON CarSurchargePolicies
    FOR EACH ROW
BEGIN
    :NEW.id := car_surcharge_policies_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_surcharge_policies_bu
    BEFORE UPDATE ON CarSurchargePolicies
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_unavailable_date
-- Source: ../models/rental/car_unavailable_date.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarUnavailableDates (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    apply_date DATE NOT NULL,
    reason NVARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    UNIQUE (car_id, apply_date)
);

CREATE INDEX idx_car_unavailable_dates_car_id ON CarUnavailableDates(car_id);

CREATE SEQUENCE car_unavailable_dates_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_unavailable_dates_bi
    BEFORE INSERT ON CarUnavailableDates
    FOR EACH ROW
BEGIN
    :NEW.id := car_unavailable_dates_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_unavailable_dates_bu
    BEFORE UPDATE ON CarUnavailableDates
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: car_weekday_discount
-- Source: ../models/rental/car_weekday_discount.sql
-- Dependencies: car
-- ========================================


CREATE TABLE CarWeekdayDiscounts (
    id NUMBER PRIMARY KEY,
    car_id NUMBER NOT NULL,
    weekday VARCHAR2(10) CHECK (weekday IN ('Mon', 'Tue', 'Wed', 'Thur', 'Fri', 'Sat', 'Sun')),
    discount_percentage NUMBER(5,2) CHECK (discount_percentage BETWEEN 0 AND 100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (car_id) REFERENCES Cars(id) ON DELETE CASCADE,
    UNIQUE (car_id, weekday)
);

CREATE INDEX idx_car_weekday_discounts_car_id ON CarWeekdayDiscounts(car_id);

CREATE SEQUENCE car_weekday_discounts_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_car_weekday_discounts_bi
    BEFORE INSERT ON CarWeekdayDiscounts
    FOR EACH ROW
BEGIN
    :NEW.id := car_weekday_discounts_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_car_weekday_discounts_bu
    BEFORE UPDATE ON CarWeekdayDiscounts
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: trip_booking_request
-- Source: ../models/trip/trip_booking_request.sql
-- Dependencies: trip user
-- ========================================


CREATE TABLE TripBookingRequests (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER NOT NULL,
    owner_id NUMBER NOT NULL,
    renter_id NUMBER NOT NULL,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Approved', 'Rejected')),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (owner_id) REFERENCES Users(id),
    FOREIGN KEY (renter_id) REFERENCES Users(id)
);

ALTER TABLE TripBookingRequests ADD FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE;

CREATE INDEX idx_trip_booking_request_trip_id ON TripBookingRequests(trip_id);
CREATE INDEX idx_trip_booking_request_owner_id ON TripBookingRequests(owner_id);
CREATE INDEX idx_trip_booking_request_renter_id ON TripBookingRequests(renter_id);

CREATE SEQUENCE trip_booking_request_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_booking_request_bi
    BEFORE INSERT ON TripBookingRequests
    FOR EACH ROW
BEGIN
    :NEW.id := trip_booking_request_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_trip_booking_request_bu
    BEFORE UPDATE ON TripBookingRequests
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: trip_cancellation
-- Source: ../models/trip/trip_cancellation.sql
-- Dependencies: trip user
-- ========================================


CREATE TABLE TripCancellations (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    cancelled_by_user_id NUMBER NOT NULL,
    reason NCLOB,
    refund_status VARCHAR2(20) DEFAULT 'NotApplicable' CHECK (refund_status IN ('NotApplicable', 'Pending', 'Processed', 'Denied')),
    cancelled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE,
    FOREIGN KEY (cancelled_by_user_id) REFERENCES Users(id)
);

CREATE SEQUENCE trip_cancellation_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_cancellation_bi
    BEFORE INSERT ON TripCancellations
    FOR EACH ROW
BEGIN
    :NEW.id := trip_cancellation_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: trip_car_detail
-- Source: ../models/trip/trip_car_detail.sql
-- Dependencies: trip
-- ========================================


CREATE TABLE TripCarDetails (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    license_plate_number VARCHAR2(20) NOT NULL,
    year_of_manufacture NUMBER(4) NOT NULL,
    brand NVARCHAR2(100) NOT NULL,
    model NVARCHAR2(100) NOT NULL,
    number_of_seats NUMBER NOT NULL,
    fuel_type VARCHAR2(20),
    transmission_type VARCHAR2(20),
    fuel_consumption NUMBER(5,2),
    vehicle_registration_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE trip_car_detail_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_car_detail_bi
    BEFORE INSERT ON TripCarDetails
    FOR EACH ROW
BEGIN
    :NEW.id := trip_car_detail_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: trip_eligibility_policy
-- Source: ../models/trip/trip_eligibility_policy.sql
-- Dependencies: trip
-- ========================================


CREATE TABLE TripEligibilityPolicies (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    requires_deposit NUMBER(1) DEFAULT 1 CHECK (requires_deposit IN (0, 1)),
    requires_driving_license NUMBER(1) DEFAULT 1 CHECK (requires_driving_license IN (0, 1)),
    requires_national_id NUMBER(1) DEFAULT 1 CHECK (requires_national_id IN (0, 1)),
    additional_note NCLOB,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE trip_eligibility_policy_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_eligibility_policy_bi
    BEFORE INSERT ON TripEligibilityPolicies
    FOR EACH ROW
BEGIN
    :NEW.id := trip_eligibility_policy_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: trip_review
-- Source: ../models/trip/trip_review.sql
-- Dependencies: trip user
-- ========================================


CREATE TABLE TripReviews (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    reviewer_id NUMBER NOT NULL,
    star_rating NUMBER(2,1) CHECK (star_rating >= 0 AND star_rating <= 5),
    review_comment NCLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewer_id) REFERENCES Users(id)
);

CREATE SEQUENCE trip_review_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_review_bi
    BEFORE INSERT ON TripReviews
    FOR EACH ROW
BEGIN
    :NEW.id := trip_review_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_trip_review_bu
    BEFORE UPDATE ON TripReviews
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: trip_surcharge_detail
-- Source: ../models/trip/trip_surcharge_detail.sql
-- Dependencies: trip
-- ========================================


CREATE TABLE TripSurchargeDetails (
    id NUMBER PRIMARY KEY,
    trip_id NUMBER UNIQUE NOT NULL,
    mileage_overage_fee NUMBER(10,2),
    daily_mileage_limit NUMBER,
    cleaning_fee NUMBER(10,2),
    overtime_fee NUMBER(10,2),
    daily_overtime_threshold NUMBER,
    odor_removal_fee NUMBER(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES Trips(id) ON DELETE CASCADE
);

CREATE SEQUENCE trip_surcharge_detail_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_trip_surcharge_detail_bi
    BEFORE INSERT ON TripSurchargeDetails
    FOR EACH ROW
BEGIN
    :NEW.id := trip_surcharge_detail_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: driving_license
-- Source: ../models/user/driving_license.sql
-- Dependencies: user
-- ========================================


CREATE TABLE DrivingLicenses (
    id NUMBER PRIMARY KEY,
    user_id NUMBER UNIQUE NOT NULL,
    verified_by_user_id NUMBER NOT NULL,
    license_number VARCHAR2(50) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    full_name_on_license NVARCHAR2(255) NOT NULL,
    image_url VARCHAR2(500),
    status VARCHAR2(20) DEFAULT 'Pending' CHECK (status IN ('Verified', 'Pending', 'Rejected')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE SEQUENCE driving_license_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_driving_license_bi
    BEFORE INSERT ON DrivingLicenses
    FOR EACH ROW
BEGIN
    :NEW.id := driving_license_seq.NEXTVAL;
END;
/

CREATE OR REPLACE TRIGGER trg_driving_license_bu
    BEFORE UPDATE ON DrivingLicenses
    FOR EACH ROW
BEGIN
    :NEW.updated_at := CURRENT_TIMESTAMP;
END;
/


-- ========================================
-- FILE: opt_request
-- Source: ../models/user/opt_request.sql
-- Dependencies: user
-- ========================================


CREATE TABLE OtpRequests (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    code VARCHAR2(10) NOT NULL,
    phone_number VARCHAR2(20) NOT NULL,
    request_type VARCHAR2(20) CHECK (request_type IN ('Registration', 'PasswordReset')),
    attempt_count NUMBER DEFAULT 0,
    max_attempts NUMBER DEFAULT 5,
    expiration_time TIMESTAMP NOT NULL,
    status VARCHAR2(20) DEFAULT 'Valid' CHECK (status IN ('Valid', 'Canceled', 'Used')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    CHECK (attempt_count <= max_attempts)
);

CREATE INDEX idx_otp_request_user_id ON OtpRequests(user_id);
CREATE INDEX idx_otp_request_phone_number ON OtpRequests(phone_number);

CREATE SEQUENCE otp_request_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_otp_request_bi
    BEFORE INSERT ON OtpRequests
    FOR EACH ROW
BEGIN
    :NEW.id := otp_request_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: role
-- Source: ../models/user/role.sql
-- Dependencies: none
-- ========================================


CREATE TABLE Roles (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(20) CHECK (name IN ('Admin', 'User')),
    description NVARCHAR2(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE SEQUENCE role_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_role_bi
    BEFORE INSERT ON Roles
    FOR EACH ROW
BEGIN
    :NEW.id := role_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: user_role
-- Source: ../models/user/user_role.sql
-- Dependencies: user role
-- ========================================


CREATE TABLE UserRoles (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    role_id NUMBER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_user_role_user_id ON UserRoles(user_id);

CREATE SEQUENCE user_role_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_user_role_bi
    BEFORE INSERT ON UserRoles
    FOR EACH ROW
BEGIN
    :NEW.id := user_role_seq.NEXTVAL;
END;
/


-- ========================================
-- FILE: user_session
-- Source: ../models/user/user_session.sql
-- Dependencies: user
-- ========================================


CREATE TABLE UserSessions (
    id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    device_info NVARCHAR2(500),
    ip_address VARCHAR2(45),
    user_agent NVARCHAR2(1000),
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active NUMBER(1) DEFAULT 1 CHECK (is_active IN (0, 1)),
    expired_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE INDEX idx_user_session_user_id ON UserSessions(user_id);

CREATE SEQUENCE user_session_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE;

CREATE OR REPLACE TRIGGER trg_user_session_bi
    BEFORE INSERT ON UserSessions
    FOR EACH ROW
BEGIN
    :NEW.id := user_session_seq.NEXTVAL;
END;
/

-- ========================================
-- END OF MERGED FILE
-- ========================================
