package main

import (
	"os"
	"path"
	"time"

	bolt "go.etcd.io/bbolt"
)

const bucket = "default"

type Kvs struct {
	dir      string
	filename string
}

func NewKvs(dir string, filename string) (*Kvs, error) {
	kvs := &Kvs{
		dir,
		filename,
	}

	if err := os.MkdirAll(kvs.dir, os.ModePerm); err != nil {
		return nil, err
	}

	return kvs, nil
}

func (kvs *Kvs) Write(key string, data []byte) error {
	db, err := bolt.Open(kvs.dbpath(), 0600, &bolt.Options{Timeout: 1 * time.Second})
	if err != nil {
		return err
	}
	defer db.Close()

	if err := db.Update(func(tx *bolt.Tx) error {
		b, err := tx.CreateBucketIfNotExists([]byte(bucket))
		if err != nil {
			logger.Error("%s", err)
			return err
		}

		keybin := []byte(key)
		if err := b.Put(keybin, data); err != nil {
			return err
		}

		return nil
	}); err != nil {
		return err
	}

	return nil
}

func (kvs *Kvs) Read(key string) ([]byte, error) {
	db, err := bolt.Open(kvs.dbpath(), 0600, &bolt.Options{Timeout: 1 * time.Second})
	if err != nil {
		return nil, err
	}
	defer db.Close()

	var data []byte
	if err := db.View(func(tx *bolt.Tx) error {
		b := tx.Bucket([]byte(bucket))
		if b == nil {
			logger.Warn("No such a bucket: \"%s\"", bucket)
			return nil
		}

		keybin := []byte(key)
		data = b.Get(keybin)

		return nil
	}); err != nil {
		return nil, err
	}

	return data, nil
}

func (kvs *Kvs) dbpath() string {
	return path.Join(kvs.dir, kvs.filename)
}
