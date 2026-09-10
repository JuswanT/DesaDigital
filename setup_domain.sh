#!/bin/bash
# Script untuk mengatur nama domain Nginx Proxy secara otomatis

echo "=========================================================="
echo "    Setup Domain Nginx Proxy untuk 4 Desa (OpenSID)       "
echo "=========================================================="
echo ""

echo "1. Masukkan domain untuk Desa Wawatu (contoh: wawatu.desa.id):"
read DOMAIN_WAWATU

echo "2. Masukkan domain untuk Desa Mata Wawatu:"
read DOMAIN_MATAWAWATU

echo "3. Masukkan domain untuk Desa Tanjung Tiram:"
read DOMAIN_TANJUNGTIRAM

echo "4. Masukkan domain untuk Kelurahan Lalowaru:"
read DOMAIN_LALOWARU

echo ""
echo "Menyimpan pengaturan domain..."

# Backup file asli untuk berjaga-jaga
cp docker-compose.yml docker-compose.yml.bak

# Mengganti domain lama di docker-compose dengan sed
sed -i "s/VIRTUAL_HOST=wawatu.local/VIRTUAL_HOST=$DOMAIN_WAWATU/g" docker-compose.yml
sed -i "s/VIRTUAL_HOST=matawawatu.local/VIRTUAL_HOST=$DOMAIN_MATAWAWATU/g" docker-compose.yml
sed -i "s/VIRTUAL_HOST=tanjungtiram.local/VIRTUAL_HOST=$DOMAIN_TANJUNGTIRAM/g" docker-compose.yml
sed -i "s/VIRTUAL_HOST=lalowaru.local/VIRTUAL_HOST=$DOMAIN_LALOWARU/g" docker-compose.yml

echo "Domain berhasil diperbarui di docker-compose.yml!"
echo ""
echo "Sedang memuat ulang kontainer Docker..."

# Restart docker-compose
docker-compose down
docker-compose up -d

echo ""
echo "=========================================================="
echo " Selesai! Sistem OpenSID sudah berjalan dengan domain baru."
echo "=========================================================="
