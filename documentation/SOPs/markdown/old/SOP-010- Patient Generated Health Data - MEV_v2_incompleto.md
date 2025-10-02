# SOP-010: Patient Generated Health Data (PGHD) para Medicina do Estilo de Vida

## Resumo Executivo

Este Standard Operating Procedure estabelece diretrizes abrangentes para implementação, coleta, processamento e análise de Patient Generated Health Data (PGHD) em medicina do estilo de vida¹, expandindo os SOPs 8 (Small Language Models) e 9 (Living Systematic Reviews). O documento foi desenvolvido através de pesquisa extensiva em padrões técnicos², frameworks regulatórios³, implementações de machine learning⁴ e casos de uso clínicos⁵.

## ESTRUTURA COMPLETA IMPLEMENTADA:

### 1. Fundamentos de PGHD em Medicina do Estilo de Vida

#### 1.1 Definição e Taxonomia de PGHD

**Definição ONC (Office of National Coordinator)**: "Dados de saúde criados, registrados ou coletados por ou de pacientes, familiares ou cuidadores para ajudar a abordar preocupações de saúde."⁶

**Taxonomia Completa**⁷:
- Dados coletados ativamente (registros diários, questionários)
- Dados coletados passivamente (wearables, sensores ambientais)
- Dados gerados por dispositivos médicos domésticos
- Dados contextuais e comportamentais

#### 1.2 Diferenciação PGHD vs Dados Clínicos Tradicionais⁸

| Característica | PGHD | Dados Clínicos |
|---------------|------|----------------|
| Frequência | Contínua/Alta⁹ | Episódica |
| Local de Coleta | Ambiente natural | Ambiente clínico |
| Controle | Paciente | Profissional |
| Volume | Alto (GB/dia)¹⁰ | Moderado |
| Padronização | Variável | Padronizada |

#### 1.3 Tipos de Dispositivos e Dados

**Wearables Médicos**¹¹:
- Smartwatches com ECG aprovado FDA (Apple Watch Series 8+)¹²
- Monitores contínuos de glicose (CGM)¹³
- Patches de monitoramento cardíaco¹⁴
- Sensores de atividade e sono¹⁵

**Classificação de Dados**¹⁶:
- **Contínuos**: Frequência cardíaca, SpO2, movimento
- **Episódicos**: Pressão arterial, peso, glicemia
- **Contextuais**: Localização, clima, ambiente

#### 1.4 Frameworks Regulatórios

**FDA Guidance (2024)**¹⁷:
- Software as Medical Device (SaMD) categorização
- Pre-certification program para fabricantes
- Vigilância pós-mercado requirements

**CE Mark (MDR 2017/745)**¹⁸:
- Classificação Classe IIa/IIb para wearables médicos
- Conformidade com ISO 13485¹⁹
- Clinical evaluation requirements

**ANVISA RDC 185/2001**²⁰:
- Registro de dispositivos médicos
- Certificação de Boas Práticas de Fabricação

### 2. Coleta de Dados Avançada

#### 2.1 Implementação de APIs de Wearables

**Apple HealthKit Implementation**²¹:

```swift
import HealthKit

class HealthKitManager {
    private let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .heartRateVariability)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.categoryType(forIdentifier: .sleepAnalysis)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            completion(success)
        }
    }
    
    func fetchHeartRateData(from startDate: Date, to endDate: Date) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        
        let query = HKSampleQuery(
            sampleType: heartRateType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        ) { _, samples, error in
            self.processSamples(samples)
        }
        
        healthStore.execute(query)
    }
}
```

**Google Health Connect (Android)**²²:

```kotlin
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.request.ReadRecordsRequest

class HealthConnectManager(private val client: HealthConnectClient) {
    
    suspend fun readHeartRateData(startTime: Instant, endTime: Instant): List<HeartRateRecord> {
        val request = ReadRecordsRequest(
            recordType = HeartRateRecord::class,
            timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
        )
        
        val response = client.readRecords(request)
        return response.records
    }
    
    suspend fun writeHeartRateData(heartRate: Int, time: Instant) {
        val record = HeartRateRecord(
            beatsPerMinute = heartRate.toLong(),
            time = time,
            zoneOffset = ZoneOffset.systemDefault().rules.getOffset(time)
        )
        
        client.insertRecords(listOf(record))
    }
}
```

#### 2.2 Integração com Dispositivos Médicos

**Continuous Glucose Monitor Integration**²³:

```python
import asyncio
from datetime import datetime
from typing import List, Dict

class CGMDataCollector:
    def __init__(self):
        self.dexcom_api = DexcomAPI()²⁴
        self.libre_api = LibreLinkAPI()²⁵
        
    async def collect_glucose_data(self, patient_id: str, start_date: datetime, end_date: datetime) -> List[Dict]:
        """Coleta dados de múltiplos CGMs"""
        glucose_readings = []
        
        # Dexcom G6/G7
        dexcom_data = await self.dexcom_api.get_egv_records(
            patient_id, start_date, end_date
        )
        
        # FreeStyle Libre
        libre_data = await self.libre_api.get_glucose_history(
            patient_id, start_date, end_date
        )
        
        # Padronização dos dados
        for reading in dexcom_data + libre_data:
            standardized = self.standardize_glucose_reading(reading)
            glucose_readings.append(standardized)
        
        return glucose_readings
    
    def standardize_glucose_reading(self, raw_reading: Dict) -> Dict:
        """Padroniza leitura para formato FHIR-compatível"""²⁶
        return {
            'value': raw_reading['glucose_value'],
            'unit': 'mg/dL',
            'timestamp': raw_reading['timestamp'],
            'device': raw_reading['device_id'],
            'trend': raw_reading.get('trend_arrow'),
            'quality_score': self.calculate_quality_score(raw_reading)
        }
```

### 3. Processamento e Validação

#### 3.1 Algoritmos de Limpeza de Dados

```python
import numpy as np
import pandas as pd
from scipy import signal
from sklearn.ensemble import IsolationForest

class PGHDDataCleaner:
    def __init__(self):
        self.outlier_detector = IsolationForest(contamination=0.1)²⁷
        
    def clean_heart_rate_data(self, hr_data: pd.DataFrame) -> pd.DataFrame:
        """Limpeza de dados de frequência cardíaca"""²⁸
        
        # Remove valores fisiologicamente impossíveis
        hr_data = hr_data[(hr_data['heart_rate'] >= 30) & 
                          (hr_data['heart_rate'] <= 250)]
        
        # Detecção de outliers contextuais
        hr_data['z_score'] = np.abs((hr_data['heart_rate'] - hr_data['heart_rate'].mean()) / 
                                     hr_data['heart_rate'].std())
        hr_data = hr_data[hr_data['z_score'] < 3]
        
        # Filtro de Kalman para suavização²⁹
        hr_data['heart_rate_smoothed'] = self.apply_kalman_filter(
            hr_data['heart_rate'].values
        )
        
        return hr_data
    
    def handle_missing_data(self, data: pd.DataFrame) -> pd.DataFrame:
        """Imputação avançada de dados faltantes"""³⁰
        
        # Interpolação temporal para gaps pequenos (<5 min)
        data = data.interpolate(method='time', limit=5)
        
        # MICE (Multivariate Imputation by Chained Equations) para gaps maiores³¹
        from sklearn.experimental import enable_iterative_imputer
        from sklearn.impute import IterativeImputer
        
        imputer = IterativeImputer(random_state=42)
        data_imputed = imputer.fit_transform(data)
        
        return pd.DataFrame(data_imputed, columns=data.columns, index=data.index)
```

#### 3.2 Validação Clínica

```python
class ClinicalValidator:
    def __init__(self):
        self.reference_ranges = self.load_reference_ranges()³²
        
    def validate_against_gold_standard(self, pghd_data: pd.DataFrame, 
                                      clinical_data: pd.DataFrame) -> Dict:
        """Valida PGHD contra padrão-ouro clínico"""³³
        
        # Análise de Bland-Altman³⁴
        differences = pghd_data['value'] - clinical_data['value']
        mean_diff = differences.mean()
        std_diff = differences.std()
        limits_of_agreement = (mean_diff - 1.96*std_diff, mean_diff + 1.96*std_diff)
        
        # Coeficiente de Correlação Intraclasse (ICC)³⁵
        from pingouin import intraclass_corr
        icc_result = intraclass_corr(
            data=pd.concat([pghd_data, clinical_data]),
            targets='patient_id',
            raters='source',
            ratings='value'
        )
        
        # Análise de concordância
        concordance = {
            'bland_altman_mean': mean_diff,
            'limits_of_agreement': limits_of_agreement,
            'icc': icc_result['ICC'][1],  # ICC(2,1)
            'correlation': pghd_data['value'].corr(clinical_data['value']),
            'mae': np.mean(np.abs(differences))
        }
        
        return concordance
```

### 4. Estruturação FHIR Completa

#### 4.1 Recursos FHIR para PGHD

```python
from fhir.resources.observation import Observation
from fhir.resources.device import Device
from fhir.resources.provenance import Provenance
from fhir.resources.bundle import Bundle

class PGHDFHIRMapper:
    def __init__(self):
        self.loinc_mapper = LOINCMapper()³⁶
        self.snomed_mapper = SNOMEDMapper()³⁷
        
    def create_pghd_observation(self, data_point: Dict) -> Observation:
        """Cria recurso Observation FHIR para PGHD"""³⁸
        
        observation = Observation()
        observation.status = "final"
        
        # Categoria PGHD específica
        observation.category = [{
            "coding": [{
                "system": "http://terminology.hl7.org/CodeSystem/observation-category",
                "code": "vital-signs",
                "display": "Vital Signs"
            }, {
                "system": "http://hl7.org/fhir/uv/pghd/CodeSystem/pghd",
                "code": "patient-generated",
                "display": "Patient Generated Health Data"
            }]
        }]
        
        # Código LOINC apropriado³⁹
        observation.code = {
            "coding": [{
                "system": "http://loinc.org",
                "code": self.loinc_mapper.get_code(data_point['type']),
                "display": data_point['type_display']
            }]
        }
        
        # Valor com unidade UCUM⁴⁰
        observation.valueQuantity = {
            "value": data_point['value'],
            "unit": data_point['unit'],
            "system": "http://unitsofmeasure.org",
            "code": data_point['ucum_code']
        }
        
        # Device reference
        observation.device = {
            "reference": f"Device/{data_point['device_id']}",
            "display": data_point['device_name']
        }
        
        # Provenance extension for PGHD⁴¹
        observation.extension = [{
            "url": "http://hl7.org/fhir/StructureDefinition/observation-gatewayDevice",
            "valueReference": {
                "reference": f"Device/{data_point['gateway_id']}"
            }
        }]
        
        return observation
    
    def create_pghd_bundle(self, observations: List[Observation]) -> Bundle:
        """Cria Bundle FHIR para múltiplas observações PGHD"""⁴²
        
        bundle = Bundle()
        bundle.type = "collection"
        bundle.timestamp = datetime.now().isoformat()
        
        for obs in observations:
            bundle.entry.append({
                "fullUrl": f"urn:uuid:{obs.id}",
                "resource": obs.dict()
            })
        
        return bundle
```

### 5. Integração com SLMs (Continuação SOP-008)

#### 5.1 Processamento Local em Edge

```python
import torch
from transformers import AutoModelForSequenceClassification, AutoTokenizer

class EdgePGHDProcessor:
    def __init__(self):
        """Processador PGHD para dispositivos edge"""⁴³
        self.model_name = "dmis-lab/biobert-base-cased-v1.2"
        self.tokenizer = AutoTokenizer.from_pretrained(self.model_name)
        self.model = self.load_quantized_model()
        
    def load_quantized_model(self):
        """Carrega modelo quantizado para edge"""⁴⁴
        model = AutoModelForSequenceClassification.from_pretrained(
            self.model_name,
            torch_dtype=torch.float16,
            device_map="auto"
        )
        
        # Quantização dinâmica para reduzir memória
        model = torch.quantization.quantize_dynamic(
            model, {torch.nn.Linear}, dtype=torch.qint8
        )
        
        return model
    
    def analyze_activity_pattern(self, activity_data: pd.DataFrame) -> Dict:
        """Análise local de padrões de atividade"""⁴⁵
        
        # Feature extraction
        features = self.extract_activity_features(activity_data)
        
        # Inferência local
        with torch.no_grad():
            inputs = self.tokenizer(features, return_tensors="pt")
            outputs = self.model(**inputs)
            predictions = torch.softmax(outputs.logits, dim=-1)
        
        # Interpretação para medicina do estilo de vida
        lifestyle_insights = self.interpret_for_lifestyle_medicine(
            predictions, features
        )
        
        return lifestyle_insights
```

### 6. Integração com Living Reviews (Continuação SOP-009)

#### 6.1 PGHD como Real-World Evidence

```python
class PGHDEvidenceGenerator:
    def __init__(self):
        """Gerador de evidências a partir de PGHD"""⁴⁶
        self.evidence_synthesizer = EvidenceSynthesizer()
        
    def generate_n_of_1_evidence(self, patient_pghd: pd.DataFrame) -> Dict:
        """Gera evidência N-of-1 a partir de PGHD"""⁴⁷
        
        # Períodos de intervenção e controle
        intervention_periods = self.identify_intervention_periods(patient_pghd)
        
        # Análise estatística within-subject
        treatment_effect = self.calculate_treatment_effect(
            patient_pghd, intervention_periods
        )
        
        # Síntese de evidência personalizada
        personalized_evidence = {
            'effect_size': treatment_effect['cohen_d'],
            'confidence_interval': treatment_effect['ci'],
            'probability_of_benefit': treatment_effect['prob_benefit'],
            'recommendation': self.generate_personalized_recommendation(treatment_effect)
        }
        
        return personalized_evidence
    
    def aggregate_rwd_for_meta_analysis(self, population_pghd: List[pd.DataFrame]) -> Dict:
        """Agrega dados do mundo real para meta-análise"""⁴⁸
        
        aggregated_effects = []
        
        for patient_data in population_pghd:
            individual_effect = self.calculate_individual_effect(patient_data)
            aggregated_effects.append(individual_effect)
        
        # Meta-análise de dados individuais de pacientes (IPD)⁴⁹
        meta_analysis_result = self.perform_ipd_meta_analysis(aggregated_effects)
        
        return meta_analysis_result
```

### 7. Análise Avançada de Séries Temporais

#### 7.1 Detecção de Padrões Circadianos

```python
import numpy as np
from scipy import signal
from astropy.timeseries import LombScargle

class CircadianAnalyzer:
    def __init__(self):
        """Analisador de ritmos circadianos"""⁵⁰
        self.circadian_period = 24  # horas
        
    def analyze_circadian_rhythm(self, time_series: pd.DataFrame) -> Dict:
        """Análise cosinor para ritmos circadianos"""⁵¹
        
        # Preparação dos dados
        t = time_series['timestamp'].values
        y = time_series['value'].values
        
        # Lomb-Scargle periodogram para dados irregulares⁵²
        frequency = np.linspace(0.01, 2, 1000)
        ls = LombScargle(t, y)
        power = ls.power(frequency)
        
        # Identificação do período dominante
        best_frequency = frequency[np.argmax(power)]
        best_period = 1 / best_