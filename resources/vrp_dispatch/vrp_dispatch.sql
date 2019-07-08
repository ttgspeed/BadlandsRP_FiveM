-- phpMyAdmin SQL Dump
-- version 3.1.3.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Feb 18, 2019 at 06:53 AM
-- Server version: 5.1.33
-- PHP Version: 5.2.9

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `vrpfx`
--

-- --------------------------------------------------------

--
-- Table structure for table `vrp_dispatch`
--

CREATE TABLE IF NOT EXISTS `vrp_dispatch` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `callerphone` varchar(13) NOT NULL,
  `callerfirst` varchar(48) NOT NULL,
  `callerlast` varchar(48) NOT NULL,
  `posx` float NOT NULL,
  `posy` float NOT NULL,
  `posz` float NOT NULL,
  `calltext` longtext NOT NULL,
  `responding` mediumtext NOT NULL,
  `calltype` varchar(32) NOT NULL,
  `calltime` int(11) NOT NULL,
  `location` tinytext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=67 ;