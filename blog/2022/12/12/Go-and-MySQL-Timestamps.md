---
title: "Go and MySQL timestamps"
author: "rsdoiel@sdf.org (R. S. Doiel)"
pubDate: 2022-12-12
keywords: [ "golang", "sql", "timestamps" ]
---

# Go and MySQL timestamps

By R. S. Doiel, 2022-12-12

The Go [sql](https://pkg.go.dev/database/sql) package provides a nice abstraction for working with SQL databases. The underlying drivers and DBMS can present some quirks that are SQL dialect and driver specific such as the [MySQL driver](github.com/go-sql-driver/mysql).  Sometimes that is not a big deal. [MySQL](https://dev.mysql.com) can maintain a creation timestamp as well as a modified timestamp easily via the SQL schema definition for the field. Unfortunately if you need to work with the MySQL timestamp at a Go level (e.g. display the timestamp in a useful way) the int64 provided via the driver isn't compatible with the `int64` used in Go's `time.Time`. To work around this limitation I've found it necessary to convert the MySQL timestamp to a formatted string using [DATE_FORMAT](https://dev.mysql.com/doc/refman/8.0/en/date-and-time-functions.html#function_date-format "DATE_FORMAT is a MySQL date/time function returning a string value") and from the Go side convert the formatted string into a `time.Time` using `time.Parse()`. Below is some Golang pseudo code showing this approach.

```
// Format used by MySQL strings representing date/times
const MySQLTimestamp = "2006-01-02 15:04:05"

// GetRecordUpdate takes a configuration with a db attribute previously
// opened and an id string returning a record populated with id and updated values where updated is an attribute of type time.Time. We use MySQL's
// `DATE_FORMAT()` function to convert the timestamp into a string and
// Go's `time.Parse()` to convert the string into a `time.Time` value.
func GetRecordUpdate(cfg, id string) {
	stmt := `SELECT id, DATE_FORMAT(updated, "%Y-%m-%d %H:%i:%s") FROM some_tabl WHERE id = ?`
	row, err := cfg.db.Query(stmt, id)
	if err != nil {
		return nil, err
	}
	defer row.Close()
	record := new(Record)
	if row.Next() {
		var updated string
		if err := row.Scan(&record.ID, &updated); err != nil {
			return nil, err
		}
		record.Updated, err = time.Parse(MySQLTimestamp, updated)
		if err != nil {
			return nil, err
		}
	}
	err = row.Err()
	return record, err
}
```
