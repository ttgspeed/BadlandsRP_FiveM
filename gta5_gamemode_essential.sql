-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 31, 2017 at 12:39 AM
-- Server version: 5.5.55-0ubuntu0.14.04.1-log
-- PHP Version: 5.6.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

-- Create db if it does not exist
CREATE DATABASE  IF NOT EXISTS `gta5_gamemode_essential` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `gta5_gamemode_essential`;


--
-- Database: `gta5_gamemode_essential`
--

-- --------------------------------------------------------

--
-- Table structure for table `bans`
--

CREATE TABLE `bans` (
  `id` int(10) UNSIGNED NOT NULL,
  `banned` varchar(50) NOT NULL DEFAULT '0',
  `banner` varchar(50) NOT NULL,
  `reason` varchar(150) NOT NULL DEFAULT '0',
  `expires` datetime NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `coordinates`
--

CREATE TABLE `coordinates` (
  `id` int(11) UNSIGNED NOT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `items`
--

CREATE TABLE `items` (
  `id` int(11) UNSIGNED NOT NULL,
  `item_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `job_id` int(11) NOT NULL,
  `job_name` varchar(40) NOT NULL,
  `salary` int(11) NOT NULL DEFAULT '500'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `outfits`
--

CREATE TABLE `outfits` (
  `identifier` varchar(50) DEFAULT NULL,
  `hair` int(11) DEFAULT NULL,
  `haircolour` int(11) DEFAULT NULL,
  `torso` int(11) DEFAULT NULL,
  `torsotexture` int(11) DEFAULT NULL,
  `torsoextra` int(11) DEFAULT NULL,
  `torsoextratexture` int(11) DEFAULT NULL,
  `pants` int(11) DEFAULT NULL,
  `pantscolour` int(11) DEFAULT NULL,
  `shoes` int(11) DEFAULT NULL,
  `shoescolour` int(11) DEFAULT NULL,
  `bodyaccesoire` int(11) DEFAULT NULL,
  `undershirt` int(11) DEFAULT NULL,
  `armor` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `owned`
--

CREATE TABLE `owned` (
  `identifier` varchar(50) DEFAULT NULL,
  `weapon` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `turfs`
--

CREATE TABLE `turfs` (
  `identifier` varchar(50) DEFAULT NULL,
  `SANDY` tinyint(4) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(60) DEFAULT NULL,
  `identifier` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `group` varchar(50) NOT NULL DEFAULT '0',
  `permission_level` int(11) NOT NULL DEFAULT '0',
  `money` double NOT NULL DEFAULT '0',
  `bankbalance` int(32) NOT NULL DEFAULT '0',
  `lastpos` varchar(255) NOT NULL DEFAULT '{-266.94, -960.744,  31.2231, 142.503463745117}',
  `job` int(11) DEFAULT '1',
  `playtime` double NOT NULL DEFAULT '0',
  `shotsfired` double NOT NULL DEFAULT '0',
  `kmdriven` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_inventory`
--

CREATE TABLE `user_inventory` (
  `user_id` varchar(30) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `item_id` int(11) UNSIGNED NOT NULL,
  `quantity` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int(11) NOT NULL,
  `owner` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `colour` int(11) DEFAULT '0',
  `scolour` int(11) DEFAULT '0',
  `ecolor` int(11) NOT NULL DEFAULT '0',
  `ecolorextra` int(11) NOT NULL DEFAULT '0',
  `neon` int(11) NOT NULL DEFAULT '0',
  `plate` varchar(50) DEFAULT NULL,
  `wheels` int(11) DEFAULT '0',
  `windows` int(11) DEFAULT '0',
  `platetype` int(11) DEFAULT '0',
  `exhausts` int(11) DEFAULT '0',
  `grills` int(11) DEFAULT '0',
  `spoiler` int(11) DEFAULT '0',
  `mods` varchar(512) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `coordinates`
--
ALTER TABLE `coordinates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `items`
--
ALTER TABLE `items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`job_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_inventory`
--
ALTER TABLE `user_inventory`
  ADD PRIMARY KEY (`user_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- Indexes for table `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `coordinates`
--
ALTER TABLE `coordinates`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `items`
--
ALTER TABLE `items`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;
--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `job_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `user_inventory`
--
ALTER TABLE `user_inventory`
  ADD CONSTRAINT `user_inventory_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `items` (`id`);
COMMIT;

---
--- Insert job into DB for Medic
---
INSERT INTO `jobs` (`job_id`, `job_name`, `salary`) VALUES (11, 'Medic', 1200);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
