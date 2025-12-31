docker rm -f kali-bootstrap
rm -rfv ~/dev/container-storage/kali-bootstrap
mkdir -p ~/dev/container-storage/kali-bootstrap
docker compose up --build -d
docker exec -it kali-bootstrap bash