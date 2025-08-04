import { Elysia } from "elysia";
const { SVG, registerWindow } = require('@svgdotjs/svg.js')
const { createSVGWindow } = require('svgdom')
const sharp = require('sharp')
import { PrismaClient } from "@prisma/client";




const prisma = new PrismaClient()

const prefixHandle = (prefix: string | undefined) => {
    switch (prefix) {
        case "DekChai":
            return "ด.ช."
        case "DekYing":
            return "ด.ญ."
        case "NangSao":
            return "นางสาว"
        case "Nang":
            return "นาง"
        case "Nai":
            return "นาย"
        default:
            return "อื่นๆ"
    }
}

export const certificate = new Elysia({ prefix: '/cert' })
    .get("/:id", async ({ set, params: { id }}) => {
        set.headers["Content-Type"] = "image/png";
        

        const decodeduser = await prisma.user.findUnique({
            where: {
                username: id
            }
        });

        const switchPrefix = prefixHandle(decodeduser?.prefix)

        const window = createSVGWindow()
        const document = window.document
        registerWindow(window, document)
        const draw = SVG(document.documentElement).size(800, 600)
        draw.rect(800, 600).fill('#fdf6e3')


        draw.image('./elysialmao.jpeg')
            .size(800, 600)
            .move(0, 0)
            
        draw.text("เกลียดติบัดร")
            .move(400, 180)
            .font({ size: 28, weight: 'bold', anchor: 'middle' })

        draw.text(`${switchPrefix} ${decodeduser?.name} ${decodeduser?.surname}`)
            .move(400, 250)
            .font({ size: 28, weight: 'bold', anchor: 'middle' })

        draw.text("ได้เข้าร่วมวันวิทยาสาด")
            .move(400, 300)
            .font({ size: 28, weight: 'bold', anchor: 'middle' })

        const svgString = draw.svg()
        const pngBuffer = await sharp(Buffer.from(svgString)).png().toBuffer()
        return pngBuffer

    })


