import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export default defineEventHandler(async (event) => {
    const {
        p01_id,
        p01_no,
        p01_name,
        p01_target,
        p01_score,
        p01_weight,
    } = event.data; // Assuming event.data contains these values

    try {
        const res = await prisma.Datap01.create({
            data: {
                p01_id,
                p01_no,
                p01_name,
                p01_target,
                p01_score,
                p01_weight,
            },
        });

        return res;
    } catch (error) {
        console.error('Error inserting data:', error);
        throw error; // Handle or propagate the error as needed
    } finally {
        await prisma.$disconnect(); // Disconnect Prisma Client after operation
    }
});