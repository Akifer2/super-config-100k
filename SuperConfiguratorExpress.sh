#!/usr/bin/env bash

set -euo pipefail
# Strict mode: abort on error, undefined var, and pipefail

LOG_FILE="/var/log/setup_env.log"

# Função de log com timestamp ISO 8601 e saída para console e arquivo
log_info() {
    local message="$1"
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "${timestamp} [INFO] ${message}" | tee -a "$LOG_FILE"
}

# Verifica privilégio de root
if [[ $(id -u) -ne 0 ]]; then
    echo "Este script precisa ser executado como root." >&2
    exit 1
fi

log_info "Iniciando configuração do ambiente"

log_info "Atualizando lista de pacotes"
apt update >>"$LOG_FILE" 2>&1

log_info "Atualizando pacotes instalados"
apt upgrade -y >>"$LOG_FILE" 2>&1

log_info "Instalando utilitários básicos (git, curl, zip, unzip)"
apt install -y git curl zip unzip >>"$LOG_FILE" 2>&1

log_info "Verificando existência de /var/www"
if [ ! -d /var/www ]; then
    log_info "Diretório /var/www não encontrado. Criando..."
    mkdir -p /var/www
fi

log_info "Ajustando permissões em /var/www"
chmod -R 777 /var/www

log_info "Adicionando repositório php"
add-apt-repository ppa:ondrej/php -y >>"$LOG_FILE" 2>&1
apt update >>"$LOG_FILE" 2>&1

log_info "Instalando PHP e extensões"
apt install -y \
    php php-bcmath php-curl php-common php-cli php-gd php-imap \
    php-intl php-imagick php-json php-mbstring php-mail php-mysql \
    php-pgsql php-pear php-soap php-zip php-sqlite3 php-xml php-dev \
    >>"$LOG_FILE" 2>&1

log_info "Instalando PHP Swoole e Redis via pacote oficial"
apt install -y php-swoole php-redis >>"$LOG_FILE" 2>&1

log_info "Instalando Supervisor e Redis Server"
apt install -y supervisor redis-server >>"$LOG_FILE" 2>&1

log_info "Habilitando e iniciando serviços"
systemctl enable --now supervisor >>"$LOG_FILE" 2>&1
systemctl enable --now redis >>"$LOG_FILE" 2>&1

# Instalar Bun (JavaScript runtime e bundler)
log_info "Instalando Bun (JavaScript runtime e bundler)"
curl -fsSL https://bun.sh/install | bash >>"$LOG_FILE" 2>&1
source /root/.bashrc

# Instalar Node.js LTS via NodeSource e npm
log_info "Instalando Node.js LTS via NodeSource"
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - >>"$LOG_FILE" 2>&1
apt install -y nodejs >>"$LOG_FILE" 2>&1

# Ajustar prefix global do npm para /usr/local
log_info "Configurando npm global prefix"
npm config set prefix '/usr/local' >>"$LOG_FILE" 2>&1

# Verificar versões instaladas
log_info "Verificando versões do Node.js e npm"
node -v | tee -a "$LOG_FILE"
npm -v | tee -a "$LOG_FILE"

log_info "Carregando configurações"
source /root/.bashrc

# Instalar Zsh, Oh My Zsh (não interativo) e Powerlevel10k
log_info "Instalando Zsh, Oh My Zsh e Powerlevel10k"
apt install -y zsh fonts-powerline >>"$LOG_FILE" 2>&1

# Oh My Zsh em modo unattended
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >>"$LOG_FILE" 2>&1

# Clonar Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" >>"$LOG_FILE" 2>&1

# Definir tema Powerlevel10k no .zshrc
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"

# Tornar zsh o shell padrão
chsh -s "$(which zsh)" >>"$LOG_FILE" 2>&1

log_info "Configuração concluída com sucesso"
