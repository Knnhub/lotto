package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	_ "github.com/go-sql-driver/mysql"
)

// สร้าง struct ของ user
type User struct {
	UID      int     json:"uid"
	FullName string  json:"full_name"
	Email    string  json:"email"
	Phone    string  json:"phone"
	Role     string  json:"role"
	Money    float64 json:"money"
}

func main() {
	// เชื่อมต่อ MySQL
	dsn := "mb68_66011212250:&WH74jVmJE6b@tcp(202.28.34.203:3306)/mb68_66011212250"
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		rows, err := db.Query("SELECT uid, full_name, email, phone, role, money FROM user")
		if err != nil {
			http.Error(w, "Query error", http.StatusInternalServerError)
			return
		}
		defer rows.Close()

		var users []User
		for rows.Next() {
			var u User
			if err := rows.Scan(&u.UID, &u.FullName, &u.Email, &u.Phone, &u.Role, &u.Money); err != nil {
				http.Error(w, "Scan error", http.StatusInternalServerError)
				return
			}
			users = append(users, u)
		}

		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(users)
	})

	log.Println("Server running at http://localhost:8080/user")
	log.Fatal(http.ListenAndServe(":8080", nil))
}