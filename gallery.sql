-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 192.168.0.102:3306
-- Время создания: Апр 20 2023 г., 15:03
-- Версия сервера: 8.0.30
-- Версия PHP: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `gallery`
--

-- --------------------------------------------------------

--
-- Структура таблицы `comment`
--

CREATE TABLE `comment` (
  `id` int UNSIGNED NOT NULL,
  `user_id` int DEFAULT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_520_ci NOT NULL,
  `img_id` bigint UNSIGNED DEFAULT NULL,
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Дамп данных таблицы `comment`
--

INSERT INTO `comment` (`id`, `user_id`, `comment`, `img_id`, `created`) VALUES
(8, 4, 'фывфывфыв', 4, '2023-04-20 11:27:01'),
(9, 4, 'фывфывфывфыв', 6, '2023-04-20 11:27:06');

-- --------------------------------------------------------

--
-- Структура таблицы `images`
--

CREATE TABLE `images` (
  `id` int NOT NULL,
  `file_name` varchar(191) COLLATE utf8mb4_unicode_520_ci DEFAULT NULL,
  `user_id` int NOT NULL,
  `created` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_520_ci;

--
-- Дамп данных таблицы `images`
--

INSERT INTO `images` (`id`, `file_name`, `user_id`, `created`) VALUES
(4, 'tsvety-fon-romashki-babochka-makro-priroda.jpg', 5, '2023-04-20 06:02:30'),
(6, 'adam-bird-maria-amanda-model-plate-mesiats-ozero-voda-nastro.jpg', 5, '2023-04-20 06:02:30'),
(9, 'mercedes_benz_cls63-1920x1080.jpg', 5, '2023-04-20 06:02:30');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `user_hash` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT '',
  `user_ip` bigint DEFAULT '0',
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `role` varchar(191) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `user_hash`, `user_ip`, `created`, `updated`, `role`) VALUES
(1, 'user 1', 'test@test.test', '$2y$10$/vJwVPAf93VSYjd9O8dXzOcuWSLRoHaC3iqCYMAYSI.wDPHP9oYOy', 'mQK4KnUo9V', 2130706433, '2023-04-08 11:01:03', '2023-04-20 11:27:20', 'staff'),
(2, 'user 2', 'test2@test.test', '$2y$10$uZAjIUoPeWHtH9EOEw.Xs.aNwV9DOqpMsOmMMBbXmUE.AprYxfZHO', 'eHXBUnYTyo', 3232235622, '2023-04-08 11:05:05', '2023-04-14 18:03:36', 'staff'),
(3, 'Василий', 'test3@test.test', '$2y$10$YPWXnW5jT9zfFvPiiQXJIO/eAQKzFC/i0ehV9SYeJ.cvBa7LJy6DK', '2t5OpmUZZU', 3232235622, '2023-04-14 18:55:59', NULL, 'user'),
(4, 'Гришка', 'test4@test.test', '$2y$10$chSLCfV5XhlEsA.tmm9iq.b8TFdxOuwiqyQSBT9uy.U0lNDuTQoWy', 'h9xQNuwS3E', 2130706433, '2023-04-20 06:09:04', '2023-04-20 10:49:32', 'user'),
(5, 'Степан', 'test5@test.test', '$2y$10$l/zYzTl34FkGPtfv/x.SL.rBVFuZLwXcUFe1kxpSjzvfMRp5gS2aC', 'yStb7cyCSm', 2130706433, '2023-04-18 13:03:52', '2023-04-20 11:26:27', 'user'),
(6, 'Васька', 'test6@test.test', '$2y$10$tz7TzBU/xY43G5rbTd7GO.6tS8i8CTbc9UmdoHw4NWPE7PYwuEnt2', 'NJMa8pGbH6', 2130706433, '2023-04-20 07:12:26', NULL, 'user');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`id`),
  ADD KEY `index_foreignkey_comment_user` (`user_id`),
  ADD KEY `img_id` (`img_id`);

--
-- Индексы таблицы `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `file_name` (`file_name`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD UNIQUE KEY `email_unique` (`email`) USING BTREE;

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `comment`
--
ALTER TABLE `comment`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT для таблицы `images`
--
ALTER TABLE `images`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;

--
-- Ограничения внешнего ключа таблицы `images`
--
ALTER TABLE `images`
  ADD CONSTRAINT `images_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
