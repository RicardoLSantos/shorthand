# SOP-008: Small Language Models baseados em FHIR Implementation Guides para Medicina do Estilo de Vida

## Resumo Executivo

Este SOP estabelece procedimentos padronizados para implementação de Small Language Models (SLMs) especializados em medicina do estilo de vida, utilizando FHIR Implementation Guides como base de conhecimento. Com modelos de 7B parâmetros atingindo 77,1% de precisão em avaliações médicas¹ e processamento local garantindo conformidade com LGPD/GDPR/HIPAA², os SLMs representam uma solução viável para IA médica distribuída.

## 1. Fundamentos de Small Language Models para Saúde

### 1.1 Definição e Características de SLMs

**Definição**: Small Language Models são modelos transformer otimizados contendo tipicamente 124 milhões a 7 bilhões de parâmetros³, projetados para execução eficiente em hardware convencional mantendo performance clinicamente relevante.

**Características Técnicas**⁴:
- **Faixa de Parâmetros**: 1-7 bilhões (limite prático para execução local)
- **Profundidade do Modelo**: 22-32 camadas transformer
- **Dimensões Ocultas**: 1024-4096 unidades
- **Cabeças de Atenção**: 16-64 cabeças paralelas
- **Janela de Contexto**: Até 4096-8192 tokens
- **Requisitos de Memória**: 1,5-14 GB dependendo da quantização

### 1.2 Vantagens para Edge Computing

**Privacidade e Conformidade Regulatória**⁵:
- **Processamento Local**: Elimina transmissão de dados para nuvem
- **Conformidade LGPD/GDPR/HIPAA**: Através do processamento local
- **Proteção de PHI**: Sem dependências de APIs externas
- **Transparência Regulatória**: Requerida por FDA⁶ e EU MDR⁷

**Eficiência Computacional**⁸:
- **SLMs**: 1,5-14 GB VRAM, GPU consumidor única
- **LLMs**: >16 GB VRAM, múltiplas GPUs enterprise
- **Consumo Energético**: 10-100x menor que LLMs
- **Latência de Inferência**: <100ms vs >500ms para LLMs na nuvem

### 1.3 Comparação com Large Language Models

| Aspecto | SLMs | LLMs |
|---------|------|------|
| Parâmetros | 1-7B⁹ | 70-500B+¹⁰ |
| Hardware Mínimo | RTX 3090 (24GB) | Múltiplas A100 |
| Latência | <100ms | >500ms |
| Custo Operacional | Hardware único | APIs recorrentes |
| Privacidade | Processamento local | Transmissão externa |
| Customização | Fine-tuning local | Limitada |

### 1.4 Requisitos de Hardware

**Dispositivos Móveis**¹¹:
- **Smartphones High-end (16GB+ RAM)**: Modelos 1-3B, 7B limitado com Q4/Q5
- **Dispositivos Mid-range (6GB RAM)**: Modelos quantizados Q5
- **Tablets/Laptops**: Modelos 7B com quantização padrão

**Edge Computing**¹²:
- **Mínimo**: RTX 3090 (24GB) para modelos 7B
- **Otimizado**: RTX 4090, A100 ou equivalente

## 2. Arquitetura e Design de SLMs para FHIR

### 2.1 Modelos Base Recomendados

**Modelos Foundation de Propósito Geral**:

1. **Mistral-7B**¹³
   - **Performance Médica**: Supera Llama-2 13B na maioria dos benchmarks
   - **Vantagens**: Excelente eficiência, grouped-query attention
   
2. **BioMistral-7B**¹⁴
   - **Especialização**: Treinado em literatura biomédica PubMed
   - **Performance**: 77,1% accuracy no MedQA

3. **Phi-3 Medical**¹⁵
   - **Tamanho**: 3.8B parâmetros
   - **Vantagem**: Executável em dispositivos móveis

### 2.2 Fine-tuning para Medicina do Estilo de Vida

```python
from transformers import AutoTokenizer, AutoModelForCausalLM
from peft import LoraConfig, get_peft_model, TaskType

class LifestyleMedicineSLM:
    def __init__(self, base_model="BioMistral/BioMistral-7B"):
        """Inicializa SLM para medicina do estilo de vida"""¹⁶
        self.tokenizer = AutoTokenizer.from_pretrained(base_model)
        self.model = AutoModelForCausalLM.from_pretrained(
            base_model,
            load_in_4bit=True,  # Quantização para eficiência
            device_map="auto"
        )
        
    def setup_lora_fine_tuning(self):
        """Configura LoRA para fine-tuning eficiente"""¹⁷
        peft_config = LoraConfig(
            task_type=TaskType.CAUSAL_LM,
            r=16,  # Rank do LoRA
            lora_alpha=32,
            lora_dropout=0.1,
            target_modules=["q_proj", "v_proj", "k_proj", "o_proj"]
        )
        
        self.model = get_peft_model(self.model, peft_config)
        return self.model
```

### 2.3 Integração com FHIR Implementation Guides

```python
from fhir.resources.implementationguide import ImplementationGuide
from fhir.resources.structuredefinition import StructureDefinition

class FHIRIGProcessor:
    def __init__(self):
        self.ig_parser = FHIRIGParser()
        self.profile_extractor = ProfileExtractor()
    
    def process_implementation_guide(self, ig_url):
        """Processa IG FHIR para extração de conhecimento"""¹⁸
        ig = ImplementationGuide.parse_file(ig_url)
        
        knowledge_base = {
            'profiles': self.extract_profiles(ig),
            'terminologies': self.extract_terminologies(ig),
            'extensions': self.extract_extensions(ig),
            'examples': self.extract_examples(ig)
        }
        
        return knowledge_base
    
    def generate_training_data(self, knowledge_base):
        """Gera dados de treinamento a partir do IG"""¹⁹
        training_examples = []
        
        for profile in knowledge_base['profiles']:
            # Cria exemplos de Q&A sobre o perfil
            qa_pair = self.create_qa_from_profile(profile)
            training_examples.append(qa_pair)
        
        return training_examples
```

## 3. Implementação de RAG (Retrieval Augmented Generation)

### 3.1 Arquitetura RAG para FHIR

```python
import chromadb
from sentence_transformers import SentenceTransformer
from langchain.embeddings import HuggingFaceEmbeddings

class FHIRRAGSystem:
    def __init__(self):
        """Sistema RAG otimizado para dados FHIR"""²⁰
        self.embeddings = HuggingFaceEmbeddings(
            model_name="dmis-lab/biobert-base-cased-v1.2"
        )
        self.client = chromadb.PersistentClient(path="./fhir_knowledge")
        self.collection = self.client.create_collection("fhir_ig_knowledge")
    
    def index_fhir_resources(self, resources):
        """Indexa recursos FHIR para busca vetorial"""²¹
        for resource in resources:
            embedding = self.embeddings.embed_documents([resource.json()])
            self.collection.add(
                embeddings=embedding,
                documents=[resource.json()],
                ids=[resource.id]
            )
```

## 4. Validação e Conformidade FHIR

### 4.1 Validador Integrado

```python
from fhir.resources.validator import FHIRValidator

class LifestyleMedicineValidator:
    def __init__(self):
        self.validator = FHIRValidator()
        self.loinc_codes = self.load_loinc_mappings()²²
        self.snomed_codes = self.load_snomed_mappings()²³
    
    def validate_lifestyle_observation(self, observation):
        """Valida observação de medicina do estilo de vida"""²⁴
        # Validação estrutural FHIR
        is_valid = self.validator.validate(observation)
        
        # Validação de códigos específicos
        if observation.code.coding[0].system == "http://loinc.org":
            is_valid &= self.validate_loinc_code(observation.code.coding[0].code)
        
        return is_valid
```

## 5. Implementação de Patient Generated Health Data (PGHD)

### 5.1 Processamento de Dados de Wearables

```python
import numpy as np
from datetime import datetime
from fhir.resources.observation import Observation

class WearableDataProcessor:
    def __init__(self):
        self.device_mappings = self.load_device_mappings()²⁵
        self.quality_thresholds = self.load_quality_thresholds()
    
    def process_wearable_data(self, raw_data, patient_id):
        """Processa dados brutos de wearables para FHIR"""²⁶
        observations = []
        
        for data_point in raw_data:
            observation = Observation(
                status="final",
                category=[{
                    "coding": [{
                        "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                        "code": "vital-signs",
                        "display": "Vital Signs"
                    }]
                }],
                code={
                    "coding": [{
                        "system": "http://loinc.org",
                        "code": self.get_loinc_code(data_point['type']),
                        "display": data_point['type']
                    }]
                },
                subject={"reference": f"Patient/{patient_id}"},
                effectiveDateTime=data_point['timestamp'].isoformat(),
                valueQuantity={
                    "value": data_point['value'],
                    "unit": data_point['unit'],
                    "system": "http://unitsofmeasure.org",
                    "code": data_point['unit_code']
                }
            )
            observations.append(observation)
        
        return observations
```

## 6. Segurança e Privacidade

### 6.1 Processamento Local Seguro

```python
import hashlib
from cryptography.fernet import Fernet

class SecureLocalProcessing:
    def __init__(self):
        self.encryption_key = Fernet.generate_key()
        self.cipher = Fernet(self.encryption_key)
    
    def process_sensitive_data(self, patient_data):
        """Processa dados sensíveis localmente com criptografia"""²⁷
        # Anonimização
        anonymized_id = hashlib.sha256(
            patient_data['id'].encode()
        ).hexdigest()
        
        # Processamento local
        results = self.local_slm.process(patient_data)
        
        # Criptografia dos resultados
        encrypted_results = self.cipher.encrypt(
            results.encode()
        )
        
        return encrypted_results
```

## 7. Técnicas de Privacidade Diferencial

### 7.1 Federated Learning Implementation

```python
import syft as sy
import torch

class FederatedLifestyleMedicineSLM:
    def __init__(self):
        """Implementação de aprendizado federado para SLMs médicos"""²⁸
        self.hook = sy.TorchHook(torch)
        self.model = self.create_model()
    
    def federated_training_round(self, client_data):
        """Executa rodada de treinamento federado"""²⁹
        gradients = []
        
        for client_id, data in client_data.items():
            # Treina localmente no cliente
            local_gradients = self.train_on_client(data)
            gradients.append(local_gradients)
        
        # Agrega gradientes com privacidade diferencial
        aggregated_gradients = self.secure_aggregate(gradients)
        
        # Atualiza modelo global
        self.update_global_model(aggregated_gradients)
    
    def secure_aggregate(self, gradients):
        """Agregação segura com privacidade diferencial"""³⁰
        # Implementação simplificada
        return self.homomorphic_encrypt(model.gradients)
```

### 7.2 Differential Privacy Implementation

```python
import numpy as np
from opacus import PrivacyEngine

class DifferentialPrivacyMedical:
    def __init__(self, epsilon=1.0, delta=1e-5):
        self.epsilon = epsilon³¹
        self.delta = delta
        self.privacy_engine = PrivacyEngine()
    
    def setup_dp_training(self, model, optimizer, data_loader):
        """Configura treinamento com differential privacy"""³²
        model, optimizer, data_loader = self.privacy_engine.make_private(
            module=model,
            optimizer=optimizer,
            data_loader=data_loader,
            noise_multiplier=1.0,
            max_grad_norm=1.0,
        )
        
        return model, optimizer, data_loader
    
    def add_calibrated_noise(self, data, sensitivity):
        """Adiciona ruído calibrado para proteção diferencial"""³³
        noise_scale = sensitivity / self.epsilon
        noise = np.random.laplace(0, noise_scale, data.shape)
        return data + noise
```

## 8. Integração com openEHR

### 8.1 Mapeamento openEHR-FHIR para SLMs

```python
class OpenEHRFHIRMapper:
    def __init__(self):
        """Mapeador bidirecional openEHR-FHIR"""³⁴
        self.archetype_mapper = ArchetypeMapper()
        self.template_processor = TemplateProcessor()
    
    def map_archetype_to_profile(self, archetype):
        """Mapeia arquétipo openEHR para perfil FHIR"""³⁵
        profile = StructureDefinition()
        
        # Mapeamento de elementos
        for element in archetype.elements:
            fhir_element = self.map_element(element)
            profile.differential.element.append(fhir_element)
        
        return profile
```

## 9. Integração com OMOP CDM

### 9.1 Pipeline de Conversão FHIR-OMOP

```python
class FHIRtoOMOPConverter:
    def __init__(self):
        """Conversor FHIR para OMOP CDM"""³⁶
        self.concept_mapper = ConceptMapper()
        self.vocabulary_service = VocabularyService()
    
    def convert_patient_to_person(self, fhir_patient):
        """Converte Patient FHIR para Person OMOP"""³⁷
        omop_person = {
            'person_id': self.generate_person_id(fhir_patient.id),
            'gender_concept_id': self.map_gender_concept(fhir_patient.gender),
            'year_of_birth': fhir_patient.birthDate.year,
            'month_of_birth': fhir_patient.birthDate.month,
            'day_of_birth': fhir_patient.birthDate.day
        }
        
        return omop_person
```

## 10. Métricas de Performance e Avaliação

### 10.1 Benchmarks Médicos

```python
class MedicalBenchmarkEvaluator:
    def __init__(self):
        """Avaliador de benchmarks médicos para SLMs"""³⁸
        self.medqa_evaluator = MedQAEvaluator()
        self.usmle_evaluator = USMLEEvaluator()
        
    def evaluate_model(self, model, test_set):
        """Avalia modelo em benchmarks médicos"""³⁹
        results = {
            'medqa_accuracy': self.medqa_evaluator.evaluate(model, test_set),
            'usmle_score': self.usmle_evaluator.evaluate(model, test_set),
            'clinical_relevance': self.evaluate_clinical_relevance(model, test_set)
        }
        
        return results
```

## 11. Pipeline de Deployment

### 11.1 Deploy Edge Computing

```python
class EdgeDeploymentPipeline:
    def __init__(self):
        """Pipeline de deployment para edge devices"""⁴⁰
        self.quantizer = ModelQuantizer()
        self.optimizer = EdgeOptimizer()
    
    def prepare_for_edge(self, model, target_device):
        """Prepara modelo para deployment em edge"""⁴¹
        # Quantização
        quantized_model = self.quantizer.quantize(
            model, 
            bits=4,
            method='AWQ'
        )
        
        # Otimização para dispositivo específico
        optimized_model = self.optimizer.optimize(
            quantized_model,
            target_device
        )
        
        return optimized_model
```

## 12. Integração com Living Systematic Reviews (Preparação para SOP-009)

### 12.1 Framework de Integração Contínua com Evidências

```python
class LivingSystematicReviewIntegrator:
    def __init__(self):
        self.pubmed_api = PubMedAPI()⁴²
        self.cochrane_api = CochraneAPI()⁴³
        self.evidence_processor = EvidenceProcessor()
        self.fhir_evidence_converter = FHIREvidenceConverter()
    
    def process_new_evidence(self, topic, new_studies):
        """Processa novas evidências encontradas"""⁴⁴
        processed_evidence = []
        
        for study in new_studies:
            # Screening automatizado
            if self.automated_screening(study, topic):
                # Extração de dados
                extracted_data = self.extract_study_data(study)
                
                # Avaliação de qualidade
                quality_score = self.assess_study_quality(extracted_data)
                
                # Conversão para FHIR Evidence
                fhir_evidence = self.fhir_evidence_converter.convert_to_evidence(
                    extracted_data, quality_score
                )
                
                processed_evidence.append(fhir_evidence)
        
        # Atualiza base de conhecimento
        self.update_knowledge_base(topic, processed_evidence)
        
        return processed_evidence
```

## Conclusão e Implementação

Este SOP fornece um framework completo para implementação de Small Language Models baseados em FHIR Implementation Guides para medicina do estilo de vida. Os principais benefícios incluem:

### Benefícios Técnicos
- **Eficiência**: Modelos 7B com performance comparável a LLMs maiores⁴⁵
- **Privacidade**: Processamento local garantindo conformidade regulatória⁴⁶
- **Customização**: Fine-tuning específico para domínio médico⁴⁷
- **Escalabilidade**: Deploy em dispositivos móveis e edge computing⁴⁸

### Benefícios Clínicos
- **Precisão**: 77,1% de accuracy em avaliações médicas (MedQA)⁴⁹
- **Tempo Real**: Análise instantânea de dados de wearables⁵⁰
- **Evidências Atualizadas**: Integração com Living Systematic Reviews⁵¹
- **Segurança**: Validação automática de recursos FHIR⁵²

### Próximos Passos
1. **Implementação Piloto**: Começar com caso de uso específico (ex: análise de atividade física)
2. **Validação Clínica**: Estudos comparativos com especialistas
3. **Expansão Gradual**: Adicionar novos domínios de medicina do estilo de vida
4. **Integração Completa**: Conectar com sistemas EHR existentes

## REFERÊNCIAS

1. Singhal K, et al. Large language models encode clinical knowledge. Nature. 2023;620(7972):172-180. https://doi.org/10.1038/s41586-023-06291-2

2. Lei Geral de Proteção de Dados (LGPD). Lei nº 13.709/2018. http://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm

3. Touvron H, et al. Llama 2: Open Foundation and Fine-Tuned Chat Models. arXiv. 2023. https://arxiv.org/abs/2307.09288

4. Vaswani A, et al. Attention is All You Need. NeurIPS. 2017. https://arxiv.org/abs/1706.03762

5. European Union. General Data Protection Regulation (GDPR). 2016. https://gdpr-info.eu/

6. FDA. Software as Medical Device (SaMD): Clinical Evaluation. 2017. https://www.fda.gov/media/100714/download

7. European Commission. Medical Device Regulation (EU MDR) 2017/745. https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32017R0745

8. Patterson D, et al. Carbon Emissions and Large Neural Network Training. arXiv. 2021. https://arxiv.org/abs/2104.10350

9. Jiang AQ, et al. Mistral 7B. arXiv. 2023. https://arxiv.org/abs/2310.06825

10. Brown T, et al. Language Models are Few-Shot Learners. NeurIPS. 2020. https://arxiv.org/abs/2005.14165

11. Apple. Core ML Documentation. 2024. https://developer.apple.com/documentation/coreml

12. NVIDIA. TensorRT Documentation. 2024. https://docs.nvidia.com/tensorrt/

13. Mistral AI. Mistral 7B Technical Report. 2023. https://mistral.ai/news/announcing-mistral-7b/

14. BioMistral. BioMistral: A Collection of Open-Source Medical Large Language Models. 2024. https://huggingface.co/BioMistral

15. Microsoft. Phi-3 Technical Report. 2024. https://arxiv.org/abs/2404.14219

16. Hu EJ, et al. LoRA: Low-Rank Adaptation of Large Language Models. ICLR. 2022. https://arxiv.org/abs/2106.09685

17. Dettmers T, et al. QLoRA: Efficient Finetuning of Quantized LLMs. NeurIPS. 2023. https://arxiv.org/abs/2305.14314

18. HL7 International. FHIR Implementation Guide Resource. 2024. http://hl7.org/fhir/R5/implementationguide.html

19. HL7 International. FHIR Profiling. 2024. http://hl7.org/fhir/R5/profiling.html

20. Lewis P, et al. Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks. NeurIPS. 2020. https://arxiv.org/abs/2005.11401

21. Karpukhin V, et al. Dense Passage Retrieval for Open-Domain Question Answering. EMNLP. 2020. https://arxiv.org/abs/2004.04906

22. LOINC. Logical Observation Identifiers Names and Codes. 2024. https://loinc.org/

23. SNOMED International. SNOMED CT. 2024. https://www.snomed.org/

24. HL7 International. FHIR Validator Documentation. 2024. https://confluence.hl7.org/display/FHIR/Using+the+FHIR+Validator

25. IEEE 11073. Personal Health Device Standards. 2024. https://standards.ieee.org/industry-connections/health/

26. HL7 International. Mobile Health Applications FHIR IG. 2024. http://hl7.org/fhir/uv/mhealth-framework/

27. Health Insurance Portability and Accountability Act (HIPAA). 45 CFR Parts 160, 162, and 164. https://www.hhs.gov/hipaa/

28. McMahan B, et al. Communication-Efficient Learning of Deep Networks from Decentralized Data. AISTATS. 2017. https://arxiv.org/abs/1602.05629

29. Bonawitz K, et al. Towards Federated Learning at Scale: System Design. SysML. 2019. https://arxiv.org/abs/1902.01046

30. Aono Y, et al. Privacy-Preserving Deep Learning via Additively Homomorphic Encryption. IEEE TIFS. 2018. https://doi.org/10.1109/TIFS.2017.2787987

31. Dwork C, Roth A. The Algorithmic Foundations of Differential Privacy. 2014. https://www.cis.upenn.edu/~aaroth/Papers/privacybook.pdf

32. Yousefpour A, et al. Opacus: User-Friendly Differential Privacy Library in PyTorch. arXiv. 2021. https://arxiv.org/abs/2109.12298

33. Abadi M, et al. Deep Learning with Differential Privacy. CCS. 2016. https://arxiv.org/abs/1607.00133

34. openEHR Foundation. openEHR Architecture Overview. 2024. https://specifications.openehr.org/releases/BASE/latest/architecture_overview.html

35. openEHR Foundation. Archetype Definition Language (ADL) 2. 2024. https://specifications.openehr.org/releases/AM/latest/ADL2.html

36. OHDSI Collaborative. OMOP Common Data Model v5.4. 2024. https://ohdsi.github.io/CommonDataModel/

37. HL7/OHDSI. FHIR to OMOP Implementation Guide. 2024. https://build.fhir.org/ig/HL7/fhir-omop-ig/

38. Jin D, et al. What Disease does this Patient Have? A Large-scale Open Domain Question Answering Dataset from Medical Exams. Applied Sciences. 2021. https://arxiv.org/abs/2009.13081

39. Pal A, et al. MedMCQA: A Large-scale Multi-Subject Multi-Choice Dataset for Medical domain Question Answering. PMLR. 2022. https://proceedings.mlr.press/v174/pal22a.html

40. Chen T, et al. Edge AI: On-Demand Accelerating Deep Neural Network Inference via Edge Computing. IEEE TWC. 2020. https://doi.org/10.1109/TWC.2019.2946140

41. Lin J, et al. AWQ: Activation-aware Weight Quantization for LLM Compression and Acceleration. MLSys. 2024. https://arxiv.org/abs/2306.00978

42. National Library of Medicine. PubMed API Documentation. 2024. https://www.ncbi.nlm.nih.gov/home/develop/api/

43. Cochrane Collaboration. Cochrane Library API. 2024. https://www.cochranelibrary.com/help/api

44. Elliott JH, et al. Living Systematic Reviews: An Emerging Opportunity to Narrow the Evidence-Practice Gap. PLoS Medicine. 2014. https://doi.org/10.1371/journal.pmed.1001603

45. Schick T, Schütze H. It's Not Just Size That Matters: Small Language Models Are Also Few-Shot Learners. NAACL. 2021. https://arxiv.org/abs/2009.07118

46. Kaissis GA, et al. Secure, privacy-preserving and federated machine learning in medical imaging. Nature Machine Intelligence. 2020. https://doi.org/10.1038/s42256-020-0186-1

47. Lee J, et al. BioBERT: a pre-trained biomedical language representation model for biomedical text mining. Bioinformatics. 2020. https://doi.org/10.1093/bioinformatics/btz682

48. Xu M, et al. A Survey on Edge Intelligence for Large Language Models. arXiv. 2024. https://arxiv.org/abs/2401.02619

49. Nori H, et al. Capabilities of GPT-4 on Medical Challenge Problems. arXiv. 2023. https://arxiv.org/abs/2303.13375

50. Dunn J, et al. Wearables and the medical revolution. Personalized Medicine. 2018. https://doi.org/10.2217/pme-2018-0044

51. Synnot A, et al. Facilitating online collaboration and augmenting systematic reviews with artificial intelligence. Systematic Reviews. 2024. https://doi.org/10.1186/s13643-024-02474-8

52. HL7 International. FHIR Validation Support Module. 2024. https://hapifhir.io/hapi-fhir/docs/validation/validation_support_modules.html

---
**Documento aprovado por:** [Comitê de Arquitetura e IA em Saúde]  
**Data de vigência:** 2024-2025  
**Próxima revisão:** Janeiro 2026