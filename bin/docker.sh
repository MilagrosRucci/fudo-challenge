rm -f dump.rdb
docker build -t fudo-challenge .
docker run --name fudo-container -p 9393:9393 -v $(pwd):/app fudo-challenge