# From Reading Papers to Eating Raw Data: China's AI — Three Fronts, One Unanswered Question

On July 17, 2026, in Shanghai, two things happened on the same day.

On one side, the World AI Conference (WAIC) opened. For the first time, exhibition space broke 100,000 square meters, over 1,100 companies exhibited, more than 3,000 products were on display, 300-plus of them global debuts, and over 1,400 international guests attended.

On the other side, that same week, global tech stocks kept falling. The Philadelphia Semiconductor Index plunged, and the semiconductor sector shed over $1 trillion in market value in a single day.

One stage was showing off products; the other was slashing prices. That's not coincidence. It's the two ends of one line: AI is moving from "telling a story" to "doing the work." Technological imagination now has to answer to real-world pricing.

China happens to stand in the middle of that line. Over the past two years it has stacked up AI capability at remarkable scale — from terminals to computing, from labs to rule-making. But all of that capability ultimately has to be re-weighed in the global market. This piece is about that re-weighing, and China's position on three fronts.

## One: How far has the capability actually come? Four "firsts"

Let's start with a plain question: how much of it has China actually built?

Scale is the easy answer. This year's WAIC broke out of the single-venue model, opening across three districts in Shanghai — the Expo, Zhangjiang, and West Bund — in four halls. Exhibition space topped 100,000 square meters for the first time, with 1,100-plus companies, 3,000-plus products, and over 300 global debuts — figures from the Shanghai municipal government's July 7 press conference, cross-confirmed by multiple media outlets[1][2].

But scale is just the surface. What matters more are the four "firsts" that appeared this year.

First, computing. Huawei showed the Atlas 950 SuperPoD — a super-node with 8,192 Ascend chips interconnected, total computing power exceeding 500,000 cards, and training performance 17 times that of the previous Atlas 900[3]. Those numbers are Huawei's official figures as relayed by financial media. The point is that domestic computing is turning "usable" into "enough."

Second, academia. For the first time, WAIC ran an academic conference, chaired by Turing laureate Andrew Yao with "the father of reinforcement learning" Richard Sutton as international co-chair. It received 284 submissions from 11 countries and regions, with accepted papers to be published by Springer[1]. The industry expo started growing an academic leg.

Third, organizational form. For the first time, there was an OPC (One-Person Company) challenge, selecting 22 projects from 711 entries across eight regional tracks to enter the venture zone, with 180 companies already in the OPC showcase area[1]. AI is rewriting the formula of entrepreneurship — what used to be team plus capital plus business plan is becoming one person plus a stack of AI tools.

A caveat here. The claim that an AI agent "does the work of three to five full-time employees at a tenth of the cost" comes from startup-media sources like OpenCSG, and it smells of marketing[4]. What can be confirmed is the direction — OPC moving from a fringe concept to a core exhibit, and that shift in position is real.

Fourth, generation. For the first time, 1,030 young talent under 35 attended, backed by a full chain from competition to academia to incubation. The city's AI talent pool is now about 300,000 people, roughly a third of the national total[1].

Put the four firsts together and the conclusion isn't "China's AI is strong." It's that China's AI is moving from a tech race toward landing capability in products, organizations, and people. That's a different front from just building a bigger model.

## Two: Into the deep end — from reading papers to eating raw data

The second front is quieter, and possibly more consequential.

Academician Wang Jian of the Chinese Academy of Engineering asked a question at WAIC 2026: what exactly is today's large model "eating"?

The answer: text. Only text. AlphaFold 2 solved the protein-structure-prediction problem that had stumped biology for 50 years, and in 2024 its two key developers, Hassabis and Jumper, won the Nobel Prize in Chemistry[5]. But Wang Jian put his finger on it: most so-called "AI for Science" only has AI reading papers — the training material is "second-hand, distilled data," already filtered through scientists' understanding, preferences, and biases. Not raw data.

The core of science was never papers; it's experimental data. Feed a large model a geological map and it sees pixels compressed into a JPEG, not strata. Feed it seismic-wave data and it sees a string of meaningless numbers.

This dilemma has a paper trail. A 2023 arXiv review surveying "geoscience foundation models" reached the same conclusion: general-purpose language models can't handle the multimodal raw data that drives real scientific discovery[6]. NASA's Earth science division admitted the same problem in a late-2023 blog post — they have to build domain-specific models step by step[7].

Wang Jian's answer leans on the large model's core technique: tokenization. Tokenization, he said, is essentially what Irish monks did centuries ago when they inserted spaces between words, turning reading from reading-aloud into silent comprehension. Large models used tokenization to digest text and code — so why not add "spaces" to scientific data too?

That idea has already landed in China. On WAIC's opening day, the Chinese Academy of Sciences released ScienceOne Omni 2.0, a scientific foundation model built on 8 million high-quality scientific reasoning data points covering 200-plus tasks[8]. Harder still was Golab, a self-driving lab incubated by the Shanghai Academy of AI for Science: it ran 135 real research tasks autonomously in five days, with 100% tool-call accuracy and over 99% overall completion. Catalyst optimization was the showcase case — the first round lifted reaction activity by about 15%, then the AI remembered the result, adjusted the molecular design, and hit roughly 6 times the literature baseline in round two. These figures come from the academy's own launch event — an official institutional source, but still a single source[9][10].

For context: a team led by Abolhasani at North Carolina State University published a blueprint for self-driving labs in *Nature Communications* in April 2025, exploring the same territory[11]. This isn't uniquely Chinese — but China is engineering it.

Wang Jian went further in a forum, with a bolder proposition: if AI can touch the underlying data of physics, chemistry, and biology at once, the very phrase "interdisciplinary" becomes redundant. He re-split STEM into STE + MAP — adding Math, AI, and Public Facilities alongside Science, Technology, and Engineering[12].

The point of this section: China's second front is pushing the tokenization revolution into the deep end of scientific data. This isn't a scale race. It's capability migrating upstream. The direction may be right, but that doesn't mean it wins tomorrow.

## Three: Rules are the other invisible front

The third front isn't in the lab. It's in the rules.

On July 17, President Xi Jinping spoke at the WAIC opening ceremony, laying out four points — openness and mutual benefit, safety and controllability, inclusiveness, and shared progress — and announcing three concrete commitments[13].

Taken separately, none of the three commitments is earth-shattering: 5,000 AI training slots for developing countries over five years; six regional "international AI application cooperation centers" aimed at ASEAN, the Arab League, the African Union, CELAC, the SCO, and BRICS; and the "Mazu" AI weather-sensing system deployed across 30 countries.

Stacked together, they point one way: China is assembling a set of AI governance infrastructure that other countries can adopt. The 5,000 trainees may walk away carrying Shanghai's governance logic rather than Brussels's EU AI Act. The six centers blanket nearly every major developing-country region. And "Mazu" uses the most uncontroversial public service — typhoon forecasting — as the entry point: get into government infrastructure first, then talk governance. Tool first, rules later.

This didn't spring up overnight. A year earlier, on July 26, 2025, Premier Li Qiang proposed establishing a "World AI Cooperation Organization" (WAICO) during WAIC 2025; on July 16, 2026, the founding agreement was signed in Shanghai, with Foreign Minister Wang Yi signing on China's behalf; on July 17, Xi formally announced its creation, with 29 founding member states including Pakistan[14][15]. From proposal to signing: under a year.

Right now there are three parallel logics of AI governance in the world. The EU is "write the rules first, then start building" — the EU AI Act entered full enforcement in 2026, with risk tiers, content labeling, and heavy fines. The U.S. is "run first, figure it out later" — still no federal comprehensive AI law, relying on corporate self-regulation and executive orders the next president can overturn. China is "state-led, top-down" — algorithm-recommendation rules, generative-AI rules, and an AI law in progress, with pre-launch safety assessment and mandatory watermarks on generated content[16].

*Nature*, in a rare geopolitical editorial in December 2025, ran the headline "China is leading the world on AI governance." What makes the editorial credible is that it also flagged China's weaknesses — in the FLI's AI safety index, Chinese leading labs scored lower than Western peers on catastrophic-risk preparedness[17]. An endorsement willing to name shortcomings carries more weight than one-sided praise.

The point of this section: rules are one way power gets moved. China is shifting from "technology follower" to "rule-maker," not through slogans but through concrete channels — services, training, and institutions. Whether it succeeds is a separate matter.

## Four: Where does this capability rank globally

The capability is built, the rules are being laid. But there are two external yardsticks to check: China's place in global innovation, and the macro base on which this capability must cash out.

Start with the macro base, because it's the gravity pulling on every dollar of "value."

In April 2026, the IMF cut its global growth forecast at the spring meetings, warning that the world economy is "drifting toward a more adverse scenario"[18]. The exact numbers belong to the formal report, but the direction is clear. Three pressures: first, the Middle East — the Strait of Hormuz carries about 20% of the world's oil and a large share of LNG; if it's blocked, energy costs ripple through chemicals, logistics, and everything downstream[19]. Second, the structural drag of trade friction — unlike the one-off shock of the early tariff war, this time it's dispersed and long-running. Third, the lagged effects of monetary policy — the after-effects of rate hikes are still unwinding, with corporate financing costs and the property adjustment unfinished.

Then there's the shape of globalization. A leading consultancy's global economics intelligence bulletins sum up 2026's core narrative as "fragmentation" — the U.S.-China fight escalating from trade war to tech-supply-chain war, European manufacturing under pressure, emerging markets diverging. The most interesting read for China within that framework: fragmentation's other face is that "the incremental global market is shrinking, but the substitutable existing market is expanding." Once cost-push inflation — tariffs, carbon tariffs, supply-chain de-risking — replaces fading demand-driven inflation as the new pressure source, competing on low price is no longer enough.

To be clear: the "fragmentation" and "scenario planning" here are narrative frameworks, not precisely citable figures. The original report itself flags that specific data points need verification, so I've kept only its analytical lens and offered no specific numbers[20].

Put the two yardsticks together and the answer is plain: China's AI capability is built, but the macro exam room is getting harder.

## Five: What's it actually worth — the world is still arguing

The last question is the hardest: what is this capability worth?

The world's mainstream institutions can't answer it, and have instead fallen into a dilemma.

Chicago Fed President Austan Goolsbee laid out the two ends of the debate in a May 2025 speech[21][22]. One end is the "overheating" thesis: if AI genuinely lands at scale and fundamentally changes productivity, demand fires before supply — companies race to finance GPUs, hire AI engineers, ship AI products, while the productivity gain takes time to digest through organizational change. In the short run, demand runs ahead, which is classic overheating — and the Fed might have to raise rates. The other end is the "stagflation" thesis: companies sink enormous sums into AI, costs rise, efficiency doesn't follow, and they start cutting — growth stalls while cost-pushed prices stay up. That's stagflation.

The two extremes share one premise: nobody can predict AI's landing pace. The Fed faces a "two-sided risk" — raise rates and risk killing growth, or hold off and risk stagflation.

This anxiety isn't new. In 1987, Nobel laureate Robert Solow said: "You can see the computer age everywhere but in the productivity statistics." In May 2025, *Fortune* reported that thousands of CEOs admitted AI had no impact on employment or productivity[23]. Economists dusted off the 40-year-old paradox. SF Fed president Mary Daly put it plainly — too much uncertainty, wait for more data; Fed governor Barr threw cold water — don't expect AI to let the Fed cut rates sooner[24]. A PIIE working paper landed on the same line: AI's effect on inflation could push it up or down, both are in play[25].

The debate has run from May 2025 all the way to now. By the week WAIC opened in July 2026, the market cast its vote with real money — over a trillion dollars wiped off the semiconductor sector in a day. The message: stop telling stories, hand over the returns.

## Conclusion: Capability is the asset, cashing out is the exam

Let's pull the threads together.

China's AI has done three things: stacked capability to scale — from terminals to computing, from expos to organizations; pushed it into the deep end — from reading papers to eating raw data; and spread rules globally — from technology follower to rule-builder.

But "built" and "worth what" are two different questions. The answer to the second rests on three keys, none of which has landed yet: the pace and divergence of the macro environment, the ownership of rule-making voice, and the timing of productivity payback.

This isn't a piece meant to reach a verdict. Whether China's AI is strong, whether the AI dividend arrives — none of that can be settled in a sentence. What's certain is this: the whole world is making decisions against one enormous question mark, and the answer may be years away.

## References

1. **Shanghai Municipal Government press conference (WAIC 2026 preparations)** — 2026-07-07, cross-confirmed (People's Daily/CCTV/Sina Finance/Interface News).
2. **WAIC 2026 preparation progress** — CCTV/CLS/Securities Times, 2026-06-17/18.
3. **Huawei Ascend Atlas 950 SuperPoD debut at WAIC** — Caijing/Sina Finance, 2026-07-14.
4. **2026 AI startup wave: OPC challenge explained** — OpenCSG/CNBlogs, 2026-03-23 (single startup-media source; agent-efficiency claims are marketing-flavored).
5. **Jumper, J. et al., "Highly accurate protein structure prediction with AlphaFold"** — *Nature*, 2021, Vol. 596; **Nobel Prize in Chemistry 2024** — NobelPrize.org, 2024-10-09.
6. **Zhang, H. et al., "When Geoscience Meets Foundation Models"** — arXiv:2309.06799, 2023-09.
7. **Ramachandran, R., "AI Foundation Models to Augment Scientific Data"** — NASA Earthdata Blog, 2023-12-07.
8. **China launches upgraded ScienceOne Omni scientific foundation model** — People's Daily Online (Xinhua), 2026-07-18.
9. **Golab materials-science self-driving lab launch data** — Shanghai Academy of AI for Science launch event, 2026-07 (official institutional source, single source).
10. **Shanghai 2025 AI enterprises: 394 above-scale firms, RMB 637bn industry scale, +39.5% YoY** — CityNewsService (announced by Pan Yan, deputy director, Shanghai Municipal Commission of Economy and Informatization), 2026-04.
11. **Canty, R.B., Abolhasani, M. et al., "Science acceleration and accessibility with self-driving labs"** — *Nature Communications*, 2025-04-24.
12. **WAIC 2026 Science Intelligence Open Forum (Wang Jian's keynote)** — Fudan University / Shanghai Academy of AI for Science, 2026-07-18.
13. **Xi Jinping's keynote at the 2026 WAIC opening ceremony, "Jointly Building a Just and Equitable Global AI Governance System"** — People's Daily/Xinhua, 2026-07-17.
14. **China proposes establishing the World AI Cooperation Organization, HQ initially planned in Shanghai** — Xinhua, 2025-07-26.
15. **Signing ceremony for the Agreement Establishing the World AI Cooperation Organization held in Shanghai** — Xinhua, 2026-07-16; **WAICO's 29 founding members** — Guandian/Xinhua, 2026-07-17.
16. **CACM, "Three Rulebooks, One Race: AI Regulation in the U.S., EU, and China"** — 2026; **University of Virginia NSDPI, "AI Governance in the PRC"** — 2026-04-07.
17. **"China is leading the world on AI governance: other countries must engage" (Editorial)** — *Nature*, 2025-12.
18. **IMF *World Economic Outlook*, Spring Meetings 2026** — 2026-04; **Reuters, "IMF cuts growth outlook, warns world already drifting toward more adverse scenario"** — 2026-04.
19. **Al Jazeera, "IMF cuts global growth forecast during Hormuz blockade"** — 2026-04.
20. **McKinsey, *Global Economics Intelligence executive summary*** — 2026-03 (qualitative framework cited only; no specific figures used).
21. **Fed's Goolsbee: AI success would be 'lovely,' but Fed would still need to watch for overheating** — Reuters/Yahoo Finance, 2025-05-09.
22. **Fed's Goolsbee: AI could produce stagflation if boom disappoints** — Barron's, 2025-05-09.
23. **Thousands of CEOs admit AI had no impact on employment or productivity** — Fortune, 2025-05-09.
24. **The AI Moment? Possibilities, Productivity, and Policy** — SF Fed (Daly), 2025-05; **Fed's Barr casts doubt on AI as rate-cutting tool** — Reuters, 2025-05.
25. **The AI productivity boom is not here (yet)** — The Economist, 2025-05-01; PIIE working paper (AI's two-way inflation impact), 2025.
