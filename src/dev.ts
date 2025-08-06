import { Elysia, t } from "elysia";
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient()

/*DO NOT USE dev.ts IN PRODUCTION. IT DOESN'T REQUIRE AUTHENTICATION */

export const dev = new Elysia({ prefix: '/dev' })
    .group('', (app) =>
        app
            .put('/base', async ({ body }) => {
                const { name, desc, location, teacher } = body;
                const base = await prisma.base.create({
                    data: {
                        name,
                        desc,
                        location,
                        teacher
                    }
                });

                return {
                    id: base.id,
                    name: base.name
                };
            }, {
                body: t.Object({
                    name: t.String(),
                    desc: t.String(),
                    location: t.String(),
                    teacher: t.String()
                })
            })
            .patch('/base', async ({ body }) => {
                const { id, name, desc, location, teacher } = body;
                const base = await prisma.base.update({
                    where: {
                        id: id
                    },
                    data: {
                        name,
                        desc,
                        location,
                        teacher
                    }
                });

                return {
                    id: base.id,
                    name: base.name
                };
            }, {
                body: t.Object({
                    id: t.Number(),
                    name: t.String(),
                    desc: t.String(),
                    location: t.String(),
                    teacher: t.String()
                })
            })
            .delete('/base', async ({ body }) => {
                const { id } = body;
                const base = await prisma.base.delete({
                    where: {
                        id: id
                    }
                });

                return {
                    id: base.id,
                    name: base.name
                };
            }, {
                body: t.Object({
                    id: t.Number()
                })
            })
            .get('/base', async () => {
                const getbases = await prisma.base.findMany()

                return getbases

            })
    )
    .group('', (app) =>
        app
            .put('/user', async ({ body }) => {
                const { username, password, name, surname, role, prefix, grade, room } = body;
                const hashed = await Bun.password.hash(password, { algorithm: "argon2id", memoryCost: 4, timeCost: 3 })

                const user = await prisma.user.create({
                    data: {
                        username,
                        password: hashed,
                        name,
                        surname,
                        role: role ?? 'USER',
                        prefix: prefix ?? 'Other',
                        grade,
                        room
                    },
                });

                return {
                    username: user.username,
                    role: user.role
                };
            }, {
                body: t.Object({
                    username: t.String(),
                    password: t.String(),
                    name: t.String(),
                    surname: t.String(),
                    role: t.Optional(t.Enum({
                        USER: 'USER',
                        ADMIN: 'ADMIN',
                        MOD: 'MOD'
                    })),
                    prefix: t.Optional(t.Enum({
                        Other: 'Other',
                        DekChai: 'DekChai',
                        DekYing: 'DekYing',
                        Nai: 'Nai',
                        NangSao: 'NangSao',
                        Nang: 'Nang'

                    })),
                    grade: t.Number(),
                    room: t.Number()
                }),
            })
            .patch('/user', async ({ body }) => {
                const { username, password, name, surname, role, prefix, grade, room } = body;
                const hashed = await Bun.password.hash(password, { algorithm: "argon2id", memoryCost: 4, timeCost: 3 })

                const user = await prisma.user.update({
                    where: {
                        username: username
                    },
                    data: {
                        password: hashed,
                        name,
                        surname,
                        role: role ?? 'USER',
                        prefix: prefix ?? 'Other',
                        grade,
                        room
                    },
                });

                return {
                    username: user.username,
                    role: user.role
                };
            }, {
                body: t.Object({
                    username: t.String(),
                    password: t.String(),
                    name: t.String(),
                    surname: t.String(),
                    role: t.Optional(t.Enum({
                        USER: 'USER',
                        ADMIN: 'ADMIN',
                        MOD: 'MOD'
                    })),
                    prefix: t.Optional(t.Enum({
                        Other: 'Other',
                        DekChai: 'DekChai',
                        DekYing: 'DekYing',
                        Nai: 'Nai',
                        NangSao: 'NangSao',
                        Nang: 'Nang'

                    })),
                    grade: t.Number(),
                    room: t.Number()
                }),
            })
            .delete('/user', async ({ body }) => {
                const { username } = body;
                const deluser = await prisma.user.delete({
                    where: {
                        username: username,
                    }
                });
                return {
                    id: deluser.username
                }
            }, {
                body: t.Object({
                    username: t.String()
                })
            })
            .get('/user/:username', async ({ params: { username } }) => {
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
                    "prefix": getuser?.prefix,
                    "grade": getuser?.grade,
                    "room": getuser?.room
                }
            })
    )
