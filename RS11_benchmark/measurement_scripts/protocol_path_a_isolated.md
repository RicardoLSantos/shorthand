[…]

## §1 · O caminho A sozinho: o protocolo, escrito antes de correr […]

A ordem: as ordens do [coordenador] de 19 Nov (ponto 1), pelas decisões do [primeiro autor] […] e pelo plano […]. Este texto fica fixo antes de haver resultados. O guião e o teste escrevem-se depois deste commit, e o protocolo entra no suplemento.

**O que se mede.** É o caminho A tal como o serviço o define. Entram as regras R0 (conferir um código que o chamador já tem) e R1 (um só candidato exacto), e a R2 quando a expansão de sinónimos do próprio serviço dá um só exacto. A chamada é a `Router.route` do serviço tal como está no `5b313864f` (`services/terminology-router`, sem alterações), sem modelo e sem rede. Conta como resposta do caminho A uma decisão com `path = A` e `outcome = resolved`. Qualquer outra decisão conta como «sem resposta do caminho A»: a R2 e a R3 passam ao C, a R4 e a R5 ao B, e a R6, a R7 e a R-pre também contam assim.

**A loja.** É uma loja nova, só do guião; o serviço não muda. Usa um índice SQLite em memória, feito uma vez no início, que cumpre o contrato do `LookupStore` (`stores.py` l.56–67, `5b313864f`):
- `get` procura por vocabulário e código;
- `search` devolve primeiro os exactos (o nome em minúsculas igual ao texto) e depois os parciais (o texto dentro do nome);
- as regras de activo (`invalid_reason` vazio) e de padrão (`standard_concept = S`) são as do `AthenaCsvStore` (l.336–386).

Ficam declaradas duas diferenças face ao `AthenaCsvStore`:
- Os exactos vêm todos do índice. A loja do CSV pára aos 40 achados, pela ordem do ficheiro, e pode não ver um exacto que venha depois.
- Os vocabulários declaram-se pelo índice inteiro. A loja do CSV só olha as primeiras 200 000 linhas.

O índice tem só os três vocabulários medidos.

**As fontes** (o ficheiro de resultados guarda o sha256 de cada uma):
- **LOINC:** `etl/data/athena/CONCEPT.csv` (48 366 807 bytes), as linhas com `vocabulary_id = LOINC`.
- **SNOMED CT:** o Vocab2 (`knowledge_base/Vocabulario/[…]/CONCEPT.csv`, 251 436 694 bytes), as linhas `SNOMED`.
- **ICD-10-CM:** as tabelas da CMS do FY2026 (`data/icd10cm_fy2026/code_tables/Table and Index/icd10cm_tabular_2026.xml`, fora do git). Entram todos os `diag` (categorias, subcategorias e códigos), todos activos e padrão.
- **RxNorm fica de fora**, porque não está em disco. Uma chamada de controlo confirma que o serviço responde `store-lacks-vocabulary` (INV-4); essa chamada não entra nas medidas.

**Os casos.** São cinco conjuntos, e a semente é 20261119.

1. **A1, os casos do benchmark que foram pelo caminho da base:** os 17 `confident_direct` da M (`results/llm_benchmarks/benchmark_3phase_rag_20260324_114358.json`, fase 4). Contêm os 8 da J (`benchmark_3phase_rag_20260320_130612.json`). Na M, 15 dos 17 estavam certos.
2. **A2, a linha de base sem recuperação:** os 33 casos validamente pontuados da G.
   - A fonte é `results/llm_benchmarks/benchmark_3level_qwen3_5_4b_all_20260319_193030.json`: 36 casos e 11 certos tal como correu. Sem os 3 pontuados pelo comprimento da resposta (HARD-REASON-01, HARD-REASON-02 e HARD-MULTI-01) ficam 33, com 8 certos. Conferi isto na fonte antes deste commit; são os «8 de 33» […].
   - A G fazia as perguntas em frase, mas o caminho A recebe o termo. O termo é o do mesmo caso no conjunto de 42 do `scripts/benchmark_3phase_rag.py` (l.345–407, `503b32644`), escrito em Março e não por mim.
   - A correspondência faz-se pelo tema, pelo tipo e pela resposta esperada. Há duas trocas de nome: HARD-CROSS-01 ↔ H-CROSS-02 e HARD-CROSS-02 ↔ H-CROSS-01.
   - A resposta esperada é a da G. Num caso difere da do conjunto de 42: E66.01 na G e E66.0 no de 42.
3. **A3, códigos reais.** Por vocabulário, tiro ao acaso 1 000 conceitos activos, sem reposição, de todos os activos do índice. Ordeno-os por código antes de tirar, para que a amostra não dependa da ordem do ficheiro. Cada um vai pelo código (R0, sem nome afirmado); os primeiros 200 da amostra vão também pelo nome oficial (R1).
4. **A4, códigos inventados.** Por vocabulário, 200 códigos com o formato certo que não estão no índice, e todos vão pelo código (R0):
   - LOINC: quatro ou cinco algarismos e o dígito de controlo mod 10 certo;
   - SNOMED CT: um identificador de conceito (partição 00) com o dígito de Verhoeff certo;
   - ICD-10-CM: uma letra, dois algarismos, um ponto e dois algarismos.
5. **A5, os termos em que a consulta sozinha deve falhar.** Não é um conjunto novo: são os casos de A1 e A2 cujo termo não é o nome de nenhum conceito activo do vocabulário. A regra decide-se no índice antes de chamar o `Router`, e a lista sai no ficheiro de resultados.

**Como cada caso de A1 e A2 vira pedido.** O pedido leva só o que um chamador teria:
- por regra, `task = retrieve`, `system_hint` igual ao vocabulário do caso e `query` igual ao termo;
- o caso do tipo `trap` (80405-4) vai como `task = verify`, com o código e o nome afirmado («heart rate variability»);
- os casos `cross_mapping` vão como `task = map` (R5, caminho B);
- os vocabulários que o serviço não conhece (ICD-11, ICD-10-PCS) vão como estão e dão R-pre.

**O que conta como acerto:**
- **A3 pelo código:** acerto é uma resposta do caminho A com o mesmo código e com o nome igual ao da fonte. Prova o índice e o caminho, não o conhecimento. Espera-se 100 %, e qualquer falha é um defeito a relatar.
- **A3 pelo nome:** se o nome pertence a um só conceito activo do vocabulário, acerto é uma resposta do caminho A com esse código. Se pertence a mais de um, o nome é ambíguo e o acerto é não haver resposta do caminho A (R3, que passa ao C).
- **A4:** acerto, ou recusa certa, é a R0 recusar por `code-not-found`; qualquer resposta é um erro.
- **A1 e A2:**
  - se a resposta esperada é um código, acerto é uma resposta do caminho A com esse código, e erro é uma resposta com outro código; os casos sem resposta contam à parte;
  - se a resposta esperada é «no» (lacuna ou armadilha), acerto, ou recusa certa, é não haver resposta do caminho A, e erro é qualquer código.

**As medidas.** Para cada conjunto, vocabulário e forma (código ou nome):
- o n;
- os acertos, com as recusas certas à parte;
- os erros;
- os sem resposta, com a regra a que cada um foi;
- a exactidão, igual a acertos sobre n;
- a latência de cada chamada a `Router.route`, por `time.perf_counter_ns`. Só se cronometra a chamada: o pedido é feito antes, e o índice e o `Router` ficam fora.

Da latência relato o p50 e o p95, pelo método do posto mais próximo, e o máximo. Nenhuma chamada se descarta. O tempo de indexação mede-se à parte, por fonte (leitura, inserção e índices).

Faço uma só corrida, sequencial, no M1: Apple M1, 16 GB, macOS 26.6.2, Python 3.14.7, SQLite 3.53.4. O ficheiro de resultados guarda os códigos e as decisões caso a caso, mas não os nomes do SNOMED CT nem do LOINC.

**Sem rede e sem modelo.** O guião não importa nenhum módulo de rede, e o `Router` não chama nenhum modelo: a R3 e a R6 entregam ao chamador.

**Onde fica.** O guião é `scripts/benchmark_path_a_isolated.py`. O teste é `scripts/test_benchmark_path_a_isolated.py`, escrito e corrido antes do guião. O resultado é `results/llm_benchmarks/benchmark_path_a_isolated_<data>.json`. A publicação no `RS11_benchmark/` só se faz com o GO do [primeiro autor]; até lá, os dados ficam disponíveis «on request».

**O limite que já se sabe.** O caminho A só responde a um código que existe ou a um nome igual ao oficial; o resto passa ao C ou é recusado. A medição diz quanto disto há nos casos do benchmark, sem mudar o benchmark.

### §1.1 · Antes de correr: o que o guião fixa e o protocolo não dizia, e a árvore do serviço

Escrevi isto depois do teste verde (12 testes, `python3 -I scripts/test_benchmark_path_a_isolated.py`) e antes da corrida.
- **Um caso de A2 tem «reasoning» como resposta esperada** (HARD-CROSS-01, de LOINC para SNOMED CT). Se o caminho A não responder, conta como sem resposta; se responder com um código, conta como erro.
- **As sementes:** há uma por conjunto e vocabulário, «20261119-<vocabulário>-real» e «20261119-<vocabulário>-invented» (`random.Random` com a cadeia). Assim, nenhum conjunto depende da ordem dos outros.
- **A4:** uma recusa por outra razão que não `code-not-found` conta à parte, como «outra recusa», e não como acerto.
- **A3 pelo nome:** o nome é o do índice. É único quando há um só conceito activo com esse nome, em minúsculas, no vocabulário.
- **A3 pelo código:** uma resposta com o código certo e outro nome conta como «erro de nome».
- **O tempo de indexação:** a leitura e a inserção medem-se por fonte. Os três índices fazem-se uma vez para os três vocabulários e dão um só número.
- **Os veredictos de origem ficam ao lado dos novos:** o do benchmark (M) em A1 e o do modelo sozinho (G) em A2.
- **A árvore do serviço:** o `src` e os `tests` do `5b313864f` são os do `HEAD`.
  - O `src` é o mesmo que o [revisor] leu no `62c238430`. Esse commit é de 30 Jul e é antepassado do `5b313864f`; entre os dois só muda o `tests/test_doc_anchors.py`.
  - Os `tests` são os do `216d2bb8a`.
  - Conferi as três coisas com `git diff --quiet` e com `git merge-base --is-ancestor`.

**Como vou relatar, pelas notas do [coordenador] à leitura deste protocolo:**
- **Os números de cabeça são os do A1 e do A2, e a latência.** O A3 e o A4 dão 100 % por construção, porque os códigos vêm do próprio índice ou foram conferidos como ausentes dele. Relato-os como conferência de conformidade e como fonte da latência, não como exactidão.
- **A loja é um índice SQLite em memória, feito para a medição.** Não é a loja CSV do serviço, e tem as duas diferenças declaradas acima. A latência é a da chamada em processo, não a do serviço por HTTP.
- **No A2, o caminho A recebeu o termo,** e não a frase que a G dava ao modelo.
