// 自适应选题器
// 路径: src/pages/diagnosis/engine/question-selector.ts

import type { Question } from './types';

interface SelectorOptions {
  targetCount: number;      // 目标题数（成人MVP=20，儿童=10-15）
  preferDifficulty?: string; // 优先难度
  maxPerDimension?: number;  // 每维最大题数
}

export function selectQuestions(
  bank: Question[],
  options: SelectorOptions
): Question[] {
  const {
    targetCount = 20,
    preferDifficulty = 'medium',
    maxPerDimension = 3,
  } = options;

  // Step 1: 按维度分组
  const byDimension = new Map<string, Question[]>();
  for (const q of bank) {
    const list = byDimension.get(q.dimension) || [];
    list.push(q);
    byDimension.set(q.dimension, list);
  }

  const dimensionCount = byDimension.size;
  const perDimension = Math.ceil(targetCount / dimensionCount);

  // Step 2: 每维度选择题
  const selected: Question[] = [];
  for (const [, questions] of byDimension) {
    // 排序：medium优先 → easy次之 → hard补充
    const sorted = [...questions].sort((a, b) => {
      const order = { medium: 0, easy: 1, hard: 2 };
      return (order[a.difficulty] ?? 99) - (order[b.difficulty] ?? 99);
    });

    const picked = sorted.slice(0, Math.min(perDimension, maxPerDimension));
    selected.push(...picked);
  }

  // Step 3: 如果不足目标，补题（从各维剩余中）
  if (selected.length < targetCount) {
    const remaining = bank.filter(q => !selected.find(s => s.id === q.id));
    const shuffled = remaining.sort(() => Math.random() - 0.5);
    selected.push(...shuffled.slice(0, targetCount - selected.length));
  }

  // Step 4: 乱序返回
  return selected.sort(() => Math.random() - 0.5);
}
