package main

import (
	"fmt"
	"os"
	"time"
)

var logger = Logger{}

type Logger struct {
}

func (l *Logger) Debug(format string, v ...any) {
	currentDatetime := time.Now().UTC().Format(time.RFC3339)
	fmt.Printf("["+currentDatetime+"] DEBUG: "+format+"\n", v...)
}

func (l *Logger) Info(format string, v ...any) {
	currentDatetime := time.Now().UTC().Format(time.RFC3339)
	fmt.Printf("["+currentDatetime+"] INFO: "+format+"\n", v...)
}

func (l *Logger) Warn(format string, v ...any) {
	currentDatetime := time.Now().UTC().Format(time.RFC3339)
	fmt.Printf("["+currentDatetime+"] WARN: "+format+"\n", v...)
}

func (l *Logger) Error(format string, v ...any) {
	currentDatetime := time.Now().UTC().Format(time.RFC3339)
	fmt.Printf("["+currentDatetime+"] ERROR: "+format+"\n", v...)
}

func (l *Logger) Fatal(v ...any) {
	currentDatetime := time.Now().UTC().Format(time.RFC3339)
	s := fmt.Sprint(v...)
	fmt.Printf("[" + currentDatetime + "] FATAL: " + s + "\n")
	os.Exit(1)
}

func (l *Logger) Panic(v ...any) {
	currentDatetime := time.Now().UTC().Format(time.RFC3339)
	s := fmt.Sprint(v...)
	fmt.Printf("[" + currentDatetime + "] PANIC: " + s + "\n")
	panic(s)
}
