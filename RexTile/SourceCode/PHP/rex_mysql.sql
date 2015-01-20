-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Dec 23, 2014 at 10:27 AM
-- Server version: 5.6.17
-- PHP Version: 5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `rex_mysql`
--

-- --------------------------------------------------------

--
-- Table structure for table `background_images`
--

CREATE TABLE IF NOT EXISTS `background_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Image id',
  `image` mediumblob NOT NULL COMMENT 'Image',
  `name` varchar(100) NOT NULL COMMENT 'Image name',
  `type` varchar(20) DEFAULT NULL COMMENT 'Image type',
  `size` varchar(20) DEFAULT NULL COMMENT 'Image size',
  `width` int(11) DEFAULT NULL COMMENT 'Image width',
  `height` int(11) DEFAULT NULL COMMENT 'Image height',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Screen Background Images' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `friends`
--

CREATE TABLE IF NOT EXISTS `friends` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Friends id',
  `user_id` int(11) NOT NULL COMMENT 'User id',
  `friend_user_id` int(11) NOT NULL COMMENT 'Friends user id',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Users friends' AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `place_categories`
--

CREATE TABLE IF NOT EXISTS `place_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Place category id',
  `name` varchar(255) NOT NULL COMMENT 'Place category name',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Place category details' AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `place_details`
--

CREATE TABLE IF NOT EXISTS `place_details` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Place detail id',
  `name` varchar(255) DEFAULT NULL COMMENT 'place name',
  `place_id` varchar(255) NOT NULL COMMENT 'unique place id of the place from map',
  `category_id` int(20) NOT NULL COMMENT 'The place category id',
  `latitude` varchar(30) DEFAULT NULL COMMENT 'Place latitude',
  `longitude` varchar(30) DEFAULT NULL COMMENT 'place longitude',
  `photos` varchar(255) DEFAULT NULL COMMENT 'Place photo ids, comma separated values',
  `international_phone` varchar(20) DEFAULT NULL COMMENT 'Place''s international phone',
  `rating` varchar(10) DEFAULT NULL COMMENT 'Ratings for the place',
  `address` varchar(255) DEFAULT NULL COMMENT 'Formatted address of the place',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='Place details information' AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `recommendations`
--

CREATE TABLE IF NOT EXISTS `recommendations` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique recommendation id',
  `user_id` int(11) NOT NULL COMMENT 'recommonded done by user id',
  `place_detail_id` int(11) NOT NULL COMMENT 'Recommendation place detail id',
  `recommended_on` datetime NOT NULL COMMENT 'Date of recommendations',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='user recommondation table' AUTO_INCREMENT=12 ;

-- --------------------------------------------------------

--
-- Table structure for table `search_histories`
--

CREATE TABLE IF NOT EXISTS `search_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Search history id',
  `user_id` int(11) NOT NULL COMMENT 'Search done by user id',
  `search_query` varchar(255) NOT NULL COMMENT 'Search query string',
  `latitude` varchar(30) NOT NULL COMMENT 'Search place latitude',
  `longitude` varchar(30) NOT NULL COMMENT 'Search place longitude',
  `searched_on` datetime NOT NULL COMMENT 'Search date',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User search history details' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Unique user id',
  `phone` varchar(25) NOT NULL DEFAULT '' COMMENT 'User phone number',
  `name` varchar(100) DEFAULT NULL COMMENT 'User name',
  `email_id` varchar(100) DEFAULT NULL COMMENT 'User email id',
  `created_date` datetime NOT NULL COMMENT 'User created date',
  `session_id` varchar(100) DEFAULT NULL COMMENT 'the user session id',
  PRIMARY KEY (`phone`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='users information' AUTO_INCREMENT=48 ;

-- --------------------------------------------------------

--
-- Table structure for table `verification_codes`
--

CREATE TABLE IF NOT EXISTS `verification_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'verification code id',
  `user_id` int(20) NOT NULL COMMENT 'user id',
  `verification_code` varchar(10) NOT NULL COMMENT 'the verification code',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COMMENT='user signup verification codes' AUTO_INCREMENT=20 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
