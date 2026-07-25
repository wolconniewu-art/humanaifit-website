// 共享类型定义 — AI素养诊断引擎
// 路径: src/pages/diagnosis/engine/types.ts

// ---------- 题库 ----------

export interface Question {
  id: string;
  version: 'adult' | 'child' | 'senior';
  dimension: string;
  difficulty: 'easy' | 'medium' | 'hard';
  stem: string;
  options: QuestionOption[];
  theoreticalBasis?: string;
}

export interface QuestionOption {
  id: string;
  text: string;
  score: number;
  dimensionWeights?: Record<string, number>;
}

export interface AnswerRecord {
  questionId: string;
  selectedOption: string;
  answeredAt?: string;
}

// ---------- 评分器 ----------

export interface ScoreInput {
  questions: Question[];
  answers: AnswerRecord[];
  userInfo?: {
    age?: number;
    occupation?: string;
    industry?: string;
  };
}

export interface ScoreOutput {
  dimensions: DimensionScore[];
  overallScore?: number;
  scenarioRecommendations?: ScenarioRecommendation[];
  securityScore?: SecurityScore;
  scorerVersion: string;
  scoringTimestamp: string;
  benchmarkMeta?: BenchmarkMeta;
}

export interface DimensionScore {
  dimensionId: string;
  name: string;
  nameEn: string;
  score: number | null;
  matchLevel?: number;
  label?: 'excellent' | 'good' | 'needs_improvement' | 'recommended' | 'optional';
  scoreHistory?: number[];
  suggestions: string[];
  securityTag?: boolean;
}

export interface ScenarioRecommendation {
  scenarioId: string;
  title: string;
  matchLevel: number;
  recommended: boolean;
}

export interface SecurityScore {
  overall: number;
  breakdown: Record<string, number>;
}

export interface BenchmarkMeta {
  digCompMapping?: Record<string, string>;
  oecdEUMapping?: Record<string, string>;
  securityScore?: SecurityScore;
  percentileRank?: {
    overall: number;
    byIndustry?: Record<string, number>;
    byRole?: Record<string, number>;
  };
  updatedAt?: string;
}

// ---------- 维度定义 ----------

export interface DimensionDefinition {
  id: string;
  name: string;
  nameEn: string;
  layer: 'base' | 'advanced' | 'leadership';
  subIndicators: SubIndicator[];
}

export interface SubIndicator {
  id: string;
  name: string;
  securityTag: boolean;
  description: string;
}
