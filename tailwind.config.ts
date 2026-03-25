import type { Config } from 'tailwindcss'

const config: Config = {
  content: [
    './app/**/*.{js,ts,jsx,tsx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#C41E3A',
        'primary-dark': '#8B1428',
        'primary-light': '#E8475F',
        gold: '#F8D49B',
        'gold-dark': '#E8B96A',
        background: '#F0E8D8',
        foreground: '#2B3A4A',
        'text-muted': '#7FA3B5',
      },
    },
  },
  plugins: [],
}
export default config
