CREATE DATABASE HanamiLearn

GO

USE HanamiLearn
GO

-- 1. Bảng Users
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    fullname NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    password_hash NVARCHAR(255) NOT NULL,
    role NVARCHAR(50) NOT NULL, -- 'student', 'teacher', 'admin'
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);

-- 2. Bảng Courses
CREATE TABLE Courses (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    teacher_id INT NOT NULL,
    price DECIMAL(18,2) DEFAULT 0,
    thumbnail_url NVARCHAR(500) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Courses_Teacher FOREIGN KEY (teacher_id) REFERENCES Users(user_id)
);

-- 3. Bảng Lessons
CREATE TABLE Lessons (
    lesson_id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    content NVARCHAR(MAX) NULL, -- Có thể lưu HTML, link video, tài liệu
    order_index INT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Lessons_Course FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

-- 4. Bảng Enrollments (Học viên đăng ký khóa học)
CREATE TABLE Enrollments (
    enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Enrollments_User FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Enrollments_Course FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT UQ_User_Course UNIQUE (user_id, course_id) -- Một học viên chỉ đăng ký 1 lần 1 khóa
);

-- 5. Bảng Assignments (Bài tập, bài kiểm tra)
CREATE TABLE Assignments (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    lesson_id INT NOT NULL,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX) NULL,
    type NVARCHAR(50) NOT NULL, -- 'quiz', 'essay', 'coding'
    due_date DATETIME NULL,

    CONSTRAINT FK_Assignments_Lesson FOREIGN KEY (lesson_id) REFERENCES Lessons(lesson_id)
);

-- 6. Bảng Submissions (Bài nộp của học viên)
CREATE TABLE Submissions (
    submission_id INT IDENTITY(1,1) PRIMARY KEY,
    assignment_id INT NOT NULL,
    user_id INT NOT NULL,
    content NVARCHAR(MAX) NULL, -- Link hoặc nội dung bài nộp
    grade DECIMAL(5,2) NULL,
    submitted_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Submissions_Assignment FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id),
    CONSTRAINT FK_Submissions_User FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 7. Bảng Progress (Tiến độ học tập)
CREATE TABLE Progress (
    progress_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    lesson_id INT NOT NULL,
    completed BIT DEFAULT 0,
    completed_at DATETIME NULL,

    CONSTRAINT FK_Progress_User FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Progress_Lesson FOREIGN KEY (lesson_id) REFERENCES Lessons(lesson_id),
    CONSTRAINT UQ_Progress_User_Lesson UNIQUE (user_id, lesson_id)
);

-- 8. Bảng Comments (Hỏi đáp, bình luận)
CREATE TABLE Comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    lesson_id INT NOT NULL,
    user_id INT NOT NULL,
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Comments_Lesson FOREIGN KEY (lesson_id) REFERENCES Lessons(lesson_id),
    CONSTRAINT FK_Comments_User FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 9. Bảng Payments (Thanh toán khóa học)
CREATE TABLE Payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL,
    course_id INT NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    payment_status NVARCHAR(50) NOT NULL, -- 'paid', 'pending', 'failed'
    payment_date DATETIME DEFAULT GETDATE(),

    CONSTRAINT FK_Payments_User FOREIGN KEY (user_id) REFERENCES Users(user_id),
    CONSTRAINT FK_Payments_Course FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);
