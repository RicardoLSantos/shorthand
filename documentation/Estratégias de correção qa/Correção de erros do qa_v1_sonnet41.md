# Estratégia de Correção de Erros em Implementation Guides FHIR

## 📋 Visão Geral

Esta estratégia fornece uma abordagem sistemática para corrigir erros em arquivos `.md` e `.fsh` de Implementation Guides FHIR, utilizando comandos bash para macOS e seguindo as especificações do HL7 International¹.

## 🎯 Objetivo

Estabelecer procedimentos automatizados para identificar e corrigir erros comuns reportados no arquivo `qa.html` após execução do `_genonce.sh`, garantindo conformidade com os padrões FHIR R5² e as diretrizes de publicação de IGs³.

## 📊 Análise Inicial e Preparação

### Script de Análise de Erros

Conforme documentado no material de referência⁴, os erros típicos incluem:
- StructureDefinitions com constraints incorretas
- Observations com bindings incompatíveis
- ValueSets/CodeSystems com mapeamentos incorretos
- URLs canônicas inconsistentes

```bash
#!/bin/bash
# analyze_errors.sh - Script para analisar erros do qa.html

# Criar diretório para logs
mkdir -p logs

# Extrair erros do qa.html
echo "🔍 Analisando erros do relatório QA..."
grep -E "(error|warning|information)" output/qa.html | \
  sed 's/<[^>]*>//g' | \
  sort | uniq -c | sort -rn > logs/errors_summary.txt

# Criar script para backup
cat > backup_ig.sh << 'EOF'
#!/bin/bash
timestamp=$(date +%Y%m%d_%H%M%S)
mkdir -p backups
tar -czf backups/ig_backup_${timestamp}.tar.gz input/
echo "✅ Backup criado: backups/ig_backup_${timestamp}.tar.gz"
EOF
chmod +x backup_ig.sh

# Executar backup antes de qualquer modificação
./backup_ig.sh
```

## 🔧 Correção de Erros Comuns em Arquivos FSH

Baseado nas especificações FHIR Shorthand⁵ e nas melhores práticas documentadas⁶:

```bash
#!/bin/bash
# fix_fsh_errors.sh - Corrigir erros comuns em arquivos FSH

echo "🔧 Iniciando correção de arquivos .fsh..."

# 2.1 - Corrigir sistemas de códigos faltantes
find input/fsh -name "*.fsh" -type f -exec sed -i '' \
  -e 's/\* code = #\([^ ]*\)/\* code = https:\/\/2rdoc.pt\/fhir\/CodeSystem\/[system-name]#\1/g' \
  -e 's/\* coding = #/\* coding.system = "http:\/\/loinc.org"\n\* coding.code = #/g' {} \;

# 2.2 - Corrigir cardinalidades obrigatórias
find input/fsh -name "*.fsh" -type f -exec sed -i '' \
  -e 's/\* identifier 0\.\.\*/\* identifier 1..*/' \
  -e 's/\* status 0\.\./\* status 1..1/' \
  -e 's/\* code 0\.\./\* code 1..1/' {} \;

# 2.3 - Adicionar flags Must Support em elementos obrigatórios
cat > add_must_support.awk << 'EOF'
/^\* [a-zA-Z]+ 1\.\./ && !/MS/ {
    sub(/\*/, "* ")
    print $0 " MS"
    next
}
{print}
EOF

find input/fsh/profiles -name "*.fsh" -type f -exec \
  awk -f add_must_support.awk {} > {}.tmp \; -exec mv {}.tmp {} \;

# 2.4 - Corrigir URLs canônicas
find input/fsh -name "*.fsh" -type f -exec sed -i '' \
  -e 's|https://2rdoc.pt/ig/ios-lifestyle-medicine|https://2rdoc.pt/fhir|g' \
  -e 's|http://example.org/fhir|https://2rdoc.pt/fhir|g' {} \;
```

### Princípios de Correção

Segundo as diretrizes do HL7⁷, os perfis devem seguir a estrutura:
- **MS (MustSupport)**: Elemento deve ser suportado
- **?! (Modifier)**: Altera significado se presente
- **SU (Summary)**: Incluído em resumos

## 🏥 Correção de ValueSets e CodeSystems

Conforme especificado na documentação de terminologias FHIR⁸:

```bash
#!/bin/bash
# fix_terminology.sh - Corrigir problemas de terminologia

echo "🏥 Corrigindo ValueSets e CodeSystems..."

# 3.1 - Criar template para CodeSystems faltantes
cat > fix_codesystem_template.fsh << 'EOF'
CodeSystem: [SYSTEM_NAME]CS
Id: [system-name]-cs
Title: "[System Name] Code System"
Description: "Códigos para [descrição]"
* ^url = "https://2rdoc.pt/fhir/CodeSystem/[system-name]-cs"
* ^version = "0.1.0"
* ^status = #draft
* ^content = #complete
EOF

# 3.2 - Corrigir bindings de ValueSets
find input/fsh -name "*.fsh" -type f -exec sed -i '' \
  -e 's/from \([^ ]*\) (preferred)/from \1 (required)/g' \
  -e 's/\#\([a-z-]*\)/"https:\/\/2rdoc.pt\/fhir\/ValueSet\/\1"/g' {} \;

# 3.3 - Validar códigos LOINC
cat > validate_loinc.sh << 'EOF'
#!/bin/bash
# Mapear códigos LOINC incorretos para corretos
declare -A loinc_map=(
  ["89595-3"]="85354-9"  # Stress level
  ["89596-1"]="85353-1"  # Stress impact
)

for file in input/fsh/**/*.fsh; do
  for wrong in "${!loinc_map[@]}"; do
    correct="${loinc_map[$wrong]}"
    sed -i '' "s/$wrong/$correct/g" "$file"
  done
done
EOF
chmod +x validate_loinc.sh
./validate_loinc.sh
```

## 📝 Correção de Arquivos Markdown

Baseado nas páginas obrigatórias definidas nas especificações⁹:

```bash
#!/bin/bash
# fix_markdown.sh - Corrigir arquivos markdown

echo "📝 Corrigindo arquivos .md..."

# 4.1 - Corrigir encoding e caracteres especiais
find input/pagecontent -name "*.md" -type f -exec \
  iconv -f UTF-8 -t UTF-8 -c {} -o {}.clean \; \
  -exec mv {}.clean {} \;

# 4.2 - Corrigir referências quebradas
find input/pagecontent -name "*.md" -type f -exec sed -i '' \
  -e 's/\[([^]]*)\](StructureDefinition-\([^)]*\)\.html)/[\1](StructureDefinition-\1.html)/g' \
  -e 's/\.html\.html/.html/g' {} \;

# 4.3 - Adicionar páginas obrigatórias se não existirem
required_pages=("index.md" "profiles.md" "terminology.md" "downloads.md" "changes.md")
for page in "${required_pages[@]}"; do
  if [ ! -f "input/pagecontent/$page" ]; then
    echo "# $(echo $page | sed 's/.md//' | sed 's/^./\U&/')" > "input/pagecontent/$page"
    echo "Esta página está em desenvolvimento." >> "input/pagecontent/$page"
  fi
done
```

### Páginas Obrigatórias do IG

Conforme documentado¹⁰, todo IG deve conter:
- **index.md**: Página inicial com visão geral
- **profiles.md**: Lista e descrição de perfis
- **terminology.md**: Sistemas de códigos e valuesets
- **downloads.md**: Pacotes para download
- **changes.md**: Histórico de mudanças

## 📊 Validação e Correção de Exemplos

Seguindo as diretrizes de conformidade¹¹:

```bash
#!/bin/bash
# fix_examples.sh - Corrigir exemplos

echo "📊 Corrigindo instâncias de exemplo..."

# 5.1 - Adicionar status obrigatório em Observations
find input/fsh/examples -name "*Observation*.fsh" -type f -exec \
  awk '/^Instance:/ {print; print "* status = #final"; next} {print}' {} > {}.tmp \; \
  -exec mv {}.tmp {} \;

# 5.2 - Corrigir referências de perfis
find input/fsh/examples -name "*.fsh" -type f -exec sed -i '' \
  -e 's/InstanceOf: [^ ]*/InstanceOf: https:\/\/2rdoc.pt\/fhir\/StructureDefinition\/&/g' {} \;

# 5.3 - Adicionar elementos obrigatórios faltantes
cat > add_required_elements.awk << 'EOF'
BEGIN { in_instance = 0 }
/^Instance:/ { 
    in_instance = 1
    print
    next
}
/^InstanceOf:/ && in_instance {
    print
    print "* meta.profile = \"https://2rdoc.pt/fhir/StructureDefinition/[profile-name]\""
    in_instance = 0
    next
}
{print}
EOF

find input/fsh/examples -name "*.fsh" -exec \
  awk -f add_required_elements.awk {} > {}.tmp \; \
  -exec mv {}.tmp {} \;
```

## 🚀 Script Mestre de Correção

Script principal que orquestra todas as correções¹²:

```bash
#!/bin/bash
# master_fix.sh - Script principal para executar todas as correções

set -e  # Parar em caso de erro

echo "🚀 INICIANDO CORREÇÃO COMPLETA DO IG FHIR"
echo "==========================================="

# 1. Backup
echo "📦 Fazendo backup..."
./backup_ig.sh

# 2. Limpar cache
echo "🧹 Limpando cache..."
rm -rf fsh-generated/
rm -rf output/
rm -f input-cache/*.json

# 3. Executar correções
echo "🔧 Executando correções..."
./fix_fsh_errors.sh
./fix_terminology.sh
./fix_markdown.sh
./fix_examples.sh

# 4. Validar com SUSHI
echo "🍣 Validando com SUSHI..."
sushi . 2>&1 | tee logs/sushi_output.txt

# 5. Contar erros restantes
echo "📊 Analisando resultados..."
errors=$(grep -c "error" logs/sushi_output.txt || true)
warnings=$(grep -c "warning" logs/sushi_output.txt || true)

echo "✅ Correção completa!"
echo "   Erros: $errors"
echo "   Avisos: $warnings"

# 6. Gerar IG se não houver erros críticos
if [ "$errors" -lt 10 ]; then
    echo "🏗️ Gerando Implementation Guide..."
    ./_genonce.sh
else
    echo "⚠️ Muitos erros ainda. Revise manualmente."
fi
```

## 📈 Monitoramento e Iteração

Para acompanhar o progresso das correções¹³:

```bash
#!/bin/bash
# monitor_progress.sh - Monitorar progresso das correções

watch_errors() {
    while true; do
        clear
        echo "📈 MONITORAMENTO DE ERROS DO IG"
        echo "================================"
        echo ""
        
        if [ -f "output/qa.html" ]; then
            echo "Erros críticos:"
            grep -c "background-color: #ffcccc" output/qa.html || echo "0"
            
            echo "Warnings:"
            grep -c "background-color: #ffebcc" output/qa.html || echo "0"
            
            echo "Informações:"
            grep -c "background-color: #ffffe6" output/qa.html || echo "0"
        else
            echo "Aguardando geração do qa.html..."
        fi
        
        echo ""
        echo "Última execução: $(date)"
        sleep 5
    done
}

# Executar monitoramento
watch_errors
```

## ✅ Checklist de Validação Final

Baseado nas diretrizes de publicação¹⁴:

```bash
#!/bin/bash
# final_check.sh - Validação final antes de publicar

echo "✅ CHECKLIST FINAL DO IG"
echo "========================"

checks=()
checks+=("[ ] Todos os perfis têm pelo menos um exemplo")
checks+=("[ ] Todos os CodeSystems têm sistema definido")  
checks+=("[ ] Todos os ValueSets têm binding correto")
checks+=("[ ] Arquivos .md não têm caracteres corrompidos")
checks+=("[ ] URLs canônicas estão consistentes")
checks+=("[ ] Não há erros críticos no qa.html")
checks+=("[ ] ig.ini aponta para o IG correto")
checks+=("[ ] sushi-config.yaml está completo")

for check in "${checks[@]}"; do
    echo "$check"
done

echo ""
echo "📝 Revise manualmente cada item antes de publicar!"
```

## 🎯 Execução da Estratégia

Para executar toda a estratégia de correção:

```bash
# 1. Tornar scripts executáveis
chmod +x *.sh

# 2. Executar análise inicial
./analyze_errors.sh

# 3. Executar correção completa
./master_fix.sh

# 4. Monitorar progresso em outro terminal
./monitor_progress.sh

# 5. Validação final
./final_check.sh
```

## 💡 Dicas Importantes

1. **Sempre faça backup antes de executar correções** - Use versionamento Git¹⁵
2. **Revise o arquivo `output/qa.html` após cada execução** - Foco em erros críticos primeiro
3. **Use `git diff` para revisar mudanças antes de commitar** - Evita alterações indesejadas
4. **Documente correções manuais necessárias** - Mantenha um log de mudanças
5. **Mantenha o arquivo `input/ignoreWarnings.txt` atualizado** - Para warnings aceitáveis

## 🔄 Processo Iterativo

O processo de correção deve seguir estas fases¹⁶:

1. **Análise** - Identificar tipos de erros
2. **Correção Automatizada** - Scripts bash
3. **Validação** - SUSHI e IG Publisher
4. **Correção Manual** - Casos específicos
5. **Documentação** - Atualizar páginas narrativas
6. **Teste Final** - Geração completa do IG

## 📚 Referências

1. **HL7 International FHIR R5 Specification**  
   [http://hl7.org/fhir/R5/](http://hl7.org/fhir/R5/)

2. **FHIR Implementation Guide Resource**  
   [http://hl7.org/fhir/R5/implementationguide.html](http://hl7.org/fhir/R5/implementationguide.html)

3. **FHIR IG Publishing Requirements**  
   [https://wiki.hl7.org/FHIR_Implementation_Guide_Publishing_Requirements](https://wiki.hl7.org/FHIR_Implementation_Guide_Publishing_Requirements)

4. **FHIR Shorthand Specification**  
   [https://build.fhir.org/ig/HL7/fhir-shorthand/](https://build.fhir.org/ig/HL7/fhir-shorthand/)

5. **FSH School - Part 1: Reading an IG**  
   [https://fshschool.org/courses/fsh-seminar/01-reading-an-ig.html](https://fshschool.org/courses/fsh-seminar/01-reading-an-ig.html)

6. **FHIR IG Guidance**  
   [http://build.fhir.org/ig/FHIR/ig-guidance/index.html](http://build.fhir.org/ig/FHIR/ig-guidance/index.html)

7. **FSH Quick Start Guide**  
   [https://fshschool.org/quickstart/](https://fshschool.org/quickstart/)

8. **HL7 Terminology Services**  
   [https://terminology.hl7.org/](https://terminology.hl7.org/)

9. **FHIR Shorthand Quick Reference**  
   Version 3.0.0, HL7 International

10. **Extending FHIR**  
    [http://hl7.org/fhir/R5/extensibility.html](http://hl7.org/fhir/R5/extensibility.html)

11. **IG Publisher Documentation**  
    [https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation)

12. **Implementation Guide Parameters**  
    [https://confluence.hl7.org/display/FHIR/Implementation+Guide+Parameters](https://confluence.hl7.org/display/FHIR/Implementation+Guide+Parameters)

13. **FHIR Chat - IG Creation Stream**  
    [https://chat.fhir.org/#narrow/stream/179252-IG-creation](https://chat.fhir.org/#narrow/stream/179252-IG-creation)

14. **FHIR Registry**  
    [https://fhir.org/guides/registry/](https://fhir.org/guides/registry/)

15. **US Core Implementation Guide**  
    [http://hl7.org/fhir/us/core/](http://hl7.org/fhir/us/core/)

16. **International Patient Summary**  
    [http://hl7.org/fhir/uv/ips/](http://hl7.org/fhir/uv/ips/)

---

*Documento baseado nas especificações HL7 FHIR e nas melhores práticas documentadas pela comunidade FHIR internacional. Última atualização: 2024*