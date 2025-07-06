# #!/bin/bash

# # Set the Instance ID and path to the .env file
# INSTANCE_ID="i-0ee177c8f3cdd7103"

# # Retrieve the public IP address of the specified EC2 instance
# ipv4_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# # Initializing variables
# file_to_find="../backend/.env.docker"
# alreadyUpdate=$(sed -n "4p" ../backend/.env.docker)
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# NC='\033[0m'

# # Use curl to fetch the public IPv4 address from the metadata service

# echo -e " ${GREEN}System Public Ipv4 address ${NC} : ${ipv4_address}"

<<<<<<< HEAD
# if [[ "${alreadyUpdate}" == "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]
# then
#         echo -e "${YELLOW}${file_to_find} file is already updated to the current host's Ipv4 ${NC}"
# else
#         if [ -f ${file_to_find} ]
#         then
#                 echo -e "${GREEN}${file_to_find}${NC} found.."
#                 echo -e "${YELLOW}Configuring env variables in ${NC} ${file_to_find}"
#                 sleep 7s;
#                 sed -i -e "s|FRONTEND_URL.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" ${file_to_find}
#                 echo -e "${GREEN}env variables configured..${NC}"
#         else
#                 echo -e "${RED}ERROR : File not found..${NC}"
#         fi
# fi


#!/bin/bash

# Local IP (hoặc localhost)
ipv4_address="localhost"

# Đường dẫn file .env.docker
file_to_find="../backend/.env.docker"
alreadyUpdate=$(sed -n "4p" "$file_to_find")

# Màu để hiển thị log
=======
# === Lấy địa chỉ IP công cộng của GCP instance hiện tại ===
ipv4_address=$(curl -s -H "Metadata-Flavor: Google" http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

# === Cấu hình file đích cần chỉnh sửa ===
file_to_find="../backend/.env.docker"
alreadyUpdate=$(sed -n "4p" $file_to_find)

# === Màu để hiển thị đẹp trong terminal ===
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

<<<<<<< HEAD
echo -e "${GREEN}Local IP address${NC}: ${ipv4_address}"

# Kiểm tra nếu giá trị đã đúng thì không cần update
if [[ "${alreadyUpdate}" == "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]; then
    echo -e "${YELLOW}${file_to_find} đã được cập nhật đúng${NC}"
else
    if [ -f "$file_to_find" ]; then
        echo -e "${GREEN}Tìm thấy file ${file_to_find}${NC}"
        echo -e "${YELLOW}Đang cấu hình lại biến môi trường...${NC}"
        sleep 2
        sed -i -e "s|^FRONTEND_URL.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" "$file_to_find"
        echo -e "${GREEN}Cấu hình thành công.${NC}"
=======
echo -e " ${GREEN}System Public IPv4 address${NC} : ${ipv4_address}"

# === Kiểm tra nếu dòng IP đã đúng thì không cần cập nhật ===
if [[ "${alreadyUpdate}" == "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]; then
    echo -e "${YELLOW}${file_to_find} đã được cập nhật đúng IP hiện tại${NC}"
else
    if [ -f "${file_to_find}" ]; then
        echo -e "${GREEN}${file_to_find}${NC} được tìm thấy..."
        echo -e "${YELLOW}Đang cập nhật biến môi trường trong${NC} ${file_to_find}"
        sleep 3
        sed -i -E "s|FRONTEND_URL=.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" "${file_to_find}"
        echo -e "${GREEN}Cập nhật thành công!${NC}"
>>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
    else
        echo -e "${RED}LỖI: Không tìm thấy file ${file_to_find}${NC}"
    fi
fi



# #!/bin/bash

# # Set the Instance ID and path to the .env file
# INSTANCE_ID="i-0ee177c8f3cdd7103"

# # Retrieve the public IP address of the specified EC2 instance
# ipv4_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# # Initializing variables
# file_to_find="../backend/.env.docker"
# alreadyUpdate=$(sed -n "4p" ../backend/.env.docker)
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# NC='\033[0m'

# # Use curl to fetch the public IPv4 address from the metadata service

# echo -e " ${GREEN}System Public Ipv4 address ${NC} : ${ipv4_address}"

# if [[ "${alreadyUpdate}" == "FRONTEND_URL=\"http://${ipv4_address}:5173\"" ]]
# then
#         echo -e "${YELLOW}${file_to_find} file is already updated to the current host's Ipv4 ${NC}"
# else
#         if [ -f ${file_to_find} ]
#         then
#                 echo -e "${GREEN}${file_to_find}${NC} found.."
#                 echo -e "${YELLOW}Configuring env variables in ${NC} ${file_to_find}"
#                 sleep 7s;
#                 sed -i -e "s|FRONTEND_URL.*|FRONTEND_URL=\"http://${ipv4_address}:5173\"|g" ${file_to_find}
#                 echo -e "${GREEN}env variables configured..${NC}"
#         else
#                 echo -e "${RED}ERROR : File not found..${NC}"
#         fi
# fi
