# Unix Server - Desktop Linux via Coolify

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white)
![XFCE](https://img.shields.io/badge/XFCE-%232284F2.svg?style=for-the-badge&logo=xfce&logoColor=white)

Um ambiente de desenvolvimento completo baseado em Ubuntu com interface gráfica XFCE, implantado via Coolify. Ideal para desenvolvimento, testes e acesso remoto a um desktop Linux completo através do navegador.

## 📋 Índice

- [Características](#-características)
- [Pré-requisitos](#-pré-requisitos)
- [Instalação](#-instalação)
- [Configuração](#-configuração)
- [Uso](#-uso)
- [Aplicações Incluídas](#-aplicações-incluídas)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Personalização](#-personalização)
- [Solução de Problemas](#-solução-de-problemas)
- [Contribuição](#-contribuição)
- [Licença](#-licença)

## 🚀 Características

- **Desktop Linux Completo**: Interface XFCE4 executando em container
- **Acesso via Navegador**: Sem necessidade de cliente VNC ou RDP
- **Ferramentas de Desenvolvimento**: VS Code, GitKraken, Postman pré-instalados
- **Conectividade de Rede**: NetworkManager com suporte a VPN
- **Produtividade**: LibreOffice, Remmina para conexões remotas
- **Ambiente Python/Node.js**: Ambientes de desenvolvimento prontos
- **Persistência de Dados**: Configurações e dados mantidos entre reinicializações

## 📋 Pré-requisitos

- Docker 20.10 ou superior
- Docker Compose 2.0 ou superior
- 4GB de RAM disponível (recomendado: 8GB)
- 10GB de espaço em disco livre

## 🔧 Instalação

Este projeto é implantado via Coolify. Para acessar o desktop:

1. Acesse: `https://unix.stellvick.fun`

Para desenvolvimento local com Docker:

1. **Clone o repositório:**
```bash
git clone https://github.com/stellvick/unix-server.git
cd unix-server
```

2. **Construa e inicie o container:**
```bash
docker-compose up -d
```

3. **Acesse o desktop:**
   - Abra seu navegador e vá para: `http://localhost:3000`
   - Para HTTPS: `https://localhost:3001`

## ⚙️ Configuração

### Variáveis de Ambiente

O arquivo `docker_compose.yaml` contém as seguintes configurações:

- `PUID=1000` - ID do usuário
- `PGID=1000` - ID do grupo
- `TZ=America/Sao_Paulo` - Fuso horário
- `TITLE=UnixDesktop` - Título da aplicação
- `BASE_URL=https://unix.stellvick.fun` - URL base (para produção)

### Persistência de Dados

Os dados são armazenados no diretório `./webtop_data` que é mapeado para `/config` no container.

### Portas

- `3000`: HTTP
- `3001`: HTTPS

## 🖥️ Uso

### Primeiro Acesso

1. Após iniciar o container, acesse `http://localhost:3000`
2. Aguarde o carregamento completo do desktop XFCE
3. As aplicações estarão disponíveis no menu ou na área de trabalho

### Gerenciamento do Container

```bash
# Iniciar
docker-compose up -d

# Parar
docker-compose down

# Ver logs
docker-compose logs -f

# Reconstruir após mudanças
docker-compose up -d --build
```

## 📱 Aplicações Incluídas

### Desenvolvimento
- **Visual Studio Code** - Editor de código com extensões
- **PyCharm** - IDE Python com interface gráfica
- **GitKraken** - Cliente Git com interface gráfica
- **Postman** - Teste de APIs REST
- **Node.js 20** - Runtime JavaScript
- **Python 3** - Linguagem de programação com pip

### Produtividade
- **LibreOffice Writer** - Editor de documentos
- **Remmina** - Cliente RDP/VNC para conexões remotas
- **Network Manager** - Gerenciamento de conexões de rede

### Sistema
- **NetworkManager** - Configuração de rede e VPN
- **XFCE4** - Ambiente desktop leve e eficiente

## 📁 Estrutura do Projeto

```
unix-server/
├── dockerfile              # Definição da imagem Docker
├── docker_compose.yaml     # Configuração do serviço
├── custom-init.sh          # Script de inicialização personalizado
├── webtop_data/            # Dados persistentes (criado automaticamente)
├── LICENSE.md              # Licença MIT
└── README.md               # Esta documentação
```

## 🎨 Personalização

### Adicionar Novas Aplicações

Edite o `dockerfile` para incluir novas aplicações:

```dockerfile
# Exemplo: Instalar Firefox
RUN apt-get install -y firefox
```

### Modificar Configurações de Inicialização

Edite o arquivo `custom-init.sh` para adicionar novos serviços ou configurações.

### Configurar VPN

1. Acesse o Network Manager no desktop
2. Configure sua conexão VPN
3. As configurações serão persistidas no volume `webtop_data`

## 🔍 Solução de Problemas

### Container não inicia
```bash
# Verificar logs
docker-compose logs webtop

# Verificar recursos do sistema
docker system df
```

### Desktop não carrega
- Verifique se a porta 3000 não está sendo usada por outro serviço
- Aguarde alguns minutos para o carregamento completo
- Limpe o cache do navegador

### Aplicações não abrem
```bash
# Reiniciar o container
docker-compose restart webtop

# Verificar permissões
docker-compose exec webtop chown -R abc:abc /config
```

### Performance lenta
- Aumente a `shm_size` no docker-compose.yaml
- Verifique recursos disponíveis no host
- Considere limitar o número de aplicações abertas simultaneamente

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📞 Suporte

Para suporte e dúvidas:
- Abra uma [issue](https://github.com/stellvick/unix-server/issues) no GitHub
- Consulte a documentação do [LinuxServer Webtop](https://docs.linuxserver.io/images/docker-webtop)

## 📄 Licença

Este projeto está licenciado sob a Licença MIT. Veja o arquivo [LICENSE.md](LICENSE.md) para detalhes.

---
