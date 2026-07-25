// AdultScorer — 成人8维三层评分器
// 路径: src/pages/diagnosis/engine/adult-scorer.ts

import { Scorer } from './scorer';
import type {
  ScoreInput, ScoreOutput, DimensionScore,
  DimensionDefinition, SubIndicator, QuestionSelector
} from './types';

// 8维定义（Connie确认）
export const ADULT_DIMENSIONS: DimensionDefinition[] = [
  {
    id: 'ai_tool_competency', name: 'AI工具力', nameEn: 'AI Tool Competency',
    layer: 'base',
    subIndicators: [
      { id: 'D01_S01', name: 'Prompt工程', securityTag: false, description: '能否写出精准可复用的指令' },
      { id: 'D01_S02', name: '工具熟练度', securityTag: false, description: '日常使用AI的频率和工具覆盖度' },
      { id: 'D01_S03', name: '效率增益', securityTag: false, description: '用AI后任务完成效率' },
    ]
  },
  {
    id: 'data_decision', name: '数据决策力', nameEn: 'Data-Driven Decision Making',
    layer: 'base',
    subIndicators: [
      { id: 'D02_S01', name: '数据来源判断', securityTag: true, description: '判断数据来源可信度' },
      { id: 'D02_S02', name: 'AI辅助分析验证', securityTag: true, description: '检查AI分析中的逻辑和假设' },
      { id: 'D02_S03', name: '批判性吸收', securityTag: true, description: '识别偏见和不足' },
    ]
  },
  {
    id: 'workflow_design', name: '工作流设计力', nameEn: 'Workflow Design & Automation',
    layer: 'base',
    subIndicators: [
      { id: 'D03_S01', name: '流程拆解', securityTag: false, description: '分解工作为人适合的和AI适合的' },
      { id: 'D03_S02', name: '自动化思维', securityTag: false, description: '识别重复性任务并自动化' },
      { id: 'D03_S03', name: 'Agent编排', securityTag: false, description: '协调多工具完成复杂任务链' },
    ]
  },
  {
    id: 'ai_creativity', name: 'AI创造力', nameEn: 'AI-Assisted Creativity',
    layer: 'advanced',
    subIndicators: [
      { id: 'D04_S01', name: 'AI辅助创作', securityTag: false, description: '突破个人创作瓶颈' },
      { id: 'D04_S02', name: '人机创新迭代', securityTag: false, description: '多轮对话产生远超个人水平的成果' },
      { id: 'D04_S03', name: '多模态表达', securityTag: false, description: '组合文字/图像/数据' },
    ]
  },
  {
    id: 'ai_judgment', name: 'AI判断力', nameEn: 'AI Judgment & Critical Evaluation',
    layer: 'advanced',
    subIndicators: [
      { id: 'D05_S01', name: '可信度评估', securityTag: true, description: '判断AI回答是否可靠' },
      { id: 'D05_S02', name: '错误识别', securityTag: true, description: '发现事实错误和逻辑谬误' },
      { id: 'D05_S03', name: '伦理审慎', securityTag: true, description: '识别偏见/隐私/版权风险' },
    ]
  },
  {
    id: 'human_ai_collab', name: '人机协作力', nameEn: 'Human-AI Collaboration',
    layer: 'advanced',
    subIndicators: [
      { id: 'D06_S01', name: '任务分配', securityTag: false, description: '判断什么交给AI、什么留着给人' },
      { id: 'D06_S02', name: 'AI沟通', securityTag: false, description: '通过对话纠偏和迭代' },
      { id: 'D06_S03', name: '冲突管理', securityTag: true, description: '方向有误时有效纠正' },
    ]
  },
  {
    id: 'ai_strategy', name: 'AI策略力', nameEn: 'AI Strategic Thinking',
    layer: 'leadership',
    subIndicators: [
      { id: 'D07_S01', name: '行业洞察', securityTag: false, description: '判断AI对行业的影响程度' },
      { id: 'D07_S02', name: '趋势判断', securityTag: false, description: '区分炒作和实质性变革' },
      { id: 'D07_S03', name: '战略应用', securityTag: false, description: 'AI趋势转化为业务方案' },
    ]
  },
  {
    id: 'ai_self_awareness', name: 'AI元认知', nameEn: 'AI Self-Awareness',
    layer: 'leadership',
    subIndicators: [
      { id: 'D08_S01', name: '自我觉察', securityTag: false, description: '准确评估自己的AI能力水平' },
      { id: 'D08_S02', name: '策略调适', securityTag: false, description: '灵活选择人机分工策略' },
      { id: 'D08_S03', name: '学习规划', securityTag: false, description: '识别短板并制定改进路径' },
    ]
  },
];

export class AdultScorer extends Scorer {
  readonly type = 'adult' as const;
  readonly version = '1.0.0';

  score(input: ScoreInput): ScoreOutput {
    const dimensionScores: Record<string, { total: number; weight: number }> = {};

    // 初始化每个维度的得分
    for (const dim of ADULT_DIMENSIONS) {
      dimensionScores[dim.id] = { total: 0, weight: 0 };
    }

    // 逐题累加得分
    for (const question of input.questions) {
      const answer = input.answers.find(a => a.questionId === question.id);
      if (!answer) continue;

      const option = question.options.find(o => o.id === answer.selectedOption);
      if (!option) continue;

      const weight = this.getDifficultyWeight(question.difficulty);
      const dimId = question.dimension;

      if (dimensionScores[dimId]) {
        dimensionScores[dimId].total += option.score * weight;
        dimensionScores[dimId].weight += 4 * weight; // 4 = 最高得分
      }

      // 支持多维度映射
      if (option.dimensionWeights) {
        for (const [otherDim, otherWeight] of Object.entries(option.dimensionWeights)) {
          if (dimensionScores[otherDim]) {
            dimensionScores[otherDim].total += option.score * otherWeight;
            dimensionScores[otherDim].weight += 4 * otherWeight;
          }
        }
      }
    }

    // 计算各维度归一化得分 + 建议
    const dimensions: DimensionScore[] = ADULT_DIMENSIONS.map(dim => {
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
        suggestions: this.getSuggestions(dim.id, score),
        securityTag: dim.subIndicators.some(s => s.securityTag),
      };
    });

    // 总分为各维度平均
    const overallScore = Math.round(
      dimensions.reduce((sum, d) => sum + (d.score ?? 0), 0) / dimensions.length
    );

    return {
      dimensions,
      overallScore,
      scorerVersion: this.version,
      scoringTimestamp: new Date().toISOString(),
    };
  }

  getDimensionDefinitions(): DimensionDefinition[] {
    return ADULT_DIMENSIONS;
  }

  getQuestionSelector(): QuestionSelector {
    // 自适应选题：每个维度2-3题，优先medium
    return {
      selectQuestions: (bank, count) => {
        // 实现见 question-selector.ts
        return [];
      },
    };
  }

  private getSuggestions(dimId: string, score: number): string[] {
    if (score >= 76) return ['继续保持', '可以尝试教别人'];
    if (score >= 56) return ['每周用1次相关任务', '记录每次的使用心得'];
    return ['从最简单的操作开始', '每天完成1个小任务'];
  }
}

export interface QuestionSelector {
  selectQuestions(bank: any[], count: number): any[];
}
