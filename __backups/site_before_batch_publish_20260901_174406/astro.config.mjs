import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
  site: 'https://humanaifit.com',
  trailingSlash: 'always',
  integrations: [
    sitemap({
      i18n: {
        defaultLocale: 'zh-cn',
        locales: {
          'zh-cn': 'zh-CN',
          en: 'en',
        },
      },
    }),
  ],
  i18n: {
    defaultLocale: 'zh-cn',
    locales: ['zh-cn', 'en'],
    routing: {
      prefixDefaultLocale: false,
    },
  },
});
