#!/bin/bash

# === Lấy Public IPv4 của GCP VM ===
ipv4_address=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

# === Đường dẫn tới file .env.docker của frontend ===
file_to_find="../frontend/.env.docker"

# === Màu hiển thị terminal ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# === Hiển thị IP ===
echo -e "${GREEN}🔍 Public IPv4 của hệ thống:${NC} ${ipv4_address}"

# === Kiểm tra tồn tại file ===
if [ ! -f "$file_to_find" ]; then
    echo -e "${RED}❌ Không tìm thấy file: ${file_to_find}${NC}"
    exit 1
fi

# === Kiểm tra nếu đã đúng IP thì không update ===
expected_line="VITE_API_PATH=\"http://${ipv4_address}:31100\""
if grep -q "^${expected_line}" "$file_to_find"; then
    echo -e "${YELLOW}✅ ${file_to_find} đã chứa đúng IP hiện tại.${NC}"
else
    echo -e "${YELLOW}⚙️ Đang cập nhật VITE_API_PATH...${NC}"
    sed -i -E "s|^VITE_API_PATH=.*|${expected_line}|g" "$file_to_find"
    echo -e "${GREEN}✅ Cập nhật thành công!${NC}"
fi



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
# >>>>>>> ed80b38 (Update scripts and env files for Jenkins pipeline)
