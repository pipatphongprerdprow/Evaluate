import { PrismaClient } from '@prisma/client'

export default defineEventHandler(async (event) => {
    const prisma = new PrismaClient()
    const res = await prisma.TrainCousre.findFirst({
        where: {
            course_id: 1
        }
    })
    return res;
})