# SOP-008: Small Language Models baseados em FHIR Implementation Guides para Medicina do Estilo de Vida

## Resumo Executivo

Este SOP estabelece procedimentos padronizados para implementação de Small Language Models (SLMs) especializados em medicina do estilo de vida, utilizando FHIR Implementation Guides como base de conhecimento. Com modelos de 7B parâmetros atingindo 77,1% de precisão em avaliações médicas e processamento local garantindo conformidade com LGPD/GDPR/HIPAA, os SLMs representam uma solução viável para IA médica distribuída.

## 1. Fundamentos de Small Language Models para Saúde

### 1.1 Definição e Características de SLMs

**Definição**: Small Language Models são modelos transformer otimizados contendo tipicamente 124 milhões a 7 bilhões de parâmetros, projetados para execução eficiente em hardware convencional mantendo performance clinicamente relevante.

**Características Técnicas**:
- **Faixa de Parâmetros**: 1-7 bilhões (limite prático para execução local)
- **Profundidade do Modelo**: 22-32 camadas transformer
- **Dimensões Ocultas**: 1024-4096 unidades
- **Cabeças de Atenção**: 16-64 cabeças paralelas
- **Janela de Contexto**: Até 4096-8192 tokens
- **Requisitos de Memória**: 1,5-14 GB dependendo da quantização

### 1.2 Vantagens para Edge Computing

**Privacidade e Conformidade Regulatória**:
- **Processamento Local**: Elimina transmissão de dados para nuvem
- **Conformidade LGPD/GDPR/HIPAA**: Através do processamento local
- **Proteção de PHI**: Sem dependências de APIs externas
- **Transparência Regulatória**: Requerida por FDA e EU MDR

**Eficiência Computacional**:
- **SLMs**: 1,5-14 GB VRAM, GPU consumidor única
- **LLMs**: >16 GB VRAM, múltiplas GPUs enterprise
- **Consumo Energético**: 10-100x menor que LLMs
- **Latência de Inferência**: <100ms vs >500ms para LLMs na nuvem

### 1.3 Comparação com Large Language Models

| Aspecto | SLMs | LLMs |
|---------|------|------|
| Parâmetros | 1-7B | 70-500B+ |
| Hardware Mínimo | RTX 3090 (24GB) | Múltiplas A100 |
| Latência | <100ms | >500ms |
| Custo Operacional | Hardware único | APIs recorrentes |
| Privacidade | Processamento local | Transmissão externa |
| Customização | Fine-tuning local | Limitada |

### 1.4 Requisitos de Hardware

**Dispositivos Móveis**:
- **Smartphones High-end (16GB+ RAM)**: Modelos 1-3B, 7B limitado com Q4/Q5
- **Dispositivos Mid-range (6GB RAM)**: Modelos quantizados Q5
- **Tablets/Laptops**: Modelos 7B com quantização padrão

**Edge Computing**:
- **Mínimo**: RTX 3090 (24GB) para modelos 7B
- **Otimizado**: RTX 4090, A100 ou equivalente

## 2. Arquitetura e Design de SLMs para FHIR

### 2.1 Modelos Base Recomendados

**Modelos Foundation de Propósito Geral**:

1. **Mistral-7B**
   - **Performance Médica**: Supera Llama-2 13B na maioria dos benchmarks
   - **Vantagens**: Excelente eficiência, grouped-query attention
   
2. **Llama-3-8B**
   - **Performance Médica**: Performance baseline superior
   - **Vantagens**: Capacidades superiores de raciocínio

3. **Phi-3-mini (3.8B)**
   - **Performance Médica**: 48,7% de precisão em exames médicos
   - **Vantagens**: Otimizado para raciocínio e geração de código

**Modelos Especializados em Saúde**:

1. **BioMistral-7B**: Performance superior em QA biomédico
2. **MediTron-7B**: 51,0% em benchmarks médicos
3. **Meerkat-7B**: 77,1% no MedQA (primeiro 7B a superar 60% USMLE)

### 2.2 Fine-tuning para Domínio FHIR

```python
# Fine-tuning com LoRA para modelos médicos
from peft import LoraConfig, get_peft_model, TaskType
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

def setup_medical_lora_training():
    lora_config = LoraConfig(
        task_type=TaskType.CAUSAL_LM,
        inference_mode=False,
        r=16,  # Rank otimizado para domínio médico
        lora_alpha=32,
        lora_dropout=0.1,
        target_modules=["q_proj", "v_proj", "k_proj", "o_proj"]
    )
    
    model = AutoModelForCausalLM.from_pretrained(
        "mistralai/Mistral-7B-v0.1",
        torch_dtype=torch.float16,
        device_map="auto"
    )
    
    return get_peft_model(model, lora_config)

training_args = {
    "output_dir": "./medical-mistral-7b",
    "num_train_epochs": 3,
    "per_device_train_batch_size": 4,
    "gradient_accumulation_steps": 4,
    "learning_rate": 2e-4,
    "weight_decay": 0.01,
    "evaluation_strategy": "steps",
    "eval_steps": 500
}
```

### 2.3 Técnicas de Compressão e Quantização

**Quantização GGUF**:

```python
class MedicalModelQuantizer:
    def __init__(self):
        self.quantization_levels = {
            'Q2_K': {'bits': 2, 'size_reduction': '4x', 'accuracy': '85%'},
            'Q4_0': {'bits': 4, 'size_reduction': '2.5x', 'accuracy': '95%'},
            'Q5_K_M': {'bits': 5, 'size_reduction': '2x', 'accuracy': '98%'},
            'Q8_0': {'bits': 8, 'size_reduction': '1.3x', 'accuracy': '99%'}
        }
    
    def quantize_medical_model(self, model_path, output_path, quant_type="Q5_K_M"):
        """Quantização otimizada para aplicações médicas"""
        command = f"python convert.py {model_path} --outdir {output_path} --outtype {quant_type}"
        os.system(command)
        return f"{output_path}/ggml-model-{quant_type.lower()}.gguf"
```

## 3. Preparação de Dados para Treinamento

### 3.1 Pseudoanonimização de Dados de Wearables

```python
import hashlib
import numpy as np
from datetime import datetime, timedelta
import random

class WearableDataAnonymizer:
    def __init__(self, privacy_level="high"):
        self.privacy_level = privacy_level
        self.noise_levels = {"low": 0.01, "medium": 0.05, "high": 0.1}
    
    def pseudoanonymize_patient_id(self, patient_id, salt):
        """Gera pseudônimo consistente para identificador do paciente"""
        return hashlib.sha256((patient_id + salt).encode()).hexdigest()[:16]
    
    def add_differential_privacy_noise(self, value, sensitivity=1.0, epsilon=1.0):
        """Adiciona ruído Laplaciano para privacidade diferencial"""
        noise_scale = sensitivity / epsilon
        noise = np.random.laplace(0, noise_scale)
        return value + noise
    
    def anonymize_heart_rate_data(self, hr_data):
        """Anonimiza dados de frequência cardíaca"""
        anonymized = []
        for record in hr_data:
            anon_record = {
                'patient_id': self.pseudoanonymize_patient_id(
                    record['patient_id'], "hr_salt_2024"
                ),
                'timestamp': self.temporal_perturbation(record['timestamp']),
                'heart_rate': max(60, int(self.add_differential_privacy_noise(
                    record['heart_rate'], sensitivity=5.0, epsilon=2.0
                ))),
                'activity_level': record.get('activity_level', 'unknown')
            }
            anonymized.append(anon_record)
        return anonymized
```

### 3.2 Estruturação de Dados FHIR para ML

```python
from fhir.resources.observation import Observation
from fhir.resources.patient import Patient
import json
from datetime import datetime

class FHIRMedicalDataStructurer:
    def __init__(self):
        self.lifestyle_codes = {
            'physical_activity': 'LA11834-1',
            'diet_assessment': 'LA11835-8',
            'sleep_quality': 'LA11836-6',
            'stress_level': 'LA11837-4'
        }
    
    def structure_wearable_data_to_fhir(self, wearable_data, patient_id):
        """Converte dados de wearables para recursos FHIR"""
        observations = []
        
        for data_point in wearable_data:
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

## 4. Casos de Uso Duplo: Geração e Validação FHIR

### 4.1 Geração de Texto Clínico baseado em FHIR

```python
from llama_cpp import Llama
import json

class FHIRClinicalSummaryGenerator:
    def __init__(self, model_name="biomistral-7b"):
        self.model = Llama(
            model_path=f"models/{model_name}.gguf",
            n_ctx=4096,
            n_gpu_layers=32,
            verbose=False
        )
    
    def generate_patient_summary(self, patient_bundle: dict) -> str:
        """Gera sumário do paciente baseado em bundle FHIR"""
        patient_info = self.extract_patient_info(patient_bundle)
        observations = self.extract_observations(patient_bundle)
        medications = self.extract_medications(patient_bundle)
        
        context = self.build_medical_context(patient_info, observations, medications)
        
        prompt = f"""
        Como médico especialista, gere um sumário clínico conciso baseado nas seguintes informações FHIR:
        
        {context}
        
        Sumário clínico:
        """
        
        response = self.model(
            prompt,
            max_tokens=512,
            temperature=0.1,
            top_p=0.9,
            stop=["</s>", "\n\n"]
        )
        
        return response['choices'][0]['text'].strip()
```

### 4.2 Validação Automática de Recursos FHIR

```python
from jsonschema import validate, ValidationError
import requests

class FHIRIntelligentValidator:
    def __init__(self):
        self.fhir_schemas = self.load_fhir_schemas()
        self.validation_rules = self.load_validation_rules()
    
    def validate_fhir_resource(self, resource: dict) -> tuple[bool, list[str]]:
        """Validação completa de recurso FHIR"""
        errors = []
        
        # Validação estrutural
        structural_errors = self.validate_structure(resource)
        errors.extend(structural_errors)
        
        # Validação semântica  
        semantic_errors = self.validate_semantics(resource)
        errors.extend(semantic_errors)
        
        # Validação clínica com IA
        clinical_errors = self.validate_clinical_logic(resource)
        errors.extend(clinical_errors)
        
        # Validação de terminologia
        terminology_errors = self.validate_terminology(resource)
        errors.extend(terminology_errors)
        
        is_valid = len(errors) == 0
        return is_valid, errors
```

## 5. Frameworks e Ferramentas para Implementação

### 5.1 LangChain e LlamaIndex para RAG

```python
from langchain.document_loaders import JSONLoader
from langchain.vectorstores import FAISS, Chroma
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.chains import RetrievalQA

class MedicalFHIRRAGSystem:
    def __init__(self):
        self.embeddings = HuggingFaceEmbeddings(
            model_name="sentence-transformers/all-MiniLM-L6-v2"
        )
        self.vector_store = None
        self.qa_chain = None
        
    def load_fhir_implementation_guides(self, ig_paths: list[str]):
        """Carrega Implementation Guides como base de conhecimento"""
        documents = []
        
        for ig_path in ig_paths:
            loader = JSONLoader(
                file_path=ig_path,
                jq_schema='.entry[].resource',
                text_content=False
            )
            documents.extend(loader.load())
        
        self.vector_store = FAISS.from_documents(documents, self.embeddings)
        
        self.qa_chain = RetrievalQA.from_chain_type(
            llm=self.load_local_model(),
            chain_type="stuff",
            retriever=self.vector_store.as_retriever(search_kwargs={"k": 5})
        )
    
    def query_medical_knowledge(self, question: str) -> str:
        """Consulta base de conhecimento médico"""
        return self.qa_chain.run(question)
```

### 5.2 Ollama para Execução Local

```python
class HealthcareOllamaProcessor:
    def __init__(self, model="biomistral:7b"):
        self.llm = Ollama(model=model)
        
    async def process_clinical_note(self, note):
        prompt = f"Extrair entidades médicas de: {note}"
        return await self.llm.ainvoke(prompt)
    
    def setup_local_deployment(self):
        # Instalar Ollama
        os.system("curl -fsSL https://ollama.ai/install.sh | sh")
        
        # Deploy modelos médicos
        os.system("ollama pull biomistral:7b")
        os.system("ollama pull llama3.2-3b:medical")
        os.system("ollama pull phi3:mini-medical")
```

### 5.3 MLX para Apple Silicon

```python
import mlx.core as mx
from mlx_lm import load, generate, fine_tune

def setup_mlx_medical_model():
    """Configuração MLX para modelos médicos"""
    # Carregamento de modelo médico
    model, tokenizer = load("mlx-community/BioMistral-7B-MLX")
    
    # Fine-tuning em dados clínicos
    fine_tune(
        model="biomistral-base",
        train_data="clinical_notes.jsonl",
        valid_data="validation_notes.jsonl",
        learning_rate=1e-5
    )
    
    return model, tokenizer
```

## 6. Integração com Implementation Guides

### 6.1 Uso de IGs como Knowledge Base

```python
class FHIRImplementationGuideProcessor:
    def __init__(self):
        self.ig_profiles = {}
        self.value_sets = {}
        self.code_systems = {}
    
    def load_implementation_guide(self, ig_path: str):
        """Carrega Implementation Guide FHIR"""
        with open(ig_path, 'r') as f:
            ig_data = json.load(f)
        
        # Processa profiles
        for entry in ig_data.get('entry', []):
            resource = entry.get('resource', {})
            
            if resource.get('resourceType') == 'StructureDefinition':
                self.ig_profiles[resource['id']] = resource
            
            elif resource.get('resourceType') == 'ValueSet':
                self.value_sets[resource['id']] = resource
            
            elif resource.get('resourceType') == 'CodeSystem':
                self.code_systems[resource['id']] = resource
    
    def generate_conformant_examples(self, profile_id: str, count: int = 5):
        """Gera exemplos conformes com perfis do IG"""
        profile = self.ig_profiles.get(profile_id)
        if not profile:
            return []
        
        examples = []
        for i in range(count):
            example = self.create_example_from_profile(profile)
            examples.append(example)
        
        return examples
```

### 6.2 Fine-tuning Específico para Profiles

```python
def fine_tune_on_fhir_profiles(base_model, ig_profiles, training_examples):
    """Fine-tuning específico para profiles FHIR"""
    
    # Preparação de dados de treinamento
    training_data = []
    
    for profile_id, profile in ig_profiles.items():
        # Gera exemplos de treinamento baseados no profile
        for example in training_examples.get(profile_id, []):
            training_data.append({
                "instruction": f"Gerar recurso FHIR conforme profile {profile_id}",
                "input": example['clinical_scenario'],
                "output": json.dumps(example['fhir_resource'], indent=2)
            })
    
    # Configuração de fine-tuning
    training_config = {
        "model_name": base_model,
        "train_data": training_data,
        "epochs": 3,
        "batch_size": 4,
        "learning_rate": 2e-4,
        "lora_config": {
            "r": 16,
            "lora_alpha": 32,
            "target_modules": ["q_proj", "v_proj", "k_proj", "o_proj"]
        }
    }
    
    return fine_tune_model(training_config)
```

## 7. Privacidade e Segurança em SLMs Locais

### 7.1 Federated Learning para Treinamento Distribuído

```python
class MedicalFederatedLearning:
    def __init__(self):
        self.central_server = None
        self.client_nodes = []
        self.privacy_budget = 10.0  # Epsilon para differential privacy
    
    def setup_federated_training(self, hospital_nodes):
        """Configura treinamento federado entre hospitais"""
        for node in hospital_nodes:
            client = FederatedClient(
                node_id=node['id'],
                data_path=node['data_path'],
                privacy_level=node.get('privacy_level', 'high')
            )
            self.client_nodes.append(client)
    
    def execute_federated_round(self, global_model):
        """Executa rodada de treinamento federado"""
        local_updates = []
        
        for client in self.client_nodes:
            # Treinamento local com differential privacy
            local_model = client.train_local_model(
                global_model,
                privacy_budget=self.privacy_budget / len(self.client_nodes)
            )
            
            # Secure aggregation dos gradientes
            encrypted_gradients = client.encrypt_gradients(local_model)
            local_updates.append(encrypted_gradients)
        
        # Agregação segura no servidor central
        aggregated_model = self.secure_aggregation(local_updates)
        return aggregated_model

class FederatedClient:
    def train_local_model(self, global_model, privacy_budget):
        """Treinamento local com differential privacy"""
        # Implementa DP-SGD para privacidade diferencial
        return self.dp_sgd_training(global_model, privacy_budget)
    
    def encrypt_gradients(self, model):
        """Criptografia homomórfica dos gradientes"""
        # Implementação simplificada
        return self.homomorphic_encrypt(model.gradients)
```

### 7.2 Differential Privacy Implementation

```python
import numpy as np
from opacus import PrivacyEngine

class DifferentialPrivacyMedical:
    def __init__(self, epsilon=1.0, delta=1e-5):
        self.epsilon = epsilon
        self.delta = delta
        self.privacy_engine = PrivacyEngine()
    
    def setup_dp_training(self, model, optimizer, data_loader):
        """Configura treinamento com differential privacy"""
        model, optimizer, data_loader = self.privacy_engine.make_private(
            module=model,
            optimizer=optimizer,
            data_loader=data_loader,
            noise_multiplier=1.0,
            max_grad_norm=1.0,
        )
        
        return model, optimizer, data_loader
    
    def add_calibrated_noise(self, data, sensitivity):
        """Adiciona ruído calibrado para proteção diferencial"""
        noise_scale = sensitivity / self.epsilon
        noise = np.random.laplace(0, noise_scale, data.shape)
        return data + noise
    
    def privacy_budget_tracking(self, epochs, batch_size, dataset_size):
        """Rastreia orçamento de privacidade durante treinamento"""
        steps = epochs * (dataset_size // batch_size)
        consumed_epsilon = self.calculate_epsilon_consumption(steps)
        
        if consumed_epsilon > self.epsilon:
            raise ValueError(f"Orçamento de privacidade excedido: {consumed_epsilon} > {self.epsilon}")
        
        return consumed_epsilon
```

### 7.3 Conformidade com LGPD/GDPR/HIPAA

```python
class MedicalComplianceFramework:
    def __init__(self):
        self.audit_logger = self.setup_audit_logging()
        self.consent_manager = self.setup_consent_management()
        self.data_governance = self.setup_data_governance()
    
    def ensure_lgpd_compliance(self, processing_activity):
        """Garante conformidade com LGPD"""
        compliance_checks = {
            'legal_basis': self.verify_legal_basis(processing_activity),
            'purpose_limitation': self.verify_purpose_limitation(processing_activity),
            'data_minimization': self.verify_data_minimization(processing_activity),
            'transparency': self.verify_transparency(processing_activity),
            'security': self.verify_security_measures(processing_activity)
        }
        
        return all(compliance_checks.values())
    
    def implement_right_to_explanation(self, model_decision, patient_id):
        """Implementa direito à explicação para decisões automatizadas"""
        explanation = {
            'decision': model_decision,
            'reasoning': self.generate_explanation(model_decision),
            'data_used': self.get_data_sources(patient_id),
            'confidence': self.calculate_confidence(model_decision),
            'alternatives': self.suggest_alternatives(model_decision)
        }
        
        # Log para auditoria
        self.audit_logger.log_explanation_request(patient_id, explanation)
        
        return explanation
    
    def handle_data_subject_requests(self, request_type, patient_id):
        """Processa solicitações de titulares de dados"""
        if request_type == 'access':
            return self.provide_data_access(patient_id)
        elif request_type == 'rectification':
            return self.enable_data_rectification(patient_id)
        elif request_type == 'erasure':
            return self.process_erasure_request(patient_id)
        elif request_type == 'portability':
            return self.export_patient_data(patient_id)
```

## 8. Pipeline de Treinamento Completo

### 8.1 Coleta e Preparação de Dados

```python
class MedicalDataPipeline:
    def __init__(self):
        self.anonymizer = WearableDataAnonymizer()
        self.fhir_structurer = FHIRMedicalDataStructurer()
        self.quality_checker = DataQualityChecker()
    
    def execute_data_pipeline(self, raw_data_sources):
        """Pipeline completo de processamento de dados médicos"""
        processed_data = []
        
        for source in raw_data_sources:
            # 1. Validação de qualidade
            quality_score = self.quality_checker.assess_quality(source)
            if quality_score < 0.8:
                continue
            
            # 2. Pseudoanonimização
            anonymized_data = self.anonymizer.anonymize_dataset(
                source['data'],
                privacy_level=source.get('privacy_level', 'high')
            )
            
            # 3. Estruturação FHIR
            fhir_data = self.fhir_structurer.convert_to_fhir(
                anonymized_data,
                source['data_type']
            )
            
            # 4. Validação FHIR
            validated_data = self.validate_fhir_resources(fhir_data)
            
            processed_data.extend(validated_data)
        
        return processed_data
```

### 8.2 Continuous Learning com Novos Dados

```python
class ContinuousLearningSystem:
    def __init__(self):
        self.model_registry = ModelRegistry()
        self.performance_monitor = PerformanceMonitor()
        self.trigger_conditions = self.setup_trigger_conditions()
    
    def monitor_model_performance(self, model_id):
        """Monitor contínuo de performance do modelo"""
        current_metrics = self.performance_monitor.get_current_metrics(model_id)
        baseline_metrics = self.model_registry.get_baseline_metrics(model_id)
        
        performance_drift = self.calculate_performance_drift(
            current_metrics, baseline_metrics
        )
        
        if performance_drift > self.trigger_conditions['performance_threshold']:
            self.trigger_retraining(model_id)
    
    def trigger_retraining(self, model_id):
        """Dispara retreinamento automático"""
        # 1. Coleta dados novos
        new_data = self.collect_new_training_data(model_id)
        
        # 2. Avalia necessidade de retreinamento
        retrain_needed = self.assess_retraining_need(model_id, new_data)
        
        if retrain_needed:
            # 3. Executa retreinamento
            new_model = self.retrain_model(model_id, new_data)
            
            # 4. Valida novo modelo
            validation_results = self.validate_new_model(new_model)
            
            # 5. Deploy se aprovado
            if validation_results['approved']:
                self.deploy_new_model(new_model)
```

## 9. Integração com Wearables e IoT Médico

### 9.1 APIs para Dispositivos Wearables

```python
class WearableIntegrationAPI:
    def __init__(self):
        self.device_registry = DeviceRegistry()
        self.data_processor = RealTimeDataProcessor()
        self.fhir_converter = FHIRConverter()
    
    async def receive_device_data(self, device_id: str, data_payload: dict):
        """Recebe dados de dispositivos wearables"""
        # 1. Autenticação do dispositivo
        if not self.device_registry.is_authenticated(device_id):
            raise AuthenticationError("Dispositivo não autorizado")
        
        # 2. Validação dos dados
        validated_data = self.validate_device_data(data_payload)
        
        # 3. Processamento em tempo real
        processed_data = await self.data_processor.process_realtime(
            validated_data, device_id
        )
        
        # 4. Conversão para FHIR
        fhir_observations = self.fhir_converter.convert_to_observations(
            processed_data, device_id
        )
        
        # 5. Análise por IA
        ai_insights = await self.analyze_with_ai(fhir_observations)
        
        return {
            'status': 'processed',
            'observations_created': len(fhir_observations),
            'insights': ai_insights
        }
    
    async def analyze_with_ai(self, observations):
        """Análise em tempo real com SLM"""
        insights = []
        
        for obs in observations:
            # Análise de tendências
            trend_analysis = self.analyze_trends(obs)
            
            # Detecção de anomalias
            anomalies = self.detect_anomalies(obs)
            
            # Recomendações de estilo de vida
            lifestyle_recommendations = self.generate_lifestyle_recommendations(obs)
            
            insights.append({
                'observation_id': obs['id'],
                'trends': trend_analysis,
                'anomalies': anomalies,
                'recommendations': lifestyle_recommendations
            })
        
        return insights
```

### 9.2 Processamento em Tempo Real

```python
class RealTimeHealthMonitor:
    def __init__(self):
        self.alert_thresholds = self.load_alert_thresholds()
        self.ml_models = self.load_monitoring_models()
    
    def process_streaming_data(self, data_stream):
        """Processamento de dados em streaming"""
        for data_point in data_stream:
            # Análise imediata
            immediate_alerts = self.check_immediate_alerts(data_point)
            
            # Análise por ML
            ml_predictions = self.run_ml_analysis(data_point)
            
            # Combina resultados
            combined_analysis = self.combine_analyses(
                immediate_alerts, ml_predictions
            )
            
            # Ações baseadas em resultados
            if combined_analysis['risk_level'] == 'high':
                self.trigger_emergency_alert(data_point, combined_analysis)
            elif combined_analysis['risk_level'] == 'medium':
                self.send_recommendation(data_point, combined_analysis)
            
            yield combined_analysis
```

## 10. Exemplos Práticos com Código Executável

### 10.1 Setup de Ambiente de Desenvolvimento

```bash
#!/bin/bash
# setup_medical_ai_environment.sh

# 1. Criar ambiente virtual
python -m venv medical_ai_env
source medical_ai_env/bin/activate

# 2. Instalar dependências principais
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install transformers accelerate peft
pip install fhir.resources fhirclient
pip install llama-cpp-python
pip install langchain langchain-community
pip install sentence-transformers faiss-cpu

# 3. Instalar Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# 4. Baixar modelos médicos
ollama pull biomistral:7b
ollama pull phi3:mini-medical
ollama pull llama3.2-3b:latest

# 5. Setup MLX (Apple Silicon)
if [[ $(uname -m) == "arm64" ]]; then
    pip install mlx-lm
fi

echo "Ambiente configurado com sucesso!"
```

### 10.2 Script Completo de Fine-tuning

```python
#!/usr/bin/env python3
"""
fine_tune_medical_model.py
Script completo para fine-tuning de SLM médico
"""

import json
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer, TrainingArguments, Trainer
from peft import LoraConfig, get_peft_model, TaskType
from datasets import Dataset
import argparse

def load_medical_training_data(data_path):
    """Carrega dados de treinamento médico"""
    with open(data_path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    formatted_data = []
    for example in data:
        formatted_example = {
            'text': f"### Instrução:\n{example['instruction']}\n\n### Entrada:\n{example['input']}\n\n### Resposta:\n{example['output']}<|endoftext|>"
        }
        formatted_data.append(formatted_example)
    
    return Dataset.from_list(formatted_data)

def setup_model_and_tokenizer(model_name):
    """Configura modelo e tokenizer"""
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    if tokenizer.pad_token is None:
        tokenizer.pad_token = tokenizer.eos_token
    
    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        torch_dtype=torch.float16,
        device_map="auto",
        trust_remote_code=True
    )
    
    return model, tokenizer

def setup_lora_config():
    """Configuração LoRA para domínio médico"""
    return LoraConfig(
        r=16,
        lora_alpha=32,
        target_modules=["q_proj", "v_proj", "k_proj", "o_proj"],
        lora_dropout=0.1,
        bias="none",
        task_type=TaskType.CAUSAL_LM
    )

def tokenize_dataset(dataset, tokenizer, max_length=1024):
    """Tokeniza dataset para treinamento"""
    def tokenize_function(examples):
        return tokenizer(
            examples["text"],
            truncation=True,
            padding=True,
            max_length=max_length,
            return_tensors="pt"
        )
    
    return dataset.map(tokenize_function, batched=True)

def main():
    parser = argparse.ArgumentParser(description='Fine-tune medical SLM')
    parser.add_argument('--model_name', default='mistralai/Mistral-7B-v0.1')
    parser.add_argument('--data_path', required=True)
    parser.add_argument('--output_dir', default='./medical_model_output')
    parser.add_argument('--epochs', type=int, default=3)
    parser.add_argument('--batch_size', type=int, default=4)
    parser.add_argument('--learning_rate', type=float, default=2e-4)
    
    args = parser.parse_args()
    
    print("🏥 Iniciando fine-tuning de modelo médico...")
    
    # 1. Carregamento de dados
    print("📊 Carregando dados de treinamento...")
    train_dataset = load_medical_training_data(args.data_path)
    
    # 2. Setup modelo e tokenizer
    print("🤖 Configurando modelo e tokenizer...")
    model, tokenizer = setup_model_and_tokenizer(args.model_name)
    
    # 3. Aplicar LoRA
    print("🔧 Aplicando configuração LoRA...")
    lora_config = setup_lora_config()
    model = get_peft_model(model, lora_config)
    
    # 4. Tokenização
    print("📝 Tokenizando dataset...")
    tokenized_dataset = tokenize_dataset(train_dataset, tokenizer)
    
    # 5. Configuração de treinamento
    training_args = TrainingArguments(
        output_dir=args.output_dir,
        num_train_epochs=args.epochs,
        per_device_train_batch_size=args.batch_size,
        gradient_accumulation_steps=4,
        learning_rate=args.learning_rate,
        weight_decay=0.01,
        logging_steps=10,
        save_steps=500,
        save_total_limit=2,
        remove_unused_columns=False,
        push_to_hub=False,
        report_to=None,
        fp16=True
    )
    
    # 6. Setup trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=tokenized_dataset,
        tokenizer=tokenizer
    )
    
    # 7. Treinamento
    print("🚀 Iniciando treinamento...")
    trainer.train()
    
    # 8. Salvar modelo
    print("💾 Salvando modelo...")
    trainer.save_model()
    tokenizer.save_pretrained(args.output_dir)
    
    print("✅ Fine-tuning concluído com sucesso!")

if __name__ == "__main__":
    main()
```

### 10.3 Sistema RAG Completo

```python
#!/usr/bin/env python3
"""
medical_rag_system.py
Sistema RAG completo para medicina com FHIR
"""

from langchain.document_loaders import JSONLoader, DirectoryLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.vectorstores import FAISS
from langchain.embeddings import HuggingFaceEmbeddings
from langchain.chains import RetrievalQA
from langchain.prompts import PromptTemplate
from langchain_community.llms import Ollama
import json
import os

class MedicalRAGSystem:
    def __init__(self):
        self.embeddings = HuggingFaceEmbeddings(
            model_name="sentence-transformers/all-MiniLM-L6-v2"
        )
        self.text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,
            chunk_overlap=200,
            separators=["\n\n", "\n", " ", ""]
        )
        self.vector_store = None
        self.qa_chain = None
        
    def load_fhir_documents(self, documents_dir):
        """Carrega documentos FHIR para base de conhecimento"""
        print("📚 Carregando documentos FHIR...")
        
        # Carrega JSONs FHIR
        loader = DirectoryLoader(
            documents_dir,
            glob="**/*.json",
            loader_cls=JSONLoader,
            loader_kwargs={"jq_schema": ".", "text_content": False}
        )
        
        documents = loader.load()
        print(f"📄 Carregados {len(documents)} documentos")
        
        # Split documents
        split_docs = self.text_splitter.split_documents(documents)
        print(f"✂️ Divididos em {len(split_docs)} chunks")
        
        return split_docs
    
    def build_vector_store(self, documents):
        """Constrói vector store com embeddings"""
        print("🔍 Construindo vector store...")
        
        self.vector_store = FAISS.from_documents(
            documents,
            self.embeddings
        )
        
        print("✅ Vector store construído")
    
    def setup_qa_chain(self, model_name="biomistral:7b"):
        """Configura cadeia de Q&A"""
        print(f"🤖 Configurando modelo {model_name}...")
        
        llm = Ollama(
            model=model_name,
            temperature=0.1,
            top_p=0.9
        )
        
        # Template específico para medicina
        prompt_template = """
        Você é um assistente médico especializado. Use apenas as informações fornecidas no contexto para responder.
        Se não souber a resposta com base no contexto, diga claramente que não tem informações suficientes.
        
        Contexto: {context}
        
        Pergunta: {question}
        
        Resposta médica baseada nas evidências fornecidas:
        """
        
        PROMPT = PromptTemplate(
            template=prompt_template,
            input_variables=["context", "question"]
        )
        
        self.qa_chain = RetrievalQA.from_chain_type(
            llm=llm,
            chain_type="stuff",
            retriever=self.vector_store.as_retriever(
                search_type="similarity",
                search_kwargs={"k": 5}
            ),
            chain_type_kwargs={"prompt": PROMPT}
        )
        
        print("✅ Cadeia Q&A configurada")
    
    def query(self, question):
        """Faz consulta ao sistema RAG"""
        if not self.qa_chain:
            raise ValueError("Sistema RAG não inicializado")
        
        print(f"❓ Pergunta: {question}")
        response = self.qa_chain.run(question)
        print(f"💬 Resposta: {response}")
        
        return response
    
    def save_vector_store(self, path):
        """Salva vector store"""
        if self.vector_store:
            self.vector_store.save_local(path)
            print(f"💾 Vector store salvo em {path}")
    
    def load_vector_store(self, path):
        """Carrega vector store salvo"""
        if os.path.exists(path):
            self.vector_store = FAISS.load_local(path, self.embeddings)
            print(f"📂 Vector store carregado de {path}")
        else:
            raise FileNotFoundError(f"Vector store não encontrado em {path}")

def main():
    # Inicialização do sistema
    rag_system = MedicalRAGSystem()
    
    # Configuração
    documents_dir = "./fhir_documents"
    vector_store_path = "./medical_vector_store"
    
    # Verifica se vector store existe
    if os.path.exists(vector_store_path):
        print("📂 Carregando vector store existente...")
        rag_system.load_vector_store(vector_store_path)
    else:
        print("🏗️ Construindo nova base de conhecimento...")
        # Carrega documentos
        documents = rag_system.load_fhir_documents(documents_dir)
        
        # Constrói vector store
        rag_system.build_vector_store(documents)
        
        # Salva para uso futuro
        rag_system.save_vector_store(vector_store_path)
    
    # Configura cadeia Q&A
    rag_system.setup_qa_chain()
    
    # Loop interativo
    print("\n🏥 Sistema RAG Médico Iniciado!")
    print("Digite suas perguntas médicas (ou 'sair' para encerrar):")
    
    while True:
        question = input("\n❓ Sua pergunta: ")
        
        if question.lower() in ['sair', 'exit', 'quit']:
            print("👋 Encerrando sistema...")
            break
        
        try:
            response = rag_system.query(question)
        except Exception as e:
            print(f"❌ Erro: {e}")

if __name__ == "__main__":
    main()
```

## 11. Métricas de Avaliação e Monitoramento

### 11.1 Acurácia Clínica

**Framework de Avaliação Clínica**:

```python
class ClinicalAccuracyEvaluator:
    def __init__(self):
        self.medical_benchmarks = {
            'MedQA': {'passing_score': 60, 'questions': 12723},
            'MedMCQA': {'passing_score': 50, 'questions': 194000},
            'PubMedQA': {'passing_score': 70, 'questions': 1000}
        }
    
    def evaluate_clinical_performance(self, model, benchmark='MedQA'):
        """Avalia performance clínica do modelo"""
        results = {
            'accuracy': 0,
            'precision': 0,
            'recall': 0,
            'f1_score': 0,
            'clinical_safety_score': 0
        }
        
        test_data = self.load_benchmark_data(benchmark)
        predictions = []
        
        for question in test_data:
            response = model.predict(question['question'])
            predictions.append({
                'predicted': response,
                'correct': question['correct_answer'],
                'clinical_domain': question['domain']
            })
        
        # Calcula métricas por domínio clínico
        domain_performance = self.calculate_domain_metrics(predictions)
        
        # Avalia segurança clínica
        safety_score = self.assess_clinical_safety(predictions)
        
        return {
            'overall_metrics': results,
            'domain_performance': domain_performance,
            'safety_assessment': safety_score,
            'benchmark': benchmark
        }
```

### 11.2 Performance Computacional

**Sistema de Monitoramento de Performance**:

```python
import psutil
import time
import GPUtil
from dataclasses import dataclass

@dataclass
class PerformanceMetrics:
    cpu_usage: float
    memory_usage: float
    gpu_usage: float
    gpu_memory: float
    inference_time: float
    tokens_per_second: float
    energy_consumption: float

class PerformanceMonitor:
    def __init__(self):
        self.metrics_history = []
        self.alert_thresholds = {
            'cpu_usage': 80,
            'memory_usage': 85,
            'gpu_usage': 90,
            'inference_time': 2.0
        }
    
    def monitor_inference(self, model_function, input_data):
        """Monitora métricas durante inferência"""
        # Métricas iniciais
        start_time = time.time()
        start_cpu = psutil.cpu_percent()
        start_memory = psutil.virtual_memory().percent
        
        gpu_info = GPUtil.getGPUs()[0] if GPUtil.getGPUs() else None
        start_gpu_usage = gpu_info.load * 100 if gpu_info else 0
        start_gpu_memory = gpu_info.memoryUtil * 100 if gpu_info else 0
        
        # Executa inferência
        result = model_function(input_data)
        
        # Métricas finais
        end_time = time.time()
        end_cpu = psutil.cpu_percent()
        end_memory = psutil.virtual_memory().percent
        
        end_gpu_usage = gpu_info.load * 100 if gpu_info else 0
        end_gpu_memory = gpu_info.memoryUtil * 100 if gpu_info else 0
        
        # Calcula métricas
        inference_time = end_time - start_time
        tokens_generated = len(result.split()) if isinstance(result, str) else 0
        tokens_per_second = tokens_generated / inference_time if inference_time > 0 else 0
        
        metrics = PerformanceMetrics(
            cpu_usage=(start_cpu + end_cpu) / 2,
            memory_usage=(start_memory + end_memory) / 2,
            gpu_usage=(start_gpu_usage + end_gpu_usage) / 2,
            gpu_memory=(start_gpu_memory + end_gpu_memory) / 2,
            inference_time=inference_time,
            tokens_per_second=tokens_per_second,
            energy_consumption=self.estimate_energy_consumption(
                inference_time, end_cpu, end_gpu_usage
            )
        )
        
        self.metrics_history.append(metrics)
        self.check_alerts(metrics)
        
        return result, metrics
    
    def check_alerts(self, metrics):
        """Verifica se métricas excedem limites"""
        alerts = []
        
        for metric, threshold in self.alert_thresholds.items():
            value = getattr(metrics, metric)
            if value > threshold:
                alerts.append(f"{metric}: {value:.1f}% > {threshold}%")
        
        if alerts:
            self.send_performance_alert(alerts)
    
    def generate_performance_report(self):
        """Gera relatório de performance"""
        if not self.metrics_history:
            return "Nenhum dado de performance disponível"
        
        avg_metrics = self.calculate_average_metrics()
        
        report = f"""
        📊 Relatório de Performance - Últimas {len(self.metrics_history)} inferências
        
        Métricas Médias:
        - CPU: {avg_metrics['cpu_usage']:.1f}%
        - Memória: {avg_metrics['memory_usage']:.1f}%
        - GPU: {avg_metrics['gpu_usage']:.1f}%
        - GPU Memória: {avg_metrics['gpu_memory']:.1f}%
        - Tempo de Inferência: {avg_metrics['inference_time']:.3f}s
        - Tokens/segundo: {avg_metrics['tokens_per_second']:.1f}
        - Consumo Energético: {avg_metrics['energy_consumption']:.2f}W
        """
        
        return report
```

### 11.3 Monitoramento de Bateria e Recursos Móveis

```python
class MobileResourceMonitor:
    def __init__(self):
        self.battery_history = []
        self.thermal_history = []
        self.optimization_strategies = {
            'low_battery': self.optimize_for_battery,
            'high_temperature': self.optimize_for_thermal,
            'low_memory': self.optimize_for_memory
        }
    
    def monitor_mobile_resources(self, model_inference_func):
        """Monitora recursos específicos de dispositivos móveis"""
        def wrapper(*args, **kwargs):
            # Métricas pré-inferência
            pre_battery = self.get_battery_level()
            pre_temperature = self.get_cpu_temperature()
            pre_memory = psutil.virtual_memory().percent
            
            # Executa inferência
            start_time = time.time()
            result = model_inference_func(*args, **kwargs)
            end_time = time.time()
            
            # Métricas pós-inferência
            post_battery = self.get_battery_level()
            post_temperature = self.get_cpu_temperature()
            post_memory = psutil.virtual_memory().percent
            
            # Calcula consumo
            battery_consumed = pre_battery - post_battery
            temperature_increase = post_temperature - pre_temperature
            inference_time = end_time - start_time
            
            # Registra métricas
            self.log_mobile_metrics({
                'battery_consumed': battery_consumed,
                'temperature_increase': temperature_increase,
                'inference_time': inference_time,
                'memory_peak': max(pre_memory, post_memory)
            })
            
            # Otimizações adaptativas
            self.adaptive_optimization(post_battery, post_temperature, post_memory)
            
            return result
        
        return wrapper
    
    def adaptive_optimization(self, battery, temperature, memory):
        """Otimização adaptativa baseada em recursos"""
        if battery < 20:
            self.optimization_strategies['low_battery']()
        
        if temperature > 60:  # Celsius
            self.optimization_strategies['high_temperature']()
        
        if memory > 85:
            self.optimization_strategies['low_memory']()
    
    def optimize_for_battery(self):
        """Otimizações para preservar bateria"""
        # Reduz frequência de inferência
        # Ativa quantização mais agressiva
        # Usa apenas CPU para inferência
        pass
    
    def optimize_for_thermal(self):
        """Otimizações para controle térmico"""
        # Reduz clock da GPU
        # Implementa throttling inteligente
        # Ativa cooling delays
        pass
```

## 12. Integração com Living Systematic Reviews (Preparação para SOP-009)

### 12.1 Framework de Integração Contínua com Evidências

```python
class LivingSystematicReviewIntegrator:
    def __init__(self):
        self.pubmed_api = PubMedAPI()
        self.cochrane_api = CochraneAPI()
        self.evidence_processor = EvidenceProcessor()
        self.fhir_evidence_converter = FHIREvidenceConverter()
        self.update_scheduler = UpdateScheduler()
    
    def setup_continuous_evidence_monitoring(self, topics):
        """Configura monitoramento contínuo de evidências"""
        for topic in topics:
            # Configura alertas para novos estudos
            self.setup_literature_alerts(topic)
            
            # Define cronograma de atualizações
            self.update_scheduler.schedule_topic_updates(
                topic, 
                frequency='monthly',
                callback=self.process_new_evidence
            )
    
    def process_new_evidence(self, topic, new_studies):
        """Processa novas evidências encontradas"""
        processed_evidence = []
        
        for study in new_studies:
            # 1. Screening automatizado
            if self.automated_screening(study, topic):
                # 2. Extração de dados
                extracted_data = self.extract_study_data(study)
                
                # 3. Avaliação de qualidade
                quality_score = self.assess_study_quality(extracted_data)
                
                # 4. Conversão para FHIR Evidence
                fhir_evidence = self.fhir_evidence_converter.convert_to_evidence(
                    extracted_data, quality_score
                )
                
                processed_evidence.append(fhir_evidence)
        
        # 5. Atualiza base de conhecimento
        self.update_knowledge_base(topic, processed_evidence)
        
        # 6. Retreina modelos se necessário
        if len(processed_evidence) > self.retrain_threshold:
            self.trigger_model_update(topic, processed_evidence)
    
    def create_dynamic_clinical_guidelines(self, evidence_base):
        """Cria diretrizes clínicas dinâmicas baseadas em evidências"""
        guidelines = {}
        
        for intervention in evidence_base:
            # Metanálise em tempo real
            meta_analysis = self.perform_real_time_meta_analysis(
                evidence_base[intervention]
            )
            
            # Gera recomendações
            recommendations = self.generate_recommendations(meta_analysis)
            
            # Converte para FHIR PlanDefinition
            fhir_guideline = self.create_fhir_plan_definition(
                intervention, recommendations
            )
            
            guidelines[intervention] = fhir_guideline
        
        return guidelines
```

### 12.2 Integração com Modelo de Linguagem

```python
class EvidenceAugmentedSLM:
    def __init__(self, base_model, evidence_retriever):
        self.base_model = base_model
        self.evidence_retriever = evidence_retriever
        self.evidence_cache = EvidenceCache()
    
    def generate_evidence_based_response(self, clinical_question):
        """Gera resposta baseada em evidências atuais"""
        # 1. Busca evidências relevantes
        relevant_evidence = self.evidence_retriever.search(clinical_question)
        
        # 2. Filtra por qualidade e recência
        filtered_evidence = self.filter_evidence_by_quality(
            relevant_evidence, 
            min_quality_score=0.7,
            max_age_months=24
        )
        
        # 3. Constrói contexto aumentado
        evidence_context = self.build_evidence_context(filtered_evidence)
        
        # 4. Gera resposta com modelo
        augmented_prompt = f"""
        Baseado nas seguintes evidências científicas recentes:
        
        {evidence_context}
        
        Pergunta clínica: {clinical_question}
        
        Forneça uma resposta baseada em evidências, incluindo:
        1. Recomendação principal
        2. Nível de evidência
        3. Limitações dos estudos
        4. Considerações práticas
        
        Resposta:
        """
        
        response = self.base_model.generate(
            augmented_prompt,
            max_tokens=512,
            temperature=0.1
        )
        
        # 5. Adiciona referências
        response_with_references = self.add_evidence_references(
            response, filtered_evidence
        )
        
        return response_with_references
    
    def monitor_evidence_changes(self, clinical_domain):
        """Monitora mudanças em evidências que podem afetar recomendações"""
        current_recommendations = self.get_current_recommendations(clinical_domain)
        
        # Busca novas evidências
        new_evidence = self.evidence_retriever.get_recent_evidence(
            clinical_domain,
            days=30
        )
        
        if new_evidence:
            # Avalia impacto nas recomendações atuais
            impact_assessment = self.assess_recommendation_impact(
                current_recommendations, new_evidence
            )
            
            if impact_assessment['requires_update']:
                # Gera novas recomendações
                updated_recommendations = self.update_recommendations(
                    current_recommendations, new_evidence
                )
                
                # Notifica stakeholders
                self.notify_recommendation_changes(
                    clinical_domain, 
                    updated_recommendations,
                    impact_assessment
                )
        
        return impact_assessment
```

## Conclusão e Implementação

Este SOP fornece um framework completo para implementação de Small Language Models baseados em FHIR Implementation Guides para medicina do estilo de vida. Os principais benefícios incluem:

### Benefícios Técnicos
- **Eficiência**: Modelos 7B com performance comparável a LLMs maiores
- **Privacidade**: Processamento local garantindo conformidade regulatória
- **Customização**: Fine-tuning específico para domínio médico
- **Escalabilidade**: Deploy em dispositivos móveis e edge computing

### Benefícios Clínicos
- **Precisão**: 77,1% de accuracy em avaliações médicas (MedQA)
- **Tempo Real**: Análise instantânea de dados de wearables
- **Evidências Atualizadas**: Integração com Living Systematic Reviews
- **Segurança**: Validação automática de recursos FHIR

### Próximos Passos
1. **Implementação Piloto**: Começar com caso de uso específico (ex: análise de atividade física)
2. **Validação Clínica**: Estudos comparativos com especialistas
3. **Expansão Gradual**: Adicionar novos domínios de medicina do estilo de vida
4. **Integração Completa**: Connect com sistemas EHR existentes

Este SOP estabelece a base técnica e metodológica para implementação segura, eficiente e clinicamente validada de SLMs em medicina do estilo de vida, preparando o caminho para o SOP-009 sobre Living Systematic Reviews.