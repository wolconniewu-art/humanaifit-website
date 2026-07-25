// API路由 — 提交答案 + 评分（三版本）
// 路径: src/pages/diagnosis/api/submit.ts

export const prerender = false;

import type { APIRoute } from 'astro';
import { AdultScorer } from '../engine/adult-scorer';
import { ChildScorer } from '../engine/child-scorer';
import { SeniorMatcher } from '../engine/senior-matcher';
import type { AnswerRecord, Question } from '../engine/types';
import adultBank from '../data/adult_questions.json';
import childBank from '../data/child_questions.json';
import seniorBank from '../data/senior_scenarios.json';

export const POST: APIRoute = async ({ request }) => {
  const body = await request.json();
  const { diagnosisId, answers, type } = body;

  let scorer;
  let bank: Question[];

  switch (type) {
    case 'adult':
      scorer = new AdultScorer();
      bank = adultBank as Question[];
      break;
    case 'child':
      scorer = new ChildScorer();
      bank = childBank as Question[];
      break;
    case 'senior':
      scorer = new SeniorMatcher();
      bank = seniorBank as Question[];
      break;
    default:
      return new Response(JSON.stringify({ error: 'Unknown type' }), { status: 400 });
  }

  const answeredQuestionIds = answers.map((a: any) => a.questionId);
  const questions = bank.filter(q => answeredQuestionIds.includes(q.id));

  const result = scorer.score({
    questions,
    answers: answers as AnswerRecord[],
  });

  return new Response(JSON.stringify({
    diagnosisId,
    result,
    reportUrl: null,
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
