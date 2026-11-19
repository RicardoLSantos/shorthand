
### §2.2 · A leitura do [rotulador] das 14 discordâncias, e o README

O [rotulador] mandou a sua leitura depois das 08:46:11[…]. Fica aqui como a recebi, sem mudar o §2.1:
- **As 10 (f):** o [rotulador] diz que a falha de rótulo é dele. Aponta também uma lacuna da especificação: a tabela não tem linha para pedidos fora do âmbito, e a meta não diz qual regra ganha.
- **A Q09:** o [rotulador] diz que o erro é dele; o `system` devia ser LOINC.
- **A Q51:** o `null` defende-se, porque ali o LOINC é o tema da pergunta.
- **A Q46:** o exemplo do README vem provavelmente da loja de fixture, que é a que o serviço usa sem `ROUTER_ATHENA_CSV`.
- O conjunto e o seu sha ficam como estão.

**O README.** Pela ordem do [coordenador], o README corrige-se depois das medições, num commit à parte. A conferência do braço 1 foi feita sobre o README tal como estava (o último commit do serviço é o `5b313864f`), e as medições do §3 também o são.

## §3 · O braço 2 do encaminhamento e o caminho C de ponta a ponta, com o modelo local: o protocolo, escrito antes de correr […]

**As palavras.**
- **O [coordenador]** deu a palavra numa mensagem recebida entre as 08:49:56 […] e as 08:50:34, com o desenho que fixo aqui. A palavra vem do formulário do [primeiro autor]: […], «Arrancar agora (Recomendado)», às 08:48:43.
- **O [primeiro autor]** deu a palavra […] para a chamada ao Ollama em `localhost`: «Sim, pode chamar (Recomendado)». A primeira hora medida depois da resposta é 08:56:02.

**O que muda no braço 2 do §2.** O [coordenador] pediu que o modelo declare o pedido inteiro, isto é, a tarefa e os campos do `RouteRequest`, e não só a etiqueta. Fica assim antes de correr; do braço 2 nada correu. O resto do §2 fica como estava:
- as seis etiquetas;
- a temperatura 0 e a semente 20261119;
- uma chamada por pergunta, sem repetir;
- com out_of_scope, não há chamada ao `Router`.

**O modelo e a chamada.**
- **O modelo** é o `qwen3.5:4b` do disco interno. O manifesto tem o sha256 `2a654d98e6fb…` e a configuração o digest `de9fed2251b3…`. O servidor é o Ollama 0.18.2 do Homebrew, que já estava a correr.
- **A chamada** é HTTP só para `127.0.0.1:11434` (`/api/chat`), sem proxy: o guião usa um `ProxyHandler` vazio e recusa outro endereço. Não há `pull`.
- **As opções:**
  - `temperature` 0, `seed` 20261119, `num_ctx` 4096 e `num_predict` 256;
  - `think` falso, `stream` falso e `keep_alive` de 60 s;
  - a resposta vem presa a um esquema JSON (`format`);
  - no fim, o guião tira o modelo da memória (`keep_alive` 0).
- **O disco:** a corrida só arranca com 5 GiB livres. O guião mede antes de cada chamada e pára se descer dos 3 GiB, guardando o que já correu.
- **A corrida** é uma só, em segundo plano. Não sondo o ficheiro de saída: espero a notificação.

**O texto fixo 1, o do pedido.** É o mesmo nos dois braços: o braço 2 e o passo do pedido no caminho C. O texto está no guião (`REQUEST_PROMPT`), e o sha256 dele vai no ficheiro de resultados.
- **A tabela de decisão** do README vai inteira e à letra.
- **Os campos** levam as descrições do `openapi.yaml` à letra:
  - `query`: «Free text, or a code when task=verify.»;
  - `system_hint`: «LOINC | SNOMED | ICD10 | ... | null»;
  - `display`: «Intended meaning. Required for semantics-verified (INV-2).».
  - O `openapi.yaml` não descreve o `code` nem o `target_system`, e as frases desses dois são minhas.
- **A sexta etiqueta, out_of_scope,** não tem linha no README nem no `openapi.yaml`: é a lacuna que o [rotulador] apontou. A definição é a da meta do [rotulador] para as (f): «the service should abstain (no task class fits)».
- **O texto pede só o que a mensagem diz.** Manda copiar os códigos e os nomes como estão escritos, e proíbe juntar um código que não esteja na mensagem.
- **O esquema** obriga a uma das seis tarefas e aos seis campos, com os opcionais nulos.
- **As respostas que não servem.** Uma cadeia vazia num campo opcional vale nulo. Uma resposta que não se leia como JSON, ou uma chamada que falhe, conta como pedido inválido: a tarefa está errada e não há rota.
- **Uma excepção do `Router`** perante um pedido do modelo regista-se à parte, como defeito do encaminhador, e a corrida continua. Nunca conta como recusa certa.

**Braço 2: as 73 perguntas do [rotulador].** O modelo recebe só o `text` de cada pergunta. As lojas são as do braço 1: a Athena com o LOINC e o UCUM, e o Vocab2 com o SNOMED CT, o ICD-10 e o UCUM. As medidas:
- **A exactidão da tarefa:** a tarefa declarada contra a do conjunto, que nas (f) é out_of_scope. Relato a global, a de cada categoria, a tabela de confusão e todas as discordâncias.
- **A rota do pedido do modelo:** o pedido inteiro do modelo vai ao `Router.route`.
  - A rota lê-se e compara-se com a esperada como no braço 1, pela mesma regra estrita.
  - Comparo-a também com a rota que o pedido do [rotulador] teve no braço 1. Essa rota recalcula-se na mesma corrida e confere-se com o ficheiro do braço 1.
- **A rota com a tarefa do modelo e os outros campos do [rotulador]:** é a medida que o §2 comitou, e sai da mesma chamada.
- **Com out_of_scope,** o chamador não chama o `Router`. Na rota isso não conta como R7: chama-se «chamador-recusa», e pela regra estrita não conforma com nenhuma rota. No desfecho conta como recusa. Um pedido inválido não conforma, nem na rota nem no desfecho.
- **Os campos:** relato quantas vezes batem com os do [rotulador] o sistema (normalizado pelo `normalise_system`) e o código. Relato também os pedidos com um código que não está no texto da pergunta.
- **A latência** de cada chamada ao modelo: o p50 e o p95, pelo posto mais próximo, e o máximo. Nenhuma chamada se descarta, e a primeira inclui a carga do modelo.

**Caminho C de ponta a ponta: os 33 casos da G.** As entradas são as da linha de base: as frases à letra dos 33 casos que a G pontuou validamente. Vêm do `scripts/benchmark_3level_terminology.py`; são os 36 menos os 3 pontuados pelo comprimento, como no §1. O modelo sozinho acertou 8. Cada caso passa por quatro passos:
1. **O pedido:** o modelo declara o pedido com o texto fixo 1.
2. **A rota:** o `Router` decide com a loja do §1, que tem o LOINC da Athena, o SNOMED CT do Vocab2 e o ICD-10-CM do ficheiro da CMS.
3. **A escolha:** quando a rota é a R3, o modelo escolhe com o texto fixo 2 (`CHOICE_PROMPT`).
   - Recebe a frase e a lista dos candidatos da base: o sistema, o código e o nome, com uma marca quando o candidato não é padrão.
   - Responde um código, ou nulo.
   - O esquema prende só a forma (`{"code": texto ou nulo}`), para que uma resposta fora da lista se veja.
4. **A revalidação pela base:** a escolha só vale se for um dos candidatos e se a loja a confirmar como activa (`get`). Uma resposta fora da lista é recusada e conta à parte.

**A resposta do sistema:**
- quando o caminho A resolve (R0, R1 ou R2→R1), é o código do caminho A;
- na R3, é a escolha revalidada;
- no resto, não há resposta.

**A pontuação é a da A2 no §1,** a regra da G com o código exacto:
- se a resposta esperada é um código, acerto é esse código e erro é outro; os casos sem resposta contam à parte;
- se a esperada é «no», recusa certa é não haver resposta, e erro é qualquer código;
- o HARD-CROSS-01, que espera «reasoning», segue o §1.1: sem resposta conta como sem resposta, e um código como erro.
- Relato também os casos em que a regra da G à letra (o código esperado aparece na resposta) daria outro veredicto.

**Em que passo nasce cada falha.** O pedido de referência é o da A2 no §1. A mesma corrida recalcula-o e confere-o com o ficheiro do §1.2.
- **No pedido**, quando:
  - o modelo declarou out_of_scope;
  - ou o JSON não se leu;
  - ou a tarefa ou o sistema normalizado diferem dos da referência;
  - ou o pedido de referência acerta e o do modelo não.
- **Na escolha**, quando a rota é a R3, havia uma escolha certa e o modelo não a fez. Havia escolha certa quando o código esperado estava entre os candidatos, ou quando a esperada era «no» ou «reasoning» e o certo era nulo.
- **Na rota**, no resto: o pedido bate com a referência, a referência também falha e, se a rota é a R3, o código esperado não estava entre os candidatos.

**O que relato:**
- os acertos, os erros e os sem resposta, caso a caso, ao lado do modelo sozinho (8 de 33) e da A2 (13 de 33);
- o passo em que nasce cada falha;
- na R3, o n, as escolhas certas, as erradas, as nulas e as que ficam fora da lista;
- os pedidos com um código que não está na frase;
- a latência das chamadas ao modelo.

**Os 17 da M ficam de fora.** As entradas da M são termos, e não frases, e a linha de base em frase é a G.

**Os limites a declarar.**
- Há um só modelo local pequeno, um só texto fixo por passo, sem afinação, e uma só corrida.
- O n é pequeno, e é ainda mais pequeno nos casos que chegam à R3.
- As perguntas do [rotulador] foram escritas e rotuladas por um só rotulador de IA.
- As lojas são o índice da medição, e não a loja do serviço.
- O ficheiro de resultados guarda os códigos, os pedidos e as respostas do modelo, mas não os nomes do SNOMED CT nem do LOINC.

**Onde fica.**
- O guião é o `scripts/benchmark_routing_arm2_path_c.py`.
- O teste é o `scripts/test_benchmark_routing_arm2_path_c.py`, escrito e corrido antes do guião, com um cliente falso e sem rede.
- O resultado será o `results/llm_benchmarks/benchmark_routing_arm2_path_c_<data>.json`.
