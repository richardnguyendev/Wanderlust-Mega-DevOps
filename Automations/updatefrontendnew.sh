# #!/bin/bash

# # Set the Instance ID and path to the .env file
# INSTANCE_ID="i-0ee177c8f3cdd7103"

# # Retrieve the public IP address of the specified EC2 instance
# ipv4_address=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)

# # Initializing variables
# file_to_find="../frontend/.env.docker"
# alreadyUpdate=$(cat ../frontend/.env.docker)
# RED='\033[0;31m'
# GREEN='\033[0;32m'
# YELLOW='\033[0;33m'
# NC='\033[0m'

# echo -e " ${GREEN}System Public Ipv4 address ${NC} : ${ipv4_address}"

# if [[ "${alreadyUpdate}" == "VITE_API_PATH=\"http://${ipv4_address}:31100\"" ]]
# then
#         echo -e "${YELLOW}${file_to_find} file is already updated to the current host's Ipv4 ${NC}"
# else
#         if [ -f ${file_to_find} ]
#         then
#                 echo -e "${GREEN}${file_to_find}${NC} found.."
#                 echo -e "${YELLOW}Configuring env variables in ${NC} ${file_to_find}"
#                 sleep 7s;
#                 sed -i -e "s|VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" ${file_to_find}
#                 echo -e "${GREEN}env variables configured..${NC}"
#         else
#                 echo -e "${RED}ERROR : File not found..${NC}"
#         fi
# fi

#!/bin/bash

# Khai báo IP local hoặc IP cục bộ
ipv4_address="localhost"

# Đường dẫn file .env frontend
file_to_find="../frontend/.env.docker"
alreadyUpdate=$(cat "$file_to_find")

# Màu hiển thị
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}Local IP Address${NC}: ${ipv4_address}"

# Kiểm tra nếu biến môi trường đã đúng thì không sửa
if [[ "${alreadyUpdate}" == *"VITE_API_PATH=\"http://${ipv4_address}:31100\""* ]]; then
    echo -e "${YELLOW}${file_to_find} đã được cập nhật đúng${NC}"
else
    if [ -f "$file_to_find" ]; then
        echo -e "${GREEN}Tìm thấy file: ${file_to_find}${NC}"
        echo -e "${YELLOW}Đang cập nhật biến VITE_API_PATH...${NC}"
        sleep 2
        sed -i -e "s|^VITE_API_PATH.*|VITE_API_PATH=\"http://${ipv4_address}:31100\"|g" "$file_to_find"
        echo -e "${GREEN}Cập nhật thành công!${NC}"
    else
        echo -e "${RED}Lỗi: Không tìm thấy file ${file_to_find}${NC}"
    fi
fi

