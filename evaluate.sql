-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: db8
-- Generation Time: Sep 10, 2024 at 12:46 PM
-- Server version: 8.3.0
-- PHP Version: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `evaluate`
--

-- --------------------------------------------------------

--
-- Table structure for table `manag_head`
--

CREATE TABLE `manag_head` (
  `id` int NOT NULL,
  `fac` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `staffid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `staffname` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `useradd` varchar(20) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `manag_head`
--

INSERT INTO `manag_head` (`id`, `fac`, `staffid`, `staffname`, `useradd`) VALUES
(2, '2010927040000', '5008765', 'นายทดสอบ 44444', '5008668'),
(6, '2010927050000', '5009942', 'พิพัฒน์พงษ์ เพริดพราว', '5008668');

-- --------------------------------------------------------

--
-- Table structure for table `p01_chk`
--

CREATE TABLE `p01_chk` (
  `chk_id` int NOT NULL,
  `chk_staffid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `chk_status` varchar(1) COLLATE utf8mb4_general_ci NOT NULL,
  `chk_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `p01_person`
--

CREATE TABLE `p01_person` (
  `p_id` int NOT NULL,
  `h_id` int NOT NULL,
  `p_no` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `p_subject` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `p_target` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_weight` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_score` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `p_staffid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `p_year` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `p_facid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `p_status` int NOT NULL DEFAULT '1' COMMENT '1=รอตรวจ / 2=อนุมัติ / 3=ไม่ผ่านอนุมัติ',
  `p_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `p01_person`
--

INSERT INTO `p01_person` (`p_id`, `h_id`, `p_no`, `p_subject`, `p_target`, `p_weight`, `p_score`, `p_staffid`, `p_year`, `p_facid`, `p_status`, `p_date`) VALUES
(1, 1, '1.1', 'ปริมาณงานของภาระงานหลักที่ปฏิบัติเป็นไปตามมาตรฐาน', '5', '5', '', '5009942', '2568', '201092704000', 3, '2024-08-08 10:06:03'),
(4, 1, '1.2', 'ประสิทธิภาพการดำเนินงานตามเป้าหมายและความรับผิดชอบที่แล้วเสร็จภายในระยะเวลาที่กำหนด', '5', '5', '', '5009942', '2568', '201092704000', 3, '2024-08-09 06:40:00'),
(5, 2, '2.1', 'คะแนนเฉลี่ยผลการดำเนินงานตัวชี้วัดที่รับผิดชอบ ตามแผนปฏิบัติราชการ ปี 67 กองแผนงาน', '5', '5', '', '5009942', '2568', '201092704000', 3, '2024-08-09 08:31:16'),
(8, 1, '1.3', 'ระดับความสำเร็จของการดำเนินงานตามภาระงานหลัก งานพัฒนาระบบคลังข้อมูลและสารสนเทศสถาบัน', '5', '35', NULL, '5009942', '2568', '201092704000', 3, '2024-08-17 06:40:56'),
(13, 1, '1.4', 'ระดับคุณภาพของการดำเนินงานหรือแก้ปัญหาร่วมกับงานอื่นหรือคณะ/หน่วยงาน', '5', '5', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 08:59:41'),
(15, 2, '2.3', 'ระดับความสำเร็จของการสรุปผลงานโดดเด่นของกลุ่มงาน', '5', '5', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 09:09:28'),
(16, 2, '2.4', 'คะแนนผลประเมินความพึงพอใจการให้บริการจากผู้รับบริการกองแผนงาน', '5', '5', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 09:10:35'),
(17, 3, '3.1', 'ผลประเมินการดำเนินงานตามแผนปฏิบัติราชการประจำปี 2567 กองแผนงาน', '5', '4', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 09:12:24'),
(18, 3, '3.2', 'ผลสัมฤทธิ์ของการดำเนินงานตามคำรับรองการปฏิบัติราชการประจำปี กองแผนงาน', '5', '4', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 09:13:47'),
(19, 3, '3.3', 'ผลประเมินคำรับรองการปฏิบัติราชการประจำปี 2567 กองแผนงาน', '5', '4', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 09:15:04'),
(20, 3, '3.4', 'ผลประเมิน ITA (OIT) ปี 67 กองแผนงาน', '5', '3', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 09:16:00'),
(23, 4, '4.1', 'ระดับความสำเร็จของการจัดทำข้อเสนอโครงการวิจัย', '5', '3', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 09:18:01'),
(24, 4, '4.2', 'มีการพัฒนาตนเอง', '5', '3', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 10:15:27'),
(25, 4, '4.3', 'ระดับคุณภาพของการวิเคราะห์ข้อมูลงานที่รับผิดชอบ', '5', '3', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 10:16:28'),
(26, 4, '4.4', 'ระดับคุณภาพการนำเสนอองค์ความรู้ที่เกี่ยวข้องกับการปฏิบัติงาน', '5', '3', NULL, '5009942', '2568', '201092704000', 3, '2024-08-21 10:17:59'),
(33, 4, '4.5', 'ระดับคุณภาพของผลงานที่เป็นรูปธรรมจากการนำความรู้ที่ได้รับจากการอบรม/สัมมนา/\nศึกษาดูงานมาประยุกต์ใช้ในการปฏิบัติงาน', '5', '3', NULL, '5009942', '2568', '201092704000', 3, '2024-08-23 08:01:16');

-- --------------------------------------------------------

--
-- Table structure for table `table_date`
--

CREATE TABLE `table_date` (
  `id` int NOT NULL,
  `d_date` int DEFAULT NULL COMMENT 'ปีงบประมาณ',
  `d_evaluationround` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'รอบการประเมิน',
  `evalua` int DEFAULT NULL,
  `d_recordingday` date DEFAULT NULL COMMENT 'ป.01-ป.02 สามารถบันทึกป.01-ป.02 สามารถบันทึกได้ถึงวันที่',
  `d_enddate` date DEFAULT NULL COMMENT 'วันที่สิ้นสุดการบันทึก',
  `d_scoringday` date DEFAULT NULL COMMENT 'วันที่กำหนดแสดงคะแนน',
  `fac_id` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'คณะหน่วยงาน',
  `dateAdd` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_date`
--

INSERT INTO `table_date` (`id`, `d_date`, `d_evaluationround`, `evalua`, `d_recordingday`, `d_enddate`, `d_scoringday`, `fac_id`, `dateAdd`) VALUES
(8, 2569, 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', 2, '2024-08-08', '2024-08-28', '2024-08-31', '201092704000', '2024-08-26 01:47:15'),
(9, 2568, 'รอบที่ 2 วันที่ 1 มีนาคม ถึง วันที่ 31 สิงหาคม', 2, '2024-09-02', '2024-11-16', '2024-11-29', '201092704000', '2024-09-02 01:23:28');

-- --------------------------------------------------------

--
-- Table structure for table `table_doc`
--

CREATE TABLE `table_doc` (
  `doc_id` int NOT NULL COMMENT 'รหัสเอกสาร',
  `p01_id` int NOT NULL COMMENT 'รหัสประเมิน/ป.01',
  `doc_no` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `doc_name` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ชื่อที่ตั้ง/ชื่อเอกสาร',
  `doc_file` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ไฟล์/ชื่อไฟล์',
  `doc_link` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_add` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_doc`
--

INSERT INTO `table_doc` (`doc_id`, `p01_id`, `doc_no`, `doc_name`, `doc_file`, `doc_link`, `data_add`) VALUES
(59, 1, '1', 'Test file', 'P03_1_267ec46f-2d30-4ae7-b47b-874f98720293.pdf', NULL, '2024-09-07 06:13:02');

-- --------------------------------------------------------

--
-- Table structure for table `table_h`
--

CREATE TABLE `table_h` (
  `id` int NOT NULL,
  `nameH` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `h_weight` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `h_year` varchar(5) COLLATE utf8mb4_general_ci NOT NULL,
  `h_fac` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_h`
--

INSERT INTO `table_h` (`id`, `nameH`, `h_weight`, `h_year`, `h_fac`) VALUES
(1, 'ภาระงานหลัก / งานประจำ', '50', '2568', '201092704000'),
(2, 'การขับเคลื่อนภารกิจ', '20', '2568', '201092704000'),
(3, 'ผลสัมฤทธิ์การมีส่วนร่วม', '15', '2568', '201092704000'),
(4, 'การพัฒนาศักยภาพ/พัฒนาตนเอง/พัฒนางาน', '15', '2568', '201092704000');

-- --------------------------------------------------------

--
-- Table structure for table `table_h_ind`
--

CREATE TABLE `table_h_ind` (
  `ind_id` int NOT NULL COMMENT 'รหัสตัวชี้วัด',
  `p_id` int NOT NULL COMMENT 'รหัสประเมิน/ข้อคำถาม',
  `ind_no` int NOT NULL COMMENT 'ข้อ/ลำดับ',
  `ind_Items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รายการ/ตัวชี้วัด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_h_ind`
--

INSERT INTO `table_h_ind` (`ind_id`, `p_id`, `ind_no`, `ind_Items`) VALUES
(358, 8, 1, 'มีการวิเคราะห์และออกแบบ และมีแผนการพัฒนาระบบประเมินรายบุคคล'),
(359, 8, 2, '-'),
(360, 8, 3, 'มีการพัฒนาระบบฯ แต่ยังไม่เริ่มให้หน่วยงานทดลองใช้งาน'),
(361, 8, 4, '-'),
(362, 8, 5, 'ระบบประเมินรายบุคคล มีการเริ่มทดลองใช้กับหน่วยงาน'),
(363, 13, 1, '-'),
(364, 13, 2, '-'),
(365, 13, 3, '-'),
(366, 13, 4, '-'),
(367, 13, 5, 'คะแนนเต็ม 10 คะแนน'),
(372, 15, 1, 'ไม่มีการสรุปผลงานโดดเด่นของงานและกลุ่มงาน รอบ 6 เดือน และ 12 เดือน'),
(373, 15, 2, '-'),
(374, 15, 3, '-'),
(375, 15, 4, 'มีการสรุปผลงานโดดเด่นของกลุ่มงาน  รอบ 6 เดือน และ 12 เดือน'),
(376, 15, 5, 'มีการจัดทำ PPT สรุปผลงานโดดเด่นของกลุ่มงาน'),
(382, 18, 1, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 1 คะแนน'),
(383, 18, 2, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 2 คะแนน'),
(384, 18, 3, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 3 คะแนน'),
(385, 18, 4, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 4 คะแนน'),
(386, 18, 5, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 5 คะแนน'),
(387, 19, 1, '-'),
(388, 19, 2, '-'),
(389, 19, 3, '-'),
(390, 19, 4, '-'),
(391, 19, 5, 'คะแนนเฉลี่ยผลประเมินฯตนเอง ณ 11 เดือน  ได้ไม่น้อยกว่า 4.50 คะแนน'),
(393, 23, 1, 'มีชื่อเรื่องโครงการวิจัย'),
(394, 23, 2, '-'),
(395, 23, 3, 'เข้าอบรมตลอดหลักสูตร แต่ไม่ผ่าน /มี Dashboard ของระบบที่รับผิดชอบแต่ไม่ครบ'),
(396, 23, 4, '-'),
(397, 23, 5, 'ผ่านการอบรมและได้ใบประกาศ / มี Dashboard ของระบบที่รับผิดชอบ'),
(398, 5, 0, '(ประเมินจากความก้าวหน้าการดำเนินงานตัวชี้วัดที่รับผิดชอบ รอบ 11 เดือน)'),
(399, 24, 1, 'ไม่ได้เข้าอบรม /ไม่มี Dashboard ของระบบที่รับผิดชอบ'),
(400, 24, 2, '-'),
(401, 24, 3, 'เข้าอบรมตลอดหลักสูตร แต่ไม่ผ่าน /มี Dashboard ของระบบที่รับผิดชอบแต่ไม่ครบ'),
(402, 24, 4, '-'),
(403, 24, 5, 'ผ่านการอบรมและได้ใบประกาศ / มี Dashboard ของระบบที่รับผิดชอบ'),
(404, 25, 1, '-'),
(405, 25, 2, '-'),
(406, 25, 3, '-'),
(407, 25, 4, '-'),
(408, 25, 5, '10 คะแนน'),
(409, 26, 1, '1 คะแนน'),
(410, 26, 2, '-'),
(411, 26, 3, '-'),
(412, 26, 4, '-'),
(413, 26, 5, '10 คะแนน'),
(440, 17, 1, 'คะแนนเฉลี่ยผลประเมินฯตนเอง ณ 11 เดือน  ไม่น้อยกว่า 3.00 คะแนน'),
(441, 17, 2, '-'),
(442, 17, 3, '-'),
(443, 17, 4, '-'),
(444, 17, 5, 'คะแนนเฉลี่ยผลประเมินฯตนเอง ณ 11 เดือน  ไม่น้อยกว่า 4.50 คะแนน'),
(458, 4, 1, 'การดำเนินการไม่แล้วเสร็จตามเป้าหมายทุกกิจกรรม'),
(459, 4, 2, 'ดำเนินการแล้วเสร็จ เพียงร้อยละ 25 ของงานที่อยู่ในความรับผิดชอบ'),
(460, 4, 3, 'ดำเนินการแล้วเสร็จ เพียงร้อยละ 50 ของงานที่อยู่ในความรับผิดชอบ'),
(461, 4, 4, 'ดำเนินการแล้วเสร็จภายในระยะเวลาที่กำหนดทุกเป้าหมาย'),
(462, 4, 5, 'ดำเนินการแล้วเสร็จก่อนเวลาทุกเป้าหมาย'),
(473, 1, 1, 'มีปริมาณงานต่ำกว่ามาตรฐาน'),
(474, 1, 2, '-'),
(475, 1, 3, 'มีปริมาณงานเป็นไปตามมาตรฐาน'),
(476, 1, 4, '-'),
(477, 1, 5, 'มีปริมาณงานสูงกว่าปริมาณงานตามมาตรฐาน'),
(500, 33, 1, '-'),
(501, 33, 2, '-'),
(502, 33, 3, '-'),
(503, 33, 4, '-'),
(504, 33, 5, '10 คะแนน');

-- --------------------------------------------------------

--
-- Table structure for table `table_indicators`
--

CREATE TABLE `table_indicators` (
  `ind_id` int NOT NULL COMMENT 'รหัสตัวชี้วัด',
  `p01_id` int NOT NULL COMMENT 'รหัสประเมิน/ข้อคำถาม',
  `ind_no` int NOT NULL COMMENT 'ข้อ/ลำดับ',
  `ind_Items` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รายการ/ตัวชี้วัด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_indicators`
--

INSERT INTO `table_indicators` (`ind_id`, `p01_id`, `ind_no`, `ind_Items`) VALUES
(6, 2, 1, 'มีการวิเคราะห์และออกแบบ และมีแผนการพัฒนาระบบประเมินรายบุคคล'),
(7, 2, 2, '-'),
(8, 2, 3, 'มีการพัฒนาระบบฯ แต่ยังไม่เริ่มให้หน่วยงานทดลองใช้งาน'),
(9, 2, 4, '-'),
(10, 2, 5, 'ระบบประเมินรายบุคคล มีการเริ่มทดลองใช้กับหน่วยงาน'),
(11, 3, 1, '-'),
(12, 3, 2, '-'),
(13, 3, 3, '-'),
(14, 3, 4, '-'),
(15, 3, 5, 'คะแนนเต็ม 10 คะแนน'),
(16, 4, 0, '(ประเมินจากความก้าวหน้าการดำเนินงานตัวชี้วัดที่รับผิดชอบ รอบ 11 เดือน)'),
(17, 5, 1, '(ประเมินจากการรายงานข้อมูลผลการดำเนินงานตัวชี้วัดในระบบ ITA)'),
(31, 10, 1, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 1 คะแนน'),
(32, 10, 2, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 2 คะแนน'),
(33, 10, 3, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 3 คะแนน'),
(34, 10, 4, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 4 คะแนน'),
(35, 10, 5, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 5 คะแนน'),
(36, 11, 1, 'SS2'),
(37, 11, 2, 'SS1'),
(38, 11, 3, 'SS3'),
(39, 11, 4, 'SS4'),
(40, 11, 5, 'SS5'),
(101, 16, 1, 'คะแนนเฉลี่ยผลประเมินฯตนเอง ณ 11 เดือน  ไม่น้อยกว่า 3.00 คะแนน'),
(102, 16, 2, '-'),
(103, 16, 3, '-'),
(104, 16, 4, '-'),
(105, 16, 5, 'คะแนนเฉลี่ยผลประเมินฯตนเอง ณ 11 เดือน  ไม่น้อยกว่า 4.50 คะแนน'),
(120, 18, 1, '-'),
(121, 18, 2, '-'),
(122, 18, 3, '-'),
(123, 18, 4, '-'),
(124, 18, 5, 'คะแนนเฉลี่ยผลประเมินฯตนเอง ณ 11 เดือน  ได้ไม่น้อยกว่า 4.50 คะแนน'),
(145, 17, 1, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 1 คะแนน'),
(146, 17, 2, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 2 คะแนน'),
(147, 17, 3, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 3 คะแนน'),
(148, 17, 4, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 4 คะแนน'),
(149, 17, 5, 'คะแนนเฉลี่ยผลประเมินฯ ได้ 5 คะแนน'),
(165, 27, 1, 'มีชื่อเรื่องโครงการวิจัย'),
(166, 27, 2, '-'),
(167, 27, 3, 'เข้าอบรมตลอดหลักสูตร แต่ไม่ผ่าน /มี Dashboard ของระบบที่รับผิดชอบแต่ไม่ครบ'),
(168, 27, 4, '-'),
(169, 27, 5, 'ผ่านการอบรมและได้ใบประกาศ / มี Dashboard ของระบบที่รับผิดชอบ'),
(170, 28, 1, 'ไม่ได้เข้าอบรม /ไม่มี Dashboard ของระบบที่รับผิดชอบ'),
(171, 28, 2, '-'),
(172, 28, 3, 'เข้าอบรมตลอดหลักสูตร แต่ไม่ผ่าน /มี Dashboard ของระบบที่รับผิดชอบแต่ไม่ครบ'),
(173, 28, 4, '-'),
(174, 28, 5, 'ผ่านการอบรมและได้ใบประกาศ / มี Dashboard ของระบบที่รับผิดชอบ'),
(205, 31, 1, '-'),
(206, 31, 2, '-'),
(207, 31, 3, '-'),
(208, 31, 4, '-'),
(209, 31, 5, '10 คะแนน'),
(215, 33, 1, '-'),
(216, 33, 2, '-'),
(217, 33, 3, '-'),
(218, 33, 4, '-'),
(219, 33, 5, 'คะแนนเฉลี่ยผลประเมินฯตนเอง ณ 11 เดือน  ได้ไม่น้อยกว่า 4.50 คะแนน'),
(220, 34, 1, 'Test1'),
(221, 34, 2, 'Test2'),
(222, 34, 3, 'Test3'),
(223, 34, 4, 'Test4'),
(224, 34, 5, 'Test5'),
(255, 1, 1, 'มีปริมาณงานต่ำกว่ามาตรฐาน'),
(256, 1, 2, '-'),
(257, 1, 3, 'มีปริมาณงานเป็นไปตามมาตรฐาน'),
(258, 1, 4, '-'),
(259, 1, 5, 'มีปริมาณงานสูงกว่าปริมาณงานตามมาตรฐาน');

-- --------------------------------------------------------

--
-- Table structure for table `table_p01`
--

CREATE TABLE `table_p01` (
  `p01_id` int NOT NULL COMMENT 'รหัสประเมิน/ข้อคำถาม',
  `p01_h` int NOT NULL,
  `p01_no` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ข้อ/ลำดับ',
  `p01_subject` text COLLATE utf8mb4_general_ci NOT NULL COMMENT 'เรื่อง	',
  `p01_target` int NOT NULL COMMENT 'ระดับเป้าหมาย',
  `p01_weight` int NOT NULL COMMENT 'น้ำหนัก',
  `p01_score` int DEFAULT '0' COMMENT 'ค่าคะแนนที่ได้',
  `p01_detail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ข้อเสนอแนะ',
  `staff_po` varchar(10) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'ผู้ประเมิน',
  `p01_staffid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ผู้เพิ้มข้อมูล',
  `p01_facid` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'คณะ',
  `p01_year` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ปีงบประมาณ',
  `p01_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'วัน/เวลา เพิ่มข้อมูล'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_p01`
--

INSERT INTO `table_p01` (`p01_id`, `p01_h`, `p01_no`, `p01_subject`, `p01_target`, `p01_weight`, `p01_score`, `p01_detail`, `staff_po`, `p01_staffid`, `p01_facid`, `p01_year`, `p01_date`) VALUES
(1, 1, '1.1', 'ปริมาณงานของภาระงานหลักที่ปฏิบัติเป็นไปตามมาตรฐาน', 5, 4, 3, 'Test 1.1 ปริมาณงานของภาระงานหลักที่ปฏิบัติเป็นไปตามมาตรฐาน', '130102', '5009942', '201092704000', '2568', '2024-09-10 04:01:35'),
(2, 1, '1.3', 'ระดับความสำเร็จของการดำเนินงานตามภาระงานหลัก งานพัฒนาระบบคลังข้อมูลและสารสนเทศสถาบัน', 5, 35, 2, 'XXXX', '130102', '5009942', '201092704000', '2568', '2024-09-09 11:31:30'),
(3, 1, '1.4', 'ระดับคุณภาพของการดำเนินงานหรือแก้ปัญหาร่วมกับงานอื่นหรือคณะ/หน่วยงาน', 5, 5, 5, 'ZZZ', '130102', '5009942', '201092704000', '2568', '2024-09-10 04:08:46'),
(4, 2, '2.1', 'คะแนนเฉลี่ยผลการดำเนินงานตัวชี้วัดที่รับผิดชอบ ตามแผนปฏิบัติราชการ ปี 67 กองแผนงาน', 5, 5, 4, 'Test', '130102', '5009942', '201092704000', '2568', '2024-09-10 04:12:39'),
(5, 2, '2.2', 'คะแนนเฉลี่ยผลการดำเนินงานตัวชี้วัดที่รับผิดชอบ  ITA ปี 2567 กองแผนงาน', 5, 5, 0, '', NULL, '5009942', '201092704000', '2568', '2024-08-26 08:49:37'),
(16, 3, '3.1', 'ผลประเมินการดำเนินงานตามแผนปฏิบัติราชการประจำปี 2567 กองแผนงาน', 5, 4, 0, '', NULL, '5009942', '201092704000', '2568', '2024-08-27 06:44:15'),
(17, 3, '3.2', 'ผลสัมฤทธิ์ของการดำเนินงานตามคำรับรองการปฏิบัติราชการประจำปี กองแผนงาน', 5, 4, 0, '', NULL, '5009942', '201092704000', '2568', '2024-08-27 07:44:41'),
(18, 3, '3.3', 'ผลประเมินคำรับรองการปฏิบัติราชการประจำปี 2567 กองแผนงาน', 3, 4, 0, '', NULL, '5009942', '201092704000', '2569', '2024-08-27 07:41:58'),
(19, 3, '3.4', 'ผลประเมิน ITA (OIT) ปี 67 กองแผนงาน', 4, 3, 0, '', NULL, '5009942', '201092704000', '2569', '2024-08-27 07:41:39'),
(27, 4, '4.1', 'ระดับความสำเร็จของการจัดทำข้อเสนอโครงการวิจัย', 5, 3, 0, '', NULL, '5009942', '201092704000', '2568', '2024-08-27 07:54:23'),
(28, 4, '4.2', 'มีการพัฒนาตนเอง', 5, 3, 0, '', NULL, '5009942', '201092704000', '2568', '2024-08-28 08:43:31'),
(31, 4, '4.3', 'ระดับคุณภาพของการวิเคราะห์ข้อมูลงานที่รับผิดชอบ', 5, 3, 0, '', NULL, '5009942', '201092704000', '2568', '2024-08-29 04:40:28'),
(33, 3, '3.3', 'ผลประเมินคำรับรองการปฏิบัติราชการประจำปี 2567 กองแผนงาน', 5, 4, 0, '', NULL, '5009942', '201092704000', '2568', '2024-09-01 05:03:42'),
(34, 4, '4.8', 'TestTest', 5, 5, 0, '', NULL, '5009942', '201092704000', '2568', '2024-09-03 10:43:33');

-- --------------------------------------------------------

--
-- Table structure for table `table_p02`
--

CREATE TABLE `table_p02` (
  `p02_id` int NOT NULL COMMENT 'ลำดับ',
  `staff_po` varchar(10) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รหัสผู้ประเมิน',
  `staff_id` varchar(10) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รหัสผู้รับการประเมิน',
  `fac_id` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รหัสคณะ',
  `year` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ปีงบประมาณ',
  `record` int NOT NULL COMMENT 'รอบประเมิน',
  `improvements` text COLLATE utf8mb4_general_ci COMMENT '1) จุดเด่น และ/หรือ สิ่งทีควรปรับปรุงแก้ไข',
  `suggestions` text COLLATE utf8mb4_general_ci COMMENT '2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา',
  `p1` int DEFAULT NULL,
  `p2` int DEFAULT NULL,
  `p3` int DEFAULT NULL,
  `p4` int DEFAULT NULL,
  `p5` int DEFAULT NULL,
  `p6` int DEFAULT NULL,
  `p7` int DEFAULT NULL,
  `p8` int DEFAULT NULL,
  `p9` int DEFAULT NULL,
  `p10` int DEFAULT NULL,
  `p11` int DEFAULT NULL,
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_p02`
--

INSERT INTO `table_p02` (`p02_id`, `staff_po`, `staff_id`, `fac_id`, `year`, `record`, `improvements`, `suggestions`, `p1`, `p2`, `p3`, `p4`, `p5`, `p6`, `p7`, `p8`, `p9`, `p10`, `p11`, `date_add`) VALUES
(5, '130102', '5009942', '201092704000', '2568', 2, 'Test 1) จุดเด่น และ/หรือ สิ่งที่ควรปรับปรุงแก้ไข XXX', 'test 2) ข้อเสนอแนะเกี่ยวกับวิธีส่งเสริมและพัฒนา CCCC', -1, 2, 3, 4, 0, 6, 7, 8, 0, 10, 0, '2024-09-09 11:27:26');

-- --------------------------------------------------------

--
-- Table structure for table `table_p03`
--

CREATE TABLE `table_p03` (
  `p01_id` int NOT NULL COMMENT 'รหัสประเมิน/ข้อคำถาม',
  `p01_score` int DEFAULT '0' COMMENT 'ค่าคะแนน',
  `p03_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'วัน/เวลา เพิ่มข้อมูล'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_p03`
--

INSERT INTO `table_p03` (`p01_id`, `p01_score`, `p03_date`) VALUES
(6, 5, '2024-09-02 02:13:48'),
(2, 4, '2024-09-02 02:37:37'),
(1, 4, '2024-09-03 10:57:59');

-- --------------------------------------------------------

--
-- Table structure for table `table_p03_ind`
--

CREATE TABLE `table_p03_ind` (
  `p03ind_id` int NOT NULL COMMENT 'รหัสตัวชี้วัด',
  `p01_id` int NOT NULL COMMENT 'รหัสประเมิน/ข้อคำถาม',
  `p03ind_no` varchar(5) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ข้อ/ลำดับ',
  `p03ind_Items` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รายการ/ตัวชี้วัด'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_p03_ind`
--

INSERT INTO `table_p03_ind` (`p03ind_id`, `p01_id`, `p03ind_no`, `p03ind_Items`) VALUES
(22, 6, '1.1', 'Test รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน  1-2'),
(23, 6, '1.2', 'Test รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน 1.23'),
(24, 6, '1.3', 'Test รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน 1-24'),
(49, 1, '1', 'Test รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน'),
(50, 1, '2', 'Test 2 รายงานผลการปฏิบัติราชการตามตัวชี้วัด/ เกณฑ์การประเมิน');

-- --------------------------------------------------------

--
-- Table structure for table `table_p04`
--

CREATE TABLE `table_p04` (
  `p02_id` int NOT NULL COMMENT 'ลำดับ',
  `staff_id` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รหัสผู้รับการประเมิน',
  `fac_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'รหัสคณะ',
  `year` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'ปีงบประมาณ',
  `record` int NOT NULL COMMENT 'รอบประเมิน',
  `p04_re1` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'ความรู้/ทักษะ/สมรรถนะ ที่ต้องการพัฒนา',
  `p04_re2` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci COMMENT 'วิธีการพัฒนา',
  `p04_re3` text COLLATE utf8mb4_general_ci COMMENT 'ช่วงเวลาที่ต้องการพัฒนา',
  `date_add` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `table_p04`
--

INSERT INTO `table_p04` (`p02_id`, `staff_id`, `fac_id`, `year`, `record`, `p04_re1`, `p04_re2`, `p04_re3`, `date_add`) VALUES
(18, '5009942', '201092704000', '2568', 2, '1', '1111', '1111', '2024-09-09 11:39:37'),
(19, '5009942', '201092704000', '2568', 2, '2', '2222', '222222', '2024-09-09 11:39:37');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `staffid` int NOT NULL,
  `fullname` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `fac` varchar(20) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `staffid`, `fullname`, `fac`) VALUES
(1, 5001234, 'นายทดสอบ 1111111', '2010927040000'),
(2, 5004321, 'นายทดสอบ 2222222', '2010927040000'),
(3, 5005678, 'นายทดสอบ 33333', '2010927040000'),
(4, 5008765, 'นายทดสอบ 44444', '2010927040000'),
(5, 5009942, 'พิพัฒน์พงษ์ เพริดพราว', '2010927040000');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `manag_head`
--
ALTER TABLE `manag_head`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `p01_chk`
--
ALTER TABLE `p01_chk`
  ADD PRIMARY KEY (`chk_id`);

--
-- Indexes for table `p01_person`
--
ALTER TABLE `p01_person`
  ADD PRIMARY KEY (`p_id`);

--
-- Indexes for table `table_date`
--
ALTER TABLE `table_date`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `table_doc`
--
ALTER TABLE `table_doc`
  ADD PRIMARY KEY (`doc_id`);

--
-- Indexes for table `table_h`
--
ALTER TABLE `table_h`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `table_h_ind`
--
ALTER TABLE `table_h_ind`
  ADD PRIMARY KEY (`ind_id`);

--
-- Indexes for table `table_indicators`
--
ALTER TABLE `table_indicators`
  ADD PRIMARY KEY (`ind_id`);

--
-- Indexes for table `table_p01`
--
ALTER TABLE `table_p01`
  ADD PRIMARY KEY (`p01_id`);

--
-- Indexes for table `table_p02`
--
ALTER TABLE `table_p02`
  ADD PRIMARY KEY (`p02_id`);

--
-- Indexes for table `table_p03_ind`
--
ALTER TABLE `table_p03_ind`
  ADD PRIMARY KEY (`p03ind_id`);

--
-- Indexes for table `table_p04`
--
ALTER TABLE `table_p04`
  ADD PRIMARY KEY (`p02_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `manag_head`
--
ALTER TABLE `manag_head`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `p01_chk`
--
ALTER TABLE `p01_chk`
  MODIFY `chk_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `p01_person`
--
ALTER TABLE `p01_person`
  MODIFY `p_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `table_date`
--
ALTER TABLE `table_date`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `table_doc`
--
ALTER TABLE `table_doc`
  MODIFY `doc_id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสเอกสาร', AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `table_h`
--
ALTER TABLE `table_h`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `table_h_ind`
--
ALTER TABLE `table_h_ind`
  MODIFY `ind_id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสตัวชี้วัด', AUTO_INCREMENT=514;

--
-- AUTO_INCREMENT for table `table_indicators`
--
ALTER TABLE `table_indicators`
  MODIFY `ind_id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสตัวชี้วัด', AUTO_INCREMENT=260;

--
-- AUTO_INCREMENT for table `table_p01`
--
ALTER TABLE `table_p01`
  MODIFY `p01_id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสประเมิน/ข้อคำถาม', AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `table_p02`
--
ALTER TABLE `table_p02`
  MODIFY `p02_id` int NOT NULL AUTO_INCREMENT COMMENT 'ลำดับ', AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `table_p03_ind`
--
ALTER TABLE `table_p03_ind`
  MODIFY `p03ind_id` int NOT NULL AUTO_INCREMENT COMMENT 'รหัสตัวชี้วัด', AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `table_p04`
--
ALTER TABLE `table_p04`
  MODIFY `p02_id` int NOT NULL AUTO_INCREMENT COMMENT 'ลำดับ', AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
