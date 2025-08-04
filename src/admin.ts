import { Elysia, status, t } from "elysia";
import { PrismaClient } from "@prisma/client";
import { jwt } from '@elysiajs/jwt'

interface JwtPayload {
    username: string

}

const prisma = new PrismaClient()

export const admin = new Elysia({ prefix: '/admin' })
    .use(
        jwt({
            name: 'jwt',
            secret: "I_CHANGED_IT_IN_PROD"
        })
    )
    .guard({
        beforeHandle: async ({ jwt, headers, status }) => {
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
        }
    })
    .group('', (app) =>
        app
            .put('/base', async ({ body }) => {
                const { name, desc, location } = body;
                const base = await prisma.base.create({
                    data: {
                        name,
                        desc,
                        location
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
                    location: t.String()
                })
            })
            .patch('/base', async ({ body }) => {
                const { id, name, desc, location } = body;
                const base = await prisma.base.update({
                    where: {
                        id: id
                    },
                    data: {
                        name,
                        desc,
                        location
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
                    location: t.String()
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
                const { username, password, name, surname, role, prefix } = body;
                const hashed = await Bun.password.hash(password)

                const user = await prisma.user.create({
                    data: {
                        username,
                        password: hashed,
                        name,
                        surname,
                        role: role ?? 'USER',
                        prefix: prefix ?? 'Other',
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
                }),
            })
            .patch('/user', async ({ body }) => {
                const { username, password, name, surname, role, prefix } = body;
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
                        prefix: prefix ?? 'Other'
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
                }),
            })
            .delete('/user', async ({ body }) => {
                const { username, password } = body;
                const hashed = await Bun.password.hash(password)

                const deluser = await prisma.user.delete({
                    where: {
                        username: username,
                        password: hashed
                    }
                });

                return {
                    id: deluser.username,
                };

            }, {
                body: t.Object({
                    username: t.String(),
                    password: t.String()
                })
            })
            .get('/user/:username', async ({ params: { username } }) => {
                const getuser = await prisma.user.findUnique({
                    where: {
                        username: username
                    }
                });
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

            }, {
                body: t.Object({
                    username: t.String()
                })
            })
    )
    .group('/database', (app) =>
        app
            .get('/user/:pagination', async ({ params: { pagination }}) => {
                const result = await prisma.user.findMany({
                    skip: 10 * (pagination - 1),
                    take: 10,
                    omit: {
                        password: true,
                        id: true
                    }
                })
                return result
            }, {
                params: t.Object({
                    pagination: t.Number()
                })
            })
    )
    .post('/approve/:user/:base', async ({ params: { user, base } }) => {
        const userExists = await prisma.user.findUnique({
            where: {
                username: user
            }
        });
        if (!userExists) {
            return status(404, 'Not Found')
        }

        const completionCheck = await prisma.completion.findMany({
            where: {
                AND: [{
                    userId: {
                        equals: user
                    },
                    baseId: {
                        equals: base
                    }
                }]
            }
        })

        if (completionCheck.length === 0) {
            await prisma.completion.create({
                data: {
                    completedOn: new Date(),
                    baseId: base,
                    userId: user,
                }
            })
        } else {
            return status(403, "Forbidden")
        }


    }, {
        params: t.Object({
            user: t.String(),
            base: t.Number()
        })
    })


