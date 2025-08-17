import pandas as pd
import requests
import asyncio
import time

def get_prefix_key(label: str) -> str:
    match label:
        case "ด.ช.":
            return "DekChai"
        case "ด.ญ.":
            return "DekYing"
        case "เด็กชาย":
            return "DekChai"
        case "เด็กหญิง":
            return "DekYing"
        case "นาย":
            return "Nai"
        case "นาง":
            return "Nang"
        case "น.ส.":
            return "NangSao"
        case "นางสาว":
            return "NangSao"
        case _:
            return "Other"

def room_num_fix(roomnum: int) -> str:
    if roomnum < 10:
        return f"0{str(roomnum)}"
    else:
        return str(roomnum)

async def main() -> None:
    grade = 1
    for room in range(1, 17):
        print(f"================= class {room} ===============")
        df = pd.read_excel(f"grade{str(grade+6)}.xlsx", sheet_name=f"{str(grade)}{room_num_fix(room)}", usecols="A:E", skiprows=5)
        df.columns = ["num", "id", "prefix", "name", "surname"]
        for index, row in df.iterrows():
            print(row["id"], get_prefix_key(str(row["prefix"]).strip()), row["name"], row["surname"], row["num"])
            studentNum = row["num"]
            studentID = str(row["id"]).strip()
            studentName = str(row["name"]).strip()
            studentSurname = str(row["surname"]).strip()

            genpass = f"{grade}{room_num_fix(room)}{room_num_fix(studentNum)}"
            print(genpass)

            res = requests.patch(
                "http://192.168.1.36:8001/dev/user",
                headers={"Content-Type": "application/json"},
                json={
                    "username": studentID,
                    "password": genpass,
                    "name": studentName,
                    "surname": studentSurname,
                    "role": "USER",
                    "prefix": get_prefix_key(str(row["prefix"]).strip()),
                    "grade": grade,
                    "room": room,
                },
            )
            print(res)
            time.sleep(0.05)

asyncio.run(main())