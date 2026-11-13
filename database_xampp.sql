-- ====================================================================
-- ARMORTECH DEFENSE & TACTICAL POS (GUN SHOP)
-- XAMPP MySQL / MariaDB Database Schema
-- Owners: Maria Labay, Denz Sacay, Jameson Parmis
-- Project: POS-Computer Accounting System
-- Compatible with: XAMPP phpMyAdmin (MySQL / MariaDB)
-- ====================================================================

-- 1. CREATE DATABASE
CREATE DATABASE IF NOT EXISTS `pos_gunshop` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `pos_gunshop`;

-- 2. DROP TABLES IF THEY EXIST (IN CORRECT FK ORDER)
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `sale_items`;
DROP TABLE IF EXISTS `sales`;
DROP TABLE IF EXISTS `restock_logs`;
DROP TABLE IF EXISTS `products`;
DROP TABLE IF EXISTS `suppliers`;
DROP TABLE IF EXISTS `payroll`;
DROP TABLE IF EXISTS `system_logs`;
DROP TABLE IF EXISTS `accounts`;
DROP TABLE IF EXISTS `settings`;
SET FOREIGN_KEY_CHECKS = 1;

-- 3. CREATE ACCOUNTS TABLE (ADMIN, MANAGER, CASHIER)
CREATE TABLE `accounts` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `username` VARCHAR(64) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `fullname` VARCHAR(128) NOT NULL,
  `role` ENUM('admin', 'manager', 'cashier') NOT NULL DEFAULT 'cashier',
  `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. CREATE SUPPLIERS TABLE
CREATE TABLE `suppliers` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `name` VARCHAR(128) NOT NULL,
  `contact_person` VARCHAR(128) NULL,
  `phone` VARCHAR(64) NULL,
  `email` VARCHAR(128) NULL,
  `address` TEXT NULL,
  `status` ENUM('active', 'inactive') NOT NULL DEFAULT 'active',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. CREATE PRODUCTS TABLE (FIREARMS, AMMUNITION, GEAR)
CREATE TABLE `products` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `barcode` VARCHAR(64) NOT NULL UNIQUE,
  `name` VARCHAR(191) NOT NULL,
  `category` VARCHAR(64) NOT NULL,
  `specs` TEXT NULL,
  `cost_price` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `selling_price` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `stock_qty` INT NOT NULL DEFAULT 0,
  `low_stock_threshold` INT NOT NULL DEFAULT 5,
  `supplier_id` VARCHAR(64) NULL,
  `supplier_name` VARCHAR(128) NULL,
  `expiry_date` DATE NULL,
  `status` ENUM('active', 'archived') NOT NULL DEFAULT 'active',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_barcode` (`barcode`),
  INDEX `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. CREATE RESTOCK LOGS TABLE
CREATE TABLE `restock_logs` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `product_id` VARCHAR(64) NOT NULL,
  `product_name` VARCHAR(191) NOT NULL,
  `supplier_id` VARCHAR(64) NULL,
  `supplier_name` VARCHAR(128) NULL,
  `quantity` INT NOT NULL,
  `unit_cost` DECIMAL(12, 2) NOT NULL,
  `total_cost` DECIMAL(12, 2) NOT NULL,
  `restocked_by` VARCHAR(128) NOT NULL,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notes` TEXT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. CREATE SALES TABLE
CREATE TABLE `sales` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `invoice_no` VARCHAR(64) NOT NULL UNIQUE,
  `cashier_id` VARCHAR(64) NULL,
  `cashier_name` VARCHAR(128) NOT NULL,
  `subtotal` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `tax_rate` DECIMAL(5, 2) NOT NULL DEFAULT 12.00,
  `tax_amount` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `discount_type` VARCHAR(64) NOT NULL DEFAULT 'None',
  `discount_id` VARCHAR(128) NULL,
  `discount_rate` DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
  `discount_amount` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `grand_total` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `payment_method` VARCHAR(32) NOT NULL DEFAULT 'Cash',
  `payment_ref` VARCHAR(128) NULL,
  `amount_tendered` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `change_due` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `status` ENUM('completed', 'voided') NOT NULL DEFAULT 'completed',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_invoice` (`invoice_no`),
  INDEX `idx_created` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. CREATE SALE ITEMS TABLE
CREATE TABLE `sale_items` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `sale_id` VARCHAR(64) NOT NULL,
  `product_id` VARCHAR(64) NULL,
  `barcode` VARCHAR(64) NULL,
  `name` VARCHAR(191) NOT NULL,
  `category` VARCHAR(64) NULL,
  `unit_price` DECIMAL(12, 2) NOT NULL,
  `cost_price` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `quantity` INT NOT NULL,
  `total_price` DECIMAL(12, 2) NOT NULL,
  INDEX `idx_sale_id` (`sale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. CREATE PAYROLL TABLE
CREATE TABLE `payroll` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `employee_name` VARCHAR(128) NOT NULL,
  `employee_role` VARCHAR(128) NOT NULL,
  `period_start` DATE NOT NULL,
  `period_end` DATE NOT NULL,
  `hourly_rate` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `hours_worked` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `gross_pay` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `deduction_sss` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `deduction_philhealth` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `deduction_pagibig` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `deduction_tax` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `deduction_other` DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
  `total_deductions` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `net_pay` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `status` ENUM('paid', 'pending') NOT NULL DEFAULT 'paid',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. CREATE SYSTEM LOGS TABLE
CREATE TABLE `system_logs` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `timestamp` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username` VARCHAR(64) NOT NULL,
  `role` VARCHAR(32) NOT NULL,
  `action` VARCHAR(64) NOT NULL,
  `details` TEXT NULL,
  INDEX `idx_timestamp` (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. CREATE SETTINGS TABLE
CREATE TABLE `settings` (
  `id` VARCHAR(64) NOT NULL PRIMARY KEY,
  `store_name` VARCHAR(191) NOT NULL DEFAULT 'ARMORTECH DEFENSE & TACTICAL POS',
  `store_owners` VARCHAR(191) NOT NULL DEFAULT 'Maria Labay, Denz Sacay, Jameson Parmis',
  `store_address` TEXT NOT NULL,
  `store_contact` VARCHAR(191) NOT NULL,
  `tax_rate` DECIMAL(5, 2) NOT NULL DEFAULT 12.00,
  `gcash_number` VARCHAR(64) DEFAULT '0917-888-ARMOR',
  `maya_number` VARCHAR(64) DEFAULT '0918-999-TAC',
  `maribank_number` VARCHAR(64) DEFAULT '0919-777-GUNS'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. INSERT DEFAULT ACCOUNTS (OWNERS & ROLES)
INSERT INTO `accounts` (`id`, `username`, `password`, `fullname`, `role`, `status`) VALUES
('acc_01', 'admin', 'admin123', 'Maria Labay (Admin)', 'admin', 'active'),
('acc_02', 'manager', 'manager123', 'Denz Sacay (Manager)', 'manager', 'active'),
('acc_03', 'cashier', 'cashier123', 'Jameson Parmis (Cashier)', 'cashier', 'active'),
('acc_04', 'maria.labay', 'maria2026', 'Maria Labay', 'admin', 'active'),
('acc_05', 'denz.sacay', 'denz2026', 'Denz Sacay', 'manager', 'active'),
('acc_06', 'jameson.parmis', 'jameson2026', 'Jameson Parmis', 'cashier', 'active')
ON DUPLICATE KEY UPDATE `fullname`=VALUES(`fullname`);

-- 13. INSERT DEFAULT SUPPLIERS
INSERT INTO `suppliers` (`id`, `name`, `contact_person`, `phone`, `email`, `address`, `status`) VALUES
('sup_01', 'Armscor Global Defense, Inc.', 'Carlos Mendoza', '+63 2 8941 1234', 'sales@armscor.com.ph', 'Marikina City, Metro Manila', 'active'),
('sup_02', 'Glock Ges.m.b.H. Philippines Dist.', 'Andrea Ramos', '+63 2 8812 5678', 'contact@glock-ph.com', 'Makati City, Metro Manila', 'active'),
('sup_03', 'Federal Premium Ammunition Phils', 'Roberto Silva', '+63 917 445 6789', 'orders@federalammo.ph', 'Pasig City, Metro Manila', 'active'),
('sup_04', 'Tactical Gear & Optics Corp.', 'Lester Tan', '+63 920 334 1122', 'supply@tacticaloptics.com', 'Quezon City, Metro Manila', 'active')
ON DUPLICATE KEY UPDATE `name`=VALUES(`name`);

-- 14. INSERT DEFAULT GUN SHOP PRODUCTS & AMMUNITION
INSERT INTO `products` (`id`, `barcode`, `name`, `category`, `specs`, `cost_price`, `selling_price`, `stock_qty`, `low_stock_threshold`, `supplier_id`, `supplier_name`, `expiry_date`, `status`) VALUES
('prod_01', '100101', 'Glock 19 Gen 5 9mm Pistol', 'Firearms', '9x19mm Parabellum, 15-Round Mag, Safe Action', 38000.00, 48500.00, 11, 3, 'sup_02', 'Glock Ges.m.b.H. Philippines Dist.', NULL, 'active'),
('prod_02', '100102', 'Armscor RIA 1911 .45 ACP Tactical', 'Firearms', '.45 ACP, 8-Round Mag, Parkerized Finish', 28000.00, 36000.00, 8, 3, 'sup_01', 'Armscor Global Defense, Inc.', NULL, 'active'),
('prod_03', '100103', 'Beretta 92FS Brigadier 9mm', 'Firearms', '9mm Luger, Heavy Slide, 15-Round Mag', 45000.00, 56000.00, 4, 3, 'sup_02', 'Glock Ges.m.b.H. Philippines Dist.', NULL, 'active'),
('prod_04', '100104', 'Remington 870 Tactical 12-Gauge', 'Firearms', '12 Gauge Shotgun, 18.5" Barrel, 6+1 Cap', 26000.00, 34500.00, 6, 2, 'sup_01', 'Armscor Global Defense, Inc.', NULL, 'active'),
('prod_05', '200101', 'Armscor 9mm Luger FMJ 115gr (Box of 50)', 'Ammunition', '115 Grain Full Metal Jacket, Brass Casing', 1100.00, 1650.00, 85, 20, 'sup_01', 'Armscor Global Defense, Inc.', '2029-12-31', 'active'),
('prod_06', '200102', 'Federal .45 ACP Hydra-Shok JHP (Box of 20)', 'Ammunition', '230 Grain Jacketed Hollow Point Defense', 1850.00, 2750.00, 3, 10, 'sup_03', 'Federal Premium Ammunition Phils', '2030-06-30', 'active'),
('prod_07', '200103', 'Federal 12-Gauge 00 Buckshot (Box of 25)', 'Ammunition', '2-3/4" 9 Pellets High Velocity', 1400.00, 2100.00, 24, 10, 'sup_03', 'Federal Premium Ammunition Phils', '2028-10-15', 'active'),
('prod_08', '200104', 'Armscor 5.56x45mm NATO FMJ 55gr (Box of 20)', 'Ammunition', '55gr Full Metal Jacket Mil-Spec', 650.00, 950.00, 115, 25, 'sup_01', 'Armscor Global Defense, Inc.', '2031-01-01', 'active'),
('prod_09', '300101', 'Holosun HS507C X2 Red Dot Sight', 'Optics', 'Solar Failsafe, Shake Awake, 2 MOA Dot', 16000.00, 21500.00, 7, 2, 'sup_04', 'Tactical Gear & Optics Corp.', NULL, 'active'),
('prod_10', '300102', 'Streamlight TLR-1 HL Tactical Light 1000lm', 'Optics', '1000 Lumens Weapon Light, Picatinny Mount', 8500.00, 12000.00, 9, 3, 'sup_04', 'Tactical Gear & Optics Corp.', NULL, 'active'),
('prod_11', '400101', 'Kydex IWB Concealment Holster for Glock 19', 'Tactical Gear', 'Right Hand, Adjustable Cant & Retention', 1200.00, 1950.00, 18, 5, 'sup_04', 'Tactical Gear & Optics Corp.', NULL, 'active'),
('prod_12', '400102', 'Universal Gun Cleaning & Bore Kit', 'Cleaning & Maintenance', 'Multi-Caliber .22 to 12GA Brass Rods & Brushes', 950.00, 1500.00, 15, 5, 'sup_04', 'Tactical Gear & Optics Corp.', '2027-05-01', 'active'),
('prod_13', '400103', 'Tactical Level IIIA Ballistic Vest Plate', 'Tactical Gear', 'NIJ 0101.06 Certified, Lightweight Kevlar', 14000.00, 19800.00, 2, 3, 'sup_04', 'Tactical Gear & Optics Corp.', '2026-12-01', 'active')
ON DUPLICATE KEY UPDATE `stock_qty`=VALUES(`stock_qty`);

-- 15. INSERT DEFAULT SETTINGS
INSERT INTO `settings` (`id`, `store_name`, `store_owners`, `store_address`, `store_contact`, `tax_rate`, `gcash_number`, `maya_number`, `maribank_number`)
VALUES ('default_settings', 'ARMORTECH DEFENSE & TACTICAL POS', 'Maria Labay, Denz Sacay, Jameson Parmis', '101 Ballistics Way, Camp General Defense, Metro Manila', '+63 917 123 4567 | info@armortech.ph', 12.00, '0917-888-ARMOR', '0918-999-TAC', '0919-777-GUNS')
ON DUPLICATE KEY UPDATE `store_name`=VALUES(`store_name`);

-- 16. INSERT SAMPLE PAYROLL RECORDS
INSERT INTO `payroll` (`id`, `employee_name`, `employee_role`, `period_start`, `period_end`, `hourly_rate`, `hours_worked`, `gross_pay`, `deduction_sss`, `deduction_philhealth`, `deduction_pagibig`, `deduction_tax`, `deduction_other`, `total_deductions`, `net_pay`, `status`) VALUES
('pay_01', 'Maria Labay', 'Admin / Operations Head', '2026-11-01', '2026-11-15', 350.00, 88.00, 30800.00, 1125.00, 750.00, 200.00, 1800.00, 0.00, 3875.00, 26925.00, 'paid'),
('pay_02', 'Denz Sacay', 'Store Manager', '2026-11-01', '2026-11-15', 280.00, 88.00, 24640.00, 950.00, 600.00, 200.00, 1200.00, 0.00, 2950.00, 21690.00, 'paid'),
('pay_03', 'Jameson Parmis', 'Senior Cashier & Armorer', '2026-11-01', '2026-11-15', 200.00, 88.00, 17600.00, 750.00, 450.00, 200.00, 600.00, 0.00, 2000.00, 15600.00, 'paid')
ON DUPLICATE KEY UPDATE `gross_pay`=VALUES(`gross_pay`);

-- 17. INSERT SAMPLE COMPLETED SALES
INSERT INTO `sales` (`id`, `invoice_no`, `cashier_id`, `cashier_name`, `subtotal`, `tax_rate`, `tax_amount`, `discount_type`, `discount_id`, `discount_rate`, `discount_amount`, `grand_total`, `payment_method`, `payment_ref`, `amount_tendered`, `change_due`, `status`, `created_at`) VALUES
('sale_01', 'INV-20261113-001', 'acc_03', 'Jameson Parmis', 51950.00, 12.00, 6234.00, 'None', NULL, 0.00, 0.00, 58184.00, 'Cash', NULL, 60000.00, 1816.00, 'completed', '2026-11-13 10:15:00'),
('sale_02', 'INV-20261113-002', 'acc_03', 'Jameson Parmis', 4200.00, 12.00, 504.00, 'Senior Citizen', 'SC-8899120 (Pedro Santos)', 20.00, 840.00, 3864.00, 'GCash', 'GC-992817264', 3864.00, 0.00, 'completed', '2026-11-13 11:30:00'),
('sale_03', 'INV-20261113-003', 'acc_01', 'Maria Labay', 36000.00, 12.00, 4320.00, 'PWD', 'PWD-445511 (Elena Gomez)', 20.00, 7200.00, 33120.00, 'Maya', 'MY-102938481', 33120.00, 0.00, 'completed', '2026-11-13 12:45:00')
ON DUPLICATE KEY UPDATE `grand_total`=VALUES(`grand_total`);

-- 18. INSERT SAMPLE SALE ITEMS
INSERT INTO `sale_items` (`id`, `sale_id`, `product_id`, `barcode`, `name`, `category`, `unit_price`, `cost_price`, `quantity`, `total_price`) VALUES
('si_01', 'sale_01', 'prod_01', '100101', 'Glock 19 Gen 5 9mm Pistol', 'Firearms', 48500.00, 38000.00, 1, 48500.00),
('si_02', 'sale_01', 'prod_05', '200101', 'Armscor 9mm Luger FMJ 115gr (Box of 50)', 'Ammunition', 1650.00, 1100.00, 2, 3300.00),
('si_03', 'sale_02', 'prod_07', '200103', 'Federal 12-Gauge 00 Buckshot (Box of 25)', 'Ammunition', 2100.00, 1400.00, 2, 4200.00),
('si_04', 'sale_03', 'prod_02', '100102', 'Armscor RIA 1911 .45 ACP Tactical', 'Firearms', 36000.00, 28000.00, 1, 36000.00)
ON DUPLICATE KEY UPDATE `total_price`=VALUES(`total_price`);

-- 19. INSERT RESTOCK LOGS
INSERT INTO `restock_logs` (`id`, `product_id`, `product_name`, `supplier_id`, `supplier_name`, `quantity`, `unit_cost`, `total_cost`, `restocked_by`, `date`, `notes`) VALUES
('rst_01', 'prod_05', 'Armscor 9mm Luger FMJ 115gr (Box of 50)', 'sup_01', 'Armscor Global Defense, Inc.', 50, 1100.00, 55000.00, 'Denz Sacay', '2026-11-10 08:00:00', 'Monthly batch delivery from Marikina plant'),
('rst_02', 'prod_01', 'Glock 19 Gen 5 9mm Pistol', 'sup_02', 'Glock Ges.m.b.H. Philippines Dist.', 5, 38000.00, 190000.00, 'Maria Labay', '2026-11-11 10:30:00', 'New import shipment with PNP verification')
ON DUPLICATE KEY UPDATE `quantity`=VALUES(`quantity`);

-- 20. INSERT INITIAL SYSTEM LOG
INSERT INTO `system_logs` (`id`, `timestamp`, `username`, `role`, `action`, `details`) VALUES
('log_01', NOW(), 'system', 'system', 'SYSTEM_INIT', 'XAMPP MySQL database initialized for ARMORTECH Gun Shop POS. Owners: Maria Labay, Denz Sacay, Jameson Parmis.');
