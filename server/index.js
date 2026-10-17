/** Liga o servidor localmente (npm start / npm run dev). No Vercel, o app roda por api/index.js. */

const app = require('./app');

const PORTA = process.env.PORT || 3000;

app.listen(PORTA, () => {
  console.log(`\n  Heróis da Saúde — servidor no ar`);
  console.log(`  http://localhost:${PORTA}\n`);
});
