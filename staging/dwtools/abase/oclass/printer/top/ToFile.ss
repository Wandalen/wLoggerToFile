(function _ToFile_ss_() {

'use strict';

// require

if( typeof module !== 'undefined' )
{

  if( typeof _global_ === 'undefined' || !_global_.wBase )
  {
    let toolsPath = '../../../../dwtools/Base.s';
    let toolsExternal = 0;
    try
    {
      require.resolve( toolsPath );
    }
    catch( err )
    {
      toolsExternal = 1;
      require( 'wTools' );
    }
    if( !toolsExternal )
    require( toolsPath );
  }

  var _ = _global_.wTools;

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
 *  <li>Add object to output list [outputTo]{@link wPrinterMid.outputTo}
 *  <li>Remove object from output list [outputUnchain]{@link wPrinterMid.outputUnchain}
 *  <li>Add current logger to target's output list [inputFrom]{@link wPrinterMid.inputFrom}
 *  <li>Remove current logger from target's output list [inputUnchain]{@link wPrinterMid.inputUnchain}
 * </ul>
 * @class wPrinterToFile
 * @param { Object } o - Options.
 * @param { Object } [ o.output=null ] - Specifies single output object for current logger.
 * @param { Object } [ o.outputPath=null ] - Specifies file path for output.
 *
 * @example
 * var path = __dirname +'/out.txt';
 * var l = new wPrinterToFile({ outputPath : path });
 * var File = _.FileProvider.HardDrive();
 * l.log( '1' );
 * FilefileReadAct
 * ({
 *  filePath : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 * @example
 * var path = __dirname +'/out2.txt';
 * var l = new wPrinterToFile({ outputPath : path });
 * vae l2 = new _.Logger({ output : l });
 * var File = _.FileProvider.HardDrive();
 * l2.log( '1' );
 * FilefileReadAct
 * ({
 *  filePath : path,
 *  sync : 1
 * });
 * //returns '1'
 *
 */

var _ = _global_.wTools;
var Parent = _.PrinterTop;
var Self = function wPrinterToFile( o )
{
  if( !( this instanceof Self ) )
  if( o instanceof Self )
  return o;
  else
  return new( _.routineJoin( Self, Self, arguments ) );
  return Self.prototype.init.apply( this,arguments );
}

Self.nameShort = 'PrinterToFile';

//

function init( o )
{
  var self = this;

  Parent.prototype.init.call( self,o );

  if( typeof __dirname !== 'undefined' )
  self.outputPath = _.pathJoin( _.pathEffectiveMainDir(),self.outputPath );

  if( !self.fileProvider )
  self.fileProvider = _.FileProvider.HardDrive();

}

//

// function __initChainingMixinWrite( name )
// {
//   var proto = this;
//   var nameAct = name + 'Act';

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

function write()
{
  var self = this;

  debugger;
  var o = _.PrinterBase.prototype.write.apply( self,arguments );

  if( !o )
  return;

  _.assert( o );
  _.assert( _.arrayIs( o.output ) );
  _.assert( o.output.length === 1 );

  var terminal = o.output[ 0 ];
  if( self.usingTags && _.mapKeys( self.attributes ).length )
  {

    var text = terminal;
    terminal = Object.create( null );
    terminal.text = text;

    for( var t in self.attributes )
    {
      terminal[ t ] = self.attributes[ t ];
    }

  }

  self.fileProvider.fileWrite
  ({
    filePath :  self.outputPath,
    data : terminal + '\n',
    writeMode : 'append',
    sync : 1
  });

  return o;
}

//

// function _writeToFile()
// {
//   var self = this;
//   _.assert( arguments.length );
//   _.assert( _.strIs( self.outputPath ),'outputPath is not defined for PrinterToFile' );

//   var data = _.strConcat.apply( { },arguments ) + '\n';

//   self.fileProvider.fileWriteAct
//   ({
//     filePath :  self.outputPath,
//     data : data,
//     writeMode : 'append',
//     sync : 1
//   });

// }

// --
// relationships
// --

var Composes =
{
  outputPath : 'output.log',
}

var Aggregates =
{
}

var Associates =
{
  fileProvider : null,
}

// --
// prototype
// --

var Proto =
{

  init : init,

  // __initChainingMixinWrite : __initChainingMixinWrite,

  write : write,
  // _writeToFile : _writeToFile,

  // relationships

  constructor : Self,
  Composes : Composes,
  Aggregates : Aggregates,
  Associates : Associates,

}

//

_.classMake
({
  cls : Self,
  parent : Parent,
  extend : Proto,
});

_global_[ Self.name ] = _[ Self.nameShort ] = Self;

// --
// export
// --

if( typeof module !== 'undefined' )
if( _global_._UsingWtoolsPrivately_ )
delete require.cache[ module.id ];

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = Self;

})();
