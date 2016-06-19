package main

import "os"
import "net/http"

func main() {
	http.ListenAndServe("127.0.0.1:" + os.Args[1], http.FileServer(http.Dir("site/")))
}
