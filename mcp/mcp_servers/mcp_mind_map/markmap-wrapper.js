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

// Import and run markmap-cli directly
try {
  // This works when bundled with pkg
  const { run } = require('markmap-cli');
  
  // Run markmap with provided arguments
  run(args).catch(error => {
    console.error('Error running markmap:', error.message);
    process.exit(1);
  });
} catch (error) {
  console.error('Failed to load markmap-cli:', error.message);
  process.exit(1);
}
