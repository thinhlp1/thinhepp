DELIMITER //

CREATE PROCEDURE ExecuteOnMultipleDatabases(
        IN databasess TEXT, 
        IN query_template TEXT)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE dbCount INT;
    DECLARE dbName VARCHAR(255);
    DECLARE exec_query TEXT;

    -- Đếm số lượng databases dựa trên số dấu phẩy
    SET dbCount = LENGTH(databasess) - LENGTH(REPLACE(databasess, ',', '')) + 1;

    -- Vòng lặp qua từng database
    WHILE i < dbCount DO
        SET dbName = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(databasess, ',', i + 1), ',', -1));
        
        -- Tạo câu lệnh SQL cho database hiện tại
        SET @exec_query = REPLACE(query_template, '{db}', dbName);

        -- Thực thi lệnh SQL động
        PREPARE stmt FROM @exec_query;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;



CALL ExecuteOnMultipleDatabases(
    'student_care_pa , student_care_pc, student_care_pd,student_care_ph ,student_care_pi ,student_care_pk ,student_care_pn ,student_care_pp ,student_care_ps ,student_care_pt ,student_care_py',
    'ALTER TABLE {db}.campaign_details 
     ADD COLUMN major_name VARCHAR(255) NULL AFTER student_code, 
     ADD COLUMN specialized_major_name VARCHAR(255) NULL AFTER major_name,
     ADD COLUMN need_recare TINYINT DEFAULT 0 AFTER deleted'
);