#!/bin/bash

# Define o diretório alvo (usa o primeiro argumento ou o diretório atual)
TARGET_DIR="${1:-.}"

# Cria nome do arquivo com timestamp (ANO MES DIA HORA MINUTO SEGUNDO)
TIMESTAMP=$(date '+%Y%m%d%H%M%S')
OUTPUT_FILE="combined_fsh_${TIMESTAMP}.txt"

# Verifica se o diretório existe
if [ ! -d "$TARGET_DIR" ]; then
    echo "Erro: Diretório '$TARGET_DIR' não encontrado."
    exit 1
fi

# Encontra todos os arquivos .fsh
FSH_FILES=$(find "$TARGET_DIR" -name "*.fsh")

# Verifica se encontrou algum arquivo
if [ -z "$FSH_FILES" ]; then
    echo "Nenhum arquivo .fsh encontrado no diretório."
    exit 1
fi

# Limpa ou cria o arquivo de saída
> "$OUTPUT_FILE"

# Contador de arquivos processados
COUNT=0

# Para cada arquivo .fsh encontrado
while IFS= read -r file; do
    echo "Processando arquivo: $(basename "$file")"
    
    # Adiciona o cabeçalho e o conteúdo do arquivo
    echo -e "\n// ===== Conteúdo de: $(basename "$file") =====\n" >> "$OUTPUT_FILE"
    cat "$file" >> "$OUTPUT_FILE"
    echo -e "\n" >> "$OUTPUT_FILE"
    
    ((COUNT++))
done <<< "$FSH_FILES"

echo -e "\nArquivos combinados com sucesso em: $OUTPUT_FILE"
echo "Total de arquivos processados: $COUNT"