RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info () {
echo -e "${CYAN}$1${NC}"
}

error () {
echo -e "${RED}$1${NC}"
}

warn () {
echo -e "${YELLOW}$1${NC}"
}

ok () {
echo -e "${GREEN}$1${NC}"
}
