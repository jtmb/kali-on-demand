mkdir -p ~/dev/container-storage/kali-bootstrap
docker compose up --build -d
docker exec -it kali-bootstrap bash