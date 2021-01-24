if( typeof module !== 'undefined' )
var wLoggerToFile = require( 'wloggertofile' );

let _ = wTools;
var logger = new wLoggerToFile();

console.log( 'output', logger.output );
console.log( 'outputPath', logger.outputPath );

logger._dprefix = '-';
logger.log( 'a1\nb1' );
logger.up( 2 );
logger.log( 'a2\nb2' );

// a1
// b1
// a2
// b2
