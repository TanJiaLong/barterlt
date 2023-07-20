-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 21, 2023 at 01:45 AM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `barterlt`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_carts`
--

CREATE TABLE `tbl_carts` (
  `cart_id` int(5) NOT NULL,
  `cart_itemId` int(5) NOT NULL,
  `cart_quantity` int(7) NOT NULL,
  `cart_price` decimal(7,2) NOT NULL,
  `cart_userId` int(5) NOT NULL,
  `cart_sellerId` int(5) NOT NULL,
  `cart_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_carts`
--

INSERT INTO `tbl_carts` (`cart_id`, `cart_itemId`, `cart_quantity`, `cart_price`, `cart_userId`, `cart_sellerId`, `cart_date`) VALUES
(38, 23, 1, 369.00, 18, 19, '2023-07-21');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(5) NOT NULL,
  `user_id` int(5) NOT NULL,
  `item_name` varchar(20) NOT NULL,
  `item_desc` varchar(50) NOT NULL,
  `item_category` varchar(25) NOT NULL,
  `item_quantity` int(5) NOT NULL,
  `item_value` decimal(8,2) NOT NULL,
  `state` varchar(20) NOT NULL,
  `locality` varchar(20) NOT NULL,
  `latitude` decimal(10,7) NOT NULL,
  `longitude` decimal(10,7) NOT NULL,
  `reg_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_name`, `item_desc`, `item_category`, `item_quantity`, `item_value`, `state`, `locality`, `latitude`, `longitude`, `reg_date`) VALUES
(10, 18, 'Iphone 13 pro', 'Iphone 13 blue', 'Electronics', 0, 3600.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(12, 18, 'Nike Air Force', 'Nike Air Force \nFor 1`07 men\nTotally new', 'Sports and Fitness', 6, 389.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(13, 18, 'Samsung Galaxy A54', 'All color available\nTotally new\nLimit stock', 'Electronics', 10, 1699.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(16, 18, 'Transformer', 'Limited edition \n2 only', 'Toys and Games', 2, 699.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(18, 18, 'Lego 2K Drive', 'Lego 2K Drive\nCondition: 9/10', 'Toys and Games', 1, 199.00, 'Kedah', 'Alor Setar', 6.1263067, 100.3671683, '2023-06-28'),
(19, 18, 'Teddy', 'Teddy', 'Toys and Games', 1, 699.00, 'Kedah', 'Alor Setar', 6.1263067, 100.3671683, '2023-06-29'),
(21, 19, 'Wilson basketball', 'Wilson size 7\ncondition: 9/10', 'Sports and Fitness', 6, 56.00, 'Kedah', 'Changlun', 6.4674900, 100.5072583, '2023-07-20'),
(22, 19, 'Badminton racket', 'LiNing ', 'Sports and Fitness', 0, 123.00, 'Kedah', 'Changlun', 6.4674900, 100.5072583, '2023-07-20'),
(23, 19, 'One Piece', 'Volumn 1 - 20', 'Books and Media', 1, 369.00, 'Kedah', 'Changlun', 6.4674900, 100.5072583, '2023-07-21'),
(24, 18, 'ps5 games', 'Full set games', 'Toys and Games', 2, 345.00, 'Kedah', 'Changlun', 6.4674900, 100.5072583, '2023-07-21');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_orders`
--

CREATE TABLE `tbl_orders` (
  `order_id` int(6) NOT NULL,
  `order_bill` varchar(8) NOT NULL,
  `order_itemId` int(6) NOT NULL,
  `order_quantity` int(7) NOT NULL,
  `order_amount` decimal(7,2) NOT NULL,
  `order_userId` int(6) NOT NULL,
  `order_sellerId` int(6) NOT NULL,
  `order_status` varchar(15) NOT NULL,
  `order_latitude` decimal(11,7) NOT NULL,
  `order_longitude` decimal(11,7) NOT NULL,
  `order_date` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_orders`
--

INSERT INTO `tbl_orders` (`order_id`, `order_bill`, `order_itemId`, `order_quantity`, `order_amount`, `order_userId`, `order_sellerId`, `order_status`, `order_latitude`, `order_longitude`, `order_date`) VALUES
(17, 'B25', 12, 1, 389.00, 19, 18, 'Processing', 6.5835557, 100.2324226, '2023-07-20'),
(19, 'B26', 18, 2, 398.00, 19, 18, 'Ready', 6.2818971, 100.5229130, '2023-07-20'),
(21, 'B29', 12, 2, 778.00, 19, 18, 'Processing', 6.1710425, 100.3822809, '2023-07-20'),
(22, 'B30', 10, 2, 7200.00, 19, 18, 'Completed', 6.3617424, 99.7970643, '2023-07-21'),
(23, 'B31', 22, 1, 123.00, 18, 19, 'New', 0.0000000, 0.0000000, '2023-07-21'),
(24, 'B32', 21, 3, 168.00, 18, 19, 'New', 0.0000000, 0.0000000, '2023-07-21'),
(25, 'B33', 21, 1, 56.00, 18, 19, 'Completed', 6.0955026, 100.3822809, '2023-07-21'),
(26, 'B34', 21, 2, 112.00, 18, 19, 'Completed', 6.1116064, 100.4202683, '2023-07-21'),
(27, 'B35', 21, 1, 56.00, 18, 19, 'Completed', 6.1075478, 100.4063110, '2023-07-21'),
(28, 'B36', 21, 3, 168.00, 18, 19, 'Completed', 5.3682503, 100.2664753, '2023-07-21'),
(29, 'B37', 21, 1, 56.00, 18, 19, 'New', 0.0000000, 0.0000000, '2023-07-21');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user`
--

CREATE TABLE `tbl_user` (
  `id` int(5) NOT NULL,
  `name` varchar(20) NOT NULL,
  `email` varchar(30) NOT NULL,
  `phone` varchar(12) NOT NULL,
  `password` varchar(40) NOT NULL,
  `regDate` date NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_user`
--

INSERT INTO `tbl_user` (`id`, `name`, `email`, `phone`, `password`, `regDate`) VALUES
(18, 'Tan Jia Long', 'jialong@gmail.com', '01252365478', 'c9b359951c09c5d04de4f852746671ab2b2d0994', '2023-05-21'),
(19, 'Gan Xiao Ming', 'xiaoming@gmail.com', '01235456879', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2023-07-11');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  ADD PRIMARY KEY (`cart_id`);

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  ADD PRIMARY KEY (`order_id`);

--
-- Indexes for table `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_carts`
--
ALTER TABLE `tbl_carts`
  MODIFY `cart_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `tbl_orders`
--
ALTER TABLE `tbl_orders`
  MODIFY `order_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
