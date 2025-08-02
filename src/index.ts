import swagger from "@elysiajs/swagger";
import { logger } from "@tqman/nice-logger";
import { Elysia, status, t, file } from "elysia";
import { PrismaClient } from "@prisma/client";
import { cors } from '@elysiajs/cors'
import { admin } from "./admin"
import { dev } from "./dev"

interface JwtPayload {
    username: string
}

const prisma = new PrismaClient()

const app = new Elysia()
    .use(swagger())
    .use(logger())
    .use(
        cors({
            origin: '*',
            methods: ['GET', 'POST', 'OPTIONS', 'PUT', 'DELETE'],
            allowedHeaders: ['Content-Type', 'authorization']
        })
    )
    //admin commands for adding, removing and reading users
    .use(admin)
    //DO NOT USE DEV IN PRODUCTION
    .use(dev)
    .onError(({ error }) => {
        return new Response(error.toString())
    })
    .get("/", () => file("elysialmao.jpeg"))
    .group('/auth', (app) =>
        app
            .post('/login', async ({ jwt, body }) => {
                const { username, password } = body;
                const login = await prisma.user.findUnique({
                    where: { username }
                });
                if (!login) {
                    return status(404, "Not found")
                }
                const hashed = login?.password!
                const isMatch = await Bun.password.verify(password, hashed)
                if (!isMatch) {
                    return status(401, "Unauthorized")
                }
                const jwttoken = await jwt.sign(
                    {
                        username: login?.username!,
                        exp: '30m'
                    },
                )

                return { "token": jwttoken }

            }, {
                body: t.Object({
                    username: t.String(),
                    password: t.String()
                },
                    {
                        error: "Invalid credentials"
                    })
            })
            .post('/verify', async ({ jwt, headers, status, body }) => {
                const auth = headers.authorization
                if (!auth) {
                    return status(401, "Unauthorized")
                }
                const decoded = await jwt.verify(auth) as unknown as JwtPayload
                if (decoded.username !== body.username) {
                    return status(401, "Unauthorized")
                }
                return status(200, "OK")
            }, {
                body: t.Object({
                    username: t.String()
                })
            })
            .get('/veriadmin', async ({ jwt, headers, status }) => {
                const auth = headers.authorization
                if (!auth) {
                    return status(401, "Unauthorized")
                }
                const decoded = await jwt.verify(auth) as unknown as JwtPayload

                const decodeduser = await prisma.user.findUnique({
                    where: {
                        username: decoded?.username!
                    }
                });

                if (!decoded || decodeduser?.role === 'USER')
                    return status(401, "Unauthorized")
                return status(200, "OK")
            })
    )
    .group('/api/v1', (app) =>
        app
            .guard({
                beforeHandle: async ({ jwt, headers, status }) => {
                    const auth = headers.authorization
                    if (!auth) {
                        return status(401, "Unauthorized")
                    }
                    const decoded = await jwt.verify(auth) as unknown as JwtPayload

                    await prisma.user.findUnique({
                        where: {
                            username: decoded?.username!
                        }
                    });

                    if (!decoded)
                        return status(401, "Unauthorized")
                }
            })
            .get('/user/:username', async ({ jwt, params: { username }, headers: { authorization } }) => {

                const decoded = await jwt.verify(authorization) as unknown as JwtPayload
                const decodeduser = await prisma.user.findUnique({
                    where: {
                        username: decoded?.username!
                    }
                });
                if (!decoded || decodeduser?.username !== username)
                    return status(401, "Unauthorized")
                const getuser = await prisma.user.findUnique({
                    where: {
                        username: username
                    }
                })
                const getevents = await prisma.completion.findMany({
                    where: {
                        userId: username
                    }
                })
                return {
                    "studentId": getuser?.username,
                    "ulid": getuser?.id,
                    "name": getuser?.name,
                    "surname": getuser?.surname,
                    "events": getevents,
                    "role": getuser?.role,
                    "prefix": getuser?.prefix
                }
            })
            .get('/base', async () => {
                const getbases = await prisma.base.findMany()

                return getbases
            })
    )

    .listen(8000);

console.log(
    `Elysia at http://${app.server?.hostname}:${app.server?.port}`
);