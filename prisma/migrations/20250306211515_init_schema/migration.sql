-- CreateTable
CREATE TABLE "User" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "password" TEXT,
    "status" TEXT NOT NULL DEFAULT 'guest'
);

-- CreateTable
CREATE TABLE "DateSpan" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "startDate" DATETIME NOT NULL,
    "endDate" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Student" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "lessonId" INTEGER,
    "weight" INTEGER,
    "height" INTEGER,
    "level" INTEGER,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "Student_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Teacher" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "lessonsId" INTEGER,
    "userId" INTEGER NOT NULL,
    CONSTRAINT "Teacher_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Booking" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "status" INTEGER NOT NULL,
    "paymentId" INTEGER,
    "sessionId" INTEGER,
    "studentsId" INTEGER NOT NULL,
    CONSTRAINT "Booking_studentsId_fkey" FOREIGN KEY ("studentsId") REFERENCES "Student" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Booking_paymentId_fkey" FOREIGN KEY ("paymentId") REFERENCES "Payment" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Booking_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Session" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Session" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "date" DATETIME NOT NULL,
    "time" TEXT NOT NULL,
    "forecastId" INTEGER,
    CONSTRAINT "Session_forecastId_fkey" FOREIGN KEY ("forecastId") REFERENCES "Forecast" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Lesson" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "sessionId" INTEGER,
    "feedbackId" INTEGER,
    "confirmationId" INTEGER,
    "teacherId" INTEGER,
    CONSTRAINT "Lesson_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Session" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Lesson_teacherId_fkey" FOREIGN KEY ("teacherId") REFERENCES "Teacher" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "LessonConfirmation" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "userRating" INTEGER,
    "teacherApproval" INTEGER NOT NULL,
    "userComment" TEXT,
    "lessonId" INTEGER NOT NULL,
    CONSTRAINT "LessonConfirmation_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "Lesson" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Payment" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "price" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "Feedback" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "comment" TEXT,
    "lessonId" INTEGER,
    CONSTRAINT "Feedback_lessonId_fkey" FOREIGN KEY ("lessonId") REFERENCES "Lesson" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Equipment" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "kiteId" INTEGER,
    "barId" INTEGER,
    "boardId" INTEGER,
    "sessionId" INTEGER,
    "comment" TEXT NOT NULL,
    CONSTRAINT "Equipment_kiteId_fkey" FOREIGN KEY ("kiteId") REFERENCES "Kite" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Equipment_barId_fkey" FOREIGN KEY ("barId") REFERENCES "Bar" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Equipment_boardId_fkey" FOREIGN KEY ("boardId") REFERENCES "Board" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Equipment_sessionId_fkey" FOREIGN KEY ("sessionId") REFERENCES "Session" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Kite" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "size" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "Bar" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "size" INTEGER NOT NULL,
    "newColumn" INTEGER
);

-- CreateTable
CREATE TABLE "Board" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "size" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "Forecast" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT
);

-- CreateTable
CREATE TABLE "ForecastPrediction" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "knots" INTEGER NOT NULL,
    "authorOrModel" TEXT NOT NULL,
    "dateSpanId" INTEGER NOT NULL,
    "forecastId" INTEGER NOT NULL,
    CONSTRAINT "ForecastPrediction_dateSpanId_fkey" FOREIGN KEY ("dateSpanId") REFERENCES "DateSpan" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "ForecastPrediction_forecastId_fkey" FOREIGN KEY ("forecastId") REFERENCES "Forecast" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_DateSpanToStudent" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,
    CONSTRAINT "_DateSpanToStudent_A_fkey" FOREIGN KEY ("A") REFERENCES "DateSpan" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_DateSpanToStudent_B_fkey" FOREIGN KEY ("B") REFERENCES "Student" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_LessonToStudent" (
    "A" INTEGER NOT NULL,
    "B" INTEGER NOT NULL,
    CONSTRAINT "_LessonToStudent_A_fkey" FOREIGN KEY ("A") REFERENCES "Lesson" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_LessonToStudent_B_fkey" FOREIGN KEY ("B") REFERENCES "Student" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Student_userId_key" ON "Student"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Teacher_userId_key" ON "Teacher"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Booking_paymentId_key" ON "Booking"("paymentId");

-- CreateIndex
CREATE UNIQUE INDEX "Lesson_feedbackId_key" ON "Lesson"("feedbackId");

-- CreateIndex
CREATE UNIQUE INDEX "Lesson_confirmationId_key" ON "Lesson"("confirmationId");

-- CreateIndex
CREATE UNIQUE INDEX "LessonConfirmation_lessonId_key" ON "LessonConfirmation"("lessonId");

-- CreateIndex
CREATE UNIQUE INDEX "Feedback_lessonId_key" ON "Feedback"("lessonId");

-- CreateIndex
CREATE UNIQUE INDEX "ForecastPrediction_dateSpanId_key" ON "ForecastPrediction"("dateSpanId");

-- CreateIndex
CREATE UNIQUE INDEX "_DateSpanToStudent_AB_unique" ON "_DateSpanToStudent"("A", "B");

-- CreateIndex
CREATE INDEX "_DateSpanToStudent_B_index" ON "_DateSpanToStudent"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_LessonToStudent_AB_unique" ON "_LessonToStudent"("A", "B");

-- CreateIndex
CREATE INDEX "_LessonToStudent_B_index" ON "_LessonToStudent"("B");
