-- Stored Procedure to handle subject allotment changes
CREATE PROCEDURE UpdateSubjectAllotment (
    @StudentId INT,
    @SubjectId VARCHAR(10)
)
AS
BEGIN
    -- Check if the requested subject is already allotted to the student
    IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = @StudentId AND SubjectId = @SubjectId)
    BEGIN
        -- If the requested subject is already allotted, do nothing
        RETURN;
    END
    -- Check if the student has an active subject
    IF EXISTS (SELECT 1 FROM SubjectAllotments WHERE StudentId = @StudentId AND Is_Valid = 1)
    BEGIN
        -- If the student has an active subject, update the existing record to invalid
        UPDATE SubjectAllotments
        SET Is_Valid = 0
        WHERE StudentId = @StudentId AND Is_Valid = 1;
    END
    -- Insert a new record for the requested subject, marking it as valid
    INSERT INTO SubjectAllotments (StudentId, SubjectId, Is_Valid)
    VALUES (@StudentId, @SubjectId, 1);
END;
GO