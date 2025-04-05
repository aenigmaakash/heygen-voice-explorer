module.exports = {
  // Public path for deployment
  publicPath: process.env.NODE_ENV === 'production' ? '/' : '/',
  
  // Disable ESLint completely
  lintOnSave: false
} 