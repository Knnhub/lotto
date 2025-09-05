package main

import (
    "database/sql"
    "fmt"
    _ "github.com/go-sql-driver/mysql"
)

func main() {
    // ข้อมูล MySQL
    username := "mb68_66011212250"
    password := "&WH74jVmJE6b"
    host := "202.28.34.203"
    port := "3306"       // port MySQL จริง ไม่ใช่ 8306 ของ phpMyAdmin
    dbname := "mb68_66011212250"   // ชื่อ database ของคุณ

    // สร้าง DSN
    dsn := fmt.Sprintf("%s:%s@tcp(%s:%s)/%s", username, password, host, port, dbname)

    // เปิดการเชื่อมต่อ
    db, err := sql.Open("mysql", dsn)
    if err != nil {
        panic(err)
    }
    defer db.Close()

    // ทดสอบ ping
    if err := db.Ping(); err != nil {
        panic(err)
    }

    fmt.Println("Connected to MySQL successfully!")

    // ตัวอย่าง query
    var now string
    err = db.QueryRow("SELECT NOW()").Scan(&now)
    if err != nil {
        panic(err)
    }
    fmt.Println("Current time from DB:", now)
}
