# AutoForce - Backend Challenge

## Configurações necessárias:

* Banco de dados utilizado: Postgresql
* rails 6
* ruby 2.6.3

> Nota estou utilizando o asdf para gerenciar o ruby, no lugar do rvm e rbenv.
> 
> Estou utilizando um arquivo .env com as variáveis de ambiente em modo de desenvolvimento, junto com a gem `dotenv-rails`

1. Depois de executar os comandos de criação do banco de dados deve-se executar o rake db:seed isto irá gerar o usuário admin padrão, com ele será possivel efetuar o login na aplicação WEB.

> usuário: admin@autoforce.com.br  senha: 123456

 Os demais usuários devem ser inseridos via sign_up form. E o token para usar na API pode ser pego em /users
   
### POSTMAN
  os endpoints usados para testar se encontram no arquivo `BackendChallenge.postman_collection`

### Gems
  * dotenv-rails -> facilita na criação de variaveis de ambiente em tempo de desenvolvimento.
  * rack-atack -> Ajuda na proteção contra ataques DDoS e Brute Force (Deixei a configuração padrão)
  * rack-cors -> para que a api consiga receber os comandos por conta do crsf do rails.
  * slim-rails -> simplicidade na implementação dos layouts.
  * devise -> Controle de acesso por meio de email e senha
  * simple-token-authentication -> inclui o token authentication para ser usado na api juntamente com o devise.
  * simple_form -> mais funcionalidades na montagem do layout web.

### Yarn
  * usando as bibliotecas do jquery, popper, bootstrap, boostrap-table e fontawesome

> O Helper `icon_helper.rb` me baseei numa gem antiga do boostrap, que possuia um helper para inserir fontes de forma mais facil nos layouts.

## API

  Para executar os comandos é preciso enviar no header da requisição os seguintes paramentros:
  * X-User-Token: xJKAiVS1auX_eYEjwUdv (token gerado ao incluir o usuário)
  * X-User-Email: admin@admin.com

### Requests:

#### Users
  > Infelizmente devido ao Ciclone Bomba que assolou Santa Catarina, meu cronograma ficou comprometido. Sendo assim não foi possivel concluir a API de inserção de usuários. Sendo necessário registrar os usuários manualmente (via sign_up) e com o usuario admim pegar os tokens para passar, ao usuário (Pouco prático). Vou deixar a tela `/users` na WEB UI da seguinte maneira, para o usuário admin, irá listar todos usuários, e para os usuários normais, apenas seu usuário. Não testei configurar a biblioteca do Devise para o envio de emails, mas acredito que se configurada irá enviar os dados para o email configurado ao cadastrar, um novo usuário.

#### Order

 > Como esta sendo utilizado controle de usuários, o usuário admin (Mestre) não irá poder inserir registros(WEB UI). Apenas visualiza-los.
 ja ná API tem como melhorar as restrictions para que seja negado o acesso aos metodos de inclusão ao usuário admin.

  * _GET_ - api/v1/orders -> desativada, apenas mantendo o código para testes.
  * _GET_ - api/v1/orders/status -> devolve uma ou mais `orders` com base nos parametros passados:
    * parametros possiveis:
      * `reference` -> referencia da ordem devolvida no momento da inclusão.
      * `client_name` -> nome do cliente.
      * `limit` -> numero de registros devolvidos, só tem efeito se usado em conjunto com o client_name, se não for informado por padrão serão devolvidos 5 registros.
  * _GET_ - api/v1/order/channel -> recupera as ordens conforme a conbinação de parametros passdos:
    * `purchase_channel` 
    * `status`  valores possiveis (READY, PRODUCTION, CLOSED, SENT)
  * _POST_ api/v1/order -> Insere uma ordem, todos os dados são mandatórios para geração do registro, caso algum destes parametros não seja enviado, o comando será devolvido com o status de erro, informando o paramentro faltante.
    ```
       {
          "purchase_channel": "Telefone",
          "client_name": "João Fernandes",
          "address": "Natalia Amorin",
          "delivery_service": "SEDEX",
          "total_value": 100.00,
          "itens": "[{SKU: 123, value: 50.00},{SKU: 122, value: 50.00}]"
        }
    ```
    > Esta é a resposta do comando acima quando executado com sucesso:
    ```
      {
        "reference": "BR8016485798",
        "purchase_channel": "Telefone",
        "client_name": "João Fernandes",
        "address": "Natalia Amorin",
        "delivery_service": "SEDEX",
        "total_value": "100.0",
        "itens": "[{SKU: 123, value: 50.00},{SKU: 123, value: 50.00}]",
        "status": "READY",
        "batch_id": null,
        "created_at": "2020-07-03T12:20:49.370Z",
        "updated_at": "2020-07-03T12:20:49.370Z",
        "url": "http://localhost:3000/orders/75.json"
      }
    ```
    > Precisa melhorar o tratamento do json de resposta removendo os campos  desnecessários ao uso da API como `batch_id`, `url`. 
  * _PUT_ api/v1/orders -> Atualiza uma ordem. SOMENTE será permitido a alteração quando a ordem estiver em PRODUCTION, caso contrário será devolvido um erro.
    ```
        {
          "reference": "BR1312408912",
          "purchase_channel": "Site BR",
          "client_name": "João Fernandes",
          "address": "Natalia Amorin",
          "delivery_service": "PAC",
          "total_value": 100.00,
          "itens": "[{SKU: 123, value: 50.00},{SKU: 124, value: 50.00}]"
        }
    ```

#### Batch

 > Por questão de lógica apenas o usuário Admin, poderá efetuar operações com o batch. Por isso se um usuário qualquer não admin tentar executar as operações abaixo recebera uma resposta em branco com o status 403 - Forbidden.

  * _POST_ api/v1/batches -> Insere um novo `batch`. 
    
    FIXME: tem que melhorar o tratamento das strings passadas, pois "Site BR" é diferente de "SITE BR" o que como são valores passados pelo cliente, podem gerar falhas ao não incluir uma ordem que deveria ser inclusa. Solução: Gerar cadastros para `purchase_channel` e `delivery_service`, assim usando Forreign Key para gerenciar os dados no lugar da string.

    * Esperado
      ```
        {
          "purchase_channel": "Site BR"
        }
      ``` 
    * resposta caso sucesso:
      ```
        {
          "reference": "BR2800206412",
          "qtd_orders": 1
        }
      ```
    * Caso não existam ordens para gerar o `batch` o mesmo não será gerado, a api irá apenas devolver a mensage: `Operation can't be completed. Don't have orders pending of producing`

  * _PUT_ api/v1/batches/close -> Irá marcar todas `orders` para CLOSED, espera receber o parametro `reference` 
    > O Método não espera receber nada via body, neste caso o **VERBO** _PUT_ esta sendo usado mais pelo sentido de UPDATE do que na sua funcionalidade completa.
  
  * _PUT_ api/v1/batches/sent -> Este método irá marcar as `orders` como `SENT`. Como o processo pode ser parcial, precisa passar 2 parametros, `reference` (do batch) e o `purchase_channel`.
    * Resposta:
      ```
        Updated 1 orders to status SENT
      ```

#### Reports

  * _GET_ api/v1/reports/financial -> Como estou usando o postgres, optei por executar um comando SQL diretamente no banco, ao invéz de tratar esses dados programaticamente (Vício de otimização SQL). 
    > Este report, se eu tivesse mais tempo teria feito uma segunda versão sumarizada pelo status da order.
  
    * Resposta:
      ```
        [
          { "purchase_channel": "SITE BR", "total_value": "700.00", "qtd_orders": 1 },
          { "purchase_channel": "Site BR", "total_value": "700.00", "qtd_orders": 1 },
          { "purchase_channel": "SiTe BR", "total_value": "700.00", "qtd_orders": 1 },
          { "purchase_channel": "Telefone", "total_value": "700.00", "qtd_orders": 1 }
        ]
      ```

## WEB UI

  Utilizei o boostrap para deixar um layout mais amigável, ainda teria que melhorar bastante para dizer que é um app funcional.

  Eu estou um pouco mais acostumado a utilizar o slim para escrever o layouts, pois acho ele mais legivel ao final do código, visto que sem as tags de fechamento, reduzem bastante as linhas inseridas.

  Ao meu ver a parte de alteração de `orders` precisaria ser revisada, e definir o que o usuário pode alterar, e assim desabilitar a edição dos campos que não poderiam ser alterados por engano.

  No UI tem os atalhos Order, Lotes (Somente Admin) e Users

  TODO: Rever as traduções.

## Segurança:

  * Como optei pelo devise ele já tem algumas funcionalidades que dão mais segurança, uma delas é o reset de sessão, evitando ataques do tipo `session fixation`
  * Outra proteção ativa é contra CRSF, que evita `session hijacking`
  * Como falei na parte das gems utilizadas, adicionei a gem rack-atack que inclui um middleware que evita ataques DDoS e por brute force.
  * Dando uma olhada no site  `https://guides.rubyonrails.org/security.html` existem diversas outras regras a serem aplicadas para manter a segurança, além das mencionadas acima  
  * Todos os registros estão vinculados ao ID de um user, por isso o usuário ADMIN não pode exeutar operações de inclusão do `orders`
 

## Testes
  Cometi o erro de iniciar o desenvolvimento, sem efetuar os testes unitários antes(para ser mais rápido, o que me possibilitou concluir ao menos os desenvolvimento da API e WEB UI.). Infelizmente (O que não uso como justificativa) ocorreu o ciclone bomba aqui no sul e fiquei 2 dias sem energia, o que acabou me deixando sem tempo para implementar os testes. E como não quero "fingir" que implementei os teste fazendo de qualquer jeito prefiro, não implementa-los e tirar isso como lição e em tudo que eu for programar SEMPRE Iniciar pelos testes.
  
## Outros

  No layout utilizei o slim_lint para tentar deixar o código mais organizado e dentro das métricas possivel.

  No código ruby utilizei o rubocop para tentar manter meu codigo dentro do padrão definido pela comunidade, tentei ao máximo respeitar as métricas de complexidade, e tamanho máximo dos métodos, sei que existem alguns métodos que precisam ser refatorados para deixar dentro deste padrão, mas meu tempo hábil não permitiu. 

## Encerramento

  Fico triste por não ter completado o desafio como eu desejava, entregando a suite completa com os testes minimos esperados, Mas fico feliz de ter tido a oportunidade de ter participado, essa oportunidade ampliou meus horizontes, e espero ter conseguido demostrar ao menos um pouco do meu conhecimento e trabalho.
