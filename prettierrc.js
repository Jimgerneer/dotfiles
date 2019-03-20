module.exports = {
  singleQuote: true,
  arrowParens: 'always',
  trailingComma: 'es5',
  semi: false,
  overrides: [
    {
      files: 'src/**/*.scss',
      options: {
        singleQuote: false,
      },
    },
  ],
}
