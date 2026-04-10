-- MySQL dump 10.13  Distrib 8.0.18, for Win64 (x86_64)
--
-- Host: localhost    Database: tennisdb
-- ------------------------------------------------------
-- Server version	8.0.18

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Temporary view structure for view `a_ages_v`
--

DROP TABLE IF EXISTS `a_ages_v`;
/*!50001 DROP VIEW IF EXISTS `a_ages_v`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `a_ages_v` AS SELECT 
 1 AS `playerno`,
 1 AS `begin_ages`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `m_matches`
--

DROP TABLE IF EXISTS `m_matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `m_matches` (
  `m_matchno` int(11) NOT NULL,
  `m_t_teamno` int(11) NOT NULL,
  `m_p_playerno` int(11) NOT NULL,
  `m_won` int(11) NOT NULL,
  `m_lost` int(11) NOT NULL,
  PRIMARY KEY (`m_matchno`),
  KEY `fk_m_matches_team` (`m_t_teamno`),
  KEY `fk_m_matches_player` (`m_p_playerno`),
  CONSTRAINT `fk_m_matches_player` FOREIGN KEY (`m_p_playerno`) REFERENCES `p_players` (`p_playerno`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_m_matches_team` FOREIGN KEY (`m_t_teamno`) REFERENCES `t_teams` (`t_teamno`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_m_matches_nonnegative` CHECK (((`m_won` >= 0) and (`m_lost` >= 0))),
  CONSTRAINT `ck_m_matches_result` CHECK ((((`m_won` = 2) and (`m_lost` in (0,1))) or ((`m_won` = 3) and (`m_lost` in (0,1,2))) or ((`m_lost` = 2) and (`m_won` in (0,1))) or ((`m_lost` = 3) and (`m_won` in (0,1,2)))))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `m_matches`
--

LOCK TABLES `m_matches` WRITE;
/*!40000 ALTER TABLE `m_matches` DISABLE KEYS */;
INSERT INTO `m_matches` VALUES (1,1,6,3,1),(2,1,6,2,3),(3,1,6,3,0),(4,1,44,3,2),(5,1,83,0,3),(6,1,2,1,3),(7,1,57,3,0),(8,1,8,0,3),(9,2,27,3,2),(11,2,112,2,3),(12,2,112,1,3),(13,2,8,0,3);
/*!40000 ALTER TABLE `m_matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `p_players`
--

DROP TABLE IF EXISTS `p_players`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `p_players` (
  `p_playerno` int(11) NOT NULL,
  `p_name` varchar(50) NOT NULL,
  `p_initials` varchar(10) NOT NULL,
  `p_year_of_birth` int(11) NOT NULL,
  `p_sex` char(1) NOT NULL,
  `p_year_joined` int(11) NOT NULL,
  `p_street` varchar(50) NOT NULL,
  `p_houseno` varchar(10) NOT NULL,
  `p_postcode` varchar(10) NOT NULL,
  `p_town` varchar(50) NOT NULL,
  `p_phoneno` varchar(20) NOT NULL,
  `p_leagueno` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`p_playerno`),
  UNIQUE KEY `uq_p_players_name_initials` (`p_name`,`p_initials`),
  UNIQUE KEY `uq_p_players_leagueno` (`p_leagueno`),
  CONSTRAINT `ck_p_players_birth` CHECK ((`p_year_of_birth` between 1900 and 2100)),
  CONSTRAINT `ck_p_players_joined` CHECK ((`p_year_joined` between `p_year_of_birth` and 2100)),
  CONSTRAINT `ck_p_players_sex` CHECK ((`p_sex` in (_utf8mb4'M',_utf8mb4'F')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `p_players`
--

LOCK TABLES `p_players` WRITE;
/*!40000 ALTER TABLE `p_players` DISABLE KEYS */;
INSERT INTO `p_players` VALUES (2,'Everett','R',1960,'M',1975,'Stoney Road','43','3575NH','Stratford','070-237893','2411'),(6,'Parmenter','R',1964,'M',1977,'Haseltine Lane','80','1234KK','Stratford','070-476537','8467'),(7,'Wise','GWS',1963,'M',1981,'Edgecomb Way','39','9758VB','Stratford','070-347689',NULL),(8,'Newcastle','B',1962,'F',1980,'Station Road','4','6584RO','Inglewood','070-458458','2983'),(27,'Collins','DD',1964,'F',1983,'Long Drive','804','8457DK','Eltham','079-234857','2513'),(28,'Collins','C',1963,'F',1983,'Old Main Road','10','1294QK','Midhurst','071-659599',NULL),(39,'Bishop','D',1956,'M',1980,'Eaton Square','78','9629CD','Stratford','070-393435',NULL),(44,'Baker','E',1963,'M',1980,'Lewsi Street','23','4444LJ','Inglewood','070-368753','1124'),(57,'Brown','M',1971,'M',1985,'Edgecomb Way','16','4377CB','Stratford','070-473458','6409'),(83,'Hope','PK',1956,'M',1982,'Magdalene Road','16A','1812UP','Stratford','070-353548','1608'),(95,'Miller','P',1963,'M',1972,'High Street','33A','5746OP','Douglas','070-867564',NULL),(100,'Parmenter','P',1963,'M',1979,'Haseltine Lane','80','1234KK','Stratford','070-494593','6524'),(112,'Bailey','IP',1963,'F',1984,'Vixen Road','8','6392LK','Plymouth','010-548745','1319');
/*!40000 ALTER TABLE `p_players` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pe_penalties`
--

DROP TABLE IF EXISTS `pe_penalties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pe_penalties` (
  `pe_paymentno` int(11) NOT NULL,
  `pe_p_playerno` int(11) NOT NULL,
  `pe_pen_date` date NOT NULL,
  `pe_amount` int(11) NOT NULL,
  PRIMARY KEY (`pe_paymentno`),
  KEY `fk_pe_penalties_player` (`pe_p_playerno`),
  CONSTRAINT `fk_pe_penalties_player` FOREIGN KEY (`pe_p_playerno`) REFERENCES `p_players` (`p_playerno`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `ck_pe_penalties_amount` CHECK ((`pe_amount` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pe_penalties`
--

LOCK TABLES `pe_penalties` WRITE;
/*!40000 ALTER TABLE `pe_penalties` DISABLE KEYS */;
INSERT INTO `pe_penalties` VALUES (1,6,'1980-12-08',100),(2,44,'1981-05-05',75),(3,27,'1983-09-10',100),(5,44,'1980-12-08',25),(6,8,'1980-12-08',25),(7,44,'1982-12-30',30),(8,27,'1984-11-12',75);
/*!40000 ALTER TABLE `pe_penalties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_teams`
--

DROP TABLE IF EXISTS `t_teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_teams` (
  `t_teamno` int(11) NOT NULL,
  `t_p_playerno` int(11) NOT NULL,
  `t_division` varchar(20) NOT NULL,
  PRIMARY KEY (`t_teamno`),
  UNIQUE KEY `uq_t_teams_captain` (`t_p_playerno`),
  CONSTRAINT `fk_t_teams_captain` FOREIGN KEY (`t_p_playerno`) REFERENCES `p_players` (`p_playerno`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_teams`
--

LOCK TABLES `t_teams` WRITE;
/*!40000 ALTER TABLE `t_teams` DISABLE KEYS */;
INSERT INTO `t_teams` VALUES (1,6,'first'),(2,27,'second');
/*!40000 ALTER TABLE `t_teams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `v_competition_player_count`
--

DROP TABLE IF EXISTS `v_competition_player_count`;
/*!50001 DROP VIEW IF EXISTS `v_competition_player_count`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_competition_player_count` AS SELECT 
 1 AS `competition_player_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_competition_players`
--

DROP TABLE IF EXISTS `v_competition_players`;
/*!50001 DROP VIEW IF EXISTS `v_competition_players`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_competition_players` AS SELECT 
 1 AS `p_playerno`,
 1 AS `p_leagueno`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_players_per_town`
--

DROP TABLE IF EXISTS `v_players_per_town`;
/*!50001 DROP VIEW IF EXISTS `v_players_per_town`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_players_per_town` AS SELECT 
 1 AS `p_town`,
 1 AS `number_of_players`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_stratford_players`
--

DROP TABLE IF EXISTS `v_stratford_players`;
/*!50001 DROP VIEW IF EXISTS `v_stratford_players`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_stratford_players` AS SELECT 
 1 AS `playerno`,
 1 AS `player_name`,
 1 AS `initials`,
 1 AS `year_of_birth`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_towns`
--

DROP TABLE IF EXISTS `v_towns`;
/*!50001 DROP VIEW IF EXISTS `v_towns`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_towns` AS SELECT 
 1 AS `p_town`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_veterans`
--

DROP TABLE IF EXISTS `v_veterans`;
/*!50001 DROP VIEW IF EXISTS `v_veterans`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_veterans` AS SELECT 
 1 AS `p_playerno`,
 1 AS `p_name`,
 1 AS `p_initials`,
 1 AS `p_year_of_birth`,
 1 AS `p_sex`,
 1 AS `p_year_joined`,
 1 AS `p_street`,
 1 AS `p_houseno`,
 1 AS `p_postcode`,
 1 AS `p_town`,
 1 AS `p_phoneno`,
 1 AS `p_leagueno`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_veterans_checked`
--

DROP TABLE IF EXISTS `v_veterans_checked`;
/*!50001 DROP VIEW IF EXISTS `v_veterans_checked`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_veterans_checked` AS SELECT 
 1 AS `p_playerno`,
 1 AS `p_name`,
 1 AS `p_initials`,
 1 AS `p_year_of_birth`,
 1 AS `p_sex`,
 1 AS `p_year_joined`,
 1 AS `p_street`,
 1 AS `p_houseno`,
 1 AS `p_postcode`,
 1 AS `p_town`,
 1 AS `p_phoneno`,
 1 AS `p_leagueno`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `a_ages_v`
--

/*!50001 DROP VIEW IF EXISTS `a_ages_v`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `a_ages_v` (`playerno`,`begin_ages`) AS select `p_players`.`p_playerno` AS `p_playerno`,(`p_players`.`p_year_joined` - `p_players`.`p_year_of_birth`) AS `p_year_joined - p_year_of_birth` from `p_players` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_competition_player_count`
--

/*!50001 DROP VIEW IF EXISTS `v_competition_player_count`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_competition_player_count` AS select count(0) AS `competition_player_count` from `v_competition_players` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_competition_players`
--

/*!50001 DROP VIEW IF EXISTS `v_competition_players`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_competition_players` AS select `p_players`.`p_playerno` AS `p_playerno`,`p_players`.`p_leagueno` AS `p_leagueno` from `p_players` where (`p_players`.`p_leagueno` is not null) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_players_per_town`
--

/*!50001 DROP VIEW IF EXISTS `v_players_per_town`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_players_per_town` AS select `p_players`.`p_town` AS `p_town`,count(0) AS `number_of_players` from `p_players` group by `p_players`.`p_town` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_stratford_players`
--

/*!50001 DROP VIEW IF EXISTS `v_stratford_players`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_stratford_players` (`playerno`,`player_name`,`initials`,`year_of_birth`) AS select `p_players`.`p_playerno` AS `p_playerno`,`p_players`.`p_name` AS `p_name`,`p_players`.`p_initials` AS `p_initials`,`p_players`.`p_year_of_birth` AS `p_year_of_birth` from `p_players` where (`p_players`.`p_town` = 'Stratford') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_towns`
--

/*!50001 DROP VIEW IF EXISTS `v_towns`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_towns` AS select distinct `p_players`.`p_town` AS `p_town` from `p_players` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_veterans`
--

/*!50001 DROP VIEW IF EXISTS `v_veterans`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_veterans` AS select `p_players`.`p_playerno` AS `p_playerno`,`p_players`.`p_name` AS `p_name`,`p_players`.`p_initials` AS `p_initials`,`p_players`.`p_year_of_birth` AS `p_year_of_birth`,`p_players`.`p_sex` AS `p_sex`,`p_players`.`p_year_joined` AS `p_year_joined`,`p_players`.`p_street` AS `p_street`,`p_players`.`p_houseno` AS `p_houseno`,`p_players`.`p_postcode` AS `p_postcode`,`p_players`.`p_town` AS `p_town`,`p_players`.`p_phoneno` AS `p_phoneno`,`p_players`.`p_leagueno` AS `p_leagueno` from `p_players` where (`p_players`.`p_year_of_birth` < 1950) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_veterans_checked`
--

/*!50001 DROP VIEW IF EXISTS `v_veterans_checked`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_veterans_checked` AS select `p_players`.`p_playerno` AS `p_playerno`,`p_players`.`p_name` AS `p_name`,`p_players`.`p_initials` AS `p_initials`,`p_players`.`p_year_of_birth` AS `p_year_of_birth`,`p_players`.`p_sex` AS `p_sex`,`p_players`.`p_year_joined` AS `p_year_joined`,`p_players`.`p_street` AS `p_street`,`p_players`.`p_houseno` AS `p_houseno`,`p_players`.`p_postcode` AS `p_postcode`,`p_players`.`p_town` AS `p_town`,`p_players`.`p_phoneno` AS `p_phoneno`,`p_players`.`p_leagueno` AS `p_leagueno` from `p_players` where (`p_players`.`p_year_of_birth` < 1950) */
/*!50002 WITH CASCADED CHECK OPTION */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-27 15:04:06
