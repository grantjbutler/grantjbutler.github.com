/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./Sources/**/*.swift",
    "./Content/**/*.{md,html,js}"
  ],
  theme: {
    extend: {},
  },
  plugins: [
    require("@tailwindcss/typography")
  ],
}

