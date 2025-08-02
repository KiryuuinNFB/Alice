/*
  Warnings:

  - You are about to drop the column `userId` on the `Base` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Base" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "desc" TEXT NOT NULL,
    "location" TEXT NOT NULL
);
INSERT INTO "new_Base" ("desc", "id", "location", "name") SELECT "desc", "id", "location", "name" FROM "Base";
DROP TABLE "Base";
ALTER TABLE "new_Base" RENAME TO "Base";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
