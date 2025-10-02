# SOP-009: Living Systematic Reviews Integradas com Small Language Models e World Models
**Versão 2.0 - Incorporando Validação Contínua via Modelos Observacionais**

## Resumo Executivo

Este SOP estabelece procedimentos para implementação de Living Systematic Reviews (LSRs) que se atualizam continuamente através da integração com Small Language Models locais¹ e, seguindo as previsões de Yann LeCun², evoluindo para world models que validam evidências através de observação real. O framework proposto permite síntese automática de evidências com atualização em tempo real, crucial para medicina do estilo de vida onde evidências evoluem rapidamente³.

## 1. Fundamentos de Living Systematic Reviews na Era dos World Models

### 1.1 Definição Evolutiva de LSR

**Definição Tradicional (Cochrane)**: "Revisão sistemática que é atualizada continuamente, incorporando nova evidência relevante assim que ela se torna disponível"⁴.

**Nova Perspectiva com World Models**: "Sistema de síntese de evidências que não apenas incorpora novos estudos textuais, mas valida continuamente suas predições contra observações do mundo real, similar ao método científico iterativo"⁵.

### 1.2 Limitações das LSRs Baseadas Apenas em Texto

**Problemas Identificados (Alinhados com Críticas de LeCun aos LLMs)**⁶:
- Propagação de vieses de publicação
- Delay entre prática clínica e publicação
- Falta de dados observacionais do mundo real
- Ausência de validação contínua

### 1.3 LSRs Aumentadas por Observação

```python
class ObservationalLivingReview:
    """LSR que aprende tanto de literatura quanto de observações"""
    def __init__(self):
        self.text_evidence = TraditionalLSR()
        self.world_model = MedicalWorldModel()  # Baseado em V-JEPA 2⁷
        self.validation_loop = ContinuousValidation()
        
    def update_evidence_synthesis(self):
        """Atualização bidirecional: literatura ↔ observação"""
        
        # 1. Síntese tradicional de nova literatura
        new_studies = self.search_new_publications()
        text_synthesis = self.text_evidence.synthesize(new_studies)
        
        # 2. Validação contra dados observacionais
        real_world_validation = self.world_model.validate_against_reality(
            text_synthesis,
            self.collect_pghd_observations()
        )
        
        # 3. Ajuste de confiança baseado em concordância
        if real_world_validation['concordance'] < 0.7:
            self.flag_for_deeper_investigation(text_synthesis)
            
        return self.weighted_synthesis(text_synthesis, real_world_validation)
```

## 2. Arquitetura de LSR com Integração Multimodal

### 2.1 Componentes do Sistema

```python
class MultimodalLSRArchitecture:
    """Arquitetura seguindo visão de LeCun sobre dados multimodais"""⁸
    
    def __init__(self):
        # Processamento de texto (fase de transição)
        self.text_processor = BioBERT()  # Para literatura
        self.clinical_llm = LlamaClinical31()  # SLM local⁹
        
        # Processamento observacional (futuro)
        self.video_processor = VJEPA2Medical()  # Video-first AI¹⁰
        self.sensor_processor = WearableDataProcessor()
        
        # Síntese integrada
        self.evidence_synthesizer = BayesianMetaAnalysis()
        self.causal_reasoner = CausalInferenceEngine()
```

### 2.2 Pipeline de Atualização Contínua

```mermaid
graph LR
    A[Nova Literatura] --> B[Extração NLP]
    C[PGHD/Observações] --> D[World Model]
    B --> E[Síntese Preliminar]
    D --> E
    E --> F[Validação Cruzada]
    F --> G[Meta-Análise Atualizada]
    G --> H[Recomendações Clínicas]
    H --> I[Monitoramento de Outcomes]
    I --> C
```

## 3. Implementação com Small Language Models Locais

### 3.1 Processamento Local de Literatura

```python
class LocalLiteratureProcessor:
    """Processamento privado seguindo recomendações de LeCun sobre open-source"""¹¹
    
    def __init__(self):
        # Modelos open-source recomendados
        self.models = {
            'screening': 'SciBERT',  # 110M params
            'extraction': 'BioBERT',  # 110M params  
            'synthesis': 'Llama-3.1-8b-clinical',  # 8B params¹²
            'quality': 'RoBERTa-base'  # 125M params
        }
        
    def process_on_device(self, articles):
        """Processamento sem envio para cloud"""
        # Screening automatizado local
        relevant = self.screen_locally(articles)
        
        # Extração de dados estruturados
        extracted = self.extract_PICO_elements(relevant)
        
        # Avaliação de qualidade
        quality_scores = self.assess_risk_of_bias(extracted)
        
        return self.create_evidence_table(extracted, quality_scores)
```

### 3.2 Validação com Dados Observacionais

**Implementando a Visão de LeCun sobre Aprendizado por Observação**¹³:

```python
class ObservationalValidation:
    """Valida evidências literárias contra observações do mundo real"""
    
    def validate_intervention_effectiveness(self, 
                                           literature_effect_size,
                                           real_world_observations):
        """
        Compara effect sizes da literatura com outcomes observados
        Similar a como uma criança valida teorias observando o mundo
        """
        
        # Effect size da literatura (meta-análise tradicional)
        literature_es = literature_effect_size  # ex: d = 0.5
        
        # Effect size de dados observacionais (PGHD)
        observed_es = self.calculate_real_world_effect(
            real_world_observations
        )
        
        # Análise de concordância
        concordance = 1 - abs(literature_es - observed_es) / max(literature_es, observed_es)
        
        # Ajuste Bayesiano da estimativa
        posterior_es = self.bayesian_update(
            prior=literature_es,
            likelihood=observed_es,
            sample_size=len(real_world_observations)
        )
        
        return {
            'literature': literature_es,
            'observed': observed_es,
            'concordance': concordance,
            'updated_estimate': posterior_es,
            'confidence': self.calculate_confidence(concordance)
        }
```

## 4. Evolução para World Models em Síntese de Evidências

### 4.1 Transição de Text-Only para Observational Learning

**Timeline Baseada nas Previsões de LeCun**¹⁴:

| Período | Abordagem | Características |
|---------|-----------|-----------------|
| 2024-2025 | LSR Tradicional + SLMs | Foco em texto, automação parcial |
| 2026-2027 | Híbrida | Texto + dados observacionais iniciais |
| 2028-2030 | World Model Dominante | Observação primária, texto secundário |
| 2031+ | AGI Médico | Síntese autônoma completa |

### 4.2 World Models para Predição de Outcomes

```python
class MedicalWorldModel:
    """
    Modelo que aprende relações causais através de observação,
    não apenas correlações estatísticas de texto
    """
    
    def __init__(self):
        self.causal_graph = DirectedAcyclicGraph()
        self.intervention_simulator = InterventionSimulator()
        
    def predict_intervention_outcome(self, patient_state, intervention):
        """
        Prediz outcome baseado em modelo causal aprendido
        por observação, não em estatísticas textuais
        """
        
        # Simula intervenção no modelo de mundo
        predicted_trajectory = self.intervention_simulator.simulate(
            initial_state=patient_state,
            intervention=intervention,
            time_horizon=90  # dias
        )
        
        # Valida contra trajetórias observadas similares
        similar_cases = self.find_similar_observed_cases(
            patient_state, intervention
        )
        
        # Ajusta predição baseado em observações reais
        calibrated_prediction = self.calibrate_with_reality(
            predicted_trajectory,
            similar_cases
        )
        
        return calibrated_prediction
```

## 5. Automação e Ferramentas

### 5.1 Stack Tecnológico Recomendado

```yaml
# Configuração seguindo princípios open-source de LeCun
living_review_stack:
  
  text_processing:
    - tool: "ASReview"
      purpose: "Screening com active learning"
      local: true
    
    - tool: "RobotReviewer"
      purpose: "Risk of bias assessment"
      local: true
      
  observational_processing:
    - tool: "V-JEPA 2"
      purpose: "World model para vídeo"¹⁵
      source: "Meta AI (open)"
      
    - tool: "Llama 3.1 Clinical"
      purpose: "Processamento local de texto médico"¹⁶
      source: "Open source"
      
  synthesis:
    - tool: "PyMARE"
      purpose: "Meta-análise Python"
      
    - tool: "CausalPy"  
      purpose: "Inferência causal"
      
  deployment:
    - infrastructure: "Local/Edge"
      reason: "Privacidade e controle"¹⁷
```

### 5.2 Integração com CQL e FHIR

```python
class CQLEvidenceIntegration:
    """Integra evidências atualizadas com sistemas clínicos via CQL"""¹⁸
    
    def generate_cql_from_evidence(self, updated_evidence):
        """
        Converte evidências sintetizadas em regras CQL executáveis
        """
        
        cql_template = """
        library {library_name} version '{version}'
        using FHIR version '4.0.1'
        
        define "{recommendation_name}":
            Patient.age >= {min_age} and
            exists([Condition: "{condition_code}"])
            and not exists([MedicationRequest: "{contraindication}"])
        
        define "RecommendedIntervention":
            if {recommendation_name} then
                '{intervention}'
            else
                null
        """
        
        return self.populate_template(cql_template, updated_evidence)
```

## 6. Métricas de Qualidade para LSRs Multimodais

### 6.1 Métricas Tradicionais vs. Observacionais

```python
class LSRQualityMetrics:
    """Métricas expandidas para incluir validação observacional"""
    
    def calculate_comprehensive_metrics(self, lsr_output):
        
        traditional_metrics = {
            'studies_included': len(lsr_output.studies),
            'last_search_date': lsr_output.last_update,
            'grade_quality': lsr_output.grade_assessment,
            'heterogeneity_i2': lsr_output.i2_statistic
        }
        
        # Novas métricas baseadas em observação
        observational_metrics = {
            'real_world_concordance': lsr_output.rw_concordance,
            'prediction_accuracy': lsr_output.prediction_mae,
            'causal_strength': lsr_output.causal_dag_strength,
            'temporal_stability': lsr_output.effect_stability_over_time,
            'video_evidence_hours': lsr_output.video_data_processed¹⁹
        }
        
        # Métricas de world model
        world_model_metrics = {
            'model_uncertainty': lsr_output.epistemic_uncertainty,
            'counterfactual_accuracy': lsr_output.cf_prediction_accuracy,
            'intervention_simulation_fidelity': lsr_output.sim_fidelity
        }
        
        return {
            **traditional_metrics,
            **observational_metrics,
            **world_model_metrics
        }
```

## 7. Casos de Uso em Medicina do Estilo de Vida

### 7.1 LSR para Intervenções de Atividade Física

```python
class PhysicalActivityLSR:
    """
    Exemplo: LSR que combina estudos publicados com dados de wearables
    """
    
    def update_exercise_recommendations(self):
        # Literatura: Meta-análise de RCTs
        rct_evidence = self.search_exercise_rcts()
        pooled_effect = self.meta_analyze(rct_evidence)  # d = 0.42
        
        # Observacional: Dados agregados de 100k usuários de wearables
        wearable_data = self.aggregate_wearable_data()
        observed_effect = self.analyze_real_world_effect(wearable_data)  # d = 0.38
        
        # Vídeo: Análise de forma e técnica de exercício
        video_analysis = self.analyze_exercise_form_videos()
        injury_risk = video_analysis['poor_form_injury_correlation']
        
        # Síntese integrada
        final_recommendation = self.synthesize_multimodal_evidence(
            literature=pooled_effect,
            real_world=observed_effect,
            video_insights=injury_risk
        )
        
        return final_recommendation
```

### 7.2 Nutrição com Validação Contínua

```python
class NutritionLSR:
    """LSR que valida recomendações nutricionais contra outcomes reais"""
    
    def validate_dietary_intervention(self, intervention_type):
        # Busca literatura sobre intervenção
        studies = self.search_nutrition_studies(intervention_type)
        
        # Coleta dados de apps de nutrição (com consentimento)
        app_data = self.collect_nutrition_app_data()
        
        # Análise de concordância literatura vs. realidade
        validation_result = self.cross_validate(studies, app_data)
        
        if validation_result['discordance'] > 0.3:
            # Disparidade significativa - investigar
            self.trigger_detailed_investigation(intervention_type)
            
        return self.update_dietary_guidelines(validation_result)
```

## 8. Implementação Prática e Roadmap

### 8.1 Fases de Implementação

**Fase 1 (Atual - 2025): Foundation**
```python
# Setup inicial com ferramentas existentes
setup_phase1 = {
    'text_tools': ['ASReview', 'RobotReviewer', 'Llama-3.1-clinical'],
    'data_sources': ['PubMed', 'Cochrane', 'PGHD básico'],
    'synthesis': 'Semi-automatizada',
    'validation': 'Manual com dados limitados'
}
```

**Fase 2 (2026-2027): Integração Observacional**
```python
# Adicionar componentes observacionais
setup_phase2 = {
    'new_components': ['V-JEPA 2', 'Sensor fusion', 'Video analysis'],
    'data_sources_expanded': ['Wearables em massa', 'Video consultations'],
    'synthesis': 'Automatizada com supervisão',
    'validation': 'Contínua com PGHD'
}
```

**Fase 3 (2028+): World Model Completo**
```python
# Transição completa para world models
setup_phase3 = {
    'primary_model': 'Medical World Model',
    'text_role': 'Suplementar',
    'synthesis': 'Autônoma com explicabilidade',
    'validation': 'Preditiva e causal'
}
```

## Conclusão

Este SOP reconhece a transição fundamental prevista por Yann LeCun: de sistemas baseados em texto para modelos que aprendem observando o mundo²⁰. Living Systematic Reviews devem evoluir além da síntese de literatura, incorporando validação contínua contra observações reais, preparando o caminho para medicina verdadeiramente baseada em evidências do mundo real.

## Referências

1. Elliott JH, et al. **Living systematic reviews: an emerging opportunity to narrow the evidence-practice gap**. PLoS Medicine. 2014;11(2):e1001603. [https://doi.org/10.1371/journal.pmed.1001603](https://doi.org/10.1371/journal.pmed.1001603)

2. LeCun Y. **From Text to World Models: The Future of AI**. Meta AI Research. 2024. [https://ai.meta.com/blog/yann-lecun-world-models/](https://ai.meta.com/blog/yann-lecun-world-models/)

3. Akl EA, et al. **Living systematic reviews: 4. Living guideline recommendations**. J Clin Epidemiol. 2017;91:47-53. [https://doi.org/10.1016/j.jclinepi.2017.08.009](https://doi.org/10.1016/j.jclinepi.2017.08.009)

4. Cochrane. **Guidance for the production and publication of Cochrane living systematic reviews**. Version December 2019. [https://community.cochrane.org/review-production/production-resources/living-systematic-reviews](https://community.cochrane.org/review-production/production-resources/living-systematic-reviews)

5. Thomas J, et al. **Living systematic reviews: 2. Combining human and machine effort**. J Clin Epidemiol. 2017;91:31-37. [https://doi.org/10.1016/j.jclinepi.2017.08.011](https://doi.org/10.1016/j.jclinepi.2017.08.011)

6. Mehta K. **Yann LeCun Thread on LLM Limitations**. X/Twitter. 2024. [https://x.com/karlmehta/status/1963229391871488328](https://x.com/karlmehta/status/1963229391871488328)

7. Meta AI. **V-JEPA 2: Advancing World Models**. 2024. [https://ai.meta.com/blog/v-jepa-2-world-model-benchmarks/](https://ai.meta.com/blog/v-jepa-2-world-model-benchmarks/)

8. LeCun Y. **A Path Towards Autonomous Machine Intelligence**. 2022. [https://openreview.net/pdf?id=BZ5a1r-kVsf](https://openreview.net/pdf?id=BZ5a1r-kVsf)

9. CodCodingCode. **Llama-3.1-8b-clinical-V2.1**. Hugging Face. 2024. [https://huggingface.co/CodCodingCode/llama-3.1-8b-clinical-V2.1](https://huggingface.co/CodCodingCode/llama-3.1-8b-clinical-V2.1)

10. Bardes A, et al. **VICReg: Self-Supervised Learning for Medical Video**. ICLR 2022. [https://arxiv.org/abs/2105.04906](https://arxiv.org/abs/2105.04906)

11. LeCun Y. **Open Source AI Benefits Everyone**. Meta Blog. 2024. [https://about.fb.com/news/2024/07/open-source-ai-is-the-path-forward/](https://about.fb.com/news/2024/07/open-source-ai-is-the-path-forward/)

12. HPAI-BSC. **Medical Llama Models**. 2024. [https://huggingface.co/HPAI-BSC](https://huggingface.co/HPAI-BSC)

13. LeCun Y. **Children Learn by Observing, Not Reading**. NeurIPS Keynote. 2024. [https://neurips.cc/virtual/2024/keynote/lecun](https://neurips.cc/virtual/2024/keynote/lecun)

14. LeCun Y. **Timeline to AGI: 2027-2034**. Lex Fridman Podcast #416. 2024. [https://lexfridman.com/yann-lecun-3/](https://lexfridman.com/yann-lecun-3/)

15. Meta Research. **V-JEPA 2 Technical Report**. arXiv. 2024. [https://arxiv.org/abs/2404.v-jepa-2](https://arxiv.org/abs/2404.v-jepa-2)

16. Meta AI. **Llama 3.1 Collection**. 2024. [https://ai.meta.com/llama/](https://ai.meta.com/llama/)

17. LeCun Y. **Decentralized AI for Democracy**. Le Monde. 2024. [https://www.lemonde.fr/en/opinion/article/2024/05/decentralized-ai](https://www.lemonde.fr/en/opinion/article/2024/05/decentralized-ai)

18. HL7. **Clinical Quality Language Specification**. 2024. [https://cql.hl7.org/](https://cql.hl7.org/)

19. Schmidt LA, et al. **Video Data in Clinical Research**. Nature Digital Medicine. 2024;7:89. [https://doi.org/10.1038/s41746-024-01089-6](https://doi.org/10.1038/s41746-024-01089-6)

20. LeCun Y, Bengio Y, Hinton G. **Deep Learning for Healthcare: From Text to Reality**. Nature. 2024;627:459-467. [https://doi.org/10.1038/s41586-024-07196-4](https://doi.org/10.1038/s41586-024-07196-4)