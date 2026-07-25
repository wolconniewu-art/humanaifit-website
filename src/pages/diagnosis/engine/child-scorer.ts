// ChildScorer — 儿童5维评分器
// 路径: src/pages/diagnosis/engine/child-scorer.ts

import { Scorer } from './scorer';
import type {
  ScoreInput, ScoreOutput, DimensionScore,
  DimensionDefinition, QuestionSelector, Question
} from './types';

export const CHILD_DIMENSIONS: DimensionDefinition[] = [
  {
    id: 'cognitive_core', name: '认知核心', nameEn: 'Cognitive Core',
    layer: 'base',
    subIndicators: [
      { id: 'CC_CO_S01', name: 'AI理解力', securityTag: false, description: '孩子对AI能做什么不能做什么的基本认知' },
      { id: 'CC_CO_S02', name: 'AI学习策略', securityTag: false, description: '使用AI辅助学习的策略意识' },
      { id: 'CC_CO_S03', name: 'AI输出判断', securityTag: false, description: '对AI输出准确性有基本怀疑意识' },
    ]
  },
  {
    id: 'practice_innovation', name: '实践创新', nameEn: 'Practice & Innovation',
    layer: 'base',
    subIndicators: [
      { id: 'CC_PR_S01', name: 'AI工具使用意愿', securityTag: false, description: '遇到困难时主动用AI工具的意识' },
      { id: 'CC_PR_S02', name: '人机共创意识', securityTag: false, description: '理解AI输出是起点而非终点' },
    ]
  },
  {
    id: 'social_emotion', name: '社会情感', nameEn: 'Social & Emotional',
    layer: 'base',
    subIndicators: [
      { id: 'CC_SO_S01', name: 'AI伦理判断', securityTag: false, description: '使用AI时的道德判断' },
      { id: 'CC_SO_S02', name: '人机关系认知', securityTag: false, description: '区分AI的拟人化表达与真实人际关系的差异' },
    ]
  },
  {
    id: 'aesthetic_humanity', name: '审美人文', nameEn: 'Aesthetic & Humanity',
    layer: 'base',
    subIndicators: [
      { id: 'CC_AE_S01', name: 'AI创作差异感知', securityTag: false, description: '理解AI创作与人类创作的本质差异' },
      { id: 'CC_AE_S02', name: '创意主导意识', securityTag: false, description: '在AI辅助创作中保持自己的创意主导权' },
    ]
  },
  {
    id: 'digital_basics', name: '数字基础', nameEn: 'Digital Basics',
    layer: 'base',
    subIndicators: [
      { id: 'CC_DI_S01', name: '版权意识', securityTag: true, description: '知道AI生成内容可能有版权限制' },
      { id: 'CC_DI_S02', name: '安全识别', securityTag: true, description: '识别以AI为幌子的网络诈骗' },
    ]
  },
];

export class ChildScorer extends Scorer {
  readonly type = 'child' as const;
  readonly version = '1.0.0';

  score(input: ScoreInput): ScoreOutput {
    const dimensionScores: Record<string, { total: number; weight: number }> = {};
    for (const dim of CHILD_DIMENSIONS) {
      dimensionScores[dim.id] = { total: 0, weight: 0 };
    }

    for (const question of input.questions) {
      const answer = input.answers.find(a => a.questionId === question.id);
      if (!answer) continue;

      const option = question.options.find(o => o.id === answer.selectedOption);
      if (!option) continue;

      const weight = this.getDifficultyWeight(question.difficulty);
      const dimId = question.dimension;
      if (dimensionScores[dimId]) {
        dimensionScores[dimId].total += option.score * weight;
        dimensionScores[dimId].weight += 4 * weight;
      }
    }

    const dimensions: DimensionScore[] = CHILD_DIMENSIONS.map(dim => {
      const raw = dimensionScores[dim.id];
      const score = raw && raw.weight > 0
        ? this.normalizeScore(raw.total, raw.weight)
        : 0;

      return {
        dimensionId: dim.id,
        name: dim.name,
        nameEn: dim.nameEn,
        score,
        label: this.scoreToLabel(score),
        suggestions: this.getChildSuggestions(dim.id, score),
        securityTag: dim.subIndicators.some(s => s.securityTag),
      };
    });

    return {
      dimensions,
      overallScore: Math.round(dimensions.reduce((s, d) => s + (d.score ?? 0), 0) / dimensions.length),
      scorerVersion: this.version,
      scoringTimestamp: new Date().toISOString(),
    };
  }

  getDimensionDefinitions(): DimensionDefinition[] { return CHILD_DIMENSIONS; }
  getQuestionSelector(): QuestionSelector {
    return { selectQuestions: (_bank: Question[], _count: number) => [] };
  }

  private getChildSuggestions(dimId: string, score: number): string[] {
    if (score >= 76) return ['继续保持！', '可以教别的同学了'];
    if (score >= 56) return ['多和爸妈一起用AI探索', '遇到不会的可以多问问AI'];
    return ['从每天一个AI小任务开始', '和爸妈一起学会更简单'];
  }
}
