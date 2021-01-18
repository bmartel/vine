module.exports = {
  purge: ['./app/**/*.html.erb', './app/helpers/**/*.rb', './app/javascript/**/*.js'],
  darkMode: 'class',
  theme: {
    extend: {
      margin: {
        '-2px': '-2px',
      },
      minWidth: {
        6: '1.5rem',
      },
    },
  },
  variants: {
    extend: {
      backgroundColor: ['checked'],
      backgroundImage: ['checked'],
      borderColor: ['checked'],
      inset: ['checked'],
      translate: ['checked'],
      zIndex: ['hover', 'active'],
    },
  },
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography'), require('@tailwindcss/aspect-ratio')],
};
