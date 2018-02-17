-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 17, 2018 at 07:18 PM
-- Server version: 5.5.59-0ubuntu0.14.04.1-log
-- PHP Version: 5.6.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `gta5_gamemode_essential`
--
CREATE DATABASE IF NOT EXISTS `gta5_gamemode_essential` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `gta5_gamemode_essential`;

-- --------------------------------------------------------

--
-- Table structure for table `bl_player_count`
--

CREATE TABLE IF NOT EXISTS `bl_player_count` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `server` int(11) NOT NULL,
  `count` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bl_time_played`
--

CREATE TABLE IF NOT EXISTS `bl_time_played` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `user_id` int(11) NOT NULL,
  `civ_time_played` int(11) NOT NULL,
  `ems_time_played` int(11) NOT NULL,
  `cop_time_played` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_srv_data`
--

CREATE TABLE IF NOT EXISTS `vrp_srv_data` (
  `dkey` varchar(255) NOT NULL DEFAULT '',
  `dvalue` text,
  PRIMARY KEY (`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_users`
--

CREATE TABLE IF NOT EXISTS `vrp_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `last_login` varchar(255) DEFAULT NULL,
  `whitelisted` tinyint(1) DEFAULT NULL,
  `banned` tinyint(1) DEFAULT NULL,
  `cop` tinyint(1) DEFAULT '0',
  `copLevel` int(11) NOT NULL DEFAULT '0',
  `emergency` tinyint(1) DEFAULT '0',
  `emergencyLevel` int(11) NOT NULL DEFAULT '0',
  `ban_reason` varchar(4000) DEFAULT NULL,
  `banned_by_admin_id` int(11) DEFAULT NULL,
  `steam_check_bypass` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_business`
--

CREATE TABLE IF NOT EXISTS `vrp_user_business` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `name` varchar(30) DEFAULT NULL,
  `description` text,
  `capital` int(11) DEFAULT NULL,
  `laundered` int(11) DEFAULT NULL,
  `reset_timestamp` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_data`
--

CREATE TABLE IF NOT EXISTS `vrp_user_data` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `dkey` varchar(255) NOT NULL DEFAULT '',
  `dvalue` text,
  PRIMARY KEY (`user_id`,`dkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_homes`
--

CREATE TABLE IF NOT EXISTS `vrp_user_homes` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `home` varchar(255) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `home` (`home`,`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_identities`
--

CREATE TABLE IF NOT EXISTS `vrp_user_identities` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `registration` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `gender` varchar(20) NOT NULL DEFAULT 'male',
  `spouse` int(11) NOT NULL DEFAULT '0',
  `driverschool` int(11) NOT NULL DEFAULT '0',
  `driverlicense` int(11) NOT NULL DEFAULT '0',
  `firearmlicense` int(11) NOT NULL DEFAULT '0',
  `pilotlicense` int(11) NOT NULL DEFAULT '0',
  `isAlive` int(11) NOT NULL DEFAULT '1',
  `towlicense` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`user_id`),
  KEY `registration` (`registration`),
  KEY `phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_ids`
--

CREATE TABLE IF NOT EXISTS `vrp_user_ids` (
  `identifier` varchar(255) NOT NULL DEFAULT '',
  `user_id` int(11) DEFAULT NULL,
  `steam_name` varchar(255) NOT NULL DEFAULT '',
  `steamid64` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`identifier`),
  KEY `fk_user_ids_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_moneys`
--

CREATE TABLE IF NOT EXISTS `vrp_user_moneys` (
  `user_id` int(11) NOT NULL DEFAULT '0',
  `wallet` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_notes`
--

CREATE TABLE IF NOT EXISTS `vrp_user_notes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `added_by` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `note` varchar(4000) COLLATE utf8mb4_unicode_ci NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `vrp_user_vehicles`
--

CREATE TABLE IF NOT EXISTS `vrp_user_vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `vehicle` varchar(255) NOT NULL,
  `out_status` int(11) NOT NULL DEFAULT '0',
  `in_impound` int(11) DEFAULT '0',
  `colour` int(11) DEFAULT '0',
  `scolour` int(11) DEFAULT '0',
  `ecolor` int(11) NOT NULL DEFAULT '0',
  `ecolorextra` int(11) NOT NULL DEFAULT '0',
  `neon` varchar(50) DEFAULT NULL,
  `plate` varchar(50) DEFAULT NULL,
  `wheels` int(11) DEFAULT '0',
  `windows` int(11) DEFAULT '0',
  `platetype` int(11) DEFAULT '0',
  `exhausts` int(11) DEFAULT '0',
  `grills` int(11) DEFAULT '0',
  `spoiler` int(11) DEFAULT '0',
  `mods` varchar(5000) NOT NULL,
  `smokecolor1` int(11) DEFAULT '0',
  `smokecolor2` int(11) DEFAULT '0',
  `smokecolor3` int(11) DEFAULT '0',
  `neoncolor1` int(11) DEFAULT '0',
  `neoncolor2` int(11) DEFAULT '0',
  `neoncolor3` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `vrp_user_business`
--
ALTER TABLE `vrp_user_business`
  ADD CONSTRAINT `fk_user_business_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vrp_user_data`
--
ALTER TABLE `vrp_user_data`
  ADD CONSTRAINT `fk_user_data_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vrp_user_homes`
--
ALTER TABLE `vrp_user_homes`
  ADD CONSTRAINT `fk_user_homes_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vrp_user_identities`
--
ALTER TABLE `vrp_user_identities`
  ADD CONSTRAINT `fk_user_identities_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vrp_user_ids`
--
ALTER TABLE `vrp_user_ids`
  ADD CONSTRAINT `fk_user_ids_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `vrp_user_moneys`
--
ALTER TABLE `vrp_user_moneys`
  ADD CONSTRAINT `fk_user_moneys_users` FOREIGN KEY (`user_id`) REFERENCES `vrp_users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
