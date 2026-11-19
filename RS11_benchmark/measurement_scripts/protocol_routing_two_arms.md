
## §2 · O encaminhamento […]: o protocolo dos dois braços, escrito antes de correr

**A ordem.** Vem das ordens do [coordenador] de 19 Nov (ponto 2) e da correcção do [coordenador] ao desenho, que chegou depois do `5f5e0ea86`. O `RouteRequest` traz a tarefa declarada pelo chamador (`models.py` l.189–197), e o encaminhador não classifica texto livre (`router.py` l.129–185).

**O conjunto** é o do [rotulador]: `[…]/routing_question_set_[…]20261119_083359.json`, comitado no `6c690a650` (08:36:54). O sha256 é `d3388829e84e89fd9a3f2ab2778b348bca9d6e5e4dd7d6c0993a17bb881e60c0`, conferido contra o `.sha256` que está ao lado. Tem 73 perguntas: 14 de (a), 19 de (b) e 10 de cada categoria de (c) a (f); 18 são de fronteira. Antes de escrever isto, li só a meta, os nomes dos campos e as contagens das rotas esperadas.

### Braço 1: a conformidade do código com a especificação (corre já, sem modelo)

**O que mede e o que não mede.** A tarefa entra declarada, tal como vem no conjunto. Por isso, este braço não mede a escolha da tarefa; medi-la aqui seria circular. Mede se o `Router.route` do `5b313864f` dá, em entradas novas, a rota que a especificação pública manda. Essa rota é a `expected_route` do [rotulador], escrita pelo README, pelo `openapi.yaml` e pela especificação formal, sem ler o código. Chama-se conformidade com a especificação, e não exactidão do encaminhamento.

**Como cada pergunta vira pedido.** Uso só os campos do pedido que o [rotulador] escreveu, que dizem o que a pergunta diz:
- `task`: o do conjunto. Nas (f) é nulo, e o pedido vai sem `task`; vale então o valor por omissão, `retrieve` (`openapi.yaml` l.111–120).
- `query`: o `term`, se houver; senão, o primeiro dos `codes`; senão, o `text`.
- `code`: o primeiro dos `codes`. Nas perguntas com dois códigos, o segundo não tem campo no pedido e fica de fora.
- `system_hint`, `display` e `target_system`: os do conjunto, como estão. Um sistema que o serviço não conhece, como «OMOP concept_id» ou «Apple HealthKit», vai assim mesmo.

**As lojas.** São duas, uma por base, com os vocabulários que a meta do conjunto dá como usados e com as mesmas fontes (os sha256 da meta batem com os do §1):
- a da Athena, com LOINC e UCUM;
- a do Vocab2, com SNOMED CT, ICD-10 e UCUM.

São o mesmo índice SQLite em memória do §1, com as mesmas duas diferenças face à loja CSV do serviço. O `Router` recebe só estas duas lojas, sem a `FixtureStore`.

**Como se compara a rota esperada com a decisão:**
- R0, R1, R3 a R7 e R-pre comparam-se com o `route` da decisão;
- «R2→R1» é a R2 com `path = A`, e «R2→R3» é a R2 com `path = C` (`router.py` l.322–362);
- «R2→R7» é a R7 com o motivo `no-candidate`, que o encaminhador dá depois da expansão (l.364–381);
- a R7 esperada aceita qualquer motivo de recusa;
- uma R2 com outro caminho conta como discordância.

**As medidas:**
- **A conformidade estrita:** as rotas iguais sobre 73, com a tabela de confusão (rota esperada × rota obtida).
- **À parte, a concordância do desfecho** (resolvido ou recusado), só onde a rota esperada o fixa:
  - a recusa, na R7, na R-pre e na «R2→R7»;
  - a resolução, nas outras;
  - a R0 fica de fora, porque o desfecho depende da validade do código.
- **As 18 de fronteira,** à parte e também dentro do total.
- **Todas as discordâncias, listadas uma a uma.** Cada uma leva a pergunta, a rota esperada, a decisão (rota, caminho, desfecho e motivo da recusa), a razão do [rotulador] e a causa que lhe atribuo, com a prova. As causas possíveis são cinco:
  1. a especificação pública e o código dizem coisas diferentes (por exemplo, as três diferenças que o [revisor] achou entre o README e o código);
  2. a classe de candidatos do [rotulador], medida só sobre conceitos padrão e válidos, não é a da loja, que também devolve os não padrão e os retirados;
  3. a expansão do serviço é uma tabela de sete termos (`router.py` l.101–125), enquanto a especificação descreve uma expansão sem lista;
  4. um defeito do encaminhador, quando nenhuma das outras causas explica a discordância;
  5. a rota esperada contradiz o próprio texto que o [rotulador] cita.

  Uma discordância que eu não consiga explicar fica na causa 4.

**Os limites a declarar.** As perguntas foram escritas e rotuladas por um só rotulador de IA, em inglês, com n pequeno, e não vêm de uso real. A tarefa vem dada. A loja é o índice da medição, e não a loja do serviço.

### Braço 2: a exactidão do chamador a declarar a tarefa (só com a palavra do [coordenador], na corrida do caminho C)

**O que mede.** É a exactidão […]: a do chamador que lê a pergunta e declara a tarefa. O chamador é o modelo local do benchmark, o `qwen3.5:4b`, que está no disco interno. Conferi isto antes deste commit:
- a pasta é `~/.ollama/models`, sem ligação simbólica, e o `OLLAMA_MODELS` não está definido;
- o manifesto e os quatro blobs existem, todos com o tamanho certo, 3 389 983 735 bytes ao todo.

**O pedido ao modelo.** O modelo recebe só o `text` da pergunta, com um texto fixo. Esse texto dá seis classes (verify, retrieve, map, hierarchy, interpret e out_of_scope), com as definições do `openapi.yaml` e do README à letra, e pede uma só etiqueta. Corre com temperatura 0 e a semente 20261119, uma chamada por pergunta, sem repetir. Uma resposta que não seja uma das seis etiquetas conta como errada.

**As medidas:**
- **A exactidão da tarefa declarada,** contra a tarefa do conjunto (nas (f), out_of_scope), com a tabela de confusão.
- **A conformidade de ponta a ponta:** cada pergunta vai ao `Router.route` com a tarefa que o modelo declarou e os mesmos outros campos, e a rota compara-se como no braço 1. Com out_of_scope, o chamador não chama o `Router`, e a pergunta conta como recusa.
- **A latência da chamada ao modelo** (p50 e p95).

**Antes de correr:**
- o texto fixo do pedido fica comitado;
- a chamada ao Ollama é HTTP em `localhost`, por isso, além da palavra do [coordenador], peço a palavra do [primeiro autor] […] antes de a fazer (a regra da rede).
