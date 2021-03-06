(function _ToFile_s_()
{

'use strict';

/**
 * Class to redirect logging to a file. Logger supports colorful formatting, verbosity control, chaining, combining several loggers/consoles into logging network. Logger provides 10 levels of verbosity [ 0,9 ] any value beyond clamped and multiple approaches to control verbosity. Logger may use console/stream/process/file as input or output. Unlike alternatives, colorful formatting is cross-platform and works similarly in the browser and on the server side. Use the module to make your diagnostic code working on any platform you work with and to been able to redirect your output to/from any destination/source.
  @module Tools/base/printer/ToFile
*/

// require

if( typeof module !== 'undefined' )
{

  // const _ = require( '../../../../../node_modules/Tools' );
  const _ = require( 'Tools' );

  _.include( 'wLogger' );
  _.include( 'wFiles' );

}

//

/**
 * @classdesc Logger based on [wLogger]{@link wLogger} that writes messages( incoming & outgoing ) to file specified by path( outputPath ).
 *
 * Writes each message to the end of file. Creates new file( outputPath ) if it doesn't exist.
 *
 * <br><b>Methods:</b><br><br>
 * Output:
 * <ul>
 * <li>log
 * <li>error
 * <li>info
 * <li>warn
 * </ul>
 * Chaining:
 * <ul>
 *  <li>Add object to output list [outputTo]{@link wLoggerMid.outputTo}
 *  <li>Remove object from output list [outputUnchain]{@link wLoggerMid.outputUnchain}
 *  <li>Add current logger to target's output list [inputFrom]{@link wLoggerMid.inputFrom}
 *  <li>Remove current logger from target's output list [inputUnchain]{@link wLoggerMid.inputUnchain}
 * </ul>
 * @class wPrinterToFile
 * @param { Object } o - Options.
 * @param { Object } [ o.output=null ] - Specifies single output object for current logger.
 * @param { Object } [ o.outputPath=null ] - Specifies file path for output.
 *
 * @example
 * let path = __dirname +'/out.txt';
 * let l = new wPrinterToFile({ outputPath : path });
 * let File = _.FileProvider.HardDrive();
 * l.log( '1' );
 * FilefileReadAct
 * ({
 *  filePath : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 * @example
 * let path = __dirname +'/out2.txt';
 * let l = new wPrinterToFile({ outputPath : path });
 * vae l2 = new _.Logger({ output : l });
 * let File = _.FileProvider.HardDrive();
 * l2.log( '1' );
 * FilefileReadAct
 * ({
 *  filePath : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 */

const _global = _global_;
const _ = _global_.wTools;
const Parent = _.Logger;
const Self = wPrinterToFile;
function wPrinterToFile( o )
{
  return _.workpiece.construct( Self, this, arguments );
}

Self.shortName = 'PrinterToFile';

//

function init( o )
{
  let self = this;

  Parent.prototype.init.call( self, o );

  if( _.path.effectiveMainDir )
  self.outputPath = _.path.join( _.path.effectiveMainDir(), self.outputPath );

  if( !self.fileProvider )
  self.fileProvider = _.FileProvider.HardDrive();

}

//

// function __initChainingMixinWrite( name )
// {
//   let proto = this;
//   let nameAct = name + 'Act';

//   _.assert( Object.hasOwnProperty.call( proto,'constructor' ) )
//   _.assert( arguments.length === 1 );
//   _.assert( _.strIs( name ) );

//   /* */

//   function write()
//   {
//     this._writeToFile.apply( this, arguments );
//     if( this.output )
//     return this[ nameAct ].apply( this,arguments );
//   }

//   proto[ name ] = write;
// }

// function write()
// {
//   let self = this;

//   debugger;
//   let o = _.LoggerBasic.prototype.write.apply( self,arguments );

//   if( !o )
//   return;

//   _.assert( o );
//   _.assert( _.arrayIs( o.output ) );
//   _.assert( o.output.length === 1 );

//   let terminal = o.output[ 0 ];
//   if( self.usingTags && _.props.keys( self.attributes ).length )
//   {

//     let text = terminal;
//     terminal = Object.create( null );
//     terminal.text = text;

//     for( let t in self.attributes )
//     {
//       terminal[ t ] = self.attributes[ t ];
//     }

//   }

//   self.fileProvider.fileWriteAct
//   ({
//     filePath :  self.outputPath,
//     data : terminal + '\n',
//     writeMode : 'append',
//     sync : 1
//   });

//   return o;
// }

//

function _transformationForm( channelName, args )
{
  let self = this;

  _.assert( arguments.length === 2, 'Expects 2 arguments' );

  let transformation = Parent.prototype._transformationForm.call( self, channelName, args );

  if( transformation === null )
  return null;

  self.fileProvider.fileWrite
  ({
    filePath : self.outputPath,
    data : transformation.input[ 0 ] + '\n',
    writeMode : 'append',
    sync : 1
  });

  return transformation;
}

//

// function _transformEnd( o )
// {
//   let self = this;

//   _.assert( arguments.length === 1, 'Expects single argument' );

//   // debugger

//   o = Parent.prototype._transformEnd.call( self, o );

//   if( !o )
//   return;

//   _.assert( _.arrayIs( o._outputForTerminal ) || _.arrayIs( o._outputForPrinter ) );
//   _.assert
//   (
//     ( o._outputForTerminal && o._outputForTerminal.length === 1 )
//     || ( o._outputForPrinter && o._outputForPrinter.length === 1 )
//   );

//   let terminal = o._outputForTerminal ? o._outputForTerminal[ 0 ] : o._outputForPrinter[ 0 ]; /* can be console or another Printer */
//   if( self.usingTags && _.props.keys( self.attributes ).length )
//   {

//     let text = terminal;
//     terminal = Object.create( null );
//     terminal.text = text;

//     for( let t in self.attributes )
//     {
//       terminal[ t ] = self.attributes[ t ];
//     }

//   }

//   self.fileProvider.fileWrite
//   ({
//     filePath : self.outputPath,
//     data : terminal + '\n',
//     writeMode : 'append',
//     sync : 1
//   });

//   return o;
// }

//

// function _writeToFile()
// {
//   let self = this;
//   _.assert( arguments.length > 0 );
//   _.assert( _.strIs( self.outputPath ),'outputPath is not defined for PrinterToFile' );

//   let data = _.strConcat.apply( { },arguments ) + '\n';

//   self.fileProvider.fileWriteAct
//   ({
//     filePath :  self.outputPath,
//     data,
//     writeMode : 'append',
//     sync : 1
//   });

// }

// --
// fields
// --

let chainerSymbol = Symbol.for( 'chainer' );

// --
// relations
// --

let Composes =
{
  outputPath : 'output.log',
}

let Aggregates =
{
}

let Associates =
{
  fileProvider : null,
}

// --
// prototype
// --

let Proto =
{

  init,

  // __initChainingMixinWrite,

  // write,

  _transformationForm,
  // _transformEnd,
  // _writeToFile,

  // relations

  /* constructor * : * Self, */
  Composes,
  Aggregates,
  Associates,

}

//

_.classDeclare
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_global_[ Self.name ] = _[ Self.shortName ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = Self;

})();
