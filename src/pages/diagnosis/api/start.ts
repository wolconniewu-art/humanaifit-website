// API路由 — 开始诊断
// 路径: src/pages/diagnosis/api/start.ts

export const prerender = false;

import type { APIRoute } from 'astro';
import { AdultScorer } from '../engine/adult-scorer';
import { selectQuestions } from '../engine/question-selector';
import adultBank from '../data/adult_questions.json';

export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();
  const { userId, type, userInfo } = body;

  // 路由分发
  let scorer;
  let bank;
  switch (type) {
    case 'adult':
      scorer = new AdultScorer();
      bank = adultBank;
      break;
    // case 'child': ... (预留)
    // case 'senior': ... (预留)
    default:
      return new Response(JSON.stringify({ error: 'Unknown type' }), { status: 400 });
  }

  // 自适应选题
  const questions = selectQuestions(bank as any, { targetCount: 20 });

  // 创建诊断记录 (TODO: 存数据库)
  const diagnosisId = crypto.randomUUID();

  return new Response(JSON.stringify({
    diagnosisId,
    type,
    questions,
    totalQuestions: questions.length,
    estimatedMinutes: Math.round(questions.length * 0.9),
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
