-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2020 at 11:23 AM
-- Server version: 10.1.28-MariaDB
-- PHP Version: 7.1.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fortel_network`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getpredeictions` (IN `week` INT)  NO SQL
SELECT team_id,team_name,sum(played) as total_played, sum(won) as total_won,sum(drawn) as total_drawn,sum(lost) as total_lost,sum(gd) as total_gd, sum(points) as total_points,(sum(won)*100)/sum(played) as average_result FROM `team_with_result` left join team_details on team_details._id = team_with_result.team_id where team_with_result.week <= week GROUP by team_id$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `match_details`
--

CREATE TABLE `match_details` (
  `_id` int(11) NOT NULL,
  `week` int(5) NOT NULL,
  `team_1` int(11) NOT NULL,
  `team_2` int(11) NOT NULL,
  `team1_score` int(11) NOT NULL,
  `team2_score` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `match_details`
--

INSERT INTO `match_details` (`_id`, `week`, `team_1`, `team_2`, `team1_score`, `team2_score`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 2, 3, 3, '2020-06-23 09:50:48', '2020-06-25 02:40:16'),
(2, 1, 3, 4, 3, 1, '2020-06-23 09:50:48', '2020-06-25 02:43:48'),
(3, 2, 1, 3, 5, 2, '2020-06-23 09:50:48', '2020-06-23 09:50:48'),
(4, 2, 2, 4, 5, 3, '2020-06-23 09:50:48', '2020-06-23 09:50:48'),
(5, 3, 1, 4, 5, 3, '2020-06-23 09:50:48', '2020-06-23 09:50:48'),
(6, 3, 2, 3, 3, 3, '2020-06-23 09:50:48', '2020-06-23 09:50:48'),
(7, 4, 1, 2, 3, 3, '2020-06-23 09:50:48', '2020-06-23 09:50:48'),
(8, 4, 3, 4, 3, 5, '2020-06-23 09:50:48', '2020-06-23 09:50:48'),
(9, 5, 1, 3, 5, 2, '2020-06-23 09:50:48', '2020-06-23 09:50:48'),
(10, 5, 2, 4, 3, 3, '2020-06-23 09:50:48', '2020-06-23 09:50:48');

-- --------------------------------------------------------

--
-- Table structure for table `team_details`
--

CREATE TABLE `team_details` (
  `_id` int(11) NOT NULL,
  `team_name` varchar(200) NOT NULL,
  `logo` varchar(200) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `team_details`
--

INSERT INTO `team_details` (`_id`, `team_name`, `logo`, `created_at`, `updated_at`) VALUES
(1, 'Manchester City', 'https://resources.premierleague.com/premierleague/badges/t43.svg', '2020-06-23 05:55:53', '2020-06-23 05:55:53'),
(2, 'Manchester United', 'https://resources.premierleague.com/premierleague/badges/t1.svg', '2020-06-23 05:55:53', '2020-06-23 05:55:53'),
(3, 'Liverpool', 'https://resources.premierleague.com/premierleague/badges/t14.svg', '2020-06-23 05:55:53', '2020-06-23 05:55:53'),
(4, 'Brighton and Hove Albion', 'https://resources.premierleague.com/premierleague/badges/t36.svg', '2020-06-23 05:55:53', '2020-06-23 05:55:53');

-- --------------------------------------------------------

--
-- Table structure for table `team_with_result`
--

CREATE TABLE `team_with_result` (
  `_id` int(11) NOT NULL,
  `match_id` int(11) NOT NULL,
  `team_id` int(11) NOT NULL,
  `week` int(11) NOT NULL DEFAULT '0',
  `played` int(11) NOT NULL DEFAULT '0',
  `won` int(11) NOT NULL DEFAULT '0',
  `drawn` int(11) NOT NULL DEFAULT '0',
  `lost` int(11) NOT NULL DEFAULT '0',
  `gd` varchar(10) NOT NULL DEFAULT '0',
  `points` int(11) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `team_with_result`
--

INSERT INTO `team_with_result` (`_id`, `match_id`, `team_id`, `week`, `played`, `won`, `drawn`, `lost`, `gd`, `points`, `created_at`, `updated_at`) VALUES
(1, 5, 1, 3, 1, 1, 0, 0, '5', 3, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(2, 5, 4, 3, 1, 0, 0, 1, '3', 0, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(3, 2, 3, 1, 1, 1, 0, 0, '3', 3, '2020-06-24 05:17:28', '2020-06-25 02:43:48'),
(4, 2, 4, 1, 1, 0, 0, 1, '1', 0, '2020-06-24 05:17:28', '2020-06-25 02:43:48'),
(5, 3, 1, 2, 1, 1, 0, 0, '5', 3, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(6, 3, 3, 2, 1, 0, 0, 1, '2', 0, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(7, 4, 2, 2, 1, 1, 0, 0, '5', 3, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(8, 4, 4, 2, 1, 0, 0, 1, '3', 0, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(9, 6, 2, 3, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(10, 6, 3, 3, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(11, 8, 3, 4, 1, 0, 0, 1, '3', 0, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(12, 8, 4, 4, 1, 1, 0, 0, '5', 3, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(13, 7, 1, 4, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(14, 7, 2, 4, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(15, 1, 1, 1, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-25 02:40:16'),
(16, 1, 2, 1, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-25 02:40:16'),
(17, 9, 1, 5, 1, 1, 0, 0, '5', 3, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(18, 9, 3, 5, 1, 0, 0, 1, '2', 0, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(19, 10, 2, 5, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-24 05:17:28'),
(20, 10, 4, 5, 1, 0, 1, 0, '3', 1, '2020-06-24 05:17:28', '2020-06-24 05:17:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `match_details`
--
ALTER TABLE `match_details`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `team_details`
--
ALTER TABLE `team_details`
  ADD PRIMARY KEY (`_id`);

--
-- Indexes for table `team_with_result`
--
ALTER TABLE `team_with_result`
  ADD PRIMARY KEY (`_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `match_details`
--
ALTER TABLE `match_details`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `team_details`
--
ALTER TABLE `team_details`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `team_with_result`
--
ALTER TABLE `team_with_result`
  MODIFY `_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
