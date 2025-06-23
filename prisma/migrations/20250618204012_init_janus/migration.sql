-- CreateTable
CREATE TABLE `yggc_authorization_codes` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `consumed` BOOLEAN NOT NULL DEFAULT false,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_authorization_codes_id_key`(`id`),
    UNIQUE INDEX `yggc_authorization_codes_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_device_codes` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `userCode` VARCHAR(191) NULL,
    `uid` VARCHAR(255) NULL,
    `consumed` BOOLEAN NOT NULL DEFAULT false,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_device_codes_id_key`(`id`),
    UNIQUE INDEX `yggc_device_codes_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_refresh_tokens` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `consumed` BOOLEAN NOT NULL DEFAULT false,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_refresh_tokens_id_key`(`id`),
    UNIQUE INDEX `yggc_refresh_tokens_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_grants` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_grants_id_key`(`id`),
    UNIQUE INDEX `yggc_grants_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_interactions` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_interactions_id_key`(`id`),
    UNIQUE INDEX `yggc_interactions_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_sessions` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_sessions_id_key`(`id`),
    UNIQUE INDEX `yggc_sessions_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
