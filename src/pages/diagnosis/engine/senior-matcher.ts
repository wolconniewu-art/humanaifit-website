// SeniorMatcher — 老年人场景匹配器（需求选择模式）
// 路径: src/pages/diagnosis/engine/senior-matcher.ts

import { Scorer } from './scorer';
import type {
  ScoreInput, ScoreOutput, DimensionScore,
  DimensionDefinition, QuestionSelector, ScenarioRecommendation
} from './types';

export const SENIOR_SCENARIOS: DimensionDefinition[] = [
  {
    id: 'photo_restore', name: '修照片', nameEn: 'Photo Restoration',
    layer: 'base',
    subIndicators: [
      { id: 'SC_PH_S01', name: '修照片需求', securityTag: false, description: '有老照片想要修复' },
    ]
  },
  {
    id: 'fraud_defense', name: '防骗', nameEn: 'Fraud Defense',
    layer: 'base',
    subIndicators: [
      { id: 'SC_FR_S01', name: '防骗需求', securityTag: true, description: '担心遭遇AI电信诈骗' },
    ]
  },
  {
    id: 'health_inquiry', name: '健康查询', nameEn: 'Health Inquiry',
    layer: 'base',
    subIndicators: [
      { id: 'SC_HE_S01', name: '健康查询需求', securityTag: true, description: '用AI查药品和挂号信息' },
    ]
  },
  {
    id: 'voice_chat', name: '语音聊天', nameEn: 'Voice Chat',
    layer: 'base',
    subIndicators: [
      { id: 'SC_VO_S01', name: '语音聊天需求', securityTag: false, description: '用语音和AI聊天' },
    ]
  },
];

export class SeniorMatcher extends Scorer {
  readonly type = 'senior' as const;
  readonly version = '1.0.0';

  score(input: ScoreInput): ScoreOutput {
    // 需求选择模式：用户从4场景中选择1个
    // 不计算分数，返回匹配度

    const selectedAnswer = input.answers[0];
    if (!selectedAnswer) {
      return {
        dimensions: [],
        scenarioRecommendations: this.getDefaultRecommendations(),
        scorerVersion: this.version,
        scoringTimestamp: new Date().toISOString(),
      };
    }

    const question = input.questions.find(q => q.id === selectedAnswer.questionId);
    const option = question?.options.find(o => o.id === selectedAnswer.selectedOption);
    const selectedScore = option?.score ?? 0;

    // 根据分数判断用户对这个场景的兴趣程度
    const dimensions: DimensionScore[] = SENIOR_SCENARIOS.map(scenario => ({
      dimensionId: scenario.id,
      name: scenario.name,
      nameEn: scenario.nameEn,
      score: null,                        // 老年人不评分
      matchLevel: selectedScore / 4,       // 归一化匹配度 0-1
      label: selectedScore >= 3 ? 'recommended' : 'optional',
      suggestions: [],
    }));

    // 场景推荐
    const recommendations: ScenarioRecommendation[] = SENIOR_SCENARIOS.map(s => ({
      scenarioId: s.id,
      title: s.name,
      matchLevel: s.id === question?.dimension ? selectedScore / 4 : 0.3,
      recommended: s.id === question?.dimension && selectedScore >= 3,
    }));

    return {
      dimensions,
      scenarioRecommendations: recommendations,
      scorerVersion: this.version,
      scoringTimestamp: new Date().toISOString(),
    };
  }

  getDimensionDefinitions(): DimensionDefinition[] { return SENIOR_SCENARIOS; }
  getQuestionSelector(): QuestionSelector {
    return { selectQuestions: () => [] };
  }

  private getDefaultRecommendations(): ScenarioRecommendation[] {
    return SENIOR_SCENARIOS.map(s => ({
      scenarioId: s.id,
      title: s.name,
      matchLevel: 0.5,
      recommended: false,
    }));
  }
}
