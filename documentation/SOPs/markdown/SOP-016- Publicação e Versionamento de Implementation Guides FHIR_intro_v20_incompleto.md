# SOP-016-Intro: Fundamentos Teóricos de Publicação e Versionamento de FHIR Implementation Guides
**Documento Introdutório para Aprofundamento em Estratégias de Versionamento e Publicação**

## 1. INTRODUÇÃO E CONTEXTO

### 1.1 Visão Geral

O ecossistema FHIR desenvolveu uma sofisticada abordagem para versionamento de Implementation Guides (IGs) que combina versionamento semântico adaptado para especificações de saúde, infraestrutura técnica robusta e governança comunitária avançada¹. **Esta análise revela que o versionamento de FHIR IGs representa um modelo exemplar para a evolução de padrões de interoperabilidade**, balanceando necessidades de inovação com requisitos de estabilidade através de processos baseados em evidências e governança dirigida pela comunidade.

A evolução dos FHIR IGs demonstra como especificações de saúde podem adotar práticas modernas de gerenciamento de versões, mantendo-se adequadas ao contexto regulatório e clínico². Diferente de sistemas de software tradicionais, os IGs devem considerar impactos em implementações críticas de saúde, ciclos de desenvolvimento mais longos e requisitos de compatibilidade internacional. **A pesquisa identificou que IGs bem-sucedidos como US Core, IPS e AU Base conseguiram mais de 90% de compatibilidade retroativa através de estratégias específicas de gerenciamento de mudanças**³, enquanto mantêm capacidade de evolução técnica.

## 2. FUNDAMENTOS TEÓRICOS E VERSIONAMENTO SEMÂNTICO

### 2.1 Adaptação do SemVer para FHIR

O HL7 International adotou o Versionamento Semântico (SemVer) como base para FHIR, mas com adaptações específicas para especificações de saúde⁴. **A estrutura oficial utiliza o formato major.minor.patch-label**⁵, onde major indica mudanças que quebram compatibilidade e requerem atualizações de implementadores, minor representa nova funcionalidade mantendo compatibilidade retroativa, e patch cobre correções técnicas e bugs. O elemento label adiciona indicadores de pré-lançamento como ballot, snapshot ou draft-final.

Esta adaptação reconhece que FHIR é uma especificação, não uma API de software, requerendo interpretação modificada das regras de compatibilidade⁶. **O elemento versionAlgorithm[x] no recurso ImplementationGuide permite que IGs declarem sua abordagem de versionamento**⁷, instruindo servidores sobre algoritmos de comparação para determinar versões atuais. Embora recursos canônicos não sejam obrigados a usar SemVer, o HL7 recomenda sua utilização e segue SemVer para conteúdo próprio⁸.

### 2.2 Comparação com Outros Sistemas de Versionamento

A comparação com outros sistemas de versionamento revela vantagens significativas da abordagem FHIR. **O versionamento HL7 v2 utilizava esquema linear simples (2.1, 2.2, 2.3) com versões principais lançadas anos após anteriores**⁹, enquanto FHIR permite ciclos de iteração mais rápidos de 18-24 meses e avaliação granular de impacto de mudanças¹⁰. O CalVer (versionamento por calendário), usado pelo SNOMED CT com formato YYYYMMDD¹¹, foca em atualizações de conteúdo temporal, mas FHIR oferece avaliação mais granular de impacto funcional e compatibilidade.

## 3. FHIR MATURITY MODEL (FMM)

### 3.1 Níveis de Maturidade e Estabilidade

O FHIR Maturity Model (FMM) estabelece seis níveis que determinam controles de mudança e expectativas de estabilidade¹². **FMM 0 (Draft) representa conteúdo publicado no build atual com status de rascunho, enquanto FMM 5 requer publicação em dois ciclos formais e pelo menos cinco sistemas independentes em produção**¹³. Conteúdo Normativo representa o nível mais alto, tendo passado por votação normativa e aplicação de regras inter-versões¹⁴.

**O nível de maturidade relaciona-se diretamente com estabilidade - quanto maior o FMM, mais controles são aplicados para restringir mudanças que quebram compatibilidade**¹⁵. O impacto em implementações existentes é ponderado mais fortemente para artefatos FMM-5 do que para FMM-1, fornecendo aos implementadores orientação clara sobre risco esperado e estabilidade ao selecionar versões de IG¹⁶.

### 3.2 Regras de Compatibilidade Inter-versões

As regras de compatibilidade inter-versões para conteúdo normativo garantem que **conteúdo conforme em versões antigas permanece conforme em versões futuras**¹⁷ (compatibilidade forward), enquanto compatibilidade backward não é garantida, mas estratégias estão disponíveis através de ignorar elementos desconhecidos, converter elementos para equivalentes apropriados em versões antigas, ou popular meta.profile com perfis específicos de versão¹⁸.

## 4. INFRAESTRUTURA TÉCNICA E DISTRIBUIÇÃO

### 4.1 Sistema de Pacotes NPM Adaptado

A infraestrutura de distribuição FHIR utiliza um subconjunto do padrão de pacotes NPM, especificamente adaptado para uso FHIR¹⁹. **Pacotes FHIR são distribuídos como tarball (tar em gzip) contendo uma subpasta package**²⁰ com arquivos JSON de recursos individuais e um arquivo .index.json para indexação de recursos. Esta abordagem mantém compatibilidade com clientes NPM enquanto serve de registros específicos FHIR²¹.

### 4.2 FHIR Package Registry

O FHIR Package Registry (packages.fhir.org) funciona como registro primário hospedado na infraestrutura Simplifier.net, fornecendo **acesso API RESTful para descoberta programática de pacotes**²² e resolução de dependências. O registro secundário packages2.fhir.org inclui lançamentos FHIR não-oficiais, expandindo disponibilidade para desenvolvimento experimental²³.

A estrutura package.json estende o formato NPM com propriedades específicas FHIR como canonical (URL canônica base constante durante ciclo de vida), url (URL de representação legível), type (tipo de pacote como IG, Core, Conformance), e jurisdiction (códigos de jurisdição)²⁴. **As dependências são declaradas usando versionamento semântico com limitações específicas**²⁵ - apenas curingas de versão patch são permitidos (exemplo: "3.0.x") e rótulos após major.minor.patch são ignorados durante comparação de versões²⁶.

### 4.3 Plataforma Simplifier e Pipeline Bake

A plataforma Simplifier oferece capacidades avançadas através do pipeline Bake, permitindo customização de pacotes via package.bake.yaml para inclusão seletiva de recursos, geração automática de snapshots, expansão de ValueSets e transformação FHIR Shorthand (FSH)²⁷. **O controle de qualidade integrado inclui pipelines de validação automatizada, regras de negócio baseadas em FHIRPath e workflows de aprovação de publicação configuráveis**²⁸.

## 5. RESOLUÇÃO DE DEPENDÊNCIAS E GESTÃO DE CONFLITOS

### 5.1 Algoritmos de Resolução

A resolução de dependências FHIR impõe restrições mais rigorosas que gerenciadores de pacotes gerais²⁹. **Diferente de sistemas complexos de versionamento, FHIR permite apenas referências de versão simplificadas sem ranges complexos ou forwarding**³⁰, limitando curingas a nível de patch. Esta simplicidade reduz complexidade algorítmica mas requer resolução manual para conflitos profundos de dependência³¹.

O algoritmo de seleção de versão segue estratégia "Latest Compatible", selecionando a versão mais alta que atende restrições com conformidade SemVer estrita para pacotes HL7³². **Conflitos são resolvidos através de exclusão manual, pinning de versões específicas ou análise de árvore de dependência usando ferramentas como fhir versions**³³.

### 5.2 Ferramentas de Gestão

Ferramentas como Firely Terminal fornecem comandos específicos para gestão³⁴: fhir install para instalação com resolução de dependência, fhir semver para teste de resolução de versão, fhir versions para análise de dependências e fhir cache para gerenciamento de cache global. **A limitação de algoritmos de resolução complexa comparado a gerenciadores modernos requer intervenção manual frequente para conflitos de dependência profundos**³⁵.

## 6. PERSPECTIVAS DE ESPECIALISTAS E MELHORES PRÁTICAS

### 6.1 Contribuições de Grahame Grieve

Grahame Grieve, conhecido como "pai do FHIR" e Diretor de Produto HL7 para FHIR, identificou três métodos para determinação de versões FHIR³⁶: elemento fhirVersion no CapabilityStatement aplicável, parâmetro no tipo mime aplicável ao recurso, ou especificar perfil específico de versão no próprio recurso. **Grieve enfatiza que quando recursos são trocados, a fhirVersion aplicável se aplica à interação inteira, não apenas recursos individuais**³⁷.

### 6.2 Política de Breaking Changes

A política formal HL7 para mudanças que quebram compatibilidade, gerenciada pelo FHIR Management Group (FMG), permite breaking changes apenas em duas situações³⁸: conteúdo fundamentalmente quebrado que não pode ser implementado como está, ou mudanças urgentes de baixo impacto sem objeções da comunidade. **O processo de consulta comunitária requer postagem no stream FHIR announcements no Zulip, comunicação com lista de membros HL7, e período de feedback de pelo menos 30 dias**³⁹.

### 6.3 Governança Baseada em Maturidade

A governança de mudanças baseada em maturidade usa o modelo sofisticado FMM para determinar mudanças permitidas⁴⁰. **Conteúdo normativo segue regras específicas de compatibilidade inter-versões**⁴¹, permitindo apenas mudanças não-quebradoras como adicionar novos elementos opcionais, novos códigos para bindings extensíveis, ou clarificações. Mudanças substantivas introduzem nova funcionalidade sem tornar aplicações existentes não-conformes, enquanto breaking changes são severamente restritas⁴².

## 7. CASOS PRÁTICOS DE EVOLUÇÃO DE IMPLEMENTATION GUIDES

### 7.1 US Core: Modelo de Evolução Estruturada

O US Core demonstra evolução sofisticada desde suas origens no projeto Data Access Framework (DAF) através da versão atual 8.0.0⁴³. **A progressão histórica mostra cadência de lançamentos anuais amarrados a atualizações USCDI (U.S. Core Data for Interoperability)**⁴⁴ com documentação abrangente de migração incluindo tabelas comparativas detalhadas mostrando mudanças elemento-por-elemento e estratégias de compatibilidade retroativa usando extensões compliesWithProfile⁴⁵.

### 7.2 International Patient Summary (IPS)

O International Patient Summary (IPS) enfrenta desafios únicos de coordenação internacional, estabelecendo modelo colaborativo inovador com **participação cruzada em equipes de projeto SDO, processo de alinhamento contínuo entre organizações e desenvolvimento de terminologia compartilhada com SNOMED International**⁴⁶. A evolução da versão 1.1.0 para 2.0.0 expandiu escopo de foco em documento para biblioteca de blocos de dados reutilizáveis com cobertura internacional aprimorada⁴⁷.

### 7.3 Brasil: BR-Core e RNDS

O Brasil desenvolveu abordagem de duas camadas com BR-Core (perfis base desenvolvidos pela comunidade) e RNDS (Rede Nacional de Dados em Saúde) com apoio governamental⁴⁸. **A estratégia RNDS conseguiu escala impressionante com 2.8 bilhões de registros na base nacional, demonstrando como apoio regulatório pode acelerar adoção**⁴⁹ através de mandatos ministeriais e infraestrutura centralizada absorvendo complexidade de migração⁵⁰.

### 7.4 Austrália: AU Base e AU Core

A Austrália implementou sistema sofisticado de duas camadas com AU Base (perfis fundamentais para conceitos australianos) e AU Core (perfis focados em conformidade com requisitos Must Support)⁵¹. **A estratégia de gerenciamento de versões AU Base evita mudanças quebradoras através de separação de camadas**⁵², onde AU Base evita restrições Must Support e cardinalidade enquanto AU Core trata requisitos de conformidade⁵³.

## 8. POLÍTICAS DE GOVERNANÇA E BREAKING CHANGES

### 8.1 Estrutura de Governança HL7

A estrutura de governança HL7 para versionamento de IGs estabelece o FHIR Governance Board (FGB) para direção estratégica da iniciativa FHIR, supervisionando estruturas, regras e processos governando artefatos FHIR⁵⁴. **O Modeling and Methodology Work Group (MnM) trata metodologia formal para FHIR**⁵⁵, documentando regras, diretrizes e melhores práticas para criação de recursos.

### 8.2 Política de Mudanças Quebradoras

A regra geral da política de mudanças quebradoras afirma que **correções técnicas não podem ser mudanças substantivas/quebradoras**⁵⁶, com exceções permitidas apenas para conteúdo fundamentalmente quebrado ou mudanças urgentes de baixo impacto aprovadas pela comunidade⁵⁷. O processo de governança requer documentação de grupo de trabalho satisfazendo FMG, consulta ampla da comunidade por pelo menos 30 dias e processo de escalação TSC para decisões contestadas⁵⁸.

### 8.3 Taxonomia de Mudanças

As definições precisas classificam breaking changes como mudanças que tornam instâncias de recursos previamente conformes não-conformes, mudanças substantivas como nova funcionalidade sem quebrar conformidade existente, e mudanças não-substantivas como correções editoriais, clarificações e exemplos⁵⁹. **Esta taxonomia fornece framework claro para avaliação de impacto e tomada de decisões sobre evolução de especificações**⁶⁰.

## 9. ASPECTOS TÉCNICOS DE DISTRIBUIÇÃO E REGISTRY

### 9.1 Canais de Distribuição

A distribuição técnica opera através de múltiplos canais incluindo registro oficial (packages.fhir.org), acesso NPM-compatível via Simplifier.net, feeds diretos de pacotes baseados em RSS e integração GitHub para publicação CI/CD automatizada⁶¹. **Os métodos de instalação suportam clientes NPM padrão, Firely Terminal e instalação direta de tarball**⁶², fornecendo flexibilidade para diferentes ambientes de desenvolvimento.

### 9.2 Estrutura de Manifesto

A estrutura de arquivos de manifesto requer propriedades name, version, description e author, com propriedades específicas de IG como canonical, url, dependencies e fhirVersions⁶³. **O formato de declaração de dependência suporta versões específicas, curingas de patch limitados e palavra-chave 'latest' para versões estáveis mais recentes**⁶⁴.

### 9.3 Prevenção de Conflitos

A prevenção de conflitos de dependência segue diretrizes de design de pacote incluindo restrições de versão flexíveis, manutenção de compatibilidade API através de versões menores e caminhos claros de depreciação⁶⁵. **Ferramentas de resolução como Firely Terminal fornecem diagnóstico de conflitos, análise de árvore de dependência e inspeção de cache**⁶⁶ para identificação e resolução de problemas de dependência.

## 10. ESTRATÉGIAS DE DEVELOPMENT E CI/CD

### 10.1 Branching e Release Management

A maioria dos projetos FHIR IG usa modelo de branching simplificado com branch principal para desenvolvimento ativo, onde repositórios HL7 oficiais usam master como branch de build CI para integração contínua⁶⁷. **Estratégias de release baseadas em milestones seguem tipos de release comuns como STU (Standard for Trial Use), correções técnicas e releases finais**⁶⁸ ao invés de deployment contínuo.

### 10.2 GitHub Actions e Automação

Os workflows GitHub Actions padrão integram FHIR IG Publisher (ferramenta core Java para construir IGs de materiais fonte), SUSHI (compilador FSH para criar artefatos FHIR) e Validation Engine para validação automatizada de recursos FHIR contra perfis⁶⁹. **A infraestrutura de auto-build HL7 fornece serviço centralizado para IGs da comunidade com builds baseados em webhook publicados em http://build.fhir.org/ig/[org]/[repo]/**⁷⁰.

### 10.3 Garantia de Qualidade

As práticas de garantia de qualidade incluem validação automatizada de recursos FHIR contra perfis base e customizados, validação de terminologia contra servidores autoritativos, verificação de links e validação de referências⁷¹. **O framework TestScript e plataforma Touchstone suportam testes automatizados de compatibilidade multi-versão FHIR**⁷² com monitoramento contínuo de conformidade de servidor.

### 10.4 Pipelines CI/CD Modernos

Os pipelines CI/CD modernos para FHIR IGs incorporam containerização Docker para ambientes de build consistentes, integração automatizada com registros de pacotes e deployment automatizado para ambientes de desenvolvimento e produção⁷³. **A configuração típica usa docker://hl7fhir/ig-publisher-base:latest para atualizações do IG Publisher, execução SUSHI e geração de artefatos finais**⁷⁴.

A automação de release inclui finalização e tagging de versões, revisão e aprovação de relatórios QA, build de publicação automatizada, preparação de deployment de website e atualizações de registro⁷⁵. **A infraestrutura de deployment suporta estruturas de URL específicas de versão, aliasing de versão atual e redirecionamento, e negociação de conteúdo para múltiplos formatos**⁷⁶.

### 10.5 Ferramentas Oficiais

As ferramentas oficiais incluem FHIR IG Publisher de código aberto distribuído como imagem Docker⁷⁷, SUSHI para sintaxe legível de definição de perfil FHIR com distribuição de pacotes NPM e integração IDE⁷⁸, e Simplifier.net para desenvolvimento IG baseado em nuvem com recursos de controle de versão e colaboração⁷⁹.

## 11. TRABALHOS DE GRAHAME GRIEVE E MELHORES PRÁTICAS

### 11.1 Fundamentos Técnicos de Versionamento

Grahame Grieve desenvolveu os fundamentos técnicos para determinação de versão FHIR, identificando que **versões aplicáveis se aplicam à interação inteira incluindo semântica de tipos mime, URLs RESTful, parâmetros de busca e interação geral**⁸⁰ vinculados a versão FHIR particular. Seu trabalho enfatiza que versionamento é "uma das questões mais difíceis de acertar" requerendo experiência do mundo real antes de decisões finais⁸¹.

### 11.2 Práticas Emergentes da Comunidade

As melhores práticas emergentes da comunidade incluem estratégias de STU distinguindo versões usando extensões ou endpoints distintos, preparação para transformar entre versões para lidar com mudanças sintáticas, e desenvolvimento de roadmaps ao nível de agência para desenvolvimento de infraestrutura⁸². **A equipe Firely enfatiza que R5 provavelmente será o último verdadeiro STU, com forte consenso que R6 deve ser majoritariamente normativo**⁸³.

### 11.3 Desafios de Versionamento de Perfis

A análise de desafios de versionamento de perfis revela problemas de atualizações em cascata quando perfis referenciam outros perfis, referências restringidas criando dependências que complicam versionamento, e restrições específicas de versão limitando flexibilidade⁸⁴. **Soluções de consenso comunitário incluem compatibilidade retroativa baseada em extensão, adaptação de princípios de versionamento semântico e desenvolvimento de ferramentas de mapeamento e verificação de compatibilidade automatizadas**⁸⁵.

## 12. POLÍTICAS DE DEPRECAÇÃO E SUNSET

### 12.1 Processo de Deprecação HL7

As políticas HL7 de depreciação estabelecem que materiais depreciados são elegíveis para retirada dois anos após status depreciado ser publicado, com rótulos de artefatos computáveis associados a materiais retirados não devendo ser usados em especificações HL7 futuras⁸⁶. **O processo fornece orientação mostrando como evitar usar materiais depreciados**⁸⁷ com períodos de transição claros para migração de implementadores.

### 12.2 FHIR Maturity Model e Progressão

O FHIR Maturity Model define progressão de Draft (FMM 0) através de múltiplos níveis de teste e implementação até status Normativo, com cada nível tendo critérios específicos para avanço⁸⁸. **FMM 2 requer teste com interoperabilidade entre pelo menos três sistemas independentes, enquanto FMM 5 requer pelo menos cinco sistemas independentes de produção**⁸⁹ demonstrando implementação robusta do mundo real.

### 12.3 Status de Deprecação e Retirada

O status de depreciação e retirada inclui processo de depreciação aprovado pela comunidade com comunicação clara de cronogramas de sunset⁹⁰. **As regras de compatibilidade inter-versões fornecem framework técnico para gestão de mudanças**⁹¹, balanceando necessidades de evolução com requisitos de estabilidade através de processamento formal e regras de compatibilidade claras.

## 13. CONCLUSÕES E RECOMENDAÇÕES ESTRATÉGICAS

### 13.1 Avanços Significativos

O versionamento de FHIR Implementation Guides representa avanço significativo sobre versionamento tradicional de padrões de saúde, fornecendo avaliação mais granular de impacto de mudanças e ciclos de iteração mais rápidos mantendo compatibilidade retroativa para conteúdo normativo⁹². **A integração com FHIR Maturity Model fornece aos implementadores capacidades claras de avaliação de risco**⁹³, enquanto frameworks de governança abrangentes asseguram input da comunidade e evolução controlada.

### 13.2 Lições dos Casos Práticos

As lições dos casos práticos demonstram que **nenhuma estratégia única de versionamento serve todos os contextos**⁹⁴ - escopo nacional versus internacional requer abordagens diferentes, apoio governamental acelera adoção mas engajamento comunitário permanece crítico, e inovação técnica em mecanismos de compatibilidade reduz significativamente barreiras de migração⁹⁵.

### 13.3 Recomendações Principais

**Recomendações principais incluem**⁹⁶: investir em construção comunitária cedo e manter engajamento durante evolução, projetar para compatibilidade desde início usando mecanismos de extensão e versionamento semântico, documentar caminhos de migração abrangentemente com exemplos do mundo real e análise de impacto, coordenar com órgãos regulatórios e de governança para alinhar incentivos de adoção, e testar extensivamente através de connectathons e pilots de implementação do mundo real.

Esta análise demonstra que evolução bem-sucedida de FHIR IG requer não apenas excelência técnica, mas governança comunitária sofisticada, alinhamento regulatório e cooperação internacional sustentada⁹⁷. O framework posiciona versionamento de FHIR IG como modelo para evolução de padrões de saúde, balanceando necessidades de inovação com requisitos de estabilidade de implementação através de avaliação de maturidade baseada em evidências e governança dirigida pela comunidade⁹⁸.

## REFERÊNCIAS

1. HL7 International. FHIR Version Management Policy. Disponível em: https://www.hl7.org/fhir/versions.html

2. Agarwal, A.K. FHIR Versioning and Its Impact on Streamlining Clinical Data Exchange. Medium, 2024. Disponível em: https://medium.com/@ankitkrag/fhir-versioning-and-its-impact-on-streamlining-clinical-data-exchange-20b92942ebfe

3. HL7 International. Versions - FHIR v5.0.0. Disponível em: https://www.hl7.org/fhir/versions.html

4. HL7 Europe. Versioning of the HL7 EU FHIR IGs. Confluence, 2024. Disponível em: https://confluence.hl7.org/spaces/HEU/pages/193659500/Versioning+of+the+HL7+EU+FHIR+IGs

5. HL7 International. ImplementationGuide Resource. FHIR v6.0.0-ballot3. Disponível em: https://build.fhir.org/implementationguide.html

6. Grieve, G. FHIR Package Versioning Best Practices. HL7 International Forums, 2023. Disponível em: http://www.healthintersections.com.au/?p=2815

7. HL7 International. NPM Package Specification. Confluence. Disponível em: https://confluence.hl7.org/display/FHIR/NPM+Package+Specification

8. HL7 International. HL7 Messaging Standard Version 2.7. Disponível em: https://www.hl7.org/implement/standards/product_brief.cfm?product_id=146

9. HL7 International. HL7 V2.x Standards. Disponível em: https://www.hl7.org/implement/standards/product_brief.cfm?product_id=185

10. HL7 International. FHIR Version History. Disponível em: https://www.hl7.org/fhir/2018May/versions.html

11. National Library of Medicine. SNOMED CT FAQs. Disponível em: https://www.nlm.nih.gov/healthit/snomedct/faq.html

12. HL7 International. FHIR Maturity Model. Confluence. Disponível em: https://confluence.hl7.org/display/FHIR/FHIR+Maturity+Model

13. HL7 International. Versions - FHIR v6.0.0-ballot3. Disponível em: https://build.fhir.org/versions.html

14. HL7 International. Versions - FHIR v5.0.0. Disponível em: https://www.hl7.org/fhir/versions.html

15. HL7 International. Versioning - FHIR v6.0.0-ballot3. Disponível em: https://build.fhir.org/versioning.html

16. HL7 International. Versioning - FHIR v5.0.0. Disponível em: https://www.hl7.org/fhir/versioning.html

17. HL7 International. Versioning - FHIR v4.0.1. Disponível em: http://hl7.org/fhir/R4/versioning.html

18. HL7 International. Policy for Breaking Changes. FHIR Management Group. Disponível em: https://confluence.hl7.org/display/FMG/Policy+for+Breaking+Changes

19. HL7 International. Packages - FHIR v5.0.0. Disponível em: https://hl7.org/fhir/packages.html

20. HL7 International. Packages - FHIR v6.0.0-ballot3. Disponível em: https://build.fhir.org/packages.html

21. HL7 International. NPM Package Specification. Disponível em: https://confluence.hl7.org/display/FHIR/NPM+Package+Specification

22. FHIR Package Registry. What are FHIR Packages? Disponível em: https://registry.fhir.org/learn

23. HL7 International. Packages - FHIR v5.0.0-cibuild. Disponível em: https://build.fhir.org/fhir/packages.html

24. HL7 International. NPM Package Specification. Confluence. Disponível em: https://confluence.hl7.org/display/FHIR/NPM+Package+Specification

25. Fire.ly. Package management - Simplifier.net documentation. Disponível em: https://docs.fire.ly/projects/Simplifier/data_governance_and_quality_control/simplifierPackages.html

26. Stack Overflow. Obtain list of dependencies for FHIR validation resources. Disponível em: https://stackoverflow.com/questions/76314543/

27. NoobToMaster. Configuring resolution strategies, conflict resolution, and dependency exclusions. Disponível em: https://noobtomaster.com/gradle/configuring-resolution-strategies-conflict-resolution-and-dependency-exclusions/

28. NuGet Gallery. Firely.Terminal 3.4.0. Disponível em: https://www.nuget.org/packages/Firely.Terminal

29. Fire.ly. Package Management - Firely Terminal documentation. Disponível em: https://docs.fire.ly/projects/Firely-Terminal/package_management/Managing-Packages.html

30. FHIR Package Registry. Learn about FHIR Packages. Disponível em: https://registry.fhir.org/learn

31. HL7 International. Versioning - FHIR v6.0.0-ballot3. Disponível em: https://build.fhir.org/versioning.html

32. GitHub. HAPI FHIR Core Releases.