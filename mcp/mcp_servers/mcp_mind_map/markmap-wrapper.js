#!/usr/bin/env node
/**
 * Standalone wrapper for markmap-cli
 * This will be bundled into a single executable using pkg
 */

const path = require('path');

// Pass through all arguments
const args = process.argv.slice(2);

// If --version flag, show version
if (args.includes('--version')) {
  try {
    const pkg = require('markmap-cli/package.json');
    console.log(pkg.version || '1.0.0');
    process.exit(0);
  } catch (e) {
    console.log('1.0.0');
    process.exit(0);
  }
}

// Directly require and execute the bundled markmap
// The bundled version is CommonJS, so we can require it
try {
  // Set up argv for the bundled CLI
  process.argv = [process.argv[0], 'markmap', ...args];
  
  // Load the bundled CLI and call main() function
  const { main } = require('./bundled/index.js');
  
  // Execute the main function (it returns a Promise)
  main().catch(err => {
    console.error('Markmap execution error:', err);
    process.exit(1);
  });
  
} catch (error) {
  console.error('Failed to execute markmap:', error.message);
  process.exit(1);
}
