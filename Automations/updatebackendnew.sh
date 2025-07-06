#!/bin/bash

# === Lấy địa chỉ Public IPv4 của GCP Instance ===
ipv4_address=$(curl -s -H "Metadata-Flavor: Google" \
  http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip)

# === Đường dẫn đến file .env.docker của backend ===
file_to_find="../backend/.env.docker"
alreadyUpdate=$(grep -E "^FRONTEND_URL=" "$file_to_find")

# === Màu sắc in log ra terminal ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}GCP Public IPv4:${NC} ${ipv4_address}"

# === Kiểm tra nếu IP đã đúng thì bỏ qua ===
expected_line="FRONTEND_URL=\"http://${ipv4_address}:5173\""

if [[ "$alreadyUpdate" == "$expected_line" ]]; then
    echo -e "${YELLOW}✅ File đã được cập nhật đúng IP hiện tại.${NC}"
else
    if [ -f "$file_to_find" ]; then
        echo -e "${GREEN}🔍 Tìm thấy file:${NC} $file_to_find"
        echo -e "${YELLOW}🔄 Đang cập nhật FRONTEND_URL...${NC}"
        sleep 1
        sed -i -E "s|^FRONTEND_URL=.*|${expected_line}|g" "$file_to_find"
        echo -e "${GREEN}✅ Cập nhật thành công!${NC}"
    else
        echo -e "${RED}❌ Lỗi: Không tìm thấy file $file_to_find${NC}"
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
