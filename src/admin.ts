import AdminJS from "adminjs";
import { PrismaClient } from "@prisma/client";
import { buildRouter } from "@adminjs/express";
import AdminJSPrisma from "@adminjs/prisma";
import express from "express";

// Register the Prisma adapter with AdminJS
AdminJS.registerAdapter({
  Database: AdminJSPrisma.Database,
  Resource: AdminJSPrisma.Resource,
});

// Initialize Prisma Client
const prisma = new PrismaClient();

// Define the AdminJS options
const adminOptions = {
  databases: [prisma],
  rootPath: "/admin",
  resources: [
    { resource: prisma.user },
    { resource: prisma.student },
    { resource: prisma.teacher },
    { resource: prisma.booking },
    { resource: prisma.session },
    { resource: prisma.lesson },
    { resource: prisma.lessonConfirmation },
    { resource: prisma.payment },
    { resource: prisma.feedback },
    { resource: prisma.equipment },
    { resource: prisma.kite },
    { resource: prisma.bar },
    { resource: prisma.board },
    { resource: prisma.forecast },
    { resource: prisma.forecastPrediction },
    { resource: prisma.dateSpan },
  ],
  branding: {
    companyName: "KiteTraffico Admin",
    softwareBrothers: false,
  },
};

// Create an Express app
const app = express();

// Initialize AdminJS with authentication
const admin = new AdminJS(adminOptions);

// Set up authentication
const authenticate = async (email: string, password: string) => {
  const ADMIN_EMAIL = "admin@kitetraffico.com";
  const ADMIN_PASSWORD = "supersecretpassword";

  if (email === ADMIN_EMAIL && password === ADMIN_PASSWORD) {
    return { email }; // Return user object if authenticated
  }
  return null; // Return null if authentication fails
};

admin.authenticate = authenticate; // Assign authentication function to admin

// Build the AdminJS router
const adminRouter = buildRouter(admin);

// Mount the AdminJS router
app.use(admin.options.rootPath, adminRouter);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`AdminJS is running at http://localhost:${PORT}/admin`);
});
