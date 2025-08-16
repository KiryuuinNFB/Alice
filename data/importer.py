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
        return roomnum

async def main() -> None:
    for room in range(1, 17):
        print(f"================= class {room} ===============")
        df = pd.read_excel("grade7.xlsx", sheet_name=f"1{room_num_fix(room)}", usecols="B:E", skiprows=5)
        df.columns = ["id", "prefix", "name", "surname"]
        for index, row in df.iterrows():
            print(row["id"], get_prefix_key(str(row["prefix"]).strip()), row["name"], row["surname"])
            studentID = str(row["id"]).strip()
            studentName = str(row["name"]).strip()
            studentSurname = str(row["surname"]).strip()

            res = requests.put(
                "http://43.229.79.165:8000/dev/user",
                headers={"Content-Type": "application/json"},
                json={
                    "username": studentID,
                    "password": "5555",
                    "name": studentName,
                    "surname": studentSurname,
                    "role": "USER",
                    "prefix": get_prefix_key(str(row["prefix"]).strip()),
                    "grade": 1,
                    "room": room,
                },
            )
            print(res)
            time.sleep(0.5)

asyncio.run(main())