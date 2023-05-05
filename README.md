# Cadastro de Produtos

API para cadastro e manipulação de produtos.

### Pré-requisitos

Caso deseje iniciar o projeto utilizando container:
```
docker
```

Caso deseje iniciar o projeto diretamente:
```
ruby 3.0.0
rails 7.0.4
```

Clone este projeto em seu ambiente de desenvolvimento local para iniciar a instalação.

### Instalação utilizando Docker

Após clonar o repositório vá rode os comandos abaixo.

```
# Entre na pasta do projeto
cd product_registration

docker-compose build
docker-compose run --rm web rails db:setup
docker-compose up
```

### Instalação diretamente na máquina local

Após clonar o repositório vá rode os comandos abaixo.

```
# Entre na pasta do projeto
cd product_registration

bundle install
rails db:setup
rails s
```


## Executando os testes

Para exectuar os testes rode os comandos abaixo.

```
docker-compose run --rm web rspec
```

### Analise de algumas decisões

1. Para realizar a busca de produtos por nome passando caracteres como parâmetro de busca, optei por criar um service object para isolar essa lógica e responsabilidade fora do model Product mantendo mais fiél à modelagem e responsabilidade do model.

2. Para alguns dos testes do model usei a gem shoulda matchers que deixa mais fácil de escrever e descritível o testes que está sendo realizado.

3. Para a paginação foi utilizado Kaminari pela facilidade na utilização da gem que supre as necessidades do projeto.
