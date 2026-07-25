// API路由 — 开始诊断（三版本）
// 路径: src/pages/diagnosis/api/start.ts

export const prerender = false;

import type { APIRoute } from 'astro';
import { AdultScorer } from '../engine/adult-scorer';
import { ChildScorer } from '../engine/child-scorer';
import { SeniorMatcher } from '../engine/senior-matcher';
import { selectQuestions } from '../engine/question-selector';
import adultBank from '../data/adult_questions.json';
import childBank from '../data/child_questions.json';
import seniorBank from '../data/senior_scenarios.json';

export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();
  const { userId, type, userInfo } = body;

  let scorer;
  let bank;
  let targetCount = 20;
  let estimatedMinPerQ = 0.9;

  switch (type) {
    case 'adult':
      scorer = new AdultScorer();
      bank = adultBank;
      break;
    case 'child':
      scorer = new ChildScorer();
      bank = childBank;
      targetCount = 10;
      estimatedMinPerQ = 0.7;
      break;
    case 'senior':
      scorer = new SeniorMatcher();
      bank = seniorBank;
      targetCount = 4;   // 4场景单选题
      estimatedMinPerQ = 0.5;
      break;
    default:
      return new Response(JSON.stringify({ error: 'Unknown type, must be adult/child/senior' }), { status: 400 });
  }

  // 老年人版：直接展示所有场景（不做自适应选题）
  const questions = type === 'senior'
    ? bank
    : selectQuestions(bank as any, { targetCount });

  const diagnosisId = crypto.randomUUID();

  return new Response(JSON.stringify({
    diagnosisId,
    type,
    questions,
    totalQuestions: questions.length,
    estimatedMinutes: Math.round(questions.length * estimatedMinPerQ),
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
