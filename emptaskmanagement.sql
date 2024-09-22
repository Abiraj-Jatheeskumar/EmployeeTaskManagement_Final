-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 11, 2024 at 03:48 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `emptaskmanagement`
--

-- --------------------------------------------------------

--
-- Table structure for table `files`
--

CREATE TABLE `files` (
  `file_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `file_path` varchar(255) NOT NULL,
  `uploaded_date` date NOT NULL,
  `file_name` varchar(100) NOT NULL,
  `project_status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `files`
--

INSERT INTO `files` (`file_id`, `project_id`, `user_id`, `file_path`, `uploaded_date`, `file_name`, `project_status`) VALUES
(1, 1, 1, 'https://drive.google.com/file/d/1lJymwsW24ZiMNUz3_ZeDo3hWBn7Zhreh/view?usp=sharing', '2023-01-15', 'file1.docx', 'Completed'),
(2, 2, 2, 'https://drive.google.com/file/d/1K2xYMj2P-9z79DPsQu00p_7BRoSWpwUf/view?usp=sharing', '2023-02-15', 'file2.docx', 'In Progress'),
(3, 3, 3, 'https://drive.google.com/file/d/11BH1ML-y3ZEQnOIcWZEob7J7dJ0MuazD/view?usp=sharing', '2023-03-15', 'file3.docx', 'Not Started'),
(4, 4, 4, 'https://drive.google.com/file/d/1jS5o5hBnWzaWa-TXj8BNGzR9yRK5suUQ/view?usp=sharing', '2023-04-15', 'file4.docx', 'In Progress'),
(5, 5, 5, 'https://drive.google.com/file/d/1wNt_NKlAHg_5we1-XwsFIIQrpEIY4kvB/view?usp=sharing', '2023-05-15', 'file5.docx', 'Completed'),
(7, 7, 7, 'https://drive.google.com/file/d/1Je6rlr_CF81rVGHQ_iDwI58jM5BGh6dg/view?usp=sharing', '2023-07-15', 'file7.docx', 'In Progress'),
(8, 8, 8, 'https://drive.google.com/file/d/1lJymwsW24ZiMNUz3_ZeDo3hWBn7Zhreh/view?usp=sharing', '2023-08-15', 'file8.docx', 'Completed'),
(9, 9, 9, 'https://drive.google.com/file/d/1K2xYMj2P-9z79DPsQu00p_7BRoSWpwUf/view?usp=sharing', '2023-09-15', 'file9.docx', 'In Progress'),
(12, 1, 6, 'https://drive.google.com/file/d/186tUpl-FWEN-KvC8qLFoW-6y2v5FMQ6n/view?usp=drive_link', '2024-08-10', 'testing1', 'Completed'),
(15, 6, 6, 'https://drive.google.com/drive/folders/1FM1YZjuEiQoSFdGDG8-ztRrpFS_qx581?usp=drive_link', '2024-08-10', 'frontend', 'Pending'),
(17, 6, 6, 'https://drive.google.com/drive/folders/1FM1YZjuEiQoSFdGDG8-ztRrpFS_qx581?usp=drive_link', '2024-08-11', 'frontend', 'Completed');

-- --------------------------------------------------------

--
-- Table structure for table `progress`
--

CREATE TABLE `progress` (
  `progress_id` int(11) NOT NULL,
  `task_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `progress_date` date DEFAULT NULL,
  `progress_description` text DEFAULT NULL,
  `progress_percentage` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `progress`
--

INSERT INTO `progress` (`progress_id`, `task_id`, `user_id`, `progress_date`, `progress_description`, `progress_percentage`) VALUES
(1, 1, 1, '2023-01-05', 'Initial setup', 20),
(2, 2, 2, '2023-02-05', 'Requirement analysis', 40),
(3, 3, 3, '2023-03-05', 'Design phase', 60),
(4, 4, 4, '2023-04-05', 'Development phase', 80),
(5, 5, 5, '2023-05-05', 'Testing phase', 55),
(6, 6, 6, '2023-06-05', 'Initial setup', 20),
(7, 7, 7, '2023-07-05', 'Requirement analysis', 40),
(8, 8, 8, '2023-08-05', 'Design phase', 60),
(9, 9, 9, '2023-09-05', 'Development phase', 80),
(11, 14, 6, '2024-08-31', 'most', 90),
(25, 7, 9, '2024-08-31', 'coming up', 60),
(26, 7, 9, '2024-09-01', 'over', 45),
(27, 15, 6, '2024-08-22', 'almost done', 99),
(28, 6, 6, '2024-01-01', 'backend', 45);

-- --------------------------------------------------------

--
-- Table structure for table `project`
--

CREATE TABLE `project` (
  `project_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `project_name` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `project_status` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `project`
--

INSERT INTO `project` (`project_id`, `user_id`, `project_name`, `description`, `start_date`, `end_date`, `project_status`) VALUES
(1, 4, 'Project Alpha', 'Description of Project Alphai', '2023-01-01', '2024-06-01', 'Pending'),
(2, 2, 'Project Beta', 'Description of Project Beta', '2023-02-01', '2023-07-01', 'Pending'),
(3, 5, 'Project Gamma', 'Description of Project Gamma', '2023-03-01', '2023-08-01', 'Pending'),
(4, 5, 'Project Delta', 'Description of Project Delta', '2023-04-01', '2023-09-01', 'Pending'),
(5, 3, 'Project Epsilon', 'Description of Project Epsilon', '2023-05-01', '2024-10-01', 'Pending'),
(6, 4, 'Project Zeta', 'Description of Project Zeta', '2023-06-01', '2023-11-01', 'Pending'),
(7, 3, 'Project Eta', 'Description of Project Eta', '2023-07-01', '2023-12-01', 'Pending'),
(8, 2, 'Project Theta', 'Description of Project Theta', '2023-08-01', '2024-01-01', 'Pending'),
(9, 5, 'Project Iota', 'Description of Project Iota', '2022-09-01', '2025-02-01', 'On Hold'),
(13, 3, 'test2', 'test 2', '2024-08-17', '2024-08-24', 'Completed'),
(14, 3, 'test2', 'test1', '2024-08-28', '2024-09-26', 'On Hold');

-- --------------------------------------------------------

--
-- Table structure for table `task`
--

CREATE TABLE `task` (
  `task_id` int(11) NOT NULL,
  `project_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `task_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `priority` varchar(50) DEFAULT NULL,
  `due_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `task`
--

INSERT INTO `task` (`task_id`, `project_id`, `user_id`, `task_name`, `description`, `status`, `priority`, `due_date`) VALUES
(1, 1, 1, 'Task 1', 'Description of Task 1', 'In Progress', 'High', '2023-05-01'),
(2, 2, 2, 'Task 2', 'Description of Task 2', 'In Progress', 'Medium', '2023-06-01'),
(3, 3, 3, 'Task 3', 'Description of Task 3', 'Not Started', 'Low', '2023-07-01'),
(4, 4, 4, 'Task 4', 'Description of Task 4', 'In Progress', 'High', '2023-08-01'),
(5, 5, 5, 'Task 5', 'Description of Task 5', 'Completed', 'Medium', '2023-09-01'),
(6, 6, 6, 'Task 6', 'Description of Task 6', 'Not Started', 'Low', '2023-10-01'),
(7, 7, 9, 'hello kitty', 'Description of Task 7', 'In Progress', 'Low', '2023-11-01'),
(8, 8, 10, 'Task 8', 'Description of Task 8', 'Completed', 'Medium', '2023-12-01'),
(9, 9, 9, 'Task 9', 'Description of Task 9', 'In Progress', 'Low', '2024-01-01'),
(13, 9, 8, 'w', 'ghgj', 'On Hold', 'Medium', '2024-08-22'),
(14, 6, 6, 'w', 'hello', 'Pending', 'High', '2024-08-31'),
(15, 1, 6, 'wi', 'o this oi', 'Completed', 'Medium', '2024-08-31');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_id` int(11) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `role` varchar(25) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `contact_num` varchar(20) DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `password` varchar(64) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_id`, `user_name`, `email`, `role`, `first_name`, `last_name`, `contact_num`, `profile_picture`, `password`) VALUES
(1, 'alicer', 'alice@example.com', 'admin', 'Alice', 'Johnson', '555-12346', 'https://media.licdn.com/dms/image/v2/D4E03AQFz1-h8AEgemg/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1686675569528?e=2147483647&v=beta&t=-RhpL0BDeLo59mP_gRb4uFlt3mw9o4KFHggv3eurlh4', '482c811da5d5b4bc6d497ffa98491e38'),
(2, 'bob', 'bob@example.com', 'manager', 'Bob', 'Smith', '555-5678', 'https://media.licdn.com/dms/image/C4E03AQEcKpZutwrvpg/profile-displayphoto-shrink_200_200/0/1517730541240?e=2147483647&v=beta&t=4n8cEdh74yy83E7zYv3QToYrglXp6xZl3L7iLn4zY30', '482c811da5d5b4bc6d497ffa98491e38'),
(3, 'carol', 'carol@example.com', 'manager', 'Carol', 'Williams', '555-8765', 'https://media.licdn.com/dms/image/v2/C5603AQFFRVS-QxreZw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1516989615549?e=2147483647&v=beta&t=ZA2hctwMXEAAAFAkYsilPMkFtZM6oK5Leao0Bsm8eEU', '482c811da5d5b4bc6d497ffa98491e38'),
(4, 'dave', 'dave@example.com', 'manager', 'Dave', 'Brown', '555-4321', 'https://media.licdn.com/dms/image/v2/D4E03AQEx6GdcJ_isbw/profile-displayphoto-shrink_200_200/profile-displayphoto-shrink_200_200/0/1692367855032?e=2147483647&v=beta&t=4DgH2rPnyRrPpjaoBNYwUl9sUtS35Hsgw-xRDt8Ks10', '482c811da5d5b4bc6d497ffa98491e38'),
(5, 'eve', 'eve@example.com', 'manager', 'Eve', 'Davis', '555-1111', 'https://media.licdn.com/dms/image/C5603AQFF-9aUwctoYg/profile-displayphoto-shrink_200_200/0/1528213570231?e=2147483647&v=beta&t=bNvXw9f-4x5XB1FYTDgQCSquFq4cJtezs7GSNIZiK74', '482c811da5d5b4bc6d497ffa98491e38'),
(6, 'frank', 'frank@example.com', 'employee', 'Frank', 'Miller', '555-2222', 'https://media.licdn.com/dms/image/D5603AQGeMJBW4KsrOw/profile-displayphoto-shrink_200_200/0/1695777892545?e=2147483647&v=beta&t=EKQV8x91oPTlEsnGUBUjyVeTwnFQ0saXomfVZHvCudU', '482c811da5d5b4bc6d497ffa98491e38'),
(7, 'grace', 'grace@example.com', 'employee', 'Grace', 'Wilson', '555-3333', 'https://media.licdn.com/dms/image/C4E03AQG00dHn-0ZMtQ/profile-displayphoto-shrink_200_200/0/1517746438402?e=2147483647&v=beta&t=6834S5FzpCpVhhQ1PrWWnLYlG33sqkmV37ZmNCG0GnE', '482c811da5d5b4bc6d497ffa98491e38'),
(8, 'heidi', 'heidi@example.com', 'employee', 'Heidi', 'Moore', '555-4444', 'https://media.licdn.com/dms/image/D4E03AQHtp9ERkDkqtw/profile-displayphoto-shrink_200_200/0/1676391669939?e=2147483647&v=beta&t=a3JQqDV1nSB1nLACL4d3tP_GL6KLEMT_8t2Att2GJFU', '482c811da5d5b4bc6d497ffa98491e38'),
(9, 'ivann', 'ivan@example.com', 'employee', 'Ivan', 'Taylor', '555-5555', 'https://media.licdn.com/dms/image/C5603AQHPmcwzjId-EQ/profile-displayphoto-shrink_200_200/0/1561211243959?e=2147483647&v=beta&t=Mbf28_P0x4VYjFXBUn1MJCO6y-VRXJvZ2wQMNq9QAJY', '482c811da5d5b4bc6d497ffa98491e38'),
(10, 'judyii', 'judyii@example.com', 'admin', 'Judyi', 'Anderson', '555-6666', 'https://media.licdn.com/dms/image/C5103AQFHqmIHiDjnbg/profile-displayphoto-shrink_200_200/0/1516355532643?e=2147483647&v=beta&t=UjXGVRuVytUBX858qRweRwvjgdw4ZjDRQ2RmxlT7D-o', '482c811da5d5b4bc6d497ffa98491e38'),
(20, 'amaliw', 'pjramyanath@gmail.com', 'employee', 'pasanww', 'ramyanathw', '0710662344', 'https://media.licdn.com/dms/image/C4E03AQFNzOBK5Y6fpg/profile-displayphoto-shrink_200_200/0/1516891211318?e=2147483647&v=beta&t=UCffQZM9fL6SeXK46wjtUGGrAVTEZjQddaOJkb1T5YU', '202cb962ac59075b964b07152d234b70');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `files`
--
ALTER TABLE `files`
  ADD PRIMARY KEY (`file_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `progress`
--
ALTER TABLE `progress`
  ADD PRIMARY KEY (`progress_id`),
  ADD KEY `task_id` (`task_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `project`
--
ALTER TABLE `project`
  ADD PRIMARY KEY (`project_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `task`
--
ALTER TABLE `task`
  ADD PRIMARY KEY (`task_id`),
  ADD KEY `project_id` (`project_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `files`
--
ALTER TABLE `files`
  MODIFY `file_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `progress`
--
ALTER TABLE `progress`
  MODIFY `progress_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `project`
--
ALTER TABLE `project`
  MODIFY `project_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `task`
--
ALTER TABLE `task`
  MODIFY `task_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `files`
--
ALTER TABLE `files`
  ADD CONSTRAINT `files_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `files_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `progress`
--
ALTER TABLE `progress`
  ADD CONSTRAINT `progress_ibfk_1` FOREIGN KEY (`task_id`) REFERENCES `task` (`task_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `progress_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `project`
--
ALTER TABLE `project`
  ADD CONSTRAINT `project_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);

--
-- Constraints for table `task`
--
ALTER TABLE `task`
  ADD CONSTRAINT `task_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `project` (`project_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `task_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
