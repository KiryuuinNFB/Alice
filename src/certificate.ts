import fs from "fs";
import path from "path";
import { Elysia } from "elysia";
const { SVG, registerWindow } = require("@svgdotjs/svg.js");
const { createSVGWindow } = require("svgdom");
const sharp = require("sharp");
import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

const prefixHandle = (prefix: string | undefined) => {
    switch (prefix) {
        case "DekChai":
            return "ด.ช.";
        case "DekYing":
            return "ด.ญ.";
        case "NangSao":
            return "นางสาว";
        case "Nang":
            return "นาง";
        case "Nai":
            return "นาย";
        default:
            return "อื่นๆ";
    }
};

export const certificate = new Elysia({ prefix: "/cert" }).get("/:id", async ({ set, params: { id } }) => {
    set.headers["Content-Type"] = "image/png";

    const decodeduser = await prisma.user.findUnique({
        where: {
            username: id,
        },
    });

    const switchPrefix = prefixHandle(decodeduser?.prefix);

    // Load your PNG background as base64
    const bgPath = path.join(process.cwd(), "certbg.png");
    const bgData = fs.readFileSync(bgPath);
    const bgBase64 = `data:image/png;base64,${bgData.toString("base64")}`;

    // Create SVG
    const window = createSVGWindow();
    const document = window.document;
    registerWindow(window, document);
    const draw = SVG(document.documentElement).size(1920, 1080);

    // Background
    draw.image(bgBase64).size(1920, 1080).move(0, 0);

    // Text (centered)
   

    draw
        .text(`${switchPrefix} ${decodeduser?.name} ${decodeduser?.surname}`)
        .move(960, 400)
        .font({ size: 64, weight: "bold", anchor: "middle" });


    const svgString = draw.svg();

    // Convert to PNG
    const pngBuffer = await sharp(Buffer.from(svgString)).png().toBuffer();
    return pngBuffer;
});