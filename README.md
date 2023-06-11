<h1 align="center">Tema Final DevOps</h1>

## Proposta:

<p>Este projeto tem a finalidade de automatizar o bake e deploy de uma aplicação em go(calculadora) em uma instancia EC2 na AWS, essa instância se utilizará de uma banco Redis que estará em uma instância EC2 distinta.</p>
<p>A aplicação em go também enviará suas métricas para outra instância contendo o Elasticshearch e Kibana para coletar essas métricas.</p>
<p>Todas as 3 instâncias terão seu loadbalancer e seu auto-scaling.</p>


## Requisitos:

- <a href="https://www.jenkins.io/">Jenkins<a>
- Packer
- AWS Cli
- Terraform

## Configurando Jenkins:

- Em "Dashboard > Gerir o Jenkins > Configurar sistema" será necessário colocar as "Environment variables" localizada em "Global properties" da seginte forma:

    |Nome da variável       |                   Valor da Variável                       |
    |:---                   |                          :---:                            |
    |AWS_ACCESS_KEY_ID      |            access key id fornecido pela AWS               |
    |AWS_SECRET_ACCESS_KEY  |           secret access key fornecido pela AWS            |
    |AWS_SESSION_TOKEN      |           session token fornecido pela AWS                |
    |key_file               |                   nome da chave .pem                      |
    |keypair_name           |       localização da chave .pem ("/local/da/chave.pem")   |
    |sg_app                 |   security group na AWS para a instancia da calculadora   |
    |sg_elk                 |       security group na AWS para a instancia do elk       |
    |sg_redis               |       security group na AWS para a instancia do Redis     |

## Configurando a Pipeline do Jenkins:

1. Criar novo item
2. Colocar o nome do Job e escolher a opção 'Pipeline'
3. Em seguida no campo Pipeline definition escolher a opção 'Pipeline script from SCM'
4. No campo SCM escolher a opção 'Git'
5. No campo Repository URL inserir: 'https://github.com/julianooen/FinalD.git'
6. Em Branch Specifier preencher com '*/master'
7. Em Script Path preencher com 'Jenkinsfile' conforme será visto em "Ordem de execução dos jobs"

## Ordem de execução dos jobs:

<p>É importante ter em mente que cada job possui uma ordem certa, pois alguns endereçamentos são pegos dinamicamente, portanto precisa que algumas instâncias estejam rodando antes das outras.</p>
<p>Cada job de seguir a configuração da pipeline descrita no tópico anterior (Configurando a Pipeline do Jenkins), o que irá mudar será o item 7, mais especificamente o que deve ser colocado em Script Path.</p>

1. Job1 - Bake da imagem do Redis, colocar em Script Path ```redis-bake/Jenkinsfile```
2. Job2 - Deploy do Redis, colocar em Script Path ```redis-deploy/Jenkinsfile```
3. Job3 - Bake da imagem com minikube-elk, colocar em Script Path ```elk-bake/Jenkinsfile```
4. Job4 - Deploy do minikube-elk, colocar em Script Path ```elk-deploy/Jenkinsfile```
5. Job5 - Bake da imagem com aplicação em Go, colocar em Script Path ```app-bake/Jenkinsfile```
6. Job6 - Deploy da aplicação em Go, colocar em Script Path ```app-deploy/Jenkinsfile```


## Utilização:

<p>Seguindo a ordem de execução proposta anteriormente, ao final do job4 e job6 será exibido o DNS publico para acessar o painel do kibana e a plicação em go respectivamente.</p>
<p>As aplicações podem demorar um pouco para que todas as funções estajem funcionando corretamente mesmo que a pipeline do jenkins já tenha finalizado seu processo.</p>

- Acessando o painel do Kibana:

    - Ao fim da execução do job4 será exibido o dns e basta copiar a colar no navegador e inserir no fim ":5601" para ter acesso ao kibana.

- Acessando aplicação da calculadora em go:

    Obs: substituir '<dns_app>' pelo DNS gerado no final do Job6.

    - Soma:         "http://<dns_app>:8080/calc/sum/10/5"
    - Subtração:    "http://<dns_app>:8080/calc/sub/10/5"
    - Divisão:      "http://<dns_app>:8080/calc/div/10/5"
    - Multiplicação:"http://<dns_app>:8080/calc/mul/10/5"
    - Histórico:    "http://<dns_app>:8080/calc/history"
    