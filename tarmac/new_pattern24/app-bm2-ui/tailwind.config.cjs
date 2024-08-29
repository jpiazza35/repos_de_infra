/** @type {import('tailwindcss').Config}*/
const config = {
  content: [
    './src/**/*.{html,js,svelte,ts}',
    './node_modules/flowbite-svelte/**/*.{html,js,svelte,ts}',
    './node_modules/flowbite-svelte-icons/**/*.{html,js,svelte,ts}',
  ],
  plugins: [require('flowbite/plugin')],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        // flowbite-svelte
        primary: {
          50: '#f5f5f5',
          100: '#e9e9e9',
          200: '#d9d9d9',
          300: '#c4c4c4',
          400: '#9d9d9d',
          500: '#7b7b7b',
          600: '#555555',
          700: '#434343',
          800: '#262626',
          900: '#000000',
        },
        'primary-green': {
          500: '#00A89D',
        },
        green: {
          50: '#00A89D',
          100: '#00A89D',
          200: '#00A89D',
          300: '#00a89d4f',
          400: '#00A89D',
          500: '#00A89D',
          600: '#00A89D',
          700: '#00A89D',
          800: '#00A89D',
          900: '#00A89D',
        },
        chart: {
          0: '#00A89D',
          1: '#A0E4DD',
          2: '#006B64',
          3: '#F9EAC3',
        },
        'custom-green': {
          100: '#CCEEEB',
          600: '#008E8C',
          700: '#00737B',
        },
        'custom-grey': {
          75: '#E8E8E9',
        },
        'custom-neutral': {
          50: '#F4F4F4',
          75: '#E9E9E9',
          100: '#DDDDDE',
          200: '#C6C6C8',
          300: '#B0B0B1',
          400: '#9291A5',
          500: '#77777A',
          600: '#555559',
          800: '#333335',
        },
        'custom-error': {
          200: '#F7DDD9',
          800: '#6D0603',
        },
        'custom-warning': {
          200: '#F9EAC3',
          800: '#7E4602',
        },
        'custom-success': {
          200: '#DAF3D8',
          800: '#034F05',
        },
        'neutral-black': '#1E1B39',
        'neutral-grey': '#615E83',
        font: '#333335',
        info: '#4E99C5',
        error: '#AC3431',
        success: '#61A961',
        warning: '#F3AA41',
      },
      spacing: {
        128: '32rem',
      },
      screens: {
        mobile: '320px',
        // => @media (min-width: 320px) { ... }
        tablet: '768px',
        // => @media (min-width: 768px) { ... }
        laptop: '1440px',
        // => @media (min-width: 1440px) { ... }
        desktop: '1920px',
        // => @media (min-width: 1920px) { ... }
      },
    },
  },
}

module.exports = config
