// Scorer 抽象基类 — AI素养诊断引擎
// 路径: src/pages/diagnosis/engine/scorer.ts

import type { ScoreInput, ScoreOutput, DimensionDefinition, QuestionSelector } from './types';

export abstract class Scorer {
  abstract readonly type: 'adult' | 'child' | 'senior';
  abstract readonly version: string;

  // 核心评分方法（子类实现）
  abstract score(input: ScoreInput): ScoreOutput;

  // 维度定义
  abstract getDimensionDefinitions(): DimensionDefinition[];

  // 题库路由策略
  abstract getQuestionSelector(): QuestionSelector;

  // 辅助：题目分数归一化 (0-100)
  protected normalizeScore(
    rawScore: number,
    maxScore: number,
    minScore: number = 0
  ): number {
    if (maxScore === minScore) return 50;
    return Math.round(((rawScore - minScore) / (maxScore - minScore)) * 100);
  }

  // 辅助：难度权重映射
  protected getDifficultyWeight(difficulty: string): number {
    switch (difficulty) {
      case 'easy': return 1.0;
      case 'medium': return 1.5;
      case 'hard': return 2.0;
      default: return 1.0;
    }
  }

  // 辅助：分数到标签映射
  protected scoreToLabel(score: number): 'excellent' | 'good' | 'needs_improvement' {
    if (score >= 76) return 'excellent';
    if (score >= 56) return 'good';
    return 'needs_improvement';
  }
}
