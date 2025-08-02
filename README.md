# 🚀 SUPER-CONFIG-100K 🚀

**Configuração fácil do ambiente de desenvolvimento Linux**

---

## Visão Geral

O `SuperConfig100k.sh` é um script Bash que automatiza a preparação de um servidor Ubuntu/Debian para desenvolvimento web full-stack, incluindo:

- Atualização e upgrade de pacotes APT  
- Instalação de utilitários básicos (git, curl, zip, unzip)  
- Criação e permissão de `/var/www`  
- Adição do repositório de PHP (ondrej/php)  
- Instalação de PHP e extensões (CLI, GD, mbstring, pdo, pgsql, redis, swoole etc.)  
- Instalação do Supervisor e do Redis Server  
- Instalação do Bun (runtime JavaScript)  
- Instalação do Node.js LTS e configuração do prefix global do npm  
- Instalação do Zsh, Oh My Zsh (modo unattended) e do tema Powerlevel10k  

---

## Pré-requisitos

- Sistema operacional Ubuntu ou Debian  
- Acesso root (ou sudo)  
- Conexão com a internet  

---

## Como Usar

1. **Clonar o repositório**  
```bash
   git clone https://github.com/Akifer2/super-config-100k.git
   cd super-config-100k
```

2. **Tornar o script executável**

   ```bash
   chmod +x SuperConfig100k.sh
   ```
3. **Executar como root**

   ```bash
   sudo ./SuperConfig100k.sh
   ```

---

## O que o script configura

1. **Ambiente APT**

   * `apt update` e `apt upgrade -y`

2. **Utilitários básicos**

   * `git`, `curl`, `zip`, `unzip`
3. **Diretório Web**
   * `/var/www` criado (se necessário) e permissão `777`
4. **PHP & Extensões**
   * PHP 8.x e módulos como `php-mbstring`, `php-pgsql`, `php-redis`, `php-swoole` etc.
5. **Supervisor & Redis**
   * `supervisor`, `redis-server` habilitados e iniciados
6. **JavaScript Runtime**
   * Bun via script oficial
   * Node.js LTS via NodeSource + `npm config set prefix '/usr/local'`
7. **Shell aprimorado**
   * `zsh`, instalação silenciosa do **Oh My Zsh**
   * Clonagem e ativação do tema **Powerlevel10k**
   * `chsh -s $(which zsh)` para tornar o Zsh padrão
  ---

## Fontes de Consulta

* **Script fonte**: `SuperConfig100k.sh` (este repositório)
* **Bash Reference Manual**: [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
* **APT (Ubuntu Guide)**: [https://help.ubuntu.com/lts/serverguide/apt.html](https://help.ubuntu.com/lts/serverguide/apt.html)
* **Oh My Zsh**: [https://github.com/ohmyzsh/ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
* **Powerlevel10k**: [https://github.com/romkatv/powerlevel10k](https://github.com/romkatv/powerlevel10k)
