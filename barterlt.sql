-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： 127.0.0.1
-- 生成日期： 2023-06-30 02:55:30
-- 服务器版本： 10.4.28-MariaDB
-- PHP 版本： 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 数据库： `barterlt`
--

-- --------------------------------------------------------

--
-- 表的结构 `tbl_items`
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
-- 转存表中的数据 `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_name`, `item_desc`, `item_category`, `item_quantity`, `item_value`, `state`, `locality`, `latitude`, `longitude`, `reg_date`) VALUES
(10, 18, 'Iphone 13 pro', 'Iphone 13 blue', 'Electronics', 1, 3600.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(12, 18, 'Nike Air Force', 'Nike Air Force \nFor 1`07 men\nTotally new', 'Sports and Fitness', 1, 389.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(13, 18, 'Samsung Galaxy A54', 'All color available\nTotally new\nLimit stock', 'Electronics', 4, 1699.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(16, 18, 'Transformer', 'Limited edition \n2 only', 'Toys and Games', 2, 699.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-12'),
(17, 18, 'Iphone 13', 'blue color\ncondition: 8/10', 'Electronics', 1, 4900.00, 'Kedah', 'Changlun', 6.4484167, 100.5096800, '2023-06-22'),
(18, 18, 'Lego 2K Drive', 'Lego 2K Drive\nCondition: 9/10', 'Toys and Games', 3, 199.00, 'Kedah', 'Alor Setar', 6.1263067, 100.3671683, '2023-06-28'),
(19, 18, 'Teddy', 'Teddy', 'Toys and Games', 1, 699.00, 'Kedah', 'Alor Setar', 6.1263067, 100.3671683, '2023-06-29');

-- --------------------------------------------------------

--
-- 表的结构 `tbl_user`
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
-- 转存表中的数据 `tbl_user`
--

INSERT INTO `tbl_user` (`id`, `name`, `email`, `phone`, `password`, `regDate`) VALUES
(18, 'jialong', 'jialong@gmail.com', '01252365478', '6367c48dd193d56ea7b0baad25b19455e529f5ee', '2023-05-21');

--
-- 转储表的索引
--

--
-- 表的索引 `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- 表的索引 `tbl_user`
--
ALTER TABLE `tbl_user`
  ADD PRIMARY KEY (`id`);

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- 使用表AUTO_INCREMENT `tbl_user`
--
ALTER TABLE `tbl_user`
  MODIFY `id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
