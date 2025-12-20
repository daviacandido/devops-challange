# 📄 Documentação Técnica — Projeto de Infraestrutura e Plataforma Kubernetes (AKS)

Este projeto foi desenvolvido como entrega técnica com o objetivo de demonstrar:

- Capacidade de desenhar e implementar infraestrutura do zero
- Uso consistente de **Infraestrutura como Código (IaC)**
- Boas práticas de segurança, automação e observabilidade
- Conhecimento prático de **Kubernetes gerenciado (AKS)**, **CI/CD** e **DNS**

Todo o ambiente foi construído sem uso de ferramentas gerenciadas externas além da nuvem, priorizando **controle**, **clareza** e **reprodutibilidade**.

---

## 1. Infraestrutura

### 1.1 Escolha da abordagem

A infraestrutura foi a primeira etapa, pois todo o restante do projeto (Kubernetes, CI/CD, Ingress, TLS, Observabilidade) depende diretamente dela.

Foi adotado o conceito de Infraestrutura como Código (IaC) para garantir:

- Reprodutibilidade
- Versionamento
- Clareza arquitetural
- Facilidade de auditoria técnica

---

## 2. Ferramenta de Infraestrutura

### Terraform

**Terraform** foi escolhido como ferramenta principal de IaC, pois:

- Padrão de mercado
- Provider oficial e estável para Azure (**azurerm**)
- Sintaxe declarativa clara
- Separação entre estado, código e variáveis
- Compatível com pipelines CI/CD

**O que não foi utilizado (intencionalmente):**

- ❌ **ARM Templates / Bicep**
  → menos portáveis, mais verbosos

- ❌ **Provisionamento manual**
  → não auditável, não idempotente

---

## 3. Estrutura do Repositório de Infra

A estrutura foi desenhada para refletir responsabilidades claras (árvore de diretórios):

    infra/
    └── terraform/
        ├── README.md
        ├── versions.tf
        ├── providers.tf
        ├── variables.tf
        ├── outputs.tf
        ├── main.tf                # Recursos principais (AKS, rede, jumpbox)
        ├── envs/
        │   └── aks/
        │       └── terraform.tfvars
        ├── cloud-init/
        │   └── jumpbox.yaml       # Bootstrap da VM (runner)
        └── bootstrap/
            └── tfstate/
                ├── versions.tf
                ├── providers.tf
                ├── main.tf        # Backend de state
                ├── variables.tf
                └── outputs.tf

A estrutura foi organizada dessa forma pois:

**`bootstrap/tfstate`**
- Criação isolada do backend de estado
- Evita dependência circular
- Segue boas práticas Terraform

**`envs/`**
- Separação de variáveis por ambiente
- Facilita reaproveitamento do código

**`cloud-init/`**
- Bootstrap automatizado da VM
- Nenhuma configuração manual pós-criação

---

## 4. Backend de Estado (Terraform State)

O estado do Terraform foi configurado de forma **remota**, garantindo:

- Consistência entre execuções
- Evita conflitos em ambientes automatizados
- Base para CI/CD

O backend é criado antes do restante da infraestrutura, de forma manual, usando o diretório `bootstrap/tfstate`.

---

## 5. Recursos Criados via Terraform

### 5.1 Recursos principais

- Resource Group
- Virtual Network (VNet)
- Subnets
- Azure Kubernetes Service (AKS)
- Bastion
- Jumpbox (VM Linux)

---

## 6. AKS — Azure Kubernetes Service

### Por que AKS?

- Kubernetes gerenciado (menor overhead operacional)
- Integração nativa com Azure
- Suporte a:
  - LoadBalancer
  - Ingress Controllers
  - CSI / certificados
- Adequado para ambientes produtivos

**Características do cluster:**

- Node Pools separados (**system / user**)
- Kubernetes recente
- Container runtime: **containerd**
- Comunicação privada entre componentes

---

## 7. Bastion (Acesso Administrativo Seguro)

### Contexto e necessidade

Durante o desenho da infraestrutura, foi necessário definir como realizar o acesso administrativo aos recursos internos, principalmente à Jumpbox (VM Linux), sem expor máquinas diretamente à internet.

Como o objetivo do projeto é demonstrar boas práticas de segurança e arquitetura, foi adotado o uso de um Bastion como ponto de entrada seguro para administração do ambiente.

Essa decisão está alinhada com princípios modernos de segurança em nuvem, priorizando mínima exposição externa e controle de acesso.

### Por que utilizar um Bastion?

O Bastion atua como um host intermediário de acesso, permitindo conexões administrativas sem a necessidade de:

- IP público em máquinas internas
- Abertura de portas SSH (22) ou RDP (3389) para a internet
- Regras de firewall amplas ou permissivas

Principais benefícios da abordagem:

- Acesso seguro utilizando HTTPS
- Conexões realizadas inteiramente pela rede interna
- Redução significativa da superfície de ataque
- Centralização do ponto de entrada administrativo

### Aplicação no projeto

No contexto deste projeto, o Bastion foi utilizado para:

- Acesso administrativo à Jumpbox (VM Linux)
- Execução de operações pontuais de troubleshooting
- Validação de conectividade e contexto do cluster AKS
- Administração segura do ambiente sem exposição direta

A Jumpbox não possui IP público, reforçando o modelo de acesso restrito e controlado, onde todo acesso administrativo ocorre exclusivamente via Bastion.

### Por que não utilizar SSH direto com IP público?

Essa abordagem foi evitada de forma intencional.

Motivos principais:

- Exposição direta da VM à internet
- Necessidade de gerenciamento contínuo de regras de firewall
- Maior risco de ataques de força bruta
- Prática não recomendada para ambientes modernos e seguros

A decisão foi seguir padrões próximos aos adotados em ambientes produtivos.

### Por que não utilizar VPN?

Embora uma VPN seja uma alternativa válida para acesso administrativo, ela não foi adotada neste projeto pelos seguintes motivos:

- Complexidade operacional maior
- Necessidade de gerenciamento de clientes, chaves e certificados
- Overhead desnecessário para o escopo do projeto
- Maior esforço de manutenção sem ganho proporcional

O Bastion atende plenamente ao objetivo de acesso seguro, com menor complexidade operacional.

### Benefícios arquiteturais da escolha

O uso do Bastion, combinado com:

- Subnets privadas
- Ausência de IP público na Jumpbox
- Network Security Groups restritivos

Resulta em uma arquitetura que:

- Minimiza a exposição externa
- Reduz vetores de ataque
- Segue princípios de Zero Trust
- Demonstra maturidade arquitetural
- Está alinhada a boas práticas de segurança em nuvem

A utilização do Bastion neste projeto foi uma decisão arquitetural e intencional, não apenas funcional.

Ela reforça:

- A preocupação com segurança desde a base da infraestrutura
- A redução da superfície de ataque
- A adoção de padrões modernos de acesso administrativo

Essa escolha complementa o restante da solução, mantendo coerência com os princípios de infraestrutura segura, automatizada, reproduzível e auditável.

---

## 8. Jumpbox (VM de Administração)

### Objetivo da Jumpbox

A Jumpbox foi criada como ponto central de operação, responsável por:

- Executar pipelines (**self-hosted runner**)
- Interagir com AKS
- Evitar dependência de máquinas locais
- Centralizar credenciais e contexto
- Isolar o acesso ao cluster

---

## 9. Cloud-init (Bootstrap Automatizado)

A VM é configurada integralmente via **cloud-init**, sem intervenção manual.

**Principais ações do cloud-init:**

- Atualização do sistema
- Instalação de ferramentas:
  - Azure CLI
  - kubectl
  - curl, jq, unzip
- Configuração de timezone
- Instalação e configuração do GitHub Actions Runner
- Registro automático do runner no repositório

**Isso garante que:**
- A VM já nasce operacional
- O runner esteja pronto assim que a VM sobe
- O ambiente seja descartável e recriável

---

## 10. CI/CD — GitHub Actions com Runner Self-Hosted

### Por que self-hosted runner?

- Acesso direto à rede privada do AKS
- Menor latência
- Controle total do ambiente
- Elimina dependência de runners públicos

### Estrutura de workflows

Os workflows foram separados por responsabilidade:

- `bootstrap` — inicialização do cluster
- `observability` — Prometheus / Grafana
- `logging` — Loki / Promtail
- `dns-cloudflare` — DNS automático
- `deploy-all` — orquestração do fluxo

Cada workflow:
- É idempotente
- Pode ser executado isoladamente
- Usa variáveis e secrets corretamente segregados

---

## 11. Ingress Controller

Foi utilizado **ingress-nginx** como controlador de entrada pois:

- Amplamente adotado
- Boa documentação
- Integração direta com cert-manager
- Compatível com AKS

Ingress configurado para:
- HTTP e HTTPS
- TLS automático
- Integração com Cloudflare

---

## 12. Certificados TLS

### Ferramenta: cert-manager

- Emissão automática de certificados
- Integração com Let’s Encrypt
- Renovação automática
- Nenhum certificado manual

Cada serviço exposto possui:
- Secret TLS próprio
- Hostname explícito
- Validação ACME funcional

---

## 13. DNS — Cloudflare

### Por que Cloudflare?

- Proteção DDoS
- Proxy reverso
- TLS edge
- Controle programático via API
- Integração automatizada

O pipeline:
- Obtém o IP público do Ingress
- Cria ou atualiza registros DNS
- Suporta múltiplos FQDNs (app + grafana)
- Registros `proxied` (orange cloud)

---

## 14. Observabilidade

### Stack utilizada

- Prometheus Operator
- Prometheus
- Alertmanager
- Grafana

**Motivo da escolha:**
- Stack padrão Kubernetes
- Totalmente open-source
- Altamente configurável
- Adequada para clusters reais

**Ajustes realizados:**
- NetworkPolicies aplicadas
- Exposição via Ingress
- Credenciais configuradas via Secret
- Integração com DNS e TLS

---

## 15. Logging

### Stack de Logs

- Loki
- Promtail

**Motivo da escolha:**
- Baixo custo operacional
- Integração nativa com Grafana
- Labels baseados em Kubernetes
- Arquitetura simples

Configurações foram ajustadas para:
- Compatibilidade com versão do Loki
- Evitar recursos experimentais desnecessários
- Garantir estabilidade do pod

---

## 16. Segurança

Medidas adotadas:

- Secrets nunca versionados
- Variáveis sensíveis via GitHub Secrets
- NetworkPolicies restritivas
- ServiceAccounts mínimos
- TLS em todos os serviços expostos
- Nenhum endpoint aberto sem necessidade

---

## 17. Resultado Final

O projeto entrega:

- Infraestrutura completa em Azure via Terraform
- Cluster Kubernetes funcional
- CI/CD automatizado
- Observabilidade operacional
- Logging funcional
- DNS e TLS automatizados
- Arquitetura clara, reproduzível e auditável

Tudo foi desenvolvido com foco em clareza técnica, decisões conscientes e aderência a boas práticas.
