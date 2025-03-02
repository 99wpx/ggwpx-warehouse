-- Tabel `warehouse`
CREATE TABLE `warehouse` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `location` INT(11) NULL DEFAULT NULL,
    `citizenid` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
    `name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
    `password` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE='utf8mb4_general_ci';

-- Tabel `stashitems`
CREATE TABLE `stashitems` (
    `stash` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_general_ci',
    `items` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
    PRIMARY KEY (`stash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE='utf8mb4_general_ci';
