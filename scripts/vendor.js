/** Build do Vercel: copia a biblioteca do Supabase para src/vendor/, servida como /vendor/supabase.js. */

const fs = require('fs');
const path = require('path');

const raiz = path.join(__dirname, '..');
const origem = path.join(raiz, 'node_modules', '@supabase', 'supabase-js', 'dist', 'umd', 'supabase.js');
const destino = path.join(raiz, 'src', 'vendor', 'supabase.js');

fs.mkdirSync(path.dirname(destino), { recursive: true });
fs.copyFileSync(origem, destino);
console.log('vendor: supabase.js copiado para src/vendor/');
