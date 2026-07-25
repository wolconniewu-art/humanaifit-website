// API路由 — 获取历史诊断结果 (预留)
// 路径: src/pages/diagnosis/api/[id]/result.ts

export const prerender = false;

import type { APIRoute } from 'astro';

export const GET: APIRoute = async ({ params }) => {
  const { id } = params;

  // TODO: 从数据库获取诊断记录
  // const record = await db.diagnosis_records.find(id);

  return new Response(JSON.stringify({
    id,
    status: 'not_implemented',
    message: '数据库集成后实现',
  }), {
    status: 200,
    headers: { 'Content-Type': 'application/json' },
  });
};
