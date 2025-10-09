// Template de ValueSet FHIR
ValueSet: [NomeDoValueSet]
Id: [id-do-valueset]
Title: "[Título do ValueSet]"
Description: "[Descrição do conjunto de valores e seu uso]"

// Metadados
* ^url = "http://example.org/fhir/ValueSet/[id-do-valueset]"
* ^version = "1.0.0"
* ^status = #draft
* ^experimental = false

// Inclusão de códigos (escolha um método)

// Método 1: Lista explícita (Extensional)
* $SystemAlias#code1 "Display 1"
* $SystemAlias#code2 "Display 2"

// Método 2: Por filtro (Intensional)
* include codes from system $SystemAlias where concept is-a #parent-code

// Método 3: Incluir ValueSet existente
* include codes from valueset ExistingValueSetURL
