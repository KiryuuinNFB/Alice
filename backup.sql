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
    location text NOT NULL,
    teacher text NOT NULL
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
    prefix public."Prefix" DEFAULT 'Other'::public."Prefix" NOT NULL,
    grade integer NOT NULL,
    room integer NOT NULL
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

COPY public."Base" (id, name, "desc", location, teacher) FROM stdin;
1	ยิงกับเขมร	เขมร	ชายแดนไทย-กัมพูชา	โชกุน
2	คุณแม่แวมไพร์ทอมบอยหวานๆ	อยากได้	ซักที่	คิสช็อต
\.


--
-- Data for Name: Completion; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public."Completion" (id, "completedOn", "baseId", "userId") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: alice
--

COPY public."User" (id, username, password, name, surname, role, prefix, grade, room) FROM stdin;
01K1XTD7NTXWJJ1BBE30RGK8KR	22621	$argon2id$v=19$m=4,t=3,p=1$IfWulOMO+DBg15I/rAD0VhVEsnszJwErACcfFAoXkOE$Nqp9O4RuJVkDnv7Gw1p6g4DLNdpwco+Bdepx1l0duZw	สิรวิชญ์	ศรชัย	ADMIN	Nai	6	13
01K1Y0TH0E6VTNJRB5PR4E40PY	22789	$argon2id$v=19$m=65536,t=2,p=1$vLKqDV1vVcJVx4hmZWB6qXewED6rKdFTkUux/sQRYcs$hFC5a+bq1CFdA7XudhbptuB/WvK5uEA8t+RmM1tzUOk	เฮอร์ตา	สุดประเสริฐ	ADMIN	NangSao	6	13
01K1XTEVBVYE8NG2QZ47MV2WDD	22015	$argon2id$v=19$m=4,t=3,p=1$yejZkIQ5nHYu2/KNJiTfGm+ZWeKLADixsetGTUq1DnQ$HUQRzn2RVATB/qU2waV0BnK9ytIc2daOlSrboR+Ws04	ทักษิณ	ชินวัตร	USER	Nai	5	13
01K1Y1FFRXQ99X1M1S7GJ42VT9	22064	$argon2id$v=19$m=65536,t=2,p=1$YqiU6KB00E3csoVm2imEI8xsAwXWG+2jY0EYpQAyHgc$mO0r+6wIjLBIT64Zn1g7WRTMGMcp2gRqvCcrMrpdnZk	คอยชี้	โคเมจิ	MOD	NangSao	5	10
01K1YR097T47KD3S74NHMZ5NVK	22068	$argon2id$v=19$m=65536,t=2,p=1$SUUNqlXF7wyWdpIpz8KBvbMR4J7jfpsiU2ERPKErb+M$/cSFr9d2cgCLKPGlpxujFtF29yFI3RQCbmvezr/66QY	อารุ	ริขุฮาจิมะ	USER	NangSao	6	4
01K1YR2K34XB38ZCPDZMRET78P	22013	$argon2id$v=19$m=65536,t=2,p=1$QTMSWAAx11smc5i74jooZnCEyqChC5pZClK64d3+0yk$bs9hC6S7/G+LsZIbNjXwxRMMxZP6sdodflIF3Jfoc44	คันนา	โอกาตะ	MOD	NangSao	6	4
01K1YRBPATSP1SBJ7766842FE1	22065	$argon2id$v=19$m=65536,t=2,p=1$+b5p2+3Ql4pscCFovXPYS6KgTM0CSsF1IUopIQXHgAE$OIuHIBlhpknUpHkGn0SAFty9hfaEEntJFrLZIIsXoSo	ซาโตริ	โคเมจิ	MOD	NangSao	6	15
01K1YRE549R3B785N1WQNV80WQ	21228	$argon2id$v=19$m=65536,t=2,p=1$knjzp7X3mQPCljclUDBDZUZolJuuui6M4Mchd0nvCJo$Rjn7NbMq1WGQVsWPe1iQTdjMU2pZpRatzd2OmstOF5s	คาร์บอน	ไดออกไซด์	USER	DekChai	3	2
01K1YREND7KVTN35CYQP8JWGZ2	21229	$argon2id$v=19$m=65536,t=2,p=1$jqYA4WDlx3ZVjh5jYi4bEAPF5MpJCcDzqnCnytUOoig$B7v+1CMBpoSuclsdqhHmQCBhiIKs09lWQpvQGZkPlBU	คาร์บอน	มอนออกไซด์	USER	DekChai	3	2
01K1YRN8T1YMEP7FMDS6YFRA0S	22345	$argon2id$v=19$m=65536,t=2,p=1$e/aOmjSky8yU4AikcNalkqoNv6Ohdqn0YT1DtczSoy8$as2epOT9LAGqjLupW2at8t1dj4/fCfPiP5t4kUdr3o0	3-ethyl-2	4-dimethylhexane	MOD	Nai	5	12
01K1YTZ02J26VCF9ZEBTZ0YG0J	22022	$argon2id$v=19$m=65536,t=2,p=1$YZ1ZDRdGyo9E61mVDrbYo+fyS2EGbc0+VN+ZgAYyBL8$8bpUvbP8YtLK+YTc0PMlPU1R007vCg9MzO94sTjlIRE	อลิซ	มากาทรอยด์	MOD	NangSao	6	15
01K1ZTXS90A5PTA90G0T5981HW	22111	$argon2id$v=19$m=65536,t=2,p=1$w22g5tmDe0L1Sd9EyL8mq5bcCi+2MwfvP22YrJsOw6s$bAAk8cnPxFBP1vYCT3D1Vx1bC7ypX9pi4vRN6K8m8Ik	จุง	โกะ	MOD	NangSao	5	9
01K1YQZ383JWCCX7KRP543BAJ2	22223	$argon2id$v=19$m=4,t=3,p=1$RlrPU3Wa0pF2e0ZdwCcF69irsp/PbD/7ORuGe2ohZ9A$L/2hfK7gVMUWPE0ahzUIvOVTELFsiFBrJJRiC9VazTI	อเวน	จุรีน	USER	Nai	4	13
01K1ZYQP42RXQKNJAJ8Y6D4RWZ	22001	$argon2id$v=19$m=4,t=3,p=1$4Bt+Oscy5CGXHUNME2im7N9stFCH38O9yGjfQ9NTT/o$R5pG52RyaQaOiy9rcNRJBTSW6ieIEsCBRTYK1LHl5xc	5555	5555	MOD	Nai	6	1
01K1ZZ83YZDFMXQC3WD8HMPBQP	22444	$argon2id$v=19$m=4,t=3,p=1$m9ar2fq5ggzqe6TeMwetCl+LFsh2K8K9JmCGDHgdgDU$Z/GhoOZ2zKrlhqEFlZ9PnIxOMB52FJYiEWHYgdK7V8I	Titan	Speakerman	USER	DekChai	1	1
01K1YQXV40PJY2FT06WTJY2P22	22222	$argon2id$v=19$m=4,t=3,p=1$tyArIjZ+vVKfcc8mDuR5t9R63rSLLFJSJP0y/zo271Y$oFq/J8vTm6cR/dWLsOc0bA+thumSJwZhZMkJclsOAMw	Sun	Day	USER	Nai	2	11
01K1ZZRBF7J1RH5QHBM5GHYAS8	22312	$argon2id$v=19$m=65536,t=2,p=1$877y0Ba+wojjrIbPgTLePaAdPNq+VOqH1yxtscotc9I$cG4mf5tpfzu+slB1HlHxoO2fZ5RJrrsANLhurSXXZjU	Kiryuuin	NFB Production	MOD	Nai	6	13
01K20012DSMXGSQ4DHDGX6KAPQ	22077	$argon2id$v=19$m=65536,t=2,p=1$ODvEfFtQjOlSVKtd+Maz6x3oWgeyOLa+R+rKFXG505Y$JM2w6bFgqy9IPEAY+EmFfR8Tt7qIpipLdsXkxhBRadg	เรมิเลีย	สการ์เล็ท	MOD	DekYing	3	9
\.


--
-- Name: Base_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alice
--

SELECT pg_catalog.setval('public."Base_id_seq"', 2, true);


--
-- Name: Completion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: alice
--

SELECT pg_catalog.setval('public."Completion_id_seq"', 1, false);


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

