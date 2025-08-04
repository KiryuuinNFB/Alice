--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: Prefix; Type: TYPE; Schema: public; Owner: alice
--

CREATE TYPE public."Prefix" AS ENUM (
    'Other',
    'DekChai',
    'DekYing',
    'Nai',
    'NangSao',
    'Nang'
);


ALTER TYPE public."Prefix" OWNER TO alice;

--
-- Name: Role; Type: TYPE; Schema: public; Owner: alice
--

CREATE TYPE public."Role" AS ENUM (
    'USER',
    'ADMIN',
    'MOD'
);


ALTER TYPE public."Role" OWNER TO alice;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Base; Type: TABLE; Schema: public; Owner: alice
--

CREATE TABLE public."Base" (
    id integer NOT NULL,
    name text NOT NULL,
    "desc" text NOT NULL,
    location text NOT NULL
);


ALTER TABLE public."Base" OWNER TO alice;

--
-- Name: Base_id_seq; Type: SEQUENCE; Schema: public; Owner: alice
--

CREATE SEQUENCE public."Base_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Base_id_seq" OWNER TO alice;

--
-- Name: Base_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alice
--

ALTER SEQUENCE public."Base_id_seq" OWNED BY public."Base".id;


--
-- Name: Completion; Type: TABLE; Schema: public; Owner: alice
--

CREATE TABLE public."Completion" (
    id integer NOT NULL,
    "completedOn" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "baseId" integer NOT NULL,
    "userId" text NOT NULL
);


ALTER TABLE public."Completion" OWNER TO alice;

--
-- Name: Completion_id_seq; Type: SEQUENCE; Schema: public; Owner: alice
--

CREATE SEQUENCE public."Completion_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Completion_id_seq" OWNER TO alice;

--
-- Name: Completion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: alice
--

ALTER SEQUENCE public."Completion_id_seq" OWNED BY public."Completion".id;


--
-- Name: User; Type: TABLE; Schema: public; Owner: alice
--

CREATE TABLE public."User" (
    id text NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    surname text NOT NULL,
    role public."Role" DEFAULT 'USER'::public."Role" NOT NULL,
    prefix public."Prefix" DEFAULT 'Other'::public."Prefix" NOT NULL
);


ALTER TABLE public."User" OWNER TO alice;

--
-- Name: Base id; Type: DEFAULT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public."Base" ALTER COLUMN id SET DEFAULT nextval('public."Base_id_seq"'::regclass);


--
-- Name: Completion id; Type: DEFAULT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public."Completion" ALTER COLUMN id SET DEFAULT nextval('public."Completion_id_seq"'::regclass);


--
-- Data for Name: Base; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public."Base" (id, name, "desc", location) FROM stdin;
1	ต้นไม้ผจญภัย	พฤกษาสตร์	สวน
2	เรลกันหรรษา	ปืนรางแม่เหล็กไฟฟ้า	ห้อง 1302
3	ส่องเซลล์พืช	ด้วยกล้องจุลทัศน์	ห้อง 1303
4	วางระเบิดจุด C	อย่าพีก	Haven C long
5	ขายรถไถ	สวนนานา	สวนนานา
6	ขับกริฟเฟน	ขับกริฟเฟนระเบิดเขมร	ชายแดนไทย-กัมพูชา
7	แข่งหุ่นยนต์	หุ่นยนต์เดินตามเส้น	ชายแดนไทย-กัมพูชา
8	แข่งวาดรูป	วาดรูปวิทยาศาสตร์	หอประชุม
9	แข่งรถลงดอย	ดอยน่ากลัวมาก	ดอยฮารุนะ
10	แข่ง Tetris	ผมเป็นคนที่จัดเรียงบล็อก	หอประชุม
11	แข่ง Valorant	ลากหัวคมๆ	ห้องคอม 1
12	แข่ง Free Fire	ลากหัวคมๆแต่ดินน้ำมัน	ห้องคอม 2
\.


--
-- Data for Name: Completion; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public."Completion" (id, "completedOn", "baseId", "userId") FROM stdin;
1	2025-08-03 16:47:23.496	1	22621
2	2025-08-03 16:47:26.581	2	22621
3	2025-08-03 16:47:30.681	3	22621
4	2025-08-03 16:47:33.65	4	22621
5	2025-08-03 16:47:36.744	5	22621
6	2025-08-03 17:38:57.84	1	22068
7	2025-08-03 17:39:11.9	2	22068
8	2025-08-03 17:39:19.702	3	22068
9	2025-08-03 17:39:29.635	4	22068
10	2025-08-03 17:39:40.694	9	22068
11	2025-08-03 19:19:37.031	11	22621
12	2025-08-04 00:24:28.987	1	22789
13	2025-08-04 00:24:32.718	2	22789
14	2025-08-04 00:24:36.267	3	22789
15	2025-08-04 00:24:40.037	4	22789
16	2025-08-04 00:25:14.956	5	22789
17	2025-08-04 00:25:18.87	6	22789
18	2025-08-04 00:25:23.568	7	22789
19	2025-08-04 00:28:44.504	8	22789
20	2025-08-04 00:29:03.645	9	22789
21	2025-08-04 00:29:09.475	10	22789
22	2025-08-04 00:29:15.334	11	22789
23	2025-08-04 00:29:20.013	12	22789
24	2025-08-04 04:44:15.759	1	22098
25	2025-08-04 04:44:39.615	10	22098
26	2025-08-04 05:09:23.059	1	22064
27	2025-08-04 05:09:41.466	2	22064
28	2025-08-04 05:09:47.845	3	22064
29	2025-08-04 05:15:47.387	7	22068
30	2025-08-04 05:17:57.109	4	22064
31	2025-08-04 05:19:04.469	5	22064
32	2025-08-04 05:19:17.962	6	22064
33	2025-08-04 05:24:13.181	1	21222
34	2025-08-04 05:25:12.668	2	21222
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public."User" (id, username, password, name, surname, role, prefix) FROM stdin;
01K1RD4PQBQHN1CXW9MD3J3VJC	22621	$argon2id$v=19$m=4,t=3,p=1$bCwljFVZHgb3a0PeVpbbUkG6b8AtOi5XMYTxsg2vboA$9os2Mapuwrd75DhupyGMlaS2tHx/4Rifi3up2kUb4iM	คาฟคา	 	ADMIN	Nang
01K1RD5E19DHD4HFB3B02Z878M	22789	$argon2id$v=19$m=4,t=3,p=1$m+IYm7Mcy8qI91bIZACDR55IZS0ePuAnGcjvQ3XcsAk$5BLEhVs/WHVxR2JJiBanWLXOKYO9hsQNBYK73qANmmI	เฮอร์ตา	สุดประเสริฐ	ADMIN	NangSao
01K1RD6B7HAH74WG3JGZ9PF0PJ	22077	$argon2id$v=19$m=4,t=3,p=1$PH0MwtR2AS7uqcuRi2mpvCeCnmX00/I83pVjnSBWJv8$w/gz9W0GHsKCLQkXV97s+lWh01wQ5Me9Aa6ILX1udak	ด้าน	เหิง	MOD	Nai
01K1RD701JSENKWXVNPJQ72TBH	22068	$argon2id$v=19$m=4,t=3,p=1$0u4vt4xNTlRJIfeiw4peQotPTXyVqzcMDSX8CAiLBNE$LiUQie4JZGAKMGSWHmgglrEZqY8hHDNfhGpkmpbHXbU	อารุ	ริขุฮาจิมะ	USER	NangSao
01K1SA0K2CKAERHG77GZKV425H	22456	$argon2id$v=19$m=4,t=3,p=1$a5FltUsfrjlmOO33Yxh9SobGaSIqOBY9yUKdfQUI59w$2TmfJK5Tc/gQY8F3vwsc+JMIbGCKllv5Af50IraFq0k	จอห์น	วิก	USER	Nai
01K1SA1V1VB5ZRHPEM32SJEYZY	22098	$argon2id$v=19$m=4,t=3,p=1$Kgdz7+x5vkbfsQ0Qnh48HaYgqiFmIU5ZI/v2z7s+5mo$aa+sNILu4GH1NKKU0vYy1UEqMbI/Iv+BIoJKqaPoLyI	ฮุน	เซ็น	USER	DekChai
01K1SA76KX5AB7QW7YRN36XPAQ	23123	$argon2id$v=19$m=4,t=3,p=1$4lQ/vXl8pRUhhPY3syA6T69nQgyfezihyEP5dzn/uJU$0JzINE9bAWNJgfCcO33Do397/ES4HjCsOQwhf1MspBE	ทักษิณ	ชินวัตร	USER	Nai
01K1SAB80VQHSECY31Q8VE8K7Q	21222	$argon2id$v=19$m=4,t=3,p=1$XRVGALVzJJCLhyXvtofViZi9ZqtPfZAtiBjEEETu8uM$juzrTZF44qP8oOZ531IzcBWGvtqEr/LvbvmJ5JQIsmo	โฮชิมิ	มิยาบิ	MOD	NangSao
01K1SATQPJTSQAGF9A1TGAKAWJ	22064	$argon2id$v=19$m=4,t=3,p=1$roR8sGMKRDMloLjwJ3T20QKCmEw1hfPIWsslzFT6o/c$8rTpCO4XAuq7jB7ruQLWgsBfr4erJIe5lYAaXvO0+EA	ทักษิณ	ชินวัตร	USER	Nai
01K1SRTSA07WDMWGXQ7ZFB3SQT	archan	$argon2id$v=19$m=4,t=3,p=1$kyk6zGdHk7yDO2H8XZn4ZsZlgJIhJdBvFcmbhV/PQ2w$pIBkWFoVod4+MJxFvX+Knh/l4wGqWmLrygOdDAw0EUg	Skibidi	Toilet	ADMIN	NangSao
\.


--
-- Name: Base_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alice
--

SELECT pg_catalog.setval('public."Base_id_seq"', 12, true);


--
-- Name: Completion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alice
--

SELECT pg_catalog.setval('public."Completion_id_seq"', 34, true);


--
-- Name: Base Base_pkey; Type: CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public."Base"
    ADD CONSTRAINT "Base_pkey" PRIMARY KEY (id);


--
-- Name: Completion Completion_pkey; Type: CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public."Completion"
    ADD CONSTRAINT "Completion_pkey" PRIMARY KEY (id);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: User_username_key; Type: INDEX; Schema: public; Owner: alice
--

CREATE UNIQUE INDEX "User_username_key" ON public."User" USING btree (username);


--
-- Name: Completion Completion_baseId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public."Completion"
    ADD CONSTRAINT "Completion_baseId_fkey" FOREIGN KEY ("baseId") REFERENCES public."Base"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Completion Completion_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: alice
--

ALTER TABLE ONLY public."Completion"
    ADD CONSTRAINT "Completion_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(username) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

