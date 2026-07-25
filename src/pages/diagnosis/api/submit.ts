// API路由 — 提交答案 + 评分
// 路径: src/pages/diagnosis/api/submit.ts

export const prerender = false;

import type { APIRoute } from 'astro';
import { AdultScorer } from '../engine/adult-scorer';
import type { AnswerRecord, Question } from '../engine/types';
import adultBank from '../data/adult_questions.json';

export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();
  const { diagnosisId, answers, type } = body;

  // 路由分发评分器
  let scorer;
  let bank: Question[];
  switch (type) {
    case 'adult':
      scorer = new AdultScorer();
      bank = adultBank as Question[];
      break;
    default:
      return new Response(JSON.stringify({ error: 'Unknown type' }), { status: 400 });
  }

  // 找出用户回答过的题目
  const answeredQuestionIds = answers.map((a: any) => a.questionId);
  const questions = bank.filter(q => answeredQuestionIds.includes(q.id));

  // 评分
  const result = scorer.score({
    questions,
    answers: answers as AnswerRecord[],
  });

  // TODO: 保存诊断记录到数据库

  return new Response(JSON.stringify({
    diagnosisId,
    result,
    reportUrl: null, // TODO: 付费报告URL
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
